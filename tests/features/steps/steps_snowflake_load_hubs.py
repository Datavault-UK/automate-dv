from behave import *

from pandas import DataFrame, Timestamp

use_step_matcher("parse")

# Distinct data from stage is loaded into an empty hub


@given("there is an empty HUB_CUSTOMER table")
def step_impl(context):
    context.testdata.create_schema("DV_PROTOTYPE_DB", "TEST_VLT")
    context.testdata.drop_and_create("DV_PROTOTYPE_DB", "TEST_VLT", "HUB_CUSTOMER",
                                     ["CUSTOMER_PK VARCHAR(32)", "CUSTOMERKEY VARCHAR(38)", "LOADDATE DATE",
                                      "SOURCE VARCHAR(4)"], materialise="table")


@step("there are records in the V_STG_CUSTOMER view")
def step_impl(context):
    context.testdata.drop_and_create("DV_PROTOTYPE_DB", "TEST_STG", "STG_CUSTOMER",
                                     ["CUSTOMER_PK VARCHAR(32)", "NATION_PK VARCHAR(32)",
                                      "CUSTOMER_NATION_PK VARCHAR(32)", "HASHDIFF VARCHAR(32)",
                                      "CUSTOMERKEY VARCHAR(38)", "CUSTOMER_NAME VARCHAR(25)",
                                      "CUSTOMER_PHONE VARCHAR(15)", "CUSTOMER_NATIONKEY NUMBER(38,0)",
                                      "SOURCE VARCHAR(4)", "LOADDATE DATE"],
                                     materialise="table")
    context.testdata.insert_data_from_ct(context.table, "STG_CUSTOMER", "TEST_STG")


@step("I run the hub load sql script")
def step_impl(context):
    context.testdata.execute_sql_from_file(
        "/home/dev/PycharmProjects/SnowflakeDemo3/tests/features/helpers/sqlFiles/hub_customer_load.sql")


@step("only distinct records from STG_CUSTOMER are inserted into HUB_CUSTOMER")
def step_impl(context):
    table_df = context.testdata.context_table_to_df(context.table)
    result_df = DataFrame(context.testdata.get_table_data("DV_PROTOTYPE_DB.TEST_VLT.HUB_CUSTOMER"), dtype=str)

    if result_df.equals(table_df):
        return True
    else:
        return False


# Unchanged records in stage are not loaded into the hub with pre-existing data

@given("there are records in the HUB_CUSTOMER table")
def step_impl(context):
    context.testdata.create_schema("DV_PROTOTYPE_DB", "TEST_VLT")
    context.testdata.drop_and_create("DV_PROTOTYPE_DB", "TEST_VLT", "HUB_CUSTOMER",
                                     ["CUSTOMER_PK VARCHAR(32)", "CUSTOMERKEY VARCHAR(38)", "LOADDATE DATE",
                                      "SOURCE VARCHAR(4)"], materialise="table")
    context.testdata.insert_data_from_ct(context.table, "HUB_CUSTOMER", "TEST_VLT")


@step("there is data in the stage")
def step_impl(context):
    context.testdata.drop_and_create("DV_PROTOTYPE_DB", "TEST_STG", "STG_CUSTOMER",
                                     ["CUSTOMER_PK VARCHAR(32)", "NATION_PK VARCHAR(32)",
                                      "CUSTOMER_NATION_PK VARCHAR(32)", "HASHDIFF VARCHAR(32)",
                                      "CUSTOMERKEY VARCHAR(38)", "CUSTOMER_NAME VARCHAR(25)",
                                      "CUSTOMER_PHONE VARCHAR(15)", "CUSTOMER_NATIONKEY NUMBER(38,0)",
                                      "SOURCE VARCHAR(4)", "LOADDATE DATE"],
                                     materialise="table")
    context.testdata.insert_data_from_ct(context.table, "STG_CUSTOMER", "TEST_STG")


@step("only different or unchanged records are loaded to the hub")
def step_impl(context):
    table_df = context.testdata.context_table_to_df(context.table)
    result_df = DataFrame(context.testdata.get_table_data("DV_PROTOTYPE_DB.TEST_VLT.HUB_CUSTOMER"), dtype=str)

    if result_df.equals(table_df):
        return True
    else:
        return False

