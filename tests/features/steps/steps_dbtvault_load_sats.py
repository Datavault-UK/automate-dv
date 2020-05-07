from behave import *

from dbt_test_utils import TESTS_DBT_ROOT
from steps.step_vars import *

use_step_matcher("parse")


# MAIN STEPS


@step('the TEST_STG_CUSTOMER table has data inserted into it')
def step_impl(context):
    context.dbutils.create_schema(DATABASE, STG_SCHEMA, context.connection)
    context.dbutils.drop_and_create(DATABASE, STG_SCHEMA, f"test_stg_customer_details_{MODE.lower()}",
                                    ["CUSTOMER_ID VARCHAR(38)", "CUSTOMER_NAME VARCHAR(60)", "CUSTOMER_DOB DATE",
                                     "CUSTOMER_PHONE VARCHAR(15)", "LOADDATE DATE", "SOURCE VARCHAR(4)"],
                                    connection=context.connection)

    context.dbutils.insert_data_from_ct(context.table, f"test_stg_customer_details_{MODE.lower()}", STG_SCHEMA,
                                        context.connection)


@given("I have an empty TEST_SAT_CUSTOMER_DETAILS table")
def step_impl(context):
    context.dbutils.drop_and_create(DATABASE, VLT_SCHEMA, f"test_sat_customer_details_{MODE.lower()}",
                                    ["HASHDIFF BINARY", "CUSTOMER_PK BINARY", "CUSTOMER_NAME VARCHAR(60)",
                                     "CUSTOMER_PHONE VARCHAR(15)", "CUSTOMER_DOB DATE", "LOADDATE DATE",
                                     "EFFECTIVE_FROM DATE", "SOURCE VARCHAR(4)"],
                                    connection=context.connection)


@given("there are records in the TEST_SAT_CUSTOMER_DETAILS table")
def step_impl(context):
    context.dbutils.create_schema(DATABASE, VLT_SCHEMA, context.connection)
    context.dbutils.drop_and_create(DATABASE, VLT_SCHEMA, f"test_sat_customer_details_{MODE.lower()}",
                                    ["HASHDIFF BINARY", "CUSTOMER_PK BINARY", "CUSTOMER_NAME VARCHAR(60)",
                                     "CUSTOMER_PHONE VARCHAR(15)", "CUSTOMER_DOB DATE", "LOADDATE DATE",
                                     "EFFECTIVE_FROM DATE", "SOURCE VARCHAR(4)"],
                                    connection=context.connection)

    context.dbutils.insert_data_from_ct(context.table, f"test_sat_customer_details_{MODE.lower()}", VLT_SCHEMA,
                                        context.connection)


@step("the TEST_SAT_CUSTOMER_DETAILS table should contain")
def step_impl(context):
    table_df = context.dbutils.context_table_to_df(context.table, ignore_columns='SOURCE',
                                                   binary_columns=['CUSTOMER_PK', 'HASHDIFF'])

    result_df = context.dbutils.get_table_data(
        full_table_name=f'{DATABASE}.{VLT_SCHEMA}.test_sat_customer_details_{MODE.lower()}',
        binary_columns=['CUSTOMER_PK', 'HASHDIFF'], ignore_columns='SOURCE', order_by='CUSTOMER_NAME',
        connection=context.connection)

    assert context.dbutils.compare_dataframes(table_df, result_df)


# CYCLE SCENARIO STEPS

@given("I have an empty TEST_SAT_CUST_CUSTOMER_DETAILS table")
def step_impl(context):
    context.dbutils.create_schema(DATABASE, VLT_SCHEMA, context.connection)
    context.dbutils.drop_and_create(DATABASE, VLT_SCHEMA, f"test_sat_cust_customer_details_{MODE.lower()}",
                                    ["CUSTOMER_PK BINARY", "HASHDIFF BINARY", "CUSTOMER_NAME VARCHAR(60)",
                                     "CUSTOMER_DOB DATE", "EFFECTIVE_FROM DATE", "LOADDATE DATE", "SOURCE VARCHAR(4)"],
                                    connection=context.connection)


@step('the TEST_SAT_CUST_CUSTOMER_DETAILS is loaded for day {day_number}')
def step_impl(context, day_number):
    os.chdir(TESTS_DBT_ROOT)

    os.system(f"dbt run --models +test_sat_cust_customer_details_{MODE.lower()}")


@step('the {model_name} table is loaded for day {day_number} using SHA hashing')
def step_impl(context, model_name, day_number):
    os.chdir(TESTS_DBT_ROOT)

    os.system(f'dbt run --vars "{{\\"hash\\": \\"SHA\\"}}" --models +{model_name.lower()}_{MODE.lower()}')
