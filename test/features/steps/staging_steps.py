from behave import *

from test.test_utils.dbtvault_generator import DBTVAULTGenerator

use_step_matcher("parse")

dbtvault_generator = DBTVAULTGenerator()


@step("I have ranked columns in the {processed_stage_name} model")
def ranked_columns(context, processed_stage_name):
    context.processed_stage_name = processed_stage_name

    ranked_column_data = context.dbt_test_utils.context_table_to_dict(table=context.table, orient="index").items()

    ranked_metadata = {v[1]['NAME']: {'partition_by': v[1]['PARTITION_BY'],
                                      'order_by': v[1]['ORDER_BY']}
                       for v in ranked_column_data}

    ranked_config = {processed_stage_name: ranked_metadata}

    context.ranked_columns = ranked_config


@step("I have hashed columns in the {processed_stage_name} model")
def hashed_columns(context, processed_stage_name):
    context.processed_stage_name = processed_stage_name
    context.hashed_columns = {processed_stage_name: context.dbt_test_utils.context_table_to_dict(table=context.table,
                                                                                                 orient="records")[0]}


@step("I have derived columns in the {processed_stage_name} model")
def derive_columns(context, processed_stage_name):
    context.processed_stage_name = processed_stage_name
    context.derived_columns = {processed_stage_name: context.dbt_test_utils.context_table_to_dict(table=context.table,
                                                                                                  orient="records")[0]}


@step("I do not include source columns")
def source_columns(context):
    context.include_source_columns = False
