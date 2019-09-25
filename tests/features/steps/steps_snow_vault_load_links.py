import os

from behave import *
from pandas import DataFrame

from definitions import DBT_ROOT

use_step_matcher("parse")


# Distinct history of data linking two hubs is loaded into a link table

@step("there are records in the TEST_STG_CUSTOMER table for links")
def step_impl(context):
    context.testdata.create_schema("DV_PROTOTYPE_DB", "SRC_TEST_STG")
    context.testdata.drop_and_create("DV_PROTOTYPE_DB", "SRC_TEST_STG", "test_stg_customer_links",
                                     ["CUSTOMER_ID VARCHAR(38)", "NATION_ID VARCHAR(38)",
                                      "CUSTOMER_NAME VARCHAR(25)",
                                      "CUSTOMER_DOB DATE", "CUSTOMER_PHONE VARCHAR(15)",
                                      "LOADDATE DATE", "SOURCE VARCHAR(15)", ],
                                     materialise="table")
    context.testdata.insert_data_from_ct(context.table, "test_stg_customer_links", "SRC_TEST_STG")


@step("there are records in the TEST_STG_CRM_CUSTOMER table")
def step_impl(context):
    context.testdata.create_schema("DV_PROTOTYPE_DB", "SRC_TEST_STG")
    context.testdata.drop_and_create("DV_PROTOTYPE_DB", "SRC_TEST_STG", "test_stg_crm_customer",
                                     ["CUSTOMER_REF VARCHAR(38)", "NATION_KEY VARCHAR(38)",
                                      "CUSTOMER_NAME VARCHAR(25)",
                                      "CUSTOMER_DOB DATE", "CUSTOMER_PHONE VARCHAR(15)",
                                      "LOADDATE DATE", "SOURCE VARCHAR(15)", ],
                                     materialise="table")
    context.testdata.insert_data_from_ct(context.table, "test_stg_crm_customer", "SRC_TEST_STG")


@step("I run a fresh dbt link load")
def step_impl(context):
    os.chdir(DBT_ROOT)

    os.system("dbt run --full-refresh --models +test_link_customer_nation")


@step("I have an empty LINK_CUSTOMER_NATION table")
def step_impl(context):
    context.testdata.drop_and_create("DV_PROTOTYPE_DB", "SRC_TEST_VLT", "test_link_customer_nation",
                                     ["CUSTOMER_NATION_PK BINARY(16)",
                                      "CUSTOMER_FK BINARY(16)", "NATION_FK BINARY(16)",
                                      "LOADDATE DATE", "SOURCE VARCHAR(4)"],
                                     materialise="table")


@step("only distinct records from the STG_CUSTOMER_NATION are loaded into the link")
@step("only different or unchanged records are loaded to the link")
def step_impl(context):
    table_df = context.testdata.context_table_to_df(context.table,
                                                    order_by='CUSTOMER_NATION_PK',
                                                    ignore_columns='SOURCE')

    result_df = context.testdata.get_table_data(full_table_name="DV_PROTOTYPE_DB.SRC_TEST_VLT.test_link_customer_nation",
                                                binary_columns=['CUSTOMER_NATION_PK', 'CUSTOMER_FK', 'NATION_FK'],
                                                order_by='CUSTOMER_NATION_PK',
                                                ignore_columns='SOURCE')

    assert context.testdata.compare_dataframes(table_df, result_df)

# Unchanged records in stage are not loaded into the link with pre-existing data


@step("there are records in the LINK_CUSTOMER_NATION table")
def step_impl(context):
    context.testdata.drop_and_create("DV_PROTOTYPE_DB", "SRC_TEST_VLT", "test_link_customer_nation",
                                     ["CUSTOMER_NATION_PK BINARY(16)",
                                      "CUSTOMER_FK BINARY(16)", "NATION_FK BINARY(16)",
                                      "LOADDATE DATE", "SOURCE VARCHAR(4)"],
                                     materialise="table")
    context.testdata.insert_data_from_ct(context.table, "test_link_customer_nation", "SRC_TEST_VLT")


@step("I run a dbt link load")
def step_impl(context):
    os.chdir(DBT_ROOT)

    os.system("dbt run --models +test_link_customer_nation")


# Only the first instance of a record is loaded into the link table for the history

@step("I have unchanged records but with different sources in the STG_CUSTOMER_NATION table")
def step_impl(context):
    context.testdata.drop_and_create("DV_PROTOTYPE_DB", "SRC_TEST_STG", "stg_customer_nation",
                                     ["CUSTOMER_PK BINARY(16)", "NATION_PK BINARY(16)", "CUSTOMER_NATION_PK BINARY(16)",
                                      "HASHDIFF BINARY(16)", "CUSTOMERKEY VARCHAR(38)", "CUSTOMER_NAME VARCHAR(25)",
                                      "CUSTOMER_PHONE VARCHAR(15)", "CUSTOMER_NATIONKEY NUMBER(38,0)",
                                      "SOURCE VARCHAR(4)", "LOADDATE DATE", "EFFECTIVE_FROM DATE"], materialise="table")
    context.testdata.insert_data_from_ct(context.table, "stg_customer_nation", "SRC_TEST_STG")


@step("only the first seen distinct records are loaded into the link")
def step_impl(context):
    table_df = context.testdata.context_table_to_df(context.table,
                                                    order_by='CUSTOMER_NATION_PK')

    result_df = context.testdata.get_table_data(full_table_name="DV_PROTOTYPE_DB.SRC_TEST_VLT.test_link_customer_nation",
                                                binary_columns=['CUSTOMER_NATION_PK', 'CUSTOMER_FK', 'NATION_FK'],
                                                order_by='CUSTOMER_NATION_PK')

    assert context.testdata.compare_dataframes(table_df, result_df)
