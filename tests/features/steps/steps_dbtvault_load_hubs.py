import os

from behave import *

from definitions import TESTS_DBT_ROOT
from steps.step_vars import *

use_step_matcher("parse")


# LOAD STEPS


@step("I load the {model_name} table")
def step_impl(context, model_name):
    os.chdir(TESTS_DBT_ROOT)

    os.system("dbt run --models +{}".format(model_name.lower()))


@step("I load the {model_name} table using SHA")
def step_impl(context, model_name):
    os.chdir(TESTS_DBT_ROOT)

    os.system('dbt run --vars "{{\\"hash\\": \\"SHA\\"}}" --models +{}'.format(model_name.lower()))


# BASE-LOAD STEPS


@step("a {table_name} table does not exist")
def step_impl(context, table_name):
    context.dbutils.create_schema(DATABASE, VLT_SCHEMA, context.connection)

    context.dbutils.drop_table(DATABASE, VLT_SCHEMA, table_name, connection=context.connection)

    is_exist = context.dbutils.table_exists(db=DATABASE, schema=VLT_SCHEMA, table_name=table_name,
                                            connection=context.connection)

    assert is_exist is False


# SINGLE-SOURCE STEPS


@step("there are records in the TEST_STG_CUSTOMER table")
def step_impl(context):
    context.dbutils.create_schema(DATABASE, STG_SCHEMA, context.connection)
    context.dbutils.drop_and_create(DATABASE, STG_SCHEMA, "test_stg_customer_hubs",
                                    ["CUSTOMER_ID VARCHAR(38)", "CUSTOMER_NAME VARCHAR(25)", "CUSTOMER_DOB DATE",
                                     "LOADDATE DATE", "SOURCE VARCHAR(4)", ], connection=context.connection)
    context.dbutils.insert_data_from_ct(context.table, "test_stg_customer_hubs", STG_SCHEMA, context.connection)


@given("there are records in the TEST_HUB_CUSTOMER table")
def step_impl(context):
    context.dbutils.create_schema(DATABASE, VLT_SCHEMA, context.connection)
    context.dbutils.drop_and_create(DATABASE, VLT_SCHEMA, "test_hub_customer_hubs",
                                    ["CUSTOMER_PK BINARY", "CUSTOMER_ID VARCHAR(38)", "LOADDATE DATE",
                                     "SOURCE VARCHAR(4)", ], connection=context.connection)
    context.dbutils.insert_data_from_ct(context.table, "test_hub_customer_hubs", VLT_SCHEMA, context.connection)


@step("there is an empty TEST_HUB_CUSTOMER table")
def step_impl(context):
    context.dbutils.create_schema(DATABASE, VLT_SCHEMA, context.connection)
    context.dbutils.drop_and_create(DATABASE, VLT_SCHEMA, "test_hub_customer_hubs",
                                    ["CUSTOMER_PK BINARY", "CUSTOMER_ID VARCHAR(38)", "LOADDATE DATE",
                                     "SOURCE VARCHAR(4)"], context.connection)


@step("the TEST_HUB_CUSTOMER table should contain")
def step_impl(context):
    table_df = context.dbutils.context_table_to_df(context.table, binary_columns=['CUSTOMER_PK'])

    result_df = context.dbutils.get_table_data(full_table_name=DATABASE + "." + VLT_SCHEMA + ".test_hub_customer_hubs",
                                               binary_columns=['CUSTOMER_PK'], order_by='CUSTOMER_ID',
                                               connection=context.connection)

    assert context.dbutils.compare_dataframes(table_df, result_df)


# UNION STEPS


@step("there are records in the TEST_STG_PARTS table")
def step_impl(context):
    context.dbutils.create_schema(DATABASE, STG_SCHEMA, context.connection)
    context.dbutils.drop_and_create(DATABASE, STG_SCHEMA, "test_stg_parts",
                                    ["PART_ID VARCHAR(38)", "PART_NAME VARCHAR(60)", "PART_TYPE VARCHAR(10)",
                                     "PART_SIZE VARCHAR(5)", "PART_RETAILPRICE DOUBLE", "LOADDATE DATE",
                                     "SOURCE VARCHAR(4)"], connection=context.connection)
    context.dbutils.insert_data_from_ct(context.table, "test_stg_parts", STG_SCHEMA, context.connection)


@step("there are records in the TEST_STG_SUPPLIER table")
def step_impl(context):
    context.dbutils.create_schema(DATABASE, STG_SCHEMA, context.connection)
    context.dbutils.drop_and_create(DATABASE, STG_SCHEMA, "test_stg_supplier",
                                    ["PART_ID VARCHAR(38)", "SUPPLIER_ID VARCHAR(38)", "AVAILQTY INT",
                                     "SUPPLYCOST DOUBLE", "LOADDATE DATE", "SOURCE VARCHAR(4)"],
                                    connection=context.connection)
    context.dbutils.insert_data_from_ct(context.table, "test_stg_supplier", STG_SCHEMA, context.connection)


@step("there are records in the TEST_STG_LINEITEM table")
def step_impl(context):
    context.dbutils.create_schema(DATABASE, STG_SCHEMA, context.connection)
    context.dbutils.drop_and_create(DATABASE, STG_SCHEMA, "test_stg_lineitem",
                                    ["ORDER_ID VARCHAR(38)", "PART_ID VARCHAR(38)", "SUPPLIER_ID VARCHAR(38)",
                                     "LINENUMBER NUMBER(38)", "QUANTITY INT", "EXTENDED_PRICE DOUBLE",
                                     "DISCOUNT DOUBLE", "LOADDATE DATE", "SOURCE VARCHAR(4)"],
                                    connection=context.connection)
    context.dbutils.insert_data_from_ct(context.table, "test_stg_lineitem", STG_SCHEMA, context.connection)


@step("there is an empty TEST_HUB_PARTS table")
def step_impl(context):
    context.dbutils.create_schema(DATABASE, VLT_SCHEMA, context.connection)
    context.dbutils.drop_and_create(DATABASE, VLT_SCHEMA, "test_hub_parts",
                                    ["PART_PK BINARY", "PART_ID VARCHAR(38)", "SOURCE VARCHAR(4)", "LOADDATE DATE"],
                                    connection=context.connection)


@given("there are records in the TEST_HUB_PARTS table")
def step_impl(context):
    context.dbutils.create_schema(DATABASE, VLT_SCHEMA, context.connection)
    context.dbutils.drop_and_create(DATABASE, VLT_SCHEMA, "test_hub_parts",
                                    ["PART_PK BINARY", "PART_ID VARCHAR(38)", "SOURCE VARCHAR(4)", "LOADDATE DATE"],
                                    connection=context.connection)
    context.dbutils.insert_data_from_ct(context.table, "test_hub_parts", VLT_SCHEMA, context.connection)


@step("the TEST_HUB_PARTS table should contain")
def step_impl(context):
    table_df = context.dbutils.context_table_to_df(context.table, ignore_columns=['SOURCE'], binary_columns=['PART_PK'])

    result_df = context.dbutils.get_table_data(full_table_name=DATABASE + "." + VLT_SCHEMA + ".test_hub_parts",
                                               binary_columns=['PART_PK'], order_by='PART_ID',
                                               ignore_columns=['SOURCE'],
                                               connection=context.connection)

    assert context.dbutils.compare_dataframes(table_df, result_df)
