from behave import *

from tests.utils.dbt_test_utils import TESTS_DBT_ROOT
from steps.step_vars import *

use_step_matcher("parse")

# SINGLE STEPS


@step("an empty TEST_LINK_CUSTOMER_ORDER")
def step_impl(context):
    context.db_utils.create_schema(DATABASE, VLT_SCHEMA, context.connection)
    context.db_utils.drop_and_create(DATABASE, VLT_SCHEMA, f"test_link_customer_order_{MODE.lower()}",
                                     ["CUSTOMER_ORDER_PK BINARY", "CUSTOMER_FK BINARY", "ORDER_FK BINARY",
                                      "LOADDATE DATE", "SOURCE VARCHAR(6)"], context.connection)


@step("an empty TEST_EFF_CUSTOMER_ORDER")
def step_impl(context):
    context.db_utils.create_schema(DATABASE, VLT_SCHEMA, context.connection)
    context.db_utils.drop_and_create(DATABASE, VLT_SCHEMA, f"test_eff_customer_order_{MODE.lower()}",
                                     ["CUSTOMER_ORDER_PK BINARY", "SOURCE VARCHAR(6)", "LOADDATE DATE",
                                      "EFFECTIVE_FROM DATE", "START_DATETIME DATE", "END_DATETIME DATE"],
                                     context.connection)


@step("I run the first Load Cycle for 2020-01-10")
def step_impl(context):
    os.chdir(TESTS_DBT_ROOT)

    link = 'test_link_customer_order_current'
    eff = 'test_eff_customer_order_current'

    os.system(f"dbt run --full-refresh --models +{link} +{eff}")


# BASE LOADS
@step("there is a {table_name} table")
def step_impl(context, table_name):

    context.db_utils.create_schema(DATABASE, VLT_SCHEMA, context.connection)

    table_name = f"{table_name.lower()}_{MODE.lower()}"

    if 'link' in table_name.lower():

        context.db_utils.drop_and_create(DATABASE, VLT_SCHEMA, table_name,
                                         ["CUSTOMER_ORDER_PK BINARY", "CUSTOMER_FK BINARY", "ORDER_FK BINARY",
                                          "LOADDATE DATE", "SOURCE VARCHAR(6)"],
                                         context.connection)
        context.db_utils.insert_data_from_ct(context.table,
                                             table_name,
                                             VLT_SCHEMA,
                                             context.connection)

    elif 'eff' in table_name.lower():

        context.db_utils.drop_and_create(DATABASE, VLT_SCHEMA,
                                         table_name,
                                         ["CUSTOMER_ORDER_PK BINARY", "SOURCE VARCHAR(6)", "LOADDATE DATE",
                                          "EFFECTIVE_FROM DATE", "START_DATETIME DATE", "END_DATETIME DATE"],
                                         context.connection)
        context.db_utils.insert_data_from_ct(context.table,
                                             table_name,
                                             VLT_SCHEMA, context.connection)


@step("there is data in {table}")
def step_impl(context, table):
    context.db_utils.create_schema(DATABASE, VLT_SCHEMA, context.connection)

    table_name = f"{table.lower()}_{MODE.lower()}"

    if 'link' in table.lower():

        context.db_utils.drop_and_create(DATABASE, VLT_SCHEMA, table_name,
                                         ["CUSTOMER_ORDER_PK BINARY", "CUSTOMER_FK BINARY", "NATION_FK BINARY",
                                          "ORDER_FK BINARY", "PRODUCT_FK BINARY", "ORGANISATION_FK BINARY",
                                          "LOADDATE DATE", "SOURCE VARCHAR(6)"], context.connection)
        context.db_utils.insert_data_from_ct(context.table,
                                             table_name,
                                             VLT_SCHEMA,
                                             context.connection)

    elif 'eff' in table.lower():

        context.db_utils.drop_and_create(DATABASE, VLT_SCHEMA, table_name,
                                         ["CUSTOMER_ORDER_PK BINARY", "SOURCE VARCHAR(6)", "LOADDATE DATE",
                                          "EFFECTIVE_FROM DATE", "START_DATETIME DATE", "END_DATETIME DATE"],
                                         context.connection)
        context.db_utils.insert_data_from_ct(context.table,
                                             table_name,
                                             VLT_SCHEMA,
                                             context.connection)


@step("there was staging data loaded on {date}")
def step_impl(context, date):
    table_name = f"test_stg_eff_sat_{MODE.lower()}"

    context.db_utils.create_schema(DATABASE, STG_SCHEMA, context.connection)
    context.db_utils.drop_and_create(DATABASE, STG_SCHEMA, table_name,
                                     ["CUSTOMER_ORDER_PK BINARY", "LOADDATE DATE", "SOURCE VARCHAR(6)",
                                      "CUSTOMER_FK BINARY", "CUSTOMER_ID VARCHAR(38)", "ORDER_FK BINARY",
                                      "ORDER_ID VARCHAR(3)", "EFFECTIVE_FROM DATE"],
                                     connection=context.connection)
    context.db_utils.insert_data_from_ct(context.table,
                                         table_name,
                                         STG_SCHEMA,
                                         context.connection)


@step("the multipart staging_data loaded on {date}")
def step_impl(context, date):
    table_name = f"test_stg_eff_sat_{MODE.lower()}"

    context.db_utils.create_schema(DATABASE, STG_SCHEMA, context.connection)
    context.db_utils.drop_and_create(DATABASE, STG_SCHEMA, table_name,
                                     ["CUSTOMER_ORDER_PK BINARY", "LOADDATE DATE", "SOURCE VARCHAR(6)",
                                      "CUSTOMER_FK BINARY", "CUSTOMER_ID VARCHAR(38)", "ORDER_FK BINARY",
                                      "ORDER_ID VARCHAR(3)", "NATION_FK BINARY", "NATION_ID VARCHAR(3)",
                                      "PRODUCT_FK BINARY", "PRODUCT_GROUP VARCHAR(6)", "ORGANISATION_FK BINARY",
                                      "ORGANISATION_ID VARCHAR(9)", "EFFECTIVE_FROM DATE"],
                                     connection=context.connection)
    context.db_utils.insert_data_from_ct(context.table,
                                         table_name,
                                         STG_SCHEMA,
                                         context.connection)


@step("I run a Load Cycle for {date}")
def step_impl(context, date):
    os.chdir(TESTS_DBT_ROOT)

    link = 'test_link_customer_order_current'
    eff = 'test_eff_customer_order_current'

    os.system(f"dbt run --models +{link} +{eff}")


@step("I run a multipart Load Cycle for {date}")
def step_impl(context, date):
    os.chdir(TESTS_DBT_ROOT)

    link = 'test_link_customer_order_multipart_current'
    eff = 'test_eff_customer_order_multipart_current'

    os.system(f"dbt run --models +{link} +{eff}")


@step("I expect the following {table_name}")
def step_impl(context, table_name):

    if 'link' in table_name.lower():

        table_df = context.db_utils.context_table_to_df(context.table,
                                                        order_by='CUSTOMER_ORDER_PK',
                                                        binary_columns=['CUSTOMER_ORDER_PK', "CUSTOMER_FK", "ORDER_FK"])

        result_df = context.db_utils.get_table_data(
            full_table_name=f"{DATABASE}.{VLT_SCHEMA}.{table_name}_{MODE.lower()}",
            binary_columns=['CUSTOMER_ORDER_PK', "CUSTOMER_FK", "ORDER_FK"],
            order_by='CUSTOMER_ORDER_PK',
            connection=context.connection)

        assert context.db_utils.compare_dataframes(table_df, result_df)

    elif 'eff' in table_name.lower():

        table_df = context.db_utils.context_table_to_df(context.table,
                                                        order_by=['CUSTOMER_ORDER_PK', 'LOADDATE'],
                                                        binary_columns=['CUSTOMER_ORDER_PK'])

        result_df = context.db_utils.get_table_data(
            full_table_name=f"{DATABASE}.{VLT_SCHEMA}.{table_name}_{MODE.lower()}",
            binary_columns=['CUSTOMER_ORDER_PK'],
            order_by=['CUSTOMER_ORDER_PK', 'LOADDATE'],
            connection=context.connection)

        assert context.db_utils.compare_dataframes(table_df, result_df)


@step("I expect to see the following multipart {table_name}")
def step_impl(context, table_name):

    if 'link' in table_name.lower():

        table_df = context.db_utils.context_table_to_df(context.table,
                                                        order_by='CUSTOMER_ORDER_PK',
                                                        binary_columns=['CUSTOMER_ORDER_PK', "CUSTOMER_FK", "NATION_FK",
                                                                        "ORDER_FK", "PRODUCT_FK", "ORGANISATION_FK"])
        result_df = context.db_utils.get_table_data(
            full_table_name=f"{DATABASE}.{VLT_SCHEMA}.{table_name}_{MODE.lower()}",
            binary_columns=['CUSTOMER_ORDER_PK', "CUSTOMER_FK", "NATION_FK", "ORDER_FK", "PRODUCT_FK", "ORGANISATION_FK"],
            order_by='CUSTOMER_ORDER_PK',
            connection=context.connection)

        assert context.db_utils.compare_dataframes(table_df, result_df)

    elif 'eff' in table_name.lower():

        table_df = context.db_utils.context_table_to_df(context.table,
                                                        order_by=['CUSTOMER_ORDER_PK', 'LOADDATE'],
                                                        binary_columns=['CUSTOMER_ORDER_PK'])

        result_df = context.db_utils.get_table_data(
            full_table_name=f"{DATABASE}.{VLT_SCHEMA}.{table_name}_{MODE.lower()}",
            binary_columns=['CUSTOMER_ORDER_PK'],
            order_by=['CUSTOMER_ORDER_PK', 'LOADDATE'],
            connection=context.connection)

        assert context.db_utils.compare_dataframes(table_df, result_df)
