from behave import *

from pandas import DataFrame, Timestamp

use_step_matcher("parse")

# Distinct data from stage is loaded into an empty hub


@given("there is an empty HUB_CUSTOMER table")
def step_impl(context):
    context.testdata.drop_and_create("DV_PROTOTYPE_DB", "TEST_SRC", "HUB_CUSTOMER",
                                     ["CUSTOMER_PK BINARY(16)", "CUSTOMERKEY NUMBER(38,0)", "LOADDATE DATE",
                                      "SOURCE VARCHAR(4)"], materialise="table")


@step("there are records in the V_STG_CUSTOMER view")
def step_impl(context):
    table = context.testdata.context_table_to_df(context.table)
    print("")

@step("I run the snowflakeDemonstrator")
def step_impl(context):
    pass


@step("the records from V_STG_CUSTOMER should have been inserted into HUB_CUSTOMER")
def step_impl(context):
    pass