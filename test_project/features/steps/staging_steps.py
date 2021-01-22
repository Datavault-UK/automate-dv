from behave import *

from test_project.test_utils.dbt_test_utils import DBTVAULTGenerator

use_step_matcher("parse")

dbtvault_generator = DBTVAULTGenerator()


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
