from behave import *

from definitions import TESTS_DBT_ROOT
from steps.step_vars import *

use_step_matcher("parse")

# SINGLE STEPS


@step("an empty LINK_CUSTOMER_ORDER")
def step_impl(context):
    context.dbutils.create_schema(DATABASE, VLT_SCHEMA, context.connection)
    context.dbutils.drop_and_create(DATABASE, VLT_SCHEMA, "test_link_customer_order_{}".format(MODE.lower()),
                                    ["CUSTOMER_ORDER_PK BINARY", "CUSTOMER_FK BINARY", "ORDER_FK BINARY",
                                     "LOADDATE DATE", "SOURCE VARCHAR(6)"], context.connection)


@step("an empty EFF_CUSTOMER_ORDER")
def step_impl(context):
    context.dbutils.create_schema(DATABASE, VLT_SCHEMA, context.connection)
    context.dbutils.drop_and_create(DATABASE, VLT_SCHEMA, "test_eff_customer_order_{}".format(MODE.lower()),
                                    ["CUSTOMER_ORDER_PK BINARY", "SOURCE VARCHAR(6)", "LOADDATE DATE",
                                     "EFFECTIVE_FROM DATE", "START_DATETIME DATE", "END_DATETIME DATE"],
                                    context.connection)


@step("I run the first Load Cycle for 2020-01-10")
def step_impl(context):
    os.chdir(TESTS_DBT_ROOT)

    os.system("dbt run --full-refresh --models +test_link_customer_order_current +test_eff_customer_order_current")


# BASE LOADS
@step("there is a {table_name} table")
def step_impl(context, table_name):

    context.dbutils.create_schema(DATABASE, VLT_SCHEMA, context.connection)

    if 'link' in table_name.lower():

        context.dbutils.drop_and_create(DATABASE, VLT_SCHEMA, "test_{}_{}".format(table_name.lower(), MODE.lower()),
                                        ["CUSTOMER_ORDER_PK BINARY", "CUSTOMER_FK BINARY", "ORDER_FK BINARY",
                                         "LOADDATE DATE", "SOURCE VARCHAR(6)"], context.connection)
        context.dbutils.insert_data_from_ct(context.table, "test_{}_{}".format(table_name.lower(), MODE.lower()), VLT_SCHEMA,
                                            context.connection)

    elif 'eff' in table_name.lower():

        context.dbutils.drop_and_create(DATABASE, VLT_SCHEMA, "test_{}_{}".format(table_name.lower(), MODE.lower()),
                                        ["CUSTOMER_ORDER_PK BINARY", "SOURCE VARCHAR(6)", "LOADDATE DATE",
                                         "EFFECTIVE_FROM DATE", "START_DATETIME DATE", "END_DATETIME DATE"],
                                        context.connection)
        context.dbutils.insert_data_from_ct(context.table, "test_{}_{}".format(table_name.lower(), MODE.lower()),
                                            VLT_SCHEMA, context.connection)


@step("staging_data loaded on {date}")
def step_impl(context, date):
    context.dbutils.create_schema(DATABASE, STG_SCHEMA, context.connection)
    context.dbutils.drop_and_create(DATABASE, STG_SCHEMA, "test_stg_eff_sat_{}".format(MODE.lower()),
                                    ["CUSTOMER_ORDER_PK BINARY", "LOADDATE DATE", "SOURCE VARCHAR(6)",
                                     "CUSTOMER_FK BINARY", "CUSTOMER_ID VARCHAR(38)", "ORDER_FK BINARY",
                                     "ORDER_ID VARCHAR(3)", "EFFECTIVE_FROM DATE"], connection=context.connection)
    context.dbutils.insert_data_from_ct(context.table, "test_stg_eff_sat_{}".format(MODE.lower()), STG_SCHEMA,
                                        context.connection)


@step("I run a Load Cycle for {date}")
def step_impl(context, date):
    os.chdir(TESTS_DBT_ROOT)

    os.system("dbt run --models +test_link_customer_order_current +test_eff_customer_order_current")


@step("I expect the following {table_name}")
def step_impl(context, table_name):

    if 'link' in table_name.lower():

        table_df = context.dbutils.context_table_to_df(context.table, order_by='CUSTOMER_ORDER_PK',
                                                       binary_columns=['CUSTOMER_ORDER_PK', "CUSTOMER_FK", "ORDER_FK"])

        result_df = context.dbutils.get_table_data(
            full_table_name=DATABASE + "." + VLT_SCHEMA + ".test_link_customer_order_{}".format(MODE.lower()),
            binary_columns=['CUSTOMER_ORDER_PK', "CUSTOMER_FK", "ORDER_FK"],
            order_by='CUSTOMER_ORDER_PK', connection=context.connection)

        assert context.dbutils.compare_dataframes(table_df, result_df)

    elif 'eff' in table_name.lower():

        table_df = context.dbutils.context_table_to_df(context.table, order_by='CUSTOMER_ORDER_PK',
                                                       binary_columns=['CUSTOMER_ORDER_PK'])

        result_df = context.dbutils.get_table_data(
            full_table_name=DATABASE + "." + VLT_SCHEMA + ".test_eff_customer_order_{}".format(MODE.lower()),
            binary_columns=['CUSTOMER_ORDER_PK'], order_by='CUSTOMER_ORDER_PK',
            connection=context.connection)

        assert context.dbutils.compare_dataframes(table_df, result_df)


