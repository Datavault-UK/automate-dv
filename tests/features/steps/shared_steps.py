from behave import *
from behave.model import Table, Row

from tests.test_utils.dbt_test_utils import DBTVAULTGenerator

use_step_matcher("parse")

dbtvault_generator = DBTVAULTGenerator()


@given("the {model_name} table does not exist")
def check_exists(context, model_name):
    """Check the model exists"""
    logs = context.dbt_test_utils.run_dbt_operation(macro_name='check_model_exists', args={'model_name': model_name})

    context.target_model_name = model_name

    assert f'Model {model_name} does not exist.' in logs


@given("the {model_name} {vault_structure} is empty")
def load_empty_table(context, model_name, vault_structure):
    """Creates an empty table"""

    context.target_model_name = model_name

    headings = list(DBTVAULTGenerator.flatten(context.vault_structure_columns.values()))

    row = Row(cells=[], headings=headings)

    empty_table = Table(headings=headings, rows=row)

    seed_file_name = context.dbt_test_utils.context_table_to_csv(table=empty_table, context=context,
                                                                 model_name=f'stg_{model_name}_empty')

    dbtvault_generator.add_seed_config(seed_name=seed_file_name,
                                       seed_config=context.seed_config)

    context.dbt_test_utils.run_dbt_seed(seed_file_name=seed_file_name)

    metadata = {'source_model': seed_file_name, **context.vault_structure_columns}

    context.vault_structure_metadata = metadata

    dbtvault_generator.raw_vault_structure(model_name, vault_structure, **metadata)

    logs = context.dbt_test_utils.run_dbt_model(mode='run', model_name=model_name)

    assert 'Completed successfully' in logs


@given("the {model_name} {vault_structure} is already populated with data")
def load_populated_table(context, model_name, vault_structure):
    """
    Create a table with data pre-populated from the context table.
    """

    context.target_model_name = model_name

    seed_file_name = context.dbt_test_utils.context_table_to_csv(table=context.table, context=context,
                                                                 model_name=f'stg_{model_name}_populated')

    dbtvault_generator.add_seed_config(seed_name=seed_file_name,
                                       seed_config=context.seed_config)

    context.dbt_test_utils.run_dbt_seed(seed_file_name=seed_file_name)

    metadata = {'source_model': seed_file_name, **context.vault_structure_columns}

    context.vault_structure_metadata = metadata

    dbtvault_generator.raw_vault_structure(model_name, vault_structure, **metadata)

    logs = context.dbt_test_utils.run_dbt_model(mode='run', model_name=model_name)

    assert 'Completed successfully' in logs


@given("the {raw_stage_model_name} table contains data")
def create_csv(context, raw_stage_model_name):
    """Creates a CSV file in the data folder"""

    seed_file_name = context.dbt_test_utils.context_table_to_csv(table=context.table, context=context,
                                                                 model_name=raw_stage_model_name)

    logs = context.dbt_test_utils.run_dbt_seed(seed_file_name=seed_file_name)

    context.raw_stage_models = seed_file_name

    context.vault_hash_columns = context.table.headings

    assert 'Completed successfully' in logs


@step("I hash the stage")
def hash_stage(context):
    hashed_model_name = f'{context.raw_stage_models}_hashed'

    dbtvault_generator.stage(hashed_model_name)

    stage_args = {
        'source_model': context.raw_stage_models, 'hashed_columns': context.hash_mapping}

    logs = context.dbt_test_utils.run_dbt_model(mode='run', model_name=hashed_model_name, args=stage_args)

    context.hashed_stage_model_name = hashed_model_name

    assert 'Completed successfully' in logs


@step("I load the {model_name} {vault_structure}")
@when("I load the {model_name} {vault_structure}")
def load_table(context, model_name, vault_structure):
    metadata = {'source_model': context.hashed_stage_model_name, **context.vault_structure_columns}

    context.vault_structure_metadata = metadata

    dbtvault_generator.raw_vault_structure(model_name, vault_structure, **metadata)

    logs = context.dbt_test_utils.run_dbt_model(mode='run', model_name=model_name)

    assert 'Completed successfully' in logs


@then("the {model_name} table should contain expected data")
def expect_data(context, model_name):
    expected_output_csv = context.dbt_test_utils.context_table_to_csv(table=context.table, context=context,
                                                                      model_name=f'{model_name}_expected')
    metadata = context.vault_structure_metadata

    test_yaml = dbtvault_generator.create_test_model_schema_dict(target_model_name=context.target_model_name,
                                                                 expected_output_csv=expected_output_csv,
                                                                 unique_id=metadata['src_pk'],
                                                                 metadata=metadata)

    dbtvault_generator.append_dict_to_schema_yml(test_yaml)

    context.dbt_test_utils.run_dbt_seed(expected_output_csv)

    logs = context.dbt_test_utils.run_dbt_command(['dbt', 'test'])

    assert '1 of 1 PASS' in logs
