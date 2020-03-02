from behave import *

from definitions import TESTS_DBT_ROOT
from steps.step_vars import *

use_step_matcher("parse")


@step("an empty LINK_CUSTOMER_ORDER")
def step_impl(context):
    context.dbutils.create_schema(DATABASE, VLT_SCHEMA, context.connection)
    context.dbutils.drop_and_create(DATABASE, VLT_SCHEMA, "test_link_customer_order_{}".format(MODE.lower()),
                                    ["CUSTOMER_ORDER_PK BINARY", "ORDER_FK BINARY", "CUSTOMER_FK BINARY",
                                     "LOADDATE DATE", "SOURCE VARCHAR(4)"], context.connection)


@step("an empty EFF_SAT_LINK_ORDER_CUSTOMER")
def step_impl(context):
    context.dbutils.create_schema(DATABASE, VLT_SCHEMA, context.connection)
    context.dbutils.drop_and_create(DATABASE, VLT_SCHEMA, "test_eff_sat_link_order_customer_{}".format(MODE.lower()),
                                    ["CUSTOMER_ORDER_PK BINARY", "SOURCE VARCHAR(4)", "LOADDATE DATE",
                                     "EFFECTIVE_FROM DATE", "EFFECTIVE_TO DATE"], context.connection)


@step("staging_data loaded on 10.01.2020")
def step_impl(context):
    context.dbutils.create_schema(DATABASE, STG_SCHEMA, context.connection)
    context.dbutils.drop_and_create(DATABASE, STG_SCHEMA, "test_stg_eff_sat_{}".format(MODE.lower()),
                                    ["CUSTOMER_ORDER_PK BINARY", "LOADDATE DATE", "SOURCE VARCHAR(6)",
                                     "CUSTOMER_FK BINARY", "CUSTOMER_ID VARCHAR(38)", "ORDER_FK BINARY",
                                     "ORDER_ID VARCHAR(3)", "EFFECTIVE_FROM DATE"], connection=context.connection)
    context.dbutils.insert_data_from_ct(context.table, "test_stg_eff_sat_{}".format(MODE.lower()), STG_SCHEMA,
                                        context.connection)


@step("I run a Load Cycle for 10.01.2020")
def step_impl(context):
    os.chdir(TESTS_DBT_ROOT)

    os.system("dbt run --full-refresh --models +test_link_customer_order_current")
    os.system("dbt run --full-refresh --models +test_eff_sat_link_order_customer_current")


@step("I expect the following LINK_CUSTOMER_ORDER")
def step_impl(context):
    table_df = context.dbutils.context_table_to_df(context.table, binary_columns=['CUSTOMER_ORDER_PK', "CUSTOMER_FK", "ORDER_FK"])

    result_df = context.dbutils.get_table_data(full_table_name=DATABASE + "." + VLT_SCHEMA + ".test_link_customer_order_{}".format(MODE.lower()),
                                               binary_columns=['CUSTOMER_ORDER_PK', "CUSTOMER_FK", "ORDER_FK"],
                                               order_by='LOADDATE', connection=context.connection)

    assert context.dbutils.compare_dataframes(table_df, result_df)


@step("the following EFF_CUSTOMER_ORDER")
def step_impl(context):
    table_df = context.dbutils.context_table_to_df(context.table, binary_columns=['CUSTOMER_ORDER_PK'])

    result_df = context.dbutils.get_table_data(full_table_name=DATABASE + "." + VLT_SCHEMA + ".test_eff_sat_link_order_customer_{}".format(MODE.lower()),
                                               binary_columns=['CUSTOMER_ORDER_PK'], order_by='LOADDATE',
                                               connection=context.connection)

    assert context.dbutils.compare_dataframes(table_df, result_df)
