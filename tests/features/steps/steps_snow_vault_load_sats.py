import os

from behave import *
from pandas import DataFrame

from definitions import DBT_ROOT

use_step_matcher("parse")


@given("I have a TEST_SAT_CUSTOMER satellite with pre-existing data")
def step_impl(context):
    context.testdata.create_schema("DV_PROTOTYPE_DB", "SRC_TEST_VLT")
    context.testdata.drop_and_create("DV_PROTOTYPE_DB", "SRC_TEST_VLT", "test_sat_customer",
                                     ["HASHDIFF BINARY(16)", "CUSTOMER_PK BINARY(16)",
                                      "NAME VARCHAR(60)", "PHONE VARCHAR(15)", "DOB DATE",
                                      "LOADDATE DATE", "EFFECTIVE_FROM DATE", "SOURCE VARCHAR(4)"],
                                     materialise="table")

    context.testdata.insert_data_from_ct(context.table, "test_sat_customer", "SRC_TEST_VLT")


@step('the TEST_STG_CUSTOMER table has data inserted into it')
def step_impl(context):
    context.testdata.create_schema("DV_PROTOTYPE_DB", "SRC_TEST_STG")
    context.testdata.drop_and_create("DV_PROTOTYPE_DB", "SRC_TEST_STG", "test_stg_customer_sats",
                                     ["CUSTOMER_ID VARCHAR(38)", "CUSTOMER_NAME VARCHAR(60)",
                                      "CUSTOMER_DOB DATE", "CUSTOMER_PHONE VARCHAR(15)",
                                      "LOADDATE DATE", "SOURCE VARCHAR(4)"],
                                     materialise="table")

    context.testdata.insert_data_from_ct(context.table, "test_stg_customer_sats", "SRC_TEST_STG")


@step("I run a fresh dbt sat load")
def step_impl(context):
    os.chdir(DBT_ROOT)
    os.system("dbt run --full-refresh --models +dbtvault.features.load_sats.test_sat_customer")


@step("I run the dbt sat load")
def step_impl(context):
    os.chdir(DBT_ROOT)
    os.system("dbt run --models +dbtvault.features.load_sats.test_sat_customer")


@step("records are inserted into the satellite")
@step("any unchanged records are not loaded into the satellite")
@step("any changed records are loaded to the satellite")
@step("only the latest records are loaded into the satellite")
def step_impl(context):
    table_df = context.testdata.context_table_to_df(context.table, ignore_columns='SOURCE')

    result_df = context.testdata.get_table_data(full_table_name="DV_PROTOTYPE_DB.SRC_TEST_VLT.test_sat_customer",
                                                binary_columns=['CUSTOMER_PK', 'HASHDIFF'],
                                                ignore_columns='SOURCE',
                                                order_by='NAME')

    assert context.testdata.compare_dataframes(table_df, result_df)

# If there are duplicate records in the history only the latest is loaded


@given("I have an empty TEST_SAT_CUSTOMER satellite")
def step_impl(context):
    context.testdata.create_schema("DV_PROTOTYPE_DB", "SRC_TEST_VLT")
    context.testdata.drop_and_create("DV_PROTOTYPE_DB", "SRC_TEST_VLT", "test_sat_customer",
                                     ["HASHDIFF BINARY(16)", "CUSTOMER_PK BINARY(16)",
                                      "NAME VARCHAR(60)", "PHONE VARCHAR(15)", "DOB DATE",
                                      "LOADDATE DATE", "EFFECTIVE_FROM DATE", "SOURCE VARCHAR(4)"],
                                     materialise="table")


# ============ Extra Load steps ================


@step("the TEST_SAT_CUST_CUSTOMER table is empty")
def step_impl(context):
    os.chdir(DBT_ROOT)

    os.system("dbt run --full-refresh --models +test_sat_cust_customer_details+")


@step('the TEST_SAT_CUST_CUSTOMER is loaded for day {day_number}')
def step_impl(context, day_number):
    os.chdir(DBT_ROOT)

    os.system("dbt run --models +test_sat_cust_customer_details")
