from behave import *

use_step_matcher("parse")


@given("that {vault_structure} will be generated with metadata")
def define_hub_columns(context, vault_structure):
    table_dict = context.dbt_test_utils.context_table_to_dict(context.table)

    context.hub_columns = table_dict[0]


@given("the {model_name} table does not exist")
def drop_table(context, model_name):
    """Drops the relation with the given model name, if it exists"""
    logs = context.dbt_test_utils.run_dbt_operation(macro_name='drop_model',
                                                    args={'model_name': model_name})

    assert (('Nothing to drop' in logs) or (f"Successfully dropped model '{model_name}'" in logs))


@given("the {stage_model_name} table contains data")
def create_csv(context, stage_model_name):
    """Creates a CSV file in the data folder"""

    seed_file_name = context.dbt_test_utils.context_table_to_csv(table=context.table, context=context,
                                                                 model_name=stage_model_name)

    logs = context.dbt_test_utils.run_dbt_seed(seed_file_name=seed_file_name)

    context.stage_model_name = seed_file_name

    assert 'Completed successfully' in logs


@when("I load the {model_name} table")
def load_table(context, model_name):

    hub_metadata = {'source_model': context.stage_model_name, **context.hub_columns}

    logs = context.dbt_test_utils.run_dbt_model(mode='run',
                                                model_name='hub',
                                                args=hub_metadata)

    assert 'Completed successfully' in logs


@then("the {model_name} table should contain expected data")
def expect_data(context, model_name):
    logs = context.dbt_test_utils.context_table_to_csv(table=context.table, context=context,
                                                       model_name=f'{model_name}_expected')
    print(model_name)
