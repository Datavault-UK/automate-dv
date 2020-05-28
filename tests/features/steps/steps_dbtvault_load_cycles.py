from behave import *

from tests.test_utils.dbt_test_utils import *
from steps.step_vars import *

use_step_matcher("parse")


# ============== Create Staging =================


@given("there is an empty TEST_STG_CUSTOMER table")
def step_impl(context):
    context.db_utils.create_schema(DATABASE, STG_SCHEMA, context.connection)
    context.db_utils.drop_and_create(DATABASE, STG_SCHEMA, f"test_stg_customer_{MODE.lower()}",
                                     ["CUSTOMER_ID VARCHAR(38)", "CUSTOMER_NAME VARCHAR(60)", "CUSTOMER_DOB DATE",
                                      "LOADDATE DATE", "EFFECTIVE_FROM DATE"], connection=context.connection)


@step("there is an empty TEST_STG_BOOKING table")
def step_impl(context):
    context.db_utils.create_schema(DATABASE, STG_SCHEMA, context.connection)
    context.db_utils.drop_and_create(DATABASE, STG_SCHEMA, f"test_stg_booking_{MODE.lower()}",
                                     ["BOOKING_REF NUMBER(38,0)", "CUSTOMER_ID VARCHAR(38)", "BOOKING_DATE DATE",
                                      "PRICE DOUBLE", "DEPARTURE_DATE DATE", "DESTINATION VARCHAR(3)",
                                      "PHONE VARCHAR(15)", "NATIONALITY VARCHAR(30)", "LOADDATE DATE"],
                                     connection=context.connection)


# ============ Load empty tables ================


@step("the vault is empty")
def step_impl(context):
    os.chdir(TESTS_DBT_ROOT)

    context.dbt_test_utils.run_dbt_model(mode='run', model=f"load_cycles_{MODE.lower()}", include_tag=True)


# ================ Data inserts =================

@when('the TEST_STG_CUSTOMER table has data inserted into it for day {day_number}')
def step_impl(context, day_number):
    context.db_utils.create_schema(DATABASE, STG_SCHEMA, context.connection)
    context.db_utils.drop_and_create(DATABASE, STG_SCHEMA, f"test_stg_customer_{MODE.lower()}",
                                     ["CUSTOMER_ID VARCHAR(38)", "CUSTOMER_NAME VARCHAR(60)", "CUSTOMER_DOB DATE",
                                      "LOADDATE DATE", "EFFECTIVE_FROM DATE"], connection=context.connection)

    context.db_utils.insert_data_from_ct(context.table, f"test_stg_customer_{MODE.lower()}", STG_SCHEMA,
                                         connection=context.connection)


@step('the TEST_STG_BOOKING table has data inserted into it for day {day_number}')
def step_impl(context, day_number):
    context.db_utils.create_schema(DATABASE, STG_SCHEMA, context.connection)
    context.db_utils.drop_and_create(DATABASE, STG_SCHEMA, f"test_stg_booking_{MODE.lower()}",
                                     ["BOOKING_REF NUMBER(38,0)", "CUSTOMER_ID VARCHAR(38)", "BOOKING_DATE DATE",
                                      "PRICE DOUBLE", "DEPARTURE_DATE DATE", "DESTINATION VARCHAR(3)",
                                      "PHONE VARCHAR(15)", "NATIONALITY VARCHAR(30)", "LOADDATE DATE"],
                                     connection=context.connection)
    context.db_utils.insert_data_from_ct(context.table, f"test_stg_booking_{MODE.lower()}", STG_SCHEMA,
                                         connection=context.connection)


@step('the vault is loaded for day {day_number}')
def step_impl(context, day_number):
    os.chdir(TESTS_DBT_ROOT)

    os.system(f"dbt run --models tag:load_cycles_{MODE.lower()}")


# ============== Check loaded data ==============


@then("we expect the TEST_HUB_CUSTOMER table to contain")
def step_impl(context):
    table_df = context.db_utils.context_table_to_df(context.table, ignore_columns=['SOURCE'],
                                                    binary_columns=['CUSTOMER_PK'])

    result_df = context.db_utils.get_table_data(full_table_name=f"{DATABASE}.{VLT_SCHEMA}.test_hub_customer_{MODE.lower()}",
                                                binary_columns=['CUSTOMER_PK'], ignore_columns=['SOURCE'],
                                                order_by='CUSTOMER_ID', connection=context.connection)

    assert context.db_utils.compare_dataframes(table_df, result_df)


@step("we expect the TEST_HUB_BOOKING table to contain")
def step_impl(context):
    table_df = context.db_utils.context_table_to_df(context.table, ignore_columns=['SOURCE'],
                                                    binary_columns=['BOOKING_PK'])

    result_df = context.db_utils.get_table_data(full_table_name=f"{DATABASE}.{VLT_SCHEMA}.test_hub_booking_{MODE.lower()}",
                                                binary_columns=['BOOKING_PK'], ignore_columns=['SOURCE'],
                                                order_by='BOOKING_REF', connection=context.connection)

    assert context.db_utils.compare_dataframes(table_df, result_df)


@step("we expect the TEST_LINK_CUSTOMER_BOOKING table to contain")
def step_impl(context):
    table_df = context.db_utils.context_table_to_df(context.table, ignore_columns=['SOURCE'], order_by='BOOKING_PK',
                                                    binary_columns=['CUSTOMER_BOOKING_PK', 'CUSTOMER_PK', 'BOOKING_PK'])

    result_df = context.db_utils.get_table_data(
        full_table_name=f"{DATABASE}.{VLT_SCHEMA}.test_link_customer_booking_{MODE.lower()}",
        binary_columns=['CUSTOMER_BOOKING_PK', 'CUSTOMER_PK', 'BOOKING_PK'], ignore_columns=['SOURCE'],
        order_by='BOOKING_PK', connection=context.connection)

    assert context.db_utils.compare_dataframes(table_df, result_df)


@step("we expect the TEST_SAT_CUST_CUSTOMER_DETAILS table to contain")
def step_impl(context):
    table_df = context.db_utils.context_table_to_df(context.table, ignore_columns=['SOURCE'],
                                                    order_by=['CUSTOMER_NAME', 'LOADDATE'],
                                                    binary_columns=['CUSTOMER_PK', 'HASHDIFF'])

    result_df = context.db_utils.get_table_data(
        full_table_name=f"{DATABASE}.{VLT_SCHEMA}.test_sat_cust_customer_details_{MODE.lower()}",
        binary_columns=['CUSTOMER_PK', 'HASHDIFF'], ignore_columns=['SOURCE'], order_by=['CUSTOMER_NAME', 'LOADDATE'],
        connection=context.connection)

    assert context.db_utils.compare_dataframes(table_df, result_df)


@step("we expect the TEST_SAT_BOOK_CUSTOMER_DETAILS table to contain")
def step_impl(context):
    table_df = context.db_utils.context_table_to_df(context.table, ignore_columns=['SOURCE'], order_by='CUSTOMER_PK',
                                                    binary_columns=['CUSTOMER_PK', 'HASHDIFF'])

    result_df = context.db_utils.get_table_data(
        full_table_name=f"{DATABASE}.{VLT_SCHEMA}.test_sat_book_customer_details_{MODE.lower()}",
        binary_columns=['CUSTOMER_PK', 'HASHDIFF'], ignore_columns=['SOURCE'], order_by='CUSTOMER_PK',
        connection=context.connection)

    assert context.db_utils.compare_dataframes(table_df, result_df)


@step("we expect the TEST_SAT_BOOK_BOOKING_DETAILS table to contain")
def step_impl(context):
    table_df = context.db_utils.context_table_to_df(context.table, ignore_columns=['SOURCE'], order_by='BOOKING_PK',
                                                    binary_columns=['BOOKING_PK', 'HASHDIFF'])

    result_df = context.db_utils.get_table_data(
        full_table_name=f"{DATABASE}.{VLT_SCHEMA}.test_sat_book_booking_details_{MODE.lower()}",
        binary_columns=['BOOKING_PK', 'HASHDIFF'], ignore_columns=['SOURCE'], order_by='BOOKING_PK',
        connection=context.connection)

    assert context.db_utils.compare_dataframes(table_df, result_df)
