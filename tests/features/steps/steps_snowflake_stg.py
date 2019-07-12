from behave import *

from pandas import DataFrame

import bindings
import os

use_step_matcher("parse")

# The data from v_history is staged into a view with hashes, loaddates, and sources for the customers


@given("there are records in source")
def step_impl(context):
    context.testdata.create_schema("DV_PROTOTYPE_DB", "SRC_TEST_SRC")
    context.testdata.drop_table("DV_PROTOTYPE_DB", "SRC_TEST_SRC", "TEST_SOURCE", materialise="table")
    context.testdata.insert_data_from_ct(context.table, "TEST_SOURCE", "SRC_TEST_SRC")


@step("I run the dbt sql for the stage")
def step_impl(context):
    # context.testdata.create_schema("DV_PROTOTYPE_DB", "SRC_TEST_STG")
    # context.testdata.drop_table("DV_PROTOTYPE_DB", "SRC_TEST_STG", "TEST_STG", materialise="view")
    # context.testdata.execute_sql_from_file(
    #     "/home/dev/PycharmProjects/SnowflakeDemo3/tests/features/helpers/sqlFiles/v_stg_customer.sql")
    os.chdir("/home/dev/PycharmProjects/SnowflakeDemo3/src/snowflakeDemo")
    os.system("dbt run --models test_stg")


@step("there are records in v_stg_customer")
def step_impl(context):
    sql = "SELECT COUNT(*) FROM DV_PROTOTYPE_DB.SRC_TEST_STG.TEST_STG"
    result = context.testdata.general_sql_statement_to_df(sql)

    if result["COUNT(*)"][0] > 0:
        assert True
    else:
        assert False


@step("it contains the original data and required hashes")
def step_impl(context):
    table_df = context.testdata.context_table_to_df(context.table)
    result_df = DataFrame(context.testdata.get_table_data("DV_PROTOTYPE_DB.SRC_TEST_STG.TEST_STG"), dtype=str)

    if result_df.equals(table_df):
        assert True
    else:
        assert False
