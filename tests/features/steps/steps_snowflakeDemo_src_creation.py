from behave import *

use_step_matcher("parse")

# Data From TPCH is joined into a history flat file view


@given("there is data in the TPCH sample data")
def step_impl(context):
    results = context.testdata.general_sql_statement_to_df(
        "SELECT COUNT(*) FROM SNOWFLAKE_SAMPLE_DATA.TPCH_SF10.ORDERS;")
    if results[0][0] != 0:
        return True
    else:
        return False


@step("I run the sql query to create the history flat file")
def step_impl(context):
    context.testdata.drop_table("DV_PROTOTYPE_DB", "TEST_SRC", "V_HISTORY", materialise="view")
    context.testdata.execute_sql_from_file(
        "/home/dev/PycharmProjects/SnowflakeDemo3/tests/features/helpers/sqlFiles/v_history.sql")


@step("the history flat file must have 57 columns")
def step_impl(context):
    result = context.testdata.general_sql_statement_to_df(
                "SELECT COUNT(COLUMN_NAME) AS COLUMN_COUNT FROM DV_PROTOTYPE_DB.INFORMATION_SCHEMA.COLUMNS "
                "WHERE TABLE_CATALOG = 'DV_PROTOTYPE_DB' "
                "AND TABLE_SCHEMA = 'TEST_SRC' "
                "AND TABLE_NAME = 'V_HISTORY';")
    if result[0][0] == 57:
        return True
    else:
        return False


@step("there are no records past the specified date")
def step_impl(context):
    result = context.testdata.general_sql_statement_to_df(
        "SELECT COUNT(*) FROM DV_PROTOTYPE_DB.TEST_SRC.V_HISTORY AS a "
        "WHERE a.ORDERDATE > CAST('1993-01-01' AS DATE);")
    if result[0][0] == 0:
        return True
    else:
        return False
