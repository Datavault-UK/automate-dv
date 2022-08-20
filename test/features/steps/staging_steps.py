from behave import *

from test import context_utils


@step("I have ranked columns in the {processed_stage_name} model")
def ranked_columns(context, processed_stage_name):
    context.processed_stage_name = processed_stage_name

    ranked_column_data = context_utils.context_table_to_dicts(table=context.table, orient="index")

    ranked_metadata = {v['NAME']: {'partition_by': v['PARTITION_BY'],
                                   'order_by': v['ORDER_BY']}
                       for d in [ranked_column_data] for v in d.values()}

    ranked_config = {processed_stage_name: ranked_metadata}

    context.ranked_columns = ranked_config


@step("I have hashed columns in the {processed_stage_name} model")
def hashed_columns(context, processed_stage_name):
    context.processed_stage_name = processed_stage_name
    context.hashed_columns = {processed_stage_name: context_utils.context_table_to_dicts(table=context.table,
                                                                                         orient="records")[0]}


@step("I have derived columns in the {processed_stage_name} model")
def derive_columns(context, processed_stage_name):
    context.processed_stage_name = processed_stage_name
    context.derived_columns = {processed_stage_name: context_utils.context_table_to_dicts(table=context.table,
                                                                                          orient="records")[0]}


@step("I have null columns in the {processed_stage_name} model")
def null_columns(context, processed_stage_name):
    context.processed_stage_name = processed_stage_name
    context.null_columns = {processed_stage_name: context_utils.context_table_to_dicts(table=context.table,
                                                                                       orient="records")[0]}


@step("I have null columns in the {processed_stage_name} model and null_key_required is "
      "{null_key_required} and null_key_optional is {null_key_optional}")
def null_columns(context, processed_stage_name, null_key_required, null_key_optional):
    context.processed_stage_name = processed_stage_name
    context.null_columns = {processed_stage_name: context_utils.context_table_to_dicts(table=context.table,
                                                                                       orient="records")[0]}
    context.null_key_required = null_key_required
    context.null_key_optional = null_key_optional


@step("I do not include source columns")
def source_columns(context):
    context.include_source_columns = False
