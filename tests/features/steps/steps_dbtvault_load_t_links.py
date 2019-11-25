import os

from behave import *

from definitions import TESTS_DBT_ROOT
from steps.step_vars import *

use_step_matcher("parse")


@given("I have an empty TEST_TLINK_TRANSACTION table")
def step_impl(context):
    context.dbutils.create_schema(DATABASE, VLT_SCHEMA, context.connection)
    context.dbutils.drop_and_create(DATABASE, VLT_SCHEMA, "test_tlink_transaction",
                                    ["TRANSACTION_PK BINARY(16)", "CUSTOMER_PK BINARY(16)",
                                     "TRANSACTION_NUMBER NUMBER(38,0)", "TRANSACTION_DATE DATE", "LOADDATE DATE",
                                     "SOURCE VARCHAR(3)", "TYPE VARCHAR(2)", "AMOUNT NUMBER(38,2)",
                                     "EFFECTIVE_FROM DATE", ], connection=context.connection)


@step("a populated TEST_STG_TRANSACTION table")
def step_impl(context):
    context.dbutils.create_schema(DATABASE, STG_SCHEMA, context.connection)
    context.dbutils.drop_and_create(DATABASE, STG_SCHEMA, "test_stg_transaction",
                                    ["CUSTOMER_ID VARCHAR(38)", "TRANSACTION_NUMBER NUMBER(38,0)",
                                     "TRANSACTION_DATE DATE", "LOADDATE DATE", "SOURCE VARCHAR(3)", "TYPE VARCHAR(2)",
                                     "AMOUNT NUMBER(38,2)"], connection=context.connection)

    context.dbutils.insert_data_from_ct(context.table, "test_stg_transaction", STG_SCHEMA, context.connection)


@when("I load the TEST_TLINK_TRANSACTION table")
def step_impl(context):
    os.chdir(TESTS_DBT_ROOT)
    os.system("dbt run --models +test_t_link_transaction")


@then("the TLINK_TRANSACTION_TABLE should contain")
def step_impl(context):
    table_df = context.dbutils.context_table_to_df(context.table, ignore_columns='SOURCE',
                                                   binary_columns=['TRANSACTION_PK', 'CUSTOMER_PK'])

    result_df = context.dbutils.get_table_data(full_table_name=DATABASE + "." + VLT_SCHEMA + ".test_t_link_transaction",
                                               binary_columns=['TRANSACTION_PK', 'CUSTOMER_PK'],
                                               ignore_columns='SOURCE', order_by='TRANSACTION_NUMBER',
                                               connection=context.connection)

    assert context.dbutils.compare_dataframes(table_df, result_df)
