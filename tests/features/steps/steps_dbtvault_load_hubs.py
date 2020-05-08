from behave import *

from dbt_test_utils import TESTS_DBT_ROOT

from steps.step_vars import *

use_step_matcher("parse")


# LOAD STEPS

@step("I load the {model_name} table")
def step_impl(context, model_name):
    os.chdir(TESTS_DBT_ROOT)

    context.dbt_test_utils.run_dbt_model(mode='run',
                                         model=f"{model_name.lower()}_{MODE.lower()}",
                                         include_model_deps=True)


@step("I load the {model_name} table using SHA")
def step_impl(context, model_name):
    os.chdir(TESTS_DBT_ROOT)

    context.dbt_test_utils.run_dbt_model(mode='run',
                                         model_vars={'hash': 'SHA'},
                                         include_model_deps=True,
                                         model=f"{model_name.lower()}_{MODE.lower()}")


# BASE-LOAD STEPS


@step("a {table_name} table does not exist")
def step_impl(context, table_name):

    table_name = f'{table_name}_{MODE}'

    context.db_utils.create_schema(DATABASE, VLT_SCHEMA, context.connection)

    context.db_utils.drop_table(DATABASE, VLT_SCHEMA, table_name, connection=context.connection)

    is_exist = context.db_utils.table_exists(db=DATABASE, schema=VLT_SCHEMA, table_name=table_name,
                                             connection=context.connection)

    assert is_exist is False


# SINGLE-SOURCE STEPS


@step("there are records in the TEST_STG_CUSTOMER table")
def step_impl(context):
    context.db_utils.create_schema(DATABASE, STG_SCHEMA, context.connection)
    context.db_utils.drop_and_create(DATABASE, STG_SCHEMA, f"test_stg_customer_hubs_{MODE.lower()}",
                                     ["CUSTOMER_ID VARCHAR(38)", "CUSTOMER_NAME VARCHAR(25)", "CUSTOMER_DOB DATE",
                                      "LOADDATE DATE", "SOURCE VARCHAR(4)", ], connection=context.connection)
    context.db_utils.insert_data_from_ct(context.table, f"test_stg_customer_hubs_{MODE.lower()}", STG_SCHEMA, context.connection)


@given("there are records in the TEST_HUB_CUSTOMER table")
def step_impl(context):
    context.db_utils.create_schema(DATABASE, VLT_SCHEMA, context.connection)
    context.db_utils.drop_and_create(DATABASE, VLT_SCHEMA, f"test_hub_customer_hubs_{MODE.lower()}",
                                     ["CUSTOMER_PK BINARY", "CUSTOMER_ID VARCHAR(38)", "LOADDATE DATE",
                                      "SOURCE VARCHAR(4)", ], connection=context.connection)
    context.db_utils.insert_data_from_ct(context.table, f"test_hub_customer_hubs_{MODE.lower()}", VLT_SCHEMA, context.connection)


@step("there is an empty TEST_HUB_CUSTOMER table")
def step_impl(context):
    context.db_utils.create_schema(DATABASE, VLT_SCHEMA, context.connection)
    context.db_utils.drop_and_create(DATABASE, VLT_SCHEMA, f"test_hub_customer_hubs_{MODE.lower()}",
                                     ["CUSTOMER_PK BINARY", "CUSTOMER_ID VARCHAR(38)", "LOADDATE DATE",
                                      "SOURCE VARCHAR(4)"], context.connection)


@step("the TEST_HUB_CUSTOMER table should contain")
def step_impl(context):
    table_df = context.db_utils.context_table_to_df(context.table, binary_columns=['CUSTOMER_PK'])

    result_df = context.db_utils.get_table_data(
        full_table_name=f"{DATABASE }.{VLT_SCHEMA}.test_hub_customer_hubs_{MODE.lower()}",
        binary_columns=['CUSTOMER_PK'],
        order_by='CUSTOMER_ID', connection=context.connection)

    assert context.db_utils.compare_dataframes(table_df, result_df)


# UNION STEPS


@step("there are records in the TEST_STG_PARTS table")
def step_impl(context):
    context.db_utils.create_schema(DATABASE, STG_SCHEMA, context.connection)
    context.db_utils.drop_and_create(DATABASE, STG_SCHEMA, f"test_stg_parts_{MODE.lower()}",
                                     ["PART_ID VARCHAR(38)", "PART_NAME VARCHAR(60)", "PART_TYPE VARCHAR(10)",
                                      "PART_SIZE VARCHAR(5)", "PART_RETAILPRICE DOUBLE", "LOADDATE DATE",
                                      "SOURCE VARCHAR(4)"], connection=context.connection)
    context.db_utils.insert_data_from_ct(context.table, f"test_stg_parts_{MODE.lower()}", STG_SCHEMA, context.connection)


@step("there are records in the TEST_STG_SUPPLIER table")
def step_impl(context):
    context.db_utils.create_schema(DATABASE, STG_SCHEMA, context.connection)
    context.db_utils.drop_and_create(DATABASE, STG_SCHEMA, f"test_stg_supplier_{MODE.lower()}",
                                     ["PART_ID VARCHAR(38)", "SUPPLIER_ID VARCHAR(38)", "AVAILQTY INT",
                                      "SUPPLYCOST DOUBLE", "LOADDATE DATE", "SOURCE VARCHAR(4)"],
                                     connection=context.connection)
    context.db_utils.insert_data_from_ct(context.table, f"test_stg_supplier_{MODE.lower()}", STG_SCHEMA, context.connection)


@step("there are records in the TEST_STG_LINEITEM table")
def step_impl(context):
    context.db_utils.create_schema(DATABASE, STG_SCHEMA, context.connection)
    context.db_utils.drop_and_create(DATABASE, STG_SCHEMA, f"test_stg_lineitem_{MODE.lower()}",
                                     ["ORDER_ID VARCHAR(38)", "PART_ID VARCHAR(38)", "SUPPLIER_ID VARCHAR(38)",
                                      "LINENUMBER NUMBER(38)", "QUANTITY INT", "EXTENDED_PRICE DOUBLE",
                                      "DISCOUNT DOUBLE", "LOADDATE DATE", "SOURCE VARCHAR(4)"],
                                     connection=context.connection)
    context.db_utils.insert_data_from_ct(context.table, f"test_stg_lineitem_{MODE.lower()}", STG_SCHEMA, context.connection)


@step("there is an empty TEST_HUB_PARTS table")
def step_impl(context):
    context.db_utils.create_schema(DATABASE, VLT_SCHEMA, context.connection)
    context.db_utils.drop_and_create(DATABASE, VLT_SCHEMA, f"test_hub_parts_{MODE.lower()}",
                                     ["PART_PK BINARY", "PART_ID VARCHAR(38)", "SOURCE VARCHAR(4)", "LOADDATE DATE"],
                                     connection=context.connection)


@given("there are records in the TEST_HUB_PARTS table")
def step_impl(context):
    context.db_utils.create_schema(DATABASE, VLT_SCHEMA, context.connection)
    context.db_utils.drop_and_create(DATABASE, VLT_SCHEMA, f"test_hub_parts_{MODE.lower()}",
                                     ["PART_PK BINARY", "PART_ID VARCHAR(38)", "SOURCE VARCHAR(4)", "LOADDATE DATE"],
                                     connection=context.connection)
    context.db_utils.insert_data_from_ct(context.table, f"test_hub_parts_{MODE.lower()}", VLT_SCHEMA, context.connection)


@step("the TEST_HUB_PARTS table should contain")
def step_impl(context):
    table_df = context.db_utils.context_table_to_df(context.table, ignore_columns=['SOURCE'], binary_columns=['PART_PK'])

    result_df = context.db_utils.get_table_data(full_table_name=f"{DATABASE}.{VLT_SCHEMA}.test_hub_parts_{MODE.lower()}",
                                                binary_columns=['PART_PK'], order_by='PART_ID',
                                                ignore_columns=['SOURCE'],
                                                connection=context.connection)

    assert context.db_utils.compare_dataframes(table_df, result_df)
