from behave import *

from steps.step_vars import *

use_step_matcher("parse")

# MAIN STEPS


@given("I have an empty T_LINK_TRANSACTION table")
def step_impl(context):
    context.db_utils.create_schema(DATABASE, VLT_SCHEMA, context.connection)
    context.db_utils.drop_and_create(DATABASE, VLT_SCHEMA, f"test_t_link_transaction_{MODE.lower()}",
                                     ["TRANSACTION_PK BINARY", "CUSTOMER_PK BINARY",
                                      "TRANSACTION_NUMBER NUMBER(38,0)", "TRANSACTION_DATE DATE", "LOADDATE DATE",
                                      "SOURCE VARCHAR(3)", "TYPE VARCHAR(2)", "AMOUNT NUMBER(38,2)",
                                      "EFFECTIVE_FROM DATE", ],
                                     connection=context.connection)


@step("a populated STG_TRANSACTION table")
def step_impl(context):
    context.db_utils.create_schema(DATABASE, STG_SCHEMA, context.connection)
    context.db_utils.drop_and_create(DATABASE, STG_SCHEMA, f"stg_transaction_{MODE.lower()}",
                                     ["CUSTOMER_ID VARCHAR(38)", "TRANSACTION_NUMBER NUMBER(38,0)",
                                      "TRANSACTION_DATE DATE", "LOADDATE DATE", "SOURCE VARCHAR(3)", "TYPE VARCHAR(2)",
                                      "AMOUNT NUMBER(38,2)"],
                                     connection=context.connection)

    context.db_utils.insert_data_from_ct(context.table,
                                         f"stg_transaction_{MODE.lower()}",
                                         STG_SCHEMA,
                                         context.connection)


@then("the TEST_T_LINK_TRANSACTION table should contain")
def step_impl(context):
    table_df = context.db_utils.context_table_to_df(context.table, ignore_columns='SOURCE',
                                                    binary_columns=['TRANSACTION_PK', 'CUSTOMER_PK'])

    result_df = context.db_utils.get_table_data(full_table_name=f"{DATABASE}.{VLT_SCHEMA}.test_t_link_transaction_{MODE.lower()}",
                                                binary_columns=['TRANSACTION_PK', 'CUSTOMER_PK'],
                                                ignore_columns='SOURCE', order_by='TRANSACTION_NUMBER',
                                                connection=context.connection)

    assert context.db_utils.compare_dataframes(table_df, result_df)


# CYCLE SCENARIO STEPS

@given("I have a populated TEST_TLINK_TRANSACTION table")
def step_impl(context):
    context.db_utils.create_schema(DATABASE, VLT_SCHEMA, context.connection)
    context.db_utils.drop_and_create(DATABASE, VLT_SCHEMA, f"test_t_link_transaction_{MODE.lower()}",
                                     ["TRANSACTION_PK BINARY", "CUSTOMER_PK BINARY",
                                      "TRANSACTION_NUMBER NUMBER(38,0)", "TRANSACTION_DATE DATE", "LOADDATE DATE",
                                      "SOURCE VARCHAR(3)", "TYPE VARCHAR(2)", "AMOUNT NUMBER(38,2)",
                                      "EFFECTIVE_FROM DATE", ],
                                     connection=context.connection)

    context.db_utils.insert_data_from_ct(context.table, f"test_t_link_transaction_{MODE.lower()}", VLT_SCHEMA,
                                         context.connection)


@step("the STG_TRANSACTION table has data inserted into it")
def step_impl(context):
    context.db_utils.insert_data_from_ct(context.table, f"stg_transaction_{MODE.lower()}", STG_SCHEMA,
                                         context.connection)
