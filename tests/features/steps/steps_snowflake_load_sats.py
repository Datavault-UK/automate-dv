from behave import *
from pandas import DataFrame, Timestamp
import bindings

use_step_matcher("parse")

# Distinct history of data is loaded into a satellite table


@step("I have an empty satellite")
def step_impl(context):
    context.testdata.create_schema("DV_PROTOTYPE_DB", "TEST_VLT")
    context.testdata.drop_and_create("DV_PROTOTYPE_DB", "TEST_VLT", "SAT_HUB_CUSTOMER",
                                     ["HASHDIFF VARCHAR(32) PRIMARY KEY",
                                      ("CUSTOMER_PK VARCHAR(32) FOREIGN KEY REFERENCES "
                                       "DV_PROTOTYPE_DB.TEST_VLT.HUB_CUSTOMER(CUSTOMER_PK)"),
                                      "CUSTOMER_NAME VARCHAR(25)", "CUSTOMER_PHONE VARCHAR(15)", "LOADDATE DATE",
                                      "EFFECTIVE_FROM DATE", "SOURCE VARCHAR(4)"], materialise="table")


@step("I run the satellite load sql")
def step_impl(context):
    context.testdata.execute_sql_from_file(
        "/home/dev/PycharmProjects/SnowflakeDemo3/tests/features/helpers/sqlFiles/sat_customer_load.sql")


@step("only distinct records are loaded into the satellite")
def step_impl(context):
    sql = "SELECT * FROM DV_PROTOTYPE_DB.TEST_VLT.SAT_HUB_CUSTOMER AS hub ORDER BY hub.CUSTOMER_NAME;"
    table_df = context.testdata.context_table_to_df(context.table)
    result_df = DataFrame(context.testdata.general_sql_statement_to_df(sql), dtype=str)

    if result_df.equals(table_df):
        assert True
    else:
        assert False


# Unchanged records are not loaded into the satellite


@step("I have a satellite with pre-existing data")
def step_impl(context):
    context.testdata.create_schema("DV_PROTOTYPE_DB", "TEST_VLT")
    context.testdata.drop_and_create("DV_PROTOTYPE_DB", "TEST_VLT", "SAT_HUB_CUSTOMER",
                                     ["HASHDIFF VARCHAR(32) PRIMARY KEY",
                                      ("CUSTOMER_PK VARCHAR(32) FOREIGN KEY REFERENCES "
                                       "DV_PROTOTYPE_DB.TEST_VLT.HUB_CUSTOMER(CUSTOMER_PK)"),
                                      "CUSTOMER_NAME VARCHAR(25)", "CUSTOMER_PHONE VARCHAR(15)", "LOADDATE DATE",
                                      "EFFECTIVE_FROM DATE", "SOURCE VARCHAR(4)"], materialise="table")
    context.testdata.insert_data_from_ct(context.table, "SAT_HUB_CUSTOMER", "TEST_VLT")


@step("any unchanged records are not loaded into the satellite")
def step_impl(context):
    sql = "SELECT * FROM DV_PROTOTYPE_DB.TEST_VLT.SAT_HUB_CUSTOMER AS hub ORDER BY hub.CUSTOMER_NAME;"
    table_df = context.testdata.context_table_to_df(context.table)
    result_df = DataFrame(context.testdata.general_sql_statement_to_df(sql), dtype=str)

    if result_df.equals(table_df):
        assert True
    else:
        assert False


# Changed records are added to the satellite


@step("any changed records are loaded to the satellite")
def step_impl(context):
    sql = "SELECT * FROM DV_PROTOTYPE_DB.TEST_VLT.SAT_HUB_CUSTOMER AS hub ORDER BY hub.LOADDATE, hub.CUSTOMER_NAME;"
    table_df = context.testdata.context_table_to_df(context.table)
    result_df = DataFrame(context.testdata.general_sql_statement_to_df(sql), dtype=str)

    if result_df.equals(table_df):
        assert True
    else:
        assert False


# If there are multiple records in the history only the latest is loaded


@step("only the latest records are loaded into the satellite")
def step_impl(context):
    sql = "SELECT * FROM DV_PROTOTYPE_DB.TEST_VLT.SAT_HUB_CUSTOMER AS hub ORDER BY hub.LOADDATE, hub.CUSTOMER_NAME;"
    table_df = context.testdata.context_table_to_df(context.table)
    result_df = DataFrame(context.testdata.general_sql_statement_to_df(sql), dtype=str)

    if result_df.equals(table_df):
        assert True
    else:
        assert False
