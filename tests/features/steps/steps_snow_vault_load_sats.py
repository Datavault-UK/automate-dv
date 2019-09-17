import os

from behave import *
from pandas import DataFrame

from definitions import DBT_ROOT

use_step_matcher("parse")


# Distinct history of data is loaded into a satellite table

@step("I have an empty SAT_HUB_CUSTOMER satellite")
def step_impl(context):
    context.testdata.create_schema("DV_PROTOTYPE_DB", "SRC_TEST_VLT")
    context.testdata.drop_and_create("DV_PROTOTYPE_DB", "SRC_TEST_VLT", "test_sat_hub_customer",
                                     ["HASHDIFF BINARY(16) PRIMARY KEY",
                                      ("CUSTOMER_PK BINARY(16) FOREIGN KEY REFERENCES "
                                       "DV_PROTOTYPE_DB.SRC_TEST_VLT.TEST_HUB_CUSTOMER(CUSTOMER_PK)"),
                                      "CUSTOMER_NAME VARCHAR(25)", "CUSTOMER_PHONE VARCHAR(15)", "LOADDATE DATE",
                                      "EFFECTIVE_FROM DATE", "SOURCE VARCHAR(4)"], materialise="table")


@step("I run the dbt satellite load sql")
def step_impl(context):
    os.chdir(DBT_ROOT)
    os.system("dbt run --full-refresh --models test_sat_hub_customer")


@step("I have data in the STG_CUSTOMER table")
def step_impl(context):
    context.testdata.drop_and_create("DV_PROTOTYPE_DB", "SRC_TEST_STG", "stg_customer",
                                     ["CUSTOMER_PK BINARY(16) PRIMARY KEY", "NATION_PK BINARY(16)",
                                      "CUSTOMER_NATION_PK BINARY(16)", "HASHDIFF BINARY(16)", "CUSTOMERKEY VARCHAR(38)",
                                      "CUSTOMER_NAME VARCHAR(38)", "CUSTOMER_PHONE VARCHAR(38)",
                                      "CUSTOMER_NATIONKEY VARCHAR(38)", "LOADDATE DATE", "EFFECTIVE_FROM DATE",
                                      "SOURCE VARCHAR(4)"], materialise="table")
    context.testdata.insert_data_from_ct(context.table, "stg_customer", "SRC_TEST_STG")


@step("only distinct records are loaded into the satellite")
@step("any unchanged records are not loaded into the satellite")
@step("any changed records are loaded to the satellite")
@step("only the latest records are loaded into the satellite")
def step_impl(context):
    sql = "SELECT CAST(HASHDIFF AS VARCHAR(32)) AS HASHDIFF, " \
          "CAST(CUSTOMER_PK AS VARCHAR(32)) AS CUSTOMER_PK, " \
          "CUSTOMER_NAME, CUSTOMER_PHONE, LOADDATE, EFFECTIVE_FROM, SOURCE " \
          "FROM DV_PROTOTYPE_DB.SRC_TEST_VLT.test_sat_hub_customer " \
          "AS sat ORDER BY sat.CUSTOMER_NAME;"

    table_df = context.testdata.context_table_to_df(context.table)
    result_df = DataFrame(context.testdata.general_sql_statement_to_df(sql), dtype=str)

    table_df['HASHDIFF'] = table_df['HASHDIFF'].str.upper()
    table_df['CUSTOMER_PK'] = table_df['CUSTOMER_PK'].str.upper()

    table_df.sort_values('CUSTOMER_NAME', inplace=True)
    table_df.reset_index(drop=True, inplace=True)

    if result_df.equals(table_df):
        assert True
    else:
        assert False


# Unchanged records are not loaded into the satellite

@step("I have a {table_name} satellite with pre-existing data")
def step_impl(context, table_name):
    context.testdata.create_schema("DV_PROTOTYPE_DB", "SRC_TEST_VLT")
    context.testdata.drop_and_create("DV_PROTOTYPE_DB", "SRC_TEST_VLT", table_name.lower(),
                                     ["HASHDIFF BINARY(16) PRIMARY KEY",
                                      ("CUSTOMER_PK BINARY(16) FOREIGN KEY REFERENCES "
                                       "DV_PROTOTYPE_DB.SRC_TEST_VLT.TEST_HUB_CUSTOMER(CUSTOMER_PK)"),
                                      "CUSTOMER_NAME VARCHAR(25)", "CUSTOMER_PHONE VARCHAR(15)", "LOADDATE DATE",
                                      "EFFECTIVE_FROM DATE", "SOURCE VARCHAR(4)"], materialise="table")

    context.testdata.insert_data_from_ct(context.table, table_name.lower(), "SRC_TEST_VLT")


@step("I run the dbt day satellite load sql")
def step_impl(context):
    os.chdir(DBT_ROOT)
    os.system("dbt run --models test_sat_hub_customer")
