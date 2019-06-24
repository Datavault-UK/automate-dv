from behave import *

import bindings

use_step_matcher("parse")

# Data From TPCH is joined into a history flat file view


@given("there is data in the TPCH sample data")
def step_impl(context):
    results = context.testdata.general_sql_statement_to_df(
        "SELECT COUNT(*) FROM SNOWFLAKE_SAMPLE_DATA.TPCH_SF10.ORDERS;")
    if results[0][0] != 0:
        assert True
    else:
        assert False


@step("I run the sql query to create the history flat file")
def step_impl(context):
    context.testdata.create_schema("DV_PROTOTYPE_DB", "TEST_SRC")
    context.testdata.drop_table("DV_PROTOTYPE_DB", "TEST_SRC", "V_HISTORY", materialise="view")
    context.testdata.execute_sql_from_file(
        "/home/dev/PycharmProjects/SnowflakeDemo3/tests/features/helpers/sqlFiles/v_history.sql")


@step("the history flat file must have 57 columns")
def step_impl(context):

    bindings.column_count(context, "DV_PROTOTYPE_DB", "TEST_SRC", "V_HISTORY", 57)


@step("there are no records past the specified date")
def step_impl(context):

    sql = ("SELECT COUNT(*) FROM DV_PROTOTYPE_DB.TEST_SRC.V_HISTORY AS a "
           "WHERE a.ORDERDATE > CAST('1993-01-01' AS DATE) "
           "AND a.SHIPDATE > CAST('1993-01-01' AS DATE) "
           "AND a.COMMITDATE > CAST('1993-01-01' AS DATE) "
           "AND a.RECEIPTDATE > CAST('1993-01-01' AS DATE);")

    result = context.testdata.general_sql_statement_to_df(sql)

    if result[0][0] == 0:
        assert True
    else:
        assert False

# Data From TPCH is joined into a flat file view for day1 load


@step("I run the sql query to create the day1 flat file")
def step_impl(context):
    context.testdata.drop_table("DV_PROTOTYPE_DB", "TEST_SRC", "V_DAY1", materialise="view")
    context.testdata.execute_sql_from_file(
        "/home/dev/PycharmProjects/SnowflakeDemo3/tests/features/helpers/sqlFiles/v_day1.sql")


@step("the day1 flat file must have 57 columns")
def step_impl(context):

    bindings.column_count(context, "DV_PROTOTYPE_DB", "TEST_SRC", "V_DAY1", 57)


@step("there are only records between the day1 date and history date")
def step_impl(context):

    sql = [("SELECT COUNT(*) FROM DV_PROTOTYPE_DB.TEST_SRC.V_DAY1 AS a "
            "WHERE a.ORDERDATE < CAST('1993-01-01' AS DATE) "
            "AND a.SHIPDATE < CAST('1993-01-01' AS DATE) "
            "AND a.COMMITDATE < CAST('1993-01-01' AS DATE) "
            "AND a.RECEIPTDATE < CAST('1993-01-01' AS DATE);"),
           ("SELECT COUNT(*) FROM DV_PROTOTYPE_DB.TEST_SRC.V_DAY1 AS a "
            "WHERE a.ORDERDATE > CAST('1993-01-02' AS DATE) "
            "AND a.SHIPDATE > CAST('1993-01-02' AS DATE) "
            "AND a.COMMITDATE > CAST('1993-01-02' AS DATE) "
            "AND a.RECEIPTDATE > CAST('1993-01-02' AS DATE);")]

    results1 = context.testdata.general_sql_statement_to_df(sql[0])
    results2 = context.testdata.general_sql_statement_to_df(sql[1])

    if results1[0][0] == 0 and results2[0][0] == 0:
        assert True
    else:
        assert False


# Data From TPCH is joined into a flat file view for day2 load

@step("I run the sql query to create the day2 flat file")
def step_impl(context):
    context.testdata.drop_table("DV_PROTOTYPE_DB", "TEST_SRC", "V_DAY2", materialise="view")
    context.testdata.execute_sql_from_file(
        "/home/dev/PycharmProjects/SnowflakeDemo3/tests/features/helpers/sqlFiles/v_day2.sql")


@step("the day2 flat file must have 57 columns")
def step_impl(context):

    bindings.column_count(context, "DV_PROTOTYPE_DB", "TEST_SRC", "V_HISTORY", 57)


@step("there are only records between the day2 date and history date")
def step_impl(context):

    sql = [("SELECT COUNT(*) FROM DV_PROTOTYPE_DB.TEST_SRC.V_DAY2 AS a "
            "WHERE a.ORDERDATE < CAST('1993-01-01' AS DATE) "
            "AND a.SHIPDATE < CAST('1993-01-01' AS DATE) "
            "AND a.COMMITDATE < CAST('1993-01-01' AS DATE) "
            "AND a.RECEIPTDATE < CAST('1993-01-01' AS DATE);"),
           ("SELECT COUNT(*) FROM DV_PROTOTYPE_DB.TEST_SRC.V_DAY2 AS a "
            "WHERE a.ORDERDATE > CAST('1993-01-03' AS DATE) "
            "AND a.SHIPDATE > CAST('1993-01-03' AS DATE) "
            "AND a.COMMITDATE > CAST('1993-01-03' AS DATE) "
            "AND a.RECEIPTDATE > CAST('1993-01-03' AS DATE);")]

    results1 = context.testdata.general_sql_statement_to_df(sql[0])
    results2 = context.testdata.general_sql_statement_to_df(sql[1])

    if results1[0][0] == 0 and results2[0][0] == 0:
        assert True
    else:
        assert False


# Data From TPCH is joined into a flat file view for day3 load

@step("I run the sql query to create the day3 flat file")
def step_impl(context):
    context.testdata.drop_table("DV_PROTOTYPE_DB", "TEST_SRC", "V_DAY3", materialise="view")
    context.testdata.execute_sql_from_file(
        "/home/dev/PycharmProjects/SnowflakeDemo3/tests/features/helpers/sqlFiles/v_day3.sql")


@step("the day3 flat file must have 57 columns")
def step_impl(context):
    bindings.column_count(context, "DV_PROTOTYPE_DB", "TEST_SRC", "V_DAY3", 57)


@step("there are only records between the day3 date and history date")
def step_impl(context):
    sql = [("SELECT COUNT(*) FROM DV_PROTOTYPE_DB.TEST_SRC.V_DAY1 AS a "
            "WHERE a.ORDERDATE < CAST('1993-01-01' AS DATE) "
            "AND a.SHIPDATE < CAST('1993-01-01' AS DATE) "
            "AND a.COMMITDATE < CAST('1993-01-01' AS DATE) "
            "AND a.RECEIPTDATE < CAST('1993-01-01' AS DATE);"),
           ("SELECT COUNT(*) FROM DV_PROTOTYPE_DB.TEST_SRC.V_DAY1 AS a "
            "WHERE a.ORDERDATE > CAST('1993-01-04' AS DATE) "
            "AND a.SHIPDATE > CAST('1993-01-04' AS DATE) "
            "AND a.COMMITDATE > CAST('1993-01-04' AS DATE) "
            "AND a.RECEIPTDATE > CAST('1993-01-04' AS DATE);")]

    results1 = context.testdata.general_sql_statement_to_df(sql[0])
    results2 = context.testdata.general_sql_statement_to_df(sql[1])

    if results1[0][0] == 0 and results2[0][0] == 0:
        assert True
    else:
        assert False
