import os

from behave import *

from definitions import DBT_ROOT

use_step_matcher("parse")


# ============== Create Staging =================


@given("there is an empty TEST_STG_CUSTOMER table")
def step_impl(context):
    context.testdata.create_schema("DV_PROTOTYPE_DB", "SRC_TEST_STG")
    context.testdata.drop_and_create("DV_PROTOTYPE_DB", "SRC_TEST_STG", "test_stg_customer",
                                     ["CUSTOMER_ID VARCHAR(38)", "CUSTOMER_NAME VARCHAR(60)", "CUSTOMER_DOB DATE",
                                      "LOADDATE DATE", "EFFECTIVE_FROM DATE"], materialise="table")


@step("there is an empty TEST_STG_BOOKING table")
def step_impl(context):
    context.testdata.create_schema("DV_PROTOTYPE_DB", "SRC_TEST_STG")
    context.testdata.drop_and_create("DV_PROTOTYPE_DB", "SRC_TEST_STG", "test_stg_booking",
                                     ["BOOKING_REF NUMBER(38,0)", "CUSTOMER_ID VARCHAR(38)", "BOOKING_DATE DATE",
                                      "PRICE DOUBLE", "DEPARTURE_DATE DATE", "DESTINATION VARCHAR(3)",
                                      "PHONE VARCHAR(15)", "NATIONALITY VARCHAR(30)", "LOADDATE DATE"],
                                     materialise="table")


# ============ Load empty tables ================


@step("the vault is empty")
def step_impl(context):
    os.chdir(DBT_ROOT)

    os.system("dbt run --full-refresh --models snow_vault.features.load_cycles.*")


# ================ Data inserts =================


@when('the TEST_STG_CUSTOMER table has data inserted into it for day {day_number}')
def step_impl(context, day_number):
    context.testdata.create_schema("DV_PROTOTYPE_DB", "SRC_TEST_STG")
    context.testdata.drop_and_create("DV_PROTOTYPE_DB", "SRC_TEST_STG", "test_stg_customer",
                                     ["CUSTOMER_ID VARCHAR(38)", "CUSTOMER_NAME VARCHAR(60)", "CUSTOMER_DOB DATE",
                                      "LOADDATE DATE", "EFFECTIVE_FROM DATE"], materialise="table")

    context.testdata.insert_data_from_ct(context.table, "test_stg_customer", "SRC_TEST_STG")


@step('the TEST_STG_BOOKING table has data inserted into it for day {day_number}')
def step_impl(context, day_number):
    context.testdata.create_schema("DV_PROTOTYPE_DB", "SRC_TEST_STG")
    context.testdata.drop_and_create("DV_PROTOTYPE_DB", "SRC_TEST_STG", "test_stg_booking",
                                     ["BOOKING_REF NUMBER(38,0)", "CUSTOMER_ID VARCHAR(38)", "BOOKING_DATE DATE",
                                      "PRICE DOUBLE", "DEPARTURE_DATE DATE", "DESTINATION VARCHAR(3)",
                                      "PHONE VARCHAR(15)", "NATIONALITY VARCHAR(30)", "LOADDATE DATE"],
                                     materialise="table")
    context.testdata.insert_data_from_ct(context.table, "test_stg_booking", "SRC_TEST_STG")


@step('the vault is loaded for day {day_number}')
def step_impl(context, day_number):
    os.chdir(DBT_ROOT)

    os.system("dbt run --models snow_vault.features.load_cycles.*")


# ============== Check loaded data ==============


@then("we expect the TEST_HUB_CUSTOMER table to contain")
def step_impl(context):
    table_df = context.testdata.context_table_to_df(context.table,
                                                    ignore_columns=['SOURCE'])

    result_df = context.testdata.get_table_data(full_table_name="DV_PROTOTYPE_DB.SRC_TEST_VLT.test_hub_customer",
                                                binary_columns=['CUSTOMER_PK'], ignore_columns=['SOURCE'],
                                                order_by='CUSTOMER_ID')

    assert context.testdata.compare_dataframes(table_df, result_df)


@step("we expect the TEST_HUB_BOOKING table to contain")
def step_impl(context):
    table_df = context.testdata.context_table_to_df(context.table,
                                                    ignore_columns=['SOURCE'])

    result_df = context.testdata.get_table_data(full_table_name="DV_PROTOTYPE_DB.SRC_TEST_VLT.test_hub_booking",
                                                binary_columns=['BOOKING_PK'], ignore_columns=['SOURCE'],
                                                order_by='BOOKING_REF')

    assert context.testdata.compare_dataframes(table_df, result_df)


@step("we expect the TEST_LINK_CUSTOMER_BOOKING table to contain")
def step_impl(context):
    table_df = context.testdata.context_table_to_df(context.table,
                                                    ignore_columns=['SOURCE'],
                                                    order_by='BOOKING_PK')

    result_df = context.testdata.get_table_data(full_table_name="DV_PROTOTYPE_DB.SRC_TEST_VLT."
                                                                "test_link_customer_booking",
                                                binary_columns=['CUSTOMER_BOOKING_PK', 'CUSTOMER_PK', 'BOOKING_PK'],
                                                ignore_columns=['SOURCE'],
                                                order_by='BOOKING_PK')

    assert context.testdata.compare_dataframes(table_df, result_df)


@step("we expect the TEST_SAT_CUST_CUSTOMER_DETAILS table to contain")
def step_impl(context):
    table_df = context.testdata.context_table_to_df(context.table, ignore_columns=['SOURCE'], order_by='CUSTOMER_PK')

    result_df = context.testdata.get_table_data(full_table_name="DV_PROTOTYPE_DB.SRC_TEST_VLT."
                                                                "test_sat_cust_customer_details",
                                                binary_columns=['CUSTOMER_PK', 'HASHDIFF'], ignore_columns=['SOURCE'],
                                                order_by='CUSTOMER_PK')

    assert context.testdata.compare_dataframes(table_df, result_df)


@step("we expect the TEST_SAT_BOOK_CUSTOMER_DETAILS table to contain")
def step_impl(context):
    table_df = context.testdata.context_table_to_df(context.table, ignore_columns=['SOURCE'], order_by='CUSTOMER_PK')

    result_df = context.testdata.get_table_data(full_table_name="DV_PROTOTYPE_DB.SRC_TEST_VLT."
                                                                "test_sat_book_customer_details",
                                                binary_columns=['CUSTOMER_PK', 'HASHDIFF'], ignore_columns=['SOURCE'],
                                                order_by='CUSTOMER_PK')

    assert context.testdata.compare_dataframes(table_df, result_df)


@step("we expect the TEST_SAT_BOOK_BOOKING_DETAILS table to contain")
def step_impl(context):
    table_df = context.testdata.context_table_to_df(context.table, ignore_columns=['SOURCE'], order_by='BOOKING_PK')

    result_df = context.testdata.get_table_data(full_table_name="DV_PROTOTYPE_DB.SRC_TEST_VLT."
                                                                "test_sat_book_booking_details",
                                                binary_columns=['BOOKING_PK', 'HASHDIFF'], ignore_columns=['SOURCE'],
                                                order_by='BOOKING_PK')

    assert context.testdata.compare_dataframes(table_df, result_df)
