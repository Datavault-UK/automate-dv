import os

from behave import *
from pandas import DataFrame

import bindings
from definitions import DBT_ROOT

use_step_matcher("parse")


# Distinct history of data from the stage is loaded into an empty hub


@given("there is an empty TEST_HUB_CUSTOMER table")
def step_impl(context):
    context.testdata.create_schema("DV_PROTOTYPE_DB", "SRC_TEST_VLT")
    context.testdata.drop_and_create("DV_PROTOTYPE_DB", "SRC_TEST_VLT", "TEST_HUB_CUSTOMER",
                                     ["CUSTOMER_PK BINARY(16) PRIMARY KEY", "CUSTOMERKEY VARCHAR(38)", "LOADDATE DATE",
                                      "SOURCE VARCHAR(4)"], materialise="table")


@step("there are records in the STG_CUSTOMER table")
def step_impl(context):
    context.testdata.create_schema("DV_PROTOTYPE_DB", "SRC_TEST_STG")
    context.testdata.drop_and_create("DV_PROTOTYPE_DB", "SRC_TEST_STG", "STG_CUSTOMER",
                                     ["CUSTOMER_PK BINARY(16)", "NATION_PK BINARY(16)",
                                      "CUSTOMER_NATION_PK BINARY(16)", "HASHDIFF BINARY(16)",
                                      "CUSTOMERKEY VARCHAR(38)", "CUSTOMER_NAME VARCHAR(25)",
                                      "CUSTOMER_PHONE VARCHAR(15)", "CUSTOMER_NATIONKEY NUMBER(38,0)",
                                      "SOURCE VARCHAR(4)", "LOADDATE DATE", "EFFECTIVE_FROM DATE"], materialise="table")
    context.testdata.insert_data_from_ct(context.table, "STG_CUSTOMER", "SRC_TEST_STG")


@step("I run the dbt hub load sql script")
def step_impl(context):
    os.chdir(DBT_ROOT)
    os.system("dbt run --full-refresh --models test_hub_customer")


@step("only distinct records from STG_CUSTOMER are inserted into HUB_CUSTOMER")
def step_impl(context):
    bindings.compare_ct_to_db_table(context, "DV_PROTOTYPE_DB.SRC_TEST_VLT.TEST_HUB_CUSTOMER", True)


# Unchanged records in stage are not loaded into the hub with pre-existing data

@given("there are records in the HUB_CUSTOMER table")
def step_impl(context):
    context.testdata.create_schema("DV_PROTOTYPE_DB", "SRC_TEST_VLT")
    context.testdata.drop_and_create("DV_PROTOTYPE_DB", "SRC_TEST_VLT", "TEST_HUB_CUSTOMER",
                                     ["CUSTOMER_PK BINARY(16) PRIMARY KEY", "CUSTOMERKEY VARCHAR(38)", "LOADDATE DATE",
                                      "SOURCE VARCHAR(4)"], materialise="table")
    context.testdata.insert_data_from_ct(context.table, "TEST_HUB_CUSTOMER", "SRC_TEST_VLT")


@step("there is data in the stage")
def step_impl(context):
    context.testdata.drop_and_create("DV_PROTOTYPE_DB", "SRC_TEST_STG", "STG_CUSTOMER",
                                     ["CUSTOMER_PK BINARY(16)", "NATION_PK BINARY(16)",
                                      "CUSTOMER_NATION_PK BINARY(16)", "HASHDIFF VARCHAR(32)",
                                      "CUSTOMERKEY VARCHAR(38)", "CUSTOMER_NAME VARCHAR(25)",
                                      "CUSTOMER_PHONE VARCHAR(15)", "CUSTOMER_NATIONKEY NUMBER(38,0)",
                                      "SOURCE VARCHAR(4)", "LOADDATE DATE", "EFFECTIVE_FROM DATE"], materialise="table")
    context.testdata.insert_data_from_ct(context.table, "STG_CUSTOMER", "SRC_TEST_STG")


@step("I run the hub load sql script")
def step_impl(context):
    os.chdir(DBT_ROOT)
    os.system("dbt run --models test_hub_customer")


@step("only different or unchanged records are loaded to the hub")
def step_impl(context):
    sql = "SELECT CAST(CUSTOMER_PK AS VARCHAR(32)) AS CUSTOMER_PK, " \
          "CUSTOMERKEY, LOADDATE, SOURCE FROM DV_PROTOTYPE_DB.SRC_TEST_VLT.TEST_HUB_CUSTOMER " \
          "AS hub ORDER BY hub.CUSTOMERKEY;"

    table_df = context.testdata.context_table_to_df(context.table)
    result_df = DataFrame(context.testdata.general_sql_statement_to_df(sql), dtype=str)

    table_df['CUSTOMER_PK'] = table_df['CUSTOMER_PK'].str.upper()

    if result_df.equals(table_df):
        assert True
    else:
        assert False


# Only the first instance of a record is loaded into the hub table for the history


@step("only the first instance of a distinct record is loaded into the hub")
def step_impl(context):
    bindings.compare_ct_to_db_table(context, "DV_PROTOTYPE_DB.SRC_TEST_VLT.TEST_HUB_CUSTOMER", True)
