import os

from behave import *

from definitions import DBT_ROOT

use_step_matcher("parse")


# LOAD STEPS


@step("I load the TEST_SAT_CUSTOMER_DETAILS table")
def step_impl(context):
    os.chdir(DBT_ROOT)
    os.system("dbt run --models +dbtvault.features.load_sats.test_sat_customer_details")


# MAIN STEPS


@step('the TEST_STG_CUSTOMER table has data inserted into it')
def step_impl(context):
    context.dbutils.create_schema(DATABASE, STG_SCHEMA)
    context.dbutils.drop_and_create(DATABASE, STG_SCHEMA, "test_stg_customer_details",
                                    ["CUSTOMER_ID VARCHAR(38)", "CUSTOMER_NAME VARCHAR(60)", "CUSTOMER_DOB DATE",
                                     "CUSTOMER_PHONE VARCHAR(15)", "LOADDATE DATE", "SOURCE VARCHAR(4)"],
                                    connection=context.connection)

    context.dbutils.insert_data_from_ct(context.table, "test_stg_customer_details", STG_SCHEMA)


@given("I have an empty TEST_SAT_CUSTOMER_DETAILS table")
def step_impl(context):
    context.dbutils.drop_and_create(DATABASE, VLT_SCHEMA, "test_sat_customer_details",
                                    ["HASHDIFF BINARY(16)", "CUSTOMER_PK BINARY(16)", "NAME VARCHAR(60)",
                                     "PHONE VARCHAR(15)", "DOB DATE", "LOADDATE DATE", "EFFECTIVE_FROM DATE",
                                     "SOURCE VARCHAR(4)"], connection=context.connection)


@given("there are records in the TEST_SAT_CUSTOMER_DETAILS table")
def step_impl(context):
    context.dbutils.create_schema(DATABASE, VLT_SCHEMA)
    context.dbutils.drop_and_create(DATABASE, VLT_SCHEMA, "test_sat_customer_details",
                                    ["HASHDIFF BINARY(16)", "CUSTOMER_PK BINARY(16)", "NAME VARCHAR(60)",
                                     "PHONE VARCHAR(15)", "DOB DATE", "LOADDATE DATE", "EFFECTIVE_FROM DATE",
                                     "SOURCE VARCHAR(4)"], connection=context.connection)

    context.dbutils.insert_data_from_ct(context.table, "test_sat_customer_details", VLT_SCHEMA)


@step("the TEST_SAT_CUSTOMER_DETAILS table should contain")
def step_impl(context):
    table_df = context.dbutils.context_table_to_df(context.table, ignore_columns='SOURCE',
                                                   binary_columns=['CUSTOMER_PK', 'HASHDIFF'])

    result_df = context.dbutils.get_table_data(
        full_table_name=DATABASE + VLT_SCHEMA + ".test_sat_customer_details",
        binary_columns=['CUSTOMER_PK', 'HASHDIFF'], ignore_columns='SOURCE', order_by='NAME')

    assert context.dbutils.compare_dataframes(table_df, result_df)


# CYCLE SCENARIO STEPS

@given("I have an empty TEST_SAT_CUST_CUSTOMER table")
def step_impl(context):
    context.dbutils.drop_and_create(DATABASE, VLT_SCHEMA, "test_sat_cust_customer_details",
                                    ["CUSTOMER_PK BINARY(16)", "HASHDIFF BINARY(16)", "NAME VARCHAR(60)", "DOB DATE",
                                     "EFFECTIVE_FROM DATE", "LOADDATE DATE", "SOURCE VARCHAR(4)"], connection=context.connection)


@step('the TEST_SAT_CUST_CUSTOMER is loaded for day {day_number}')
def step_impl(context, day_number):
    os.chdir(DBT_ROOT)

    os.system("dbt run --models +test_sat_cust_customer_details")
