from behave import *

from test import dbtvault_harness_utils


@step("I have ranked columns in the {processed_stage_name} model")
def ranked_columns(context, processed_stage_name):
    context.processed_stage_name = processed_stage_name

    ranked_column_data = dbtvault_harness_utils.context_table_to_dicts(table=context.table, orient="index")

    ranked_metadata = {v['NAME']: {'partition_by': v['PARTITION_BY'],
                                   'order_by': v['ORDER_BY']}
                       for d in ranked_column_data for v in d.values()}

    ranked_config = {processed_stage_name: ranked_metadata}

    context.ranked_columns = ranked_config


@step("I have hashed columns in the {processed_stage_name} model")
def hashed_columns(context, processed_stage_name):
    context.processed_stage_name = processed_stage_name
    context.hashed_columns = {processed_stage_name: dbtvault_harness_utils.context_table_to_dicts(table=context.table,
                                                                                                  orient="records")[0]}


@step("I have derived columns in the {processed_stage_name} model")
def derive_columns(context, processed_stage_name):
    context.processed_stage_name = processed_stage_name
    context.derived_columns = {processed_stage_name: dbtvault_harness_utils.context_table_to_dicts(table=context.table,
                                                                                                   orient="records")[0]}


@step("I do not include source columns")
def source_columns(context):
    context.include_source_columns = False
