from behave import *

from steps.step_vars import *

use_step_matcher("parse")


# SINGLE-SOURCE STEPS


@step("there are records in the TEST_STG_CUSTOMER table for links")
def step_impl(context):
    context.db_utils.create_schema(DATABASE, STG_SCHEMA, context.connection)
    context.db_utils.drop_and_create(DATABASE, STG_SCHEMA, f"test_stg_customer_links_{MODE.lower()}",
                                     ["CUSTOMER_ID VARCHAR(38)", "NATION_ID VARCHAR(38)", "CUSTOMER_NAME VARCHAR(25)",
                                      "CUSTOMER_DOB DATE", "CUSTOMER_PHONE VARCHAR(15)", "LOADDATE DATE",
                                      "SOURCE VARCHAR(15)"], connection=context.connection)
    context.db_utils.insert_data_from_ct(context.table, f"test_stg_customer_links_{MODE.lower()}", STG_SCHEMA,
                                         context.connection)


@step("there are records in the TEST_STG_EFF_SAT_HASHED table")
def step_impl(context):
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


@step("there are records in the TEST_STG_CRM_CUSTOMER_ORDER_HASHED table")
def step_impl(context):
    table_name = f"test_stg_crm_customer_order_{MODE.lower()}"

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


@step("I have an empty LINK_CUSTOMER_NATION table")
def step_impl(context):
    context.db_utils.create_schema(DATABASE, VLT_SCHEMA, context.connection)
    context.db_utils.drop_and_create(DATABASE, VLT_SCHEMA, f"test_link_customer_nation_{MODE.lower()}",
                                     ["CUSTOMER_NATION_PK BINARY", "CUSTOMER_FK BINARY", "NATION_FK BINARY",
                                      "LOADDATE DATE", "SOURCE VARCHAR(4)"], connection=context.connection)


@step("I have an empty LINK_CUSTOMER_ORDER_MULTIPART table")
def step_impl(context):
    context.db_utils.create_schema(DATABASE, VLT_SCHEMA, context.connection)
    context.db_utils.drop_and_create(DATABASE, VLT_SCHEMA, f"test_link_customer_order_multipart_{MODE.lower()}",
                                     ["CUSTOMER_ORDER_PK BINARY", "CUSTOMER_FK BINARY", "NATION_FK BINARY",
                                      "ORDER_FK BINARY", "PRODUCT_FK BINARY", "ORGANISATION_FK BINARY",
                                      "LOADDATE DATE", "SOURCE VARCHAR(4)"], connection=context.connection)


@step("I have an empty LINK_CUSTOMER_ORDER_MULTIPART_UNION table")
def step_impl(context):
    context.db_utils.create_schema(DATABASE, VLT_SCHEMA, context.connection)
    context.db_utils.drop_and_create(DATABASE, VLT_SCHEMA, f"test_link_customer_order_multipart_union_{MODE.lower()}",
                                     ["CUSTOMER_ORDER_PK BINARY", "CUSTOMER_FK BINARY", "NATION_FK BINARY",
                                      "ORDER_FK BINARY", "PRODUCT_FK BINARY", "ORGANISATION_FK BINARY",
                                      "LOADDATE DATE", "SOURCE VARCHAR(4)"], connection=context.connection)


@step("there are records in the LINK_CUSTOMER_NATION table")
def step_impl(context):
    context.db_utils.create_schema(DATABASE, VLT_SCHEMA, context.connection)
    context.db_utils.drop_and_create(DATABASE, VLT_SCHEMA, f"test_link_customer_nation_{MODE.lower()}",
                                     ["CUSTOMER_NATION_PK BINARY", "CUSTOMER_FK BINARY", "NATION_FK BINARY",
                                      "LOADDATE DATE", "SOURCE VARCHAR(4)"], connection=context.connection)

    context.db_utils.insert_data_from_ct(context.table, f"test_link_customer_nation_{MODE.lower()}", VLT_SCHEMA,
                                         context.connection)


@step("there are records in the LINK_CUSTOMER_CUSTOMER_ORDER_MULTIPART table")
def step_impl(context):
    context.db_utils.create_schema(DATABASE, VLT_SCHEMA, context.connection)
    context.db_utils.drop_and_create(DATABASE, VLT_SCHEMA, f"test_link_customer_order_multipart_{MODE.lower()}",
                                     ['CUSTOMER_ORDER_PK BINARY', 'CUSTOMER_FK BINARY', 'NATION_FK BINARY',
                                      'ORDER_FK BINARY', 'PRODUCT_FK BINARY', 'ORGANISATION_FK BINARY', 'LOADDATE DATE',
                                      'SOURCE VARCHAR(4)'], connection=context.connection)

    context.db_utils.insert_data_from_ct(context.table, f"test_link_customer_order_multipart_{MODE.lower()}",
                                         VLT_SCHEMA, context.connection)


@step("the LINK_CUSTOMER_NATION table should contain")
def step_impl(context):
    table_df = context.db_utils.context_table_to_df(context.table, order_by='CUSTOMER_NATION_PK',
                                                    ignore_columns='SOURCE',
                                                    binary_columns=['CUSTOMER_NATION_PK', 'CUSTOMER_FK', 'NATION_FK'])

    result_df = context.db_utils.get_table_data(
        full_table_name=f"{DATABASE}.{VLT_SCHEMA}.test_link_customer_nation_{MODE.lower()}",
        binary_columns=['CUSTOMER_NATION_PK', 'CUSTOMER_FK', 'NATION_FK'], order_by='CUSTOMER_NATION_PK',
        ignore_columns='SOURCE', connection=context.connection)

    assert context.db_utils.compare_dataframes(table_df, result_df)


@step("the LINK_CUSTOMER_ORDER_MULTIPART should contain")
def step_impl(context):
    table_df = context.db_utils.context_table_to_df(context.table, order_by='CUSTOMER_ORDER_PK',
                                                    binary_columns=['CUSTOMER_ORDER_PK', 'CUSTOMER_FK', 'NATION_FK',
                                                                    'ORDER_FK', 'PRODUCT_FK', 'ORGANISATION_FK'])

    result_df = context.db_utils.get_table_data(
        full_table_name=f"{DATABASE}.{VLT_SCHEMA}.test_link_customer_order_multipart_{MODE.lower()}",
        binary_columns=['CUSTOMER_ORDER_PK', 'CUSTOMER_FK', 'NATION_FK', 'ORDER_FK', 'PRODUCT_FK', 'ORGANISATION_FK'],
        order_by='CUSTOMER_ORDER_PK', connection=context.connection)

    assert context.db_utils.compare_dataframes(table_df, result_df)


# UNION STEPS


@step("I have an empty LINK_CUSTOMER_NATION_UNION table")
def step_impl(context):
    context.db_utils.create_schema(DATABASE, VLT_SCHEMA, context.connection)
    context.db_utils.drop_and_create(DATABASE, VLT_SCHEMA, f"test_link_customer_nation_union_{MODE.lower()}",
                                     ["CUSTOMER_NATION_PK BINARY", "CUSTOMER_FK BINARY", "NATION_FK BINARY",
                                      "LOADDATE DATE", "SOURCE VARCHAR(4)"], connection=context.connection)


@step("there are records in the TEST_STG_SAP_CUSTOMER table")
def step_impl(context):
    context.db_utils.create_schema(DATABASE, STG_SCHEMA, context.connection)
    context.db_utils.drop_and_create(DATABASE, STG_SCHEMA, f"test_stg_sap_customer_{MODE.lower()}",
                                     ["CUSTOMER_ID VARCHAR(38)", "NATION_ID VARCHAR(38)", "CUSTOMER_NAME VARCHAR(25)",
                                      "CUSTOMER_DOB DATE", "CUSTOMER_PHONE VARCHAR(15)", "LOADDATE DATE",
                                      "SOURCE VARCHAR(15)"], connection=context.connection)
    context.db_utils.insert_data_from_ct(context.table, f"test_stg_sap_customer_{MODE.lower()}", STG_SCHEMA,
                                         context.connection)


@step("there are records in the TEST_STG_CRM_CUSTOMER table")
def step_impl(context):
    context.db_utils.create_schema(DATABASE, STG_SCHEMA, context.connection)
    context.db_utils.drop_and_create(DATABASE, STG_SCHEMA, f"test_stg_crm_customer_{MODE.lower()}",
                                     ["CUSTOMER_REF VARCHAR(38)", "NATION_KEY VARCHAR(38)", "CUSTOMER_NAME VARCHAR(25)",
                                      "CUSTOMER_DOB DATE", "CUSTOMER_PHONE VARCHAR(15)", "LOADDATE DATE",
                                      "SOURCE VARCHAR(15)"], connection=context.connection)
    context.db_utils.insert_data_from_ct(context.table, f"test_stg_crm_customer_{MODE.lower()}", STG_SCHEMA,
                                         context.connection)


@step("there are records in the TEST_STG_WEB_CUSTOMER table")
def step_impl(context):
    context.db_utils.create_schema(DATABASE, STG_SCHEMA, context.connection)
    context.db_utils.drop_and_create(DATABASE, STG_SCHEMA, f"test_stg_web_customer_{MODE.lower()}",
                                     ["CUSTOMER_REF VARCHAR(38)", "NATION_KEY VARCHAR(38)", "CUSTOMER_NAME VARCHAR(25)",
                                      "CUSTOMER_DOB DATE", "CUSTOMER_PHONE VARCHAR(15)", "LOADDATE DATE",
                                      "SOURCE VARCHAR(15)"], connection=context.connection)
    context.db_utils.insert_data_from_ct(context.table, f"test_stg_web_customer_{MODE.lower()}", STG_SCHEMA,
                                         context.connection)


@step("there are records in the LINK_CUSTOMER_NATION_UNION table")
def step_impl(context):
    context.db_utils.create_schema(DATABASE, VLT_SCHEMA, context.connection)
    context.db_utils.drop_and_create(DATABASE, VLT_SCHEMA, f"test_link_customer_nation_union_{MODE.lower()}",
                                     ["CUSTOMER_NATION_PK BINARY", "CUSTOMER_FK BINARY", "NATION_FK BINARY",
                                      "LOADDATE DATE", "SOURCE VARCHAR(4)"], connection=context.connection)

    context.db_utils.insert_data_from_ct(context.table, f"test_link_customer_nation_union_{MODE.lower()}",
                                         VLT_SCHEMA, context.connection)


@step("the LINK_CUSTOMER_NATION_UNION table should contain")
def step_impl(context):
    table_df = context.db_utils.context_table_to_df(context.table, order_by='CUSTOMER_NATION_PK',
                                                    ignore_columns='SOURCE',
                                                    binary_columns=['CUSTOMER_NATION_PK', 'CUSTOMER_FK', 'NATION_FK'])

    result_df = context.db_utils.get_table_data(
        full_table_name=f"{DATABASE}.{VLT_SCHEMA}.test_link_customer_nation_union_{MODE.lower()}",
        binary_columns=['CUSTOMER_NATION_PK', 'CUSTOMER_FK', 'NATION_FK'], order_by='CUSTOMER_NATION_PK',
        ignore_columns='SOURCE',
        connection=context.connection)

    assert context.db_utils.compare_dataframes(table_df, result_df)


@step("the LINK_CUSTOMER_ORDER_MULTIPART_UNION should contain")
def step_impl(context):
    table_df = context.db_utils.context_table_to_df(context.table, order_by='CUSTOMER_ORDER_PK',
                                                    binary_columns=['CUSTOMER_ORDER_PK', 'CUSTOMER_FK', 'NATION_FK',
                                                                    'ORDER_FK', 'PRODUCT_FK', 'ORGANISATION_FK'])

    result_df = context.db_utils.get_table_data(
        full_table_name=f"{DATABASE}.{VLT_SCHEMA}.test_link_customer_order_multipart_union_{MODE.lower()}",
        binary_columns=['CUSTOMER_ORDER_PK', 'CUSTOMER_FK', 'NATION_FK', 'ORDER_FK', 'PRODUCT_FK', 'ORGANISATION_FK'],
        order_by='CUSTOMER_ORDER_PK', connection=context.connection)

    assert context.db_utils.compare_dataframes(table_df, result_df)
