import os

from behave import *
from pandas import DataFrame

import bindings
from definitions import DBT_ROOT

use_step_matcher("parse")


# Distinct history of data from the stage is loaded into an empty hub
# Unchanged records in stage are not loaded into the hub with pre-existing data
# Only one instance of a record is loaded into the hub table for the history with multiple sources

@step("there are records in the TEST_STG_CUSTOMER table")
def step_impl(context):
    context.testdata.create_schema("DV_PROTOTYPE_DB", "SRC_TEST_STG")
    context.testdata.drop_and_create("DV_PROTOTYPE_DB", "SRC_TEST_STG", "test_stg_customer_hubs",
                                     ["CUSTOMER_ID VARCHAR(38)", "CUSTOMER_NAME VARCHAR(25)", "CUSTOMER_DOB DATE",
                                      "LOADDATE DATE", "SOURCE VARCHAR(4)", ], materialise="table")
    context.testdata.insert_data_from_ct(context.table, "test_stg_customer_hubs", "SRC_TEST_STG")


@given("there are records in the TEST_HUB_CUSTOMER table")
def step_impl(context):
    context.testdata.insert_data_from_ct(context.table, "test_stg_customer_hubs", "SRC_TEST_VLT")


@step("I run a fresh dbt hub load")
def step_impl(context):
    os.chdir(DBT_ROOT)

    os.system("dbt run --full-refresh --models +test_hub_customer_hubs")


@step("I load the TEST_HUB_CUSTOMER table")
def step_impl(context):
    os.chdir(DBT_ROOT)

    os.system("dbt run --models +test_hub_customer_hubs")


@step("only distinct records from TEST_STG_CUSTOMER are inserted into TEST_HUB_CUSTOMER")
@step("only different or unchanged records are loaded into TEST_HUB_CUSTOMER")
@step("only the first instance of a distinct record is loaded into TEST_HUB_CUSTOMER")
def step_impl(context):
    table_df = context.testdata.context_table_to_df(context.table)

    result_df = context.testdata.get_table_data(full_table_name="DV_PROTOTYPE_DB.SRC_TEST_VLT.test_hub_customer_hubs",
                                                binary_columns=['CUSTOMER_PK'], order_by='CUSTOMER_ID')

    assert context.testdata.compare_dataframes(table_df, result_df)


# Union Tests
# Distinct history of data from a union of stage tables is loaded into an empty HUB_PART


@step("there are records in the TEST_STG_PARTS table")
def step_impl(context):
    context.testdata.create_schema("DV_PROTOTYPE_DB", "SRC_TEST_STG")
    context.testdata.drop_and_create("DV_PROTOTYPE_DB", "SRC_TEST_STG", "test_stg_parts",
                                     ["PART_ID VARCHAR(38)", "PART_NAME VARCHAR(60)", "PART_TYPE VARCHAR(10)",
                                      "PART_SIZE VARCHAR(5)", "PART_RETAILPRICE DOUBLE", "LOADDATE DATE",
                                      "SOURCE VARCHAR(4)"], materialise="table")
    context.testdata.insert_data_from_ct(context.table, "test_stg_parts", "SRC_TEST_STG")


@step("there are records in the TEST_STG_SUPPLIER table")
def step_impl(context):
    context.testdata.create_schema("DV_PROTOTYPE_DB", "SRC_TEST_STG")
    context.testdata.drop_and_create("DV_PROTOTYPE_DB", "SRC_TEST_STG", "test_stg_supplier",
                                     ["PART_ID VARCHAR(38)", "SUPPLIER_ID VARCHAR(38)", "AVAILQTY INT",
                                      "SUPPLYCOST DOUBLE", "LOADDATE DATE", "SOURCE VARCHAR(4)"], materialise="table")
    context.testdata.insert_data_from_ct(context.table, "test_stg_supplier", "SRC_TEST_STG")


@step("there are records in the TEST_STG_LINEITEM table")
def step_impl(context):
    context.testdata.create_schema("DV_PROTOTYPE_DB", "SRC_TEST_STG")
    context.testdata.drop_and_create("DV_PROTOTYPE_DB", "SRC_TEST_STG", "test_stg_lineitem",
                                     ["ORDER_ID VARCHAR(38)", "PART_ID VARCHAR(38)", "SUPPLIER_ID VARCHAR(38)",
                                      "LINENUMBER NUMBER(38)", "QUANTITY INT", "EXTENDED_PRICE DOUBLE",
                                      "DISCOUNT DOUBLE", "LOADDATE DATE", "SOURCE VARCHAR(4)"], materialise="table")
    context.testdata.insert_data_from_ct(context.table, "test_stg_lineitem", "SRC_TEST_STG")


@step("I run the dbt hub load with unions")
def step_impl(context):
    os.chdir(DBT_ROOT)

    os.system("dbt run --full-refresh --models +test_hub_parts")


@step("only different or unchanged records are loaded into TEST_HUB_PARTS")
@step("only distinct records from the union are inserted into TEST_HUB_PARTS")
@step("only the first instance of a distinct record is loaded into TEST_HUB_PARTS")
def step_impl(context):
    table_df = context.testdata.context_table_to_df(context.table, ignore_columns=['SOURCE'])

    result_df = context.testdata.get_table_data(full_table_name="DV_PROTOTYPE_DB.SRC_TEST_VLT.test_hub_parts",
                                                binary_columns=['PART_PK'], order_by='PART_ID',
                                                ignore_columns=['SOURCE'])

    assert context.testdata.compare_dataframes(table_df, result_df)


# Unchanged records in stage are not loaded into the union hub with pre-existing data


@given("there are records in the TEST_HUB_PARTS table")
def step_impl(context):
    context.testdata.create_schema("DV_PROTOTYPE_DB", "SRC_TEST_VLT")
    context.testdata.drop_and_create("DV_PROTOTYPE_DB", "SRC_TEST_VLT", "test_hub_parts",
                                     ["PART_PK BINARY(16)", "PART_ID VARCHAR(38)", "SOURCE VARCHAR(4)",
                                      "LOADDATE DATE"], materialise="table")
    context.testdata.insert_data_from_ct(context.table, "test_hub_parts", "SRC_TEST_VLT")
