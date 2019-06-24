from behave import *

from pandas import DataFrame

import bindings

use_step_matcher("parse")

# The data from v_history is staged into a view with hashes, loaddates, and sources for the customers


@given("there are records in v_history")
def step_impl(context):
    context.testdata.drop_table("DV_PROTOTYPE_DB", "TEST_SRC", "HISTORY", materialise="table")
    context.testdata.insert_data_from_ct(context.table, "HISTORY", "TEST_SRC")


@step("I run the sql query to create the staging view for the customers from the v_history")
def step_impl(context):
    context.testdata.create_schema("DV_PROTOTYPE_DB", "TEST_STG")
    context.testdata.drop_table("DV_PROTOTYPE_DB", "TEST_STG", "V_STG_CUSTOMER", materialise="view")
    context.testdata.execute_sql_from_file(
        "/home/dev/PycharmProjects/SnowflakeDemo3/tests/features/helpers/sqlFiles/v_stg_customer.sql")


@step("there are records in v_stg_customer")
def step_impl(context):
    sql = "SELECT COUNT(*) FROM DV_PROTOTYPE_DB.TEST_STG.V_STG_CUSTOMER;"
    result = context.testdata.general_sql_statement_to_df(sql)

    if result["COUNT(*)"][0] > 0:
        assert True
    else:
        assert False


@step("it contains the original data and required hashes")
def step_impl(context):
    table_df = context.testdata.context_table_to_df(context.table)
    result_df = DataFrame(context.testdata.get_table_data("DV_PROTOTYPE_DB.TEST_STG.V_STG_CUSTOMER"), dtype=str)

    if result_df.equals(table_df):
        assert True
    else:
        assert False
