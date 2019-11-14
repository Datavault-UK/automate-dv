import os

from behave import *

from definitions import TESTS_DBT_ROOT
from steps.step_vars import *

use_step_matcher("parse")


# LOAD STEPS


@step("I load the TEST_LINK_CUSTOMER_NATION table")
def step_impl(context):
    os.chdir(TESTS_DBT_ROOT)

    os.system("dbt run --models +test_link_customer_nation")


@step("I load the TEST_LINK_CUSTOMER_NATION_UNION table")
def step_impl(context):
    os.chdir(TESTS_DBT_ROOT)

    os.system("dbt run --models +test_link_customer_nation_union")


# SINGLE-SOURCE STEPS


@step("there are records in the TEST_STG_CUSTOMER table for links")
def step_impl(context):
    context.dbutils.create_schema(DATABASE, STG_SCHEMA, context.connection)
    context.dbutils.drop_and_create(DATABASE, STG_SCHEMA, "test_stg_customer_links",
                                    ["CUSTOMER_ID VARCHAR(38)", "NATION_ID VARCHAR(38)", "CUSTOMER_NAME VARCHAR(25)",
                                     "CUSTOMER_DOB DATE", "CUSTOMER_PHONE VARCHAR(15)", "LOADDATE DATE",
                                     "SOURCE VARCHAR(15)"], connection=context.connection)
    context.dbutils.insert_data_from_ct(context.table, "test_stg_customer_links", STG_SCHEMA, context.connection)


@step("I have an empty LINK_CUSTOMER_NATION table")
def step_impl(context):
    context.dbutils.drop_and_create(DATABASE, VLT_SCHEMA, "test_link_customer_nation",
                                    ["CUSTOMER_NATION_PK BINARY(16)", "CUSTOMER_FK BINARY(16)", "NATION_FK BINARY(16)",
                                     "LOADDATE DATE", "SOURCE VARCHAR(4)"], connection=context.connection)


@step("there are records in the LINK_CUSTOMER_NATION table")
def step_impl(context):
    context.dbutils.create_schema(DATABASE, VLT_SCHEMA, context.connection)
    context.dbutils.drop_and_create(DATABASE, VLT_SCHEMA, "test_link_customer_nation",
                                    ["CUSTOMER_NATION_PK BINARY(16)", "CUSTOMER_FK BINARY(16)", "NATION_FK BINARY(16)",
                                     "LOADDATE DATE", "SOURCE VARCHAR(4)"], connection=context.connection)

    context.dbutils.insert_data_from_ct(context.table, "test_link_customer_nation", VLT_SCHEMA, context.connection)


@step("the LINK_CUSTOMER_NATION table should contain")
def step_impl(context):
    table_df = context.dbutils.context_table_to_df(context.table, order_by='CUSTOMER_NATION_PK',
                                                   ignore_columns='SOURCE',
                                                   binary_columns=['CUSTOMER_NATION_PK', 'CUSTOMER_FK', 'NATION_FK'])

    result_df = context.dbutils.get_table_data(
        full_table_name=DATABASE + "." + VLT_SCHEMA + ".test_link_customer_nation",
        binary_columns=['CUSTOMER_NATION_PK', 'CUSTOMER_FK', 'NATION_FK'], order_by='CUSTOMER_NATION_PK',
        ignore_columns='SOURCE', connection=context.connection)

    assert context.dbutils.compare_dataframes(table_df, result_df)


# UNION STEPS


@step("I have an empty LINK_CUSTOMER_NATION_UNION table")
def step_impl(context):
    context.dbutils.drop_and_create(DATABASE, VLT_SCHEMA, "test_link_customer_nation_union",
                                    ["CUSTOMER_NATION_PK BINARY(16)", "CUSTOMER_FK BINARY(16)", "NATION_FK BINARY(16)",
                                     "LOADDATE DATE", "SOURCE VARCHAR(4)"], connection=context.connection)


@step("there are records in the TEST_STG_SAP_CUSTOMER table")
def step_impl(context):
    context.dbutils.create_schema(DATABASE, STG_SCHEMA, context.connection)
    context.dbutils.drop_and_create(DATABASE, STG_SCHEMA, "test_stg_sap_customer",
                                    ["CUSTOMER_ID VARCHAR(38)", "NATION_ID VARCHAR(38)", "CUSTOMER_NAME VARCHAR(25)",
                                     "CUSTOMER_DOB DATE", "CUSTOMER_PHONE VARCHAR(15)", "LOADDATE DATE",
                                     "SOURCE VARCHAR(15)"], connection=context.connection)
    context.dbutils.insert_data_from_ct(context.table, "test_stg_sap_customer", STG_SCHEMA, context.connection)


@step("there are records in the TEST_STG_CRM_CUSTOMER table")
def step_impl(context):
    context.dbutils.create_schema(DATABASE, STG_SCHEMA, context.connection)
    context.dbutils.drop_and_create(DATABASE, STG_SCHEMA, "test_stg_crm_customer",
                                    ["CUSTOMER_REF VARCHAR(38)", "NATION_KEY VARCHAR(38)", "CUSTOMER_NAME VARCHAR(25)",
                                     "CUSTOMER_DOB DATE", "CUSTOMER_PHONE VARCHAR(15)", "LOADDATE DATE",
                                     "SOURCE VARCHAR(15)"], connection=context.connection)
    context.dbutils.insert_data_from_ct(context.table, "test_stg_crm_customer", STG_SCHEMA, context.connection)


@step("there are records in the TEST_STG_WEB_CUSTOMER table")
def step_impl(context):
    context.dbutils.create_schema(DATABASE, STG_SCHEMA, context.connection)
    context.dbutils.drop_and_create(DATABASE, STG_SCHEMA, "test_stg_web_customer",
                                    ["CUSTOMER_REF VARCHAR(38)", "NATION_KEY VARCHAR(38)", "CUSTOMER_NAME VARCHAR(25)",
                                     "CUSTOMER_DOB DATE", "CUSTOMER_PHONE VARCHAR(15)", "LOADDATE DATE",
                                     "SOURCE VARCHAR(15)"], connection=context.connection)
    context.dbutils.insert_data_from_ct(context.table, "test_stg_web_customer", STG_SCHEMA, context.connection)


@step("there are records in the LINK_CUSTOMER_NATION_UNION table")
def step_impl(context):
    context.dbutils.create_schema(DATABASE, VLT_SCHEMA, context.connection)
    context.dbutils.drop_and_create(DATABASE, VLT_SCHEMA, "test_link_customer_nation_union",
                                    ["CUSTOMER_NATION_PK BINARY(16)", "CUSTOMER_FK BINARY(16)", "NATION_FK BINARY(16)",
                                     "LOADDATE DATE", "SOURCE VARCHAR(4)"], connection=context.connection)

    context.dbutils.insert_data_from_ct(context.table, "test_link_customer_nation_union", VLT_SCHEMA,
                                        context.connection)


@step("the LINK_CUSTOMER_NATION_UNION table should contain")
def step_impl(context):
    table_df = context.dbutils.context_table_to_df(context.table, order_by='CUSTOMER_NATION_PK',
                                                   ignore_columns='SOURCE',
                                                   binary_columns=['CUSTOMER_NATION_PK', 'CUSTOMER_FK', 'NATION_FK'])

    result_df = context.dbutils.get_table_data(
        full_table_name=DATABASE + "." + VLT_SCHEMA + ".test_link_customer_nation_union",
        binary_columns=['CUSTOMER_NATION_PK', 'CUSTOMER_FK', 'NATION_FK'], order_by='CUSTOMER_NATION_PK',
        ignore_columns='SOURCE', connection=context.connection)

    assert context.dbutils.compare_dataframes(table_df, result_df)
