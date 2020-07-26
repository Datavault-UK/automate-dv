from behave import *
from behave.model import Table, Row
import copy

from tests.test_utils.dbt_test_utils import DBTVAULTGenerator

use_step_matcher("parse")

dbtvault_generator = DBTVAULTGenerator()


@given("the {model_name} table does not exist")
def check_exists(context, model_name):
    """Check the model exists"""
    logs = context.dbt_test_utils.run_dbt_operation(macro_name='check_model_exists',
                                                    args={'model_name': model_name})

    context.target_model_name = model_name

    assert f'Model {model_name} does not exist.' in logs


@given('the raw vault contains empty tables')
def clear_schema(context):
    context.dbt_test_utils.replace_test_schema()

    model_names = context.dbt_test_utils.context_table_to_dict(table=context.table,
                                                               orient='list')

    context.vault_model_names = model_names

    models = [name for name in DBTVAULTGenerator.flatten([v for k, v in model_names.items()]) if name]

    for model_name in models:
        headings_dict = dbtvault_generator.evaluate_hashdiff(copy.deepcopy(context.vault_structure_columns[model_name]))

        headings = list(DBTVAULTGenerator.flatten([v for k, v in headings_dict.items() if k != 'source_model']))

        row = Row(cells=[], headings=headings)

        empty_table = Table(headings=headings, rows=row)

        seed_file_name = context.dbt_test_utils.context_table_to_csv(table=empty_table,
                                                                     model_name=model_name)

        dbtvault_generator.add_seed_config(seed_name=seed_file_name,
                                           seed_config=context.seed_config[model_name])

        logs = context.dbt_test_utils.run_dbt_seed(seed_file_name=seed_file_name)

        assert 'Completed successfully' in logs


@given("the {model_name} {vault_structure} is empty")
def load_empty_table(context, model_name, vault_structure):
    """Creates an empty table"""

    context.target_model_name = model_name

    if vault_structure == 'stage':
        headings = context.stage_columns[model_name]
    else:
        headings = list(DBTVAULTGenerator.flatten(context.vault_structure_columns[model_name].values()))

    row = Row(cells=[], headings=headings)

    empty_table = Table(headings=headings, rows=row)

    seed_file_name = context.dbt_test_utils.context_table_to_csv(table=empty_table,
                                                                 model_name=model_name)

    dbtvault_generator.add_seed_config(seed_name=seed_file_name,
                                       seed_config=context.seed_config[model_name])

    logs = context.dbt_test_utils.run_dbt_seed(seed_file_name=seed_file_name)

    if not vault_structure == 'stage':
        metadata = {'source_model': seed_file_name, **context.vault_structure_columns[model_name]}

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

    seed_file_name = context.dbt_test_utils.context_table_to_csv(table=context.table,
                                                                 model_name=model_name)

    dbtvault_generator.add_seed_config(seed_name=seed_file_name,
                                       seed_config=context.seed_config[model_name])

    context.dbt_test_utils.run_dbt_seed(seed_file_name=seed_file_name)

    metadata = {'source_model': seed_file_name, **context.vault_structure_columns[model_name]}

    context.vault_structure_metadata = metadata

    dbtvault_generator.raw_vault_structure(model_name, vault_structure, **metadata)

    logs = context.dbt_test_utils.run_dbt_model(mode='run', model_name=model_name)

    assert 'Completed successfully' in logs


@step("I load the {model_name} {vault_structure}")
def load_table(context, model_name, vault_structure):
    metadata = {'source_model': context.hashed_stage_model_name, **context.vault_structure_columns[model_name]}

    context.vault_structure_metadata = metadata

    dbtvault_generator.raw_vault_structure(model_name, vault_structure, **metadata)

    logs = context.dbt_test_utils.run_dbt_model(mode='run', model_name=model_name)

    assert 'Completed successfully' in logs


@step("I use insert_by_period to load the {model_name} {vault_structure} with date range: {start_date} to {stop_date}")
def load_table(context, model_name, vault_structure, start_date=None, stop_date=None):
    metadata = {'source_model': context.hashed_stage_model_name,
                **context.vault_structure_columns[model_name]}

    config = {'materialized': 'vault_insert_by_period',
              'timestamp_field': 'LOADDATE',
              'start_date': start_date,
              'stop_date': stop_date,
              'source_model': context.hashed_stage_model_name}

    context.vault_structure_metadata = metadata

    dbtvault_generator.raw_vault_structure(model_name=model_name,
                                           vault_structure=vault_structure,
                                           config=config,
                                           **metadata)

    logs = context.dbt_test_utils.run_dbt_model(mode='run', model_name=model_name)

    assert 'Completed successfully' in logs


@step("I use insert_by_period to load the {model_name} {vault_structure}")
def load_table(context, model_name, vault_structure):
    metadata = {'source_model': context.hashed_stage_model_name,
                **context.vault_structure_columns[model_name]}

    config = {'materialized': 'vault_insert_by_period',
              'timestamp_field': 'LOADDATE',
              'source_model': context.hashed_stage_model_name}

    context.vault_structure_metadata = metadata

    dbtvault_generator.raw_vault_structure(model_name=model_name,
                                           vault_structure=vault_structure,
                                           config=config,
                                           **metadata)

    logs = context.dbt_test_utils.run_dbt_model(mode='run', model_name=model_name)

    assert 'Completed successfully' in logs


@step("I load the vault")
def load_vault(context):
    models = [name for name in DBTVAULTGenerator.flatten([v for k, v in context.vault_model_names.items()]) if name]

    for model_name in models:
        metadata = {**context.vault_structure_columns[model_name]}

        context.vault_structure_metadata = metadata

        vault_structure = model_name.split('_')[0]

        dbtvault_generator.raw_vault_structure(model_name, vault_structure, **metadata)

        logs = context.dbt_test_utils.run_dbt_model(mode='run', model_name=model_name)

        assert 'Completed successfully' in logs


@given("the {raw_stage_model_name} table contains data")
def create_csv(context, raw_stage_model_name):
    """Creates a CSV file in the data folder"""

    seed_file_name = context.dbt_test_utils.context_table_to_csv(table=context.table,
                                                                 model_name=raw_stage_model_name)

    dbtvault_generator.add_seed_config(seed_name=seed_file_name,
                                       seed_config=context.seed_config[raw_stage_model_name])

    logs = context.dbt_test_utils.run_dbt_seed(seed_file_name=seed_file_name)

    context.raw_stage_models = seed_file_name

    context.raw_stage_model_name = raw_stage_model_name

    assert 'Completed successfully' in logs


@when("the {raw_stage_model_name} is loaded")
@step("the {raw_stage_model_name} is loaded for day 1")
@step("the {raw_stage_model_name} is loaded for day 2")
@step("the {raw_stage_model_name} is loaded for day 3")
@step("the {raw_stage_model_name} is loaded for day 4")
def create_csv(context, raw_stage_model_name):
    """Creates a CSV file in the data folder
    """

    context.raw_stage_model_name = raw_stage_model_name

    seed_file_name = context.dbt_test_utils.context_table_to_csv(table=context.table,
                                                                 model_name=raw_stage_model_name)

    dbtvault_generator.add_seed_config(seed_name=seed_file_name,
                                       seed_config=context.seed_config[raw_stage_model_name])

    logs = context.dbt_test_utils.run_dbt_seed(seed_file_name=seed_file_name)

    context.raw_stage_models = seed_file_name

    assert 'Completed successfully' in logs


@step("I hash the stage")
def stage(context):
    hashed_model_name = f'{context.raw_stage_models}_hashed'

    dbtvault_generator.stage(hashed_model_name)

    stage_args = {
        'source_model': context.raw_stage_models,
        'hashed_columns': context.hash_mapping_config[context.raw_stage_model_name]}

    if hasattr(context, 'derived_mapping'):
        stage_args['derived_columns'] = context.derived_mapping[context.raw_stage_model_name]

    if hasattr(context, 'hashing'):
        if context.hashing == 'sha':
            stage_args['hash'] = 'SHA'

    logs = context.dbt_test_utils.run_dbt_model(mode='run', model_name=hashed_model_name, args=stage_args)

    if hasattr(context, 'hashed_stage_model_name'):

        context.hashed_stage_model_name = context.dbt_test_utils.process_hashed_stage_names(
            context.hashed_stage_model_name,
            hashed_model_name)

    else:
        context.hashed_stage_model_name = hashed_model_name

    assert 'Completed successfully' in logs


@then("the {model_name} table should contain expected data")
def expect_data(context, model_name):
    expected_output_csv = context.dbt_test_utils.context_table_to_csv(table=context.table,
                                                                      model_name=f'{model_name}_expected')

    metadata = dbtvault_generator.evaluate_hashdiff(copy.deepcopy(context.vault_structure_columns[model_name]))

    ignore_columns = context.dbt_test_utils.find_columns_to_ignore(context.table)

    test_yaml = dbtvault_generator.create_test_model_schema_dict(target_model_name=model_name,
                                                                 expected_output_csv=expected_output_csv,
                                                                 unique_id=metadata['src_pk'],
                                                                 metadata=metadata,
                                                                 ignore_columns=ignore_columns)

    dbtvault_generator.append_dict_to_schema_yml(test_yaml)

    dbtvault_generator.add_seed_config(seed_name=f"{model_name}_expected".lower(),
                                       seed_config=context.seed_config[model_name])

    context.dbt_test_utils.run_dbt_seed(expected_output_csv)

    logs = context.dbt_test_utils.run_dbt_command(['dbt', 'test'])

    assert '1 of 1 PASS' in logs
