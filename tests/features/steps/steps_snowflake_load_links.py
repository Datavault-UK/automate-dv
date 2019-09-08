import os

from behave import *
from pandas import DataFrame

from definitions import DBT_ROOT

use_step_matcher("parse")


# Distinct history of data linking two hubs is loaded into a link table


@given("I have a HUB_CUSTOMER table")
def step_impl(context):
    context.testdata.create_schema("DV_PROTOTYPE_DB", "SRC_TEST_VLT")
    context.testdata.drop_and_create("DV_PROTOTYPE_DB", "SRC_TEST_VLT", "TEST_HUB_CUSTOMER",
                                     ["CUSTOMER_PK BINARY(16) PRIMARY KEY", "CUSTOMERKEY VARCHAR(38)", "LOADDATE DATE",
                                      "SOURCE VARCHAR(4)"], materialise="table")
    context.testdata.insert_data_from_ct(context.table, "TEST_HUB_CUSTOMER", "SRC_TEST_VLT")


@step("I have a HUB_NATION table")
def step_impl(context):
    context.testdata.drop_and_create("DV_PROTOTYPE_DB", "SRC_TEST_VLT", "TEST_HUB_NATION",
                                     ["NATION_PK BINARY(16) PRIMARY KEY", "CUSTOMER_NATIONKEY VARCHAR(38)",
                                      "LOADDATE DATE", "SOURCE VARCHAR(4)"], materialise="table")
    context.testdata.insert_data_from_ct(context.table, "TEST_HUB_NATION", "SRC_TEST_VLT")


@step("I have an empty LINK_CUSTOMER_NATION table")
def step_impl(context):
    context.testdata.drop_and_create("DV_PROTOTYPE_DB", "SRC_TEST_VLT", "TEST_LINK_CUSTOMER_NATION",
                                     ["CUSTOMER_NATION_PK BINARY(16) PRIMARY KEY UNIQUE",
                                      ("CUSTOMER_PK BINARY(16) FOREIGN KEY REFERENCES "
                                       "DV_PROTOTYPE_DB.SRC_TEST_VLT.TEST_HUB_CUSTOMER(CUSTOMER_PK)"),
                                      ("NATION_PK BINARY(16) FOREIGN KEY REFERENCES "
                                       "DV_PROTOTYPE_DB.SRC_TEST_VLT.TEST_HUB_NATION(NATION_PK)"), "LOADDATE DATE",
                                      "SOURCE VARCHAR(4)"], materialise="table")


@step("I have data in the STG_CUSTOMER table")
def step_impl(context):
    context.testdata.drop_and_create("DV_PROTOTYPE_DB", "SRC_TEST_STG", "STG_CUSTOMER",
                                     ["CUSTOMER_PK BINARY(16)", "NATION_PK BINARY(16)", "CUSTOMER_NATION_PK BINARY(16)",
                                      "HASHDIFF VARCHAR(32)", "CUSTOMERKEY VARCHAR(38)", "CUSTOMER_NAME VARCHAR(25)",
                                      "CUSTOMER_PHONE VARCHAR(15)", "CUSTOMER_NATIONKEY NUMBER(38,0)",
                                      "SOURCE VARCHAR(4)", "LOADDATE DATE", "EFFECTIVE_FROM DATE"], materialise="table")
    context.testdata.insert_data_from_ct(context.table, "STG_CUSTOMER", "SRC_TEST_STG")


@step("I run the dbt load to the link")
def step_impl(context):
    os.chdir(DBT_ROOT)
    os.system("dbt run --full-refresh --models test_link_customer_nation")


@step("only distinct records from the STG_CUSTOMER are loaded into the link")
@step("only the first seen distinct records are loaded into the link")
@step("only different or unchanged records are loaded to the link")
def step_impl(context):
    sql = "SELECT CAST(CUSTOMER_NATION_PK AS VARCHAR(32)) AS CUSTOMER_NATION_PK, " \
          "CAST(CUSTOMER_PK AS VARCHAR(32)) AS CUSTOMER_PK, " \
          "CAST(NATION_PK AS VARCHAR(32)) AS NATION_PK, " \
          "LOADDATE, SOURCE " \
          "FROM DV_PROTOTYPE_DB.SRC_TEST_VLT.TEST_LINK_CUSTOMER_NATION " \
          "ORDER BY CUSTOMER_NATION_PK"

    table_df = context.testdata.context_table_to_df(context.table)
    result_df = DataFrame(context.testdata.general_sql_statement_to_df(sql), dtype=str)

    table_df['CUSTOMER_NATION_PK'] = table_df['CUSTOMER_NATION_PK'].str.upper()
    table_df['CUSTOMER_PK'] = table_df['CUSTOMER_PK'].str.upper()
    table_df['NATION_PK'] = table_df['NATION_PK'].str.upper()

    table_df.sort_values('CUSTOMER_NATION_PK', inplace=True)
    table_df.reset_index(drop=True, inplace=True)

    if table_df.equals(result_df):
        assert True
    else:
        assert False


# Unchanged records in stage are not loaded into the link with pre-existing data

@step("there are records in the LINK_CUSTOMER_NATION table")
def step_impl(context):
    context.testdata.drop_and_create("DV_PROTOTYPE_DB", "SRC_TEST_VLT", "TEST_LINK_CUSTOMER_NATION",
                                     ["CUSTOMER_NATION_PK BINARY(16) PRIMARY KEY ",
                                      ("CUSTOMER_PK BINARY(16) FOREIGN KEY REFERENCES "
                                       "DV_PROTOTYPE_DB.SRC_TEST_VLT.TEST_HUB_CUSTOMER(CUSTOMER_PK)"),
                                      ("NATION_PK BINARY(16) FOREIGN KEY REFERENCES "
                                       "DV_PROTOTYPE_DB.SRC_TEST_VLT.TEST_HUB_NATION(NATION_PK)"), "LOADDATE DATE",
                                      "SOURCE VARCHAR(4)"], materialise="table")
    context.testdata.insert_data_from_ct(context.table, "TEST_LINK_CUSTOMER_NATION", "SRC_TEST_VLT")


@step("I run the dbt day load to the link")
def step_impl(context):
    os.chdir(DBT_ROOT)
    os.system("dbt run --models test_link_customer_nation")


# Only the first instance of a record is loaded into the link table for the history

@step("I have unchanged records but with different loaddates in the STG_CUSTOMER table")
def step_impl(context):
    context.testdata.drop_and_create("DV_PROTOTYPE_DB", "SRC_TEST_STG", "STG_CUSTOMER",
                                     ["CUSTOMER_PK BINARY(16)", "NATION_PK BINARY(16)", "CUSTOMER_NATION_PK BINARY(16)",
                                      "HASHDIFF BINARY(16)", "CUSTOMERKEY VARCHAR(38)", "CUSTOMER_NAME VARCHAR(25)",
                                      "CUSTOMER_PHONE VARCHAR(15)", "CUSTOMER_NATIONKEY NUMBER(38,0)",
                                      "SOURCE VARCHAR(4)", "LOADDATE DATE", "EFFECTIVE_FROM DATE"], materialise="table")
    context.testdata.insert_data_from_ct(context.table, "STG_CUSTOMER", "SRC_TEST_STG")
