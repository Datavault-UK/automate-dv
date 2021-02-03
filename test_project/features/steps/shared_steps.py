from behave import *
from behave.model import Table, Row
import copy

from test_project.test_utils.dbt_test_utils import DBTVAULTGenerator

use_step_matcher("parse")

dbtvault_generator = DBTVAULTGenerator()


def set_stage_metadata(context, stage_model_name) -> dict:
    """
        Setup the context to include required staging metadata and return as a dictionary to
        support providing the variables in the command line to dbt instead
    """

    context.processed_stage_name = context.dbt_test_utils.process_stage_names(context, stage_model_name)

    context.include_source_columns = getattr(context, "include_source_columns", True)

    context.hashing = getattr(context, "hashing", "MD5")

    if not getattr(context, "ranked_columns", None):
        context.ranked_columns = dict()
        context.ranked_columns[stage_model_name] = dict()
    else:
        if not context.ranked_columns.get(stage_model_name, None):
            context.ranked_columns[stage_model_name] = dict()

    if not getattr(context, "hashed_columns", None):
        context.hashed_columns = dict()
        context.hashed_columns[stage_model_name] = dict()
    else:
        if not context.hashed_columns.get(stage_model_name, None):
            context.hashed_columns[stage_model_name] = dict()

    if not getattr(context, "derived_columns", None):
        context.derived_columns = dict()
        context.derived_columns[stage_model_name] = dict()
    else:
        if not context.derived_columns.get(stage_model_name, None):
            context.derived_columns[stage_model_name] = dict()

    dbt_vars = {
        "include_source_columns": context.include_source_columns,
        "hashed_columns": context.hashed_columns,
        "derived_columns": context.derived_columns,
        "hash": context.hashing
    }

    return dbt_vars


@given("the {model_name} table does not exist")
def check_exists(context, model_name):
    """Check the model exists"""
    logs = context.dbt_test_utils.run_dbt_operation(macro_name="check_model_exists",
                                                    args={"model_name": model_name})

    context.target_model_name = model_name

    assert f"Model {model_name} does not exist." in logs


@given("the raw vault contains empty tables")
def clear_schema(context):
    context.dbt_test_utils.replace_test_schema()

    model_names = context.dbt_test_utils.context_table_to_dict(table=context.table,
                                                               orient="list")

    context.vault_model_names = model_names

    models = [name for name in DBTVAULTGenerator.flatten([v for k, v in model_names.items()]) if name]

    for model_name in models:
        headings_dict = dbtvault_generator.evaluate_hashdiff(copy.deepcopy(context.vault_structure_columns[model_name]))

        headings = [v for k, v in headings_dict.items() if k != "source_model"]

        headings = dbtvault_generator.process_structure_headings(context, model_name, headings)

        row = Row(cells=[], headings=headings)

        empty_table = Table(headings=headings, rows=row)

        seed_file_name = context.dbt_test_utils.context_table_to_csv(table=empty_table,
                                                                     model_name=model_name)

        dbtvault_generator.add_seed_config(seed_name=seed_file_name,
                                           seed_config=context.seed_config[model_name])

        logs = context.dbt_test_utils.run_dbt_seed(seed_file_name=seed_file_name)

        assert "Completed successfully" in logs


@step("the {model_name} {vault_structure} is empty")
@given("the {model_name} {vault_structure} is empty")
def load_empty_table(context, model_name, vault_structure):
    """Creates an empty table"""

    context.target_model_name = model_name
    columns = context.vault_structure_columns

    if vault_structure == "stage":
        headings = context.stage_columns[model_name]
    else:
        headings = [val for key, val in columns[model_name].items()]
        headings = dbtvault_generator.process_structure_headings(context, model_name, headings)

    row = Row(cells=[], headings=headings)

    empty_table = Table(headings=headings, rows=row)

    seed_file_name = context.dbt_test_utils.context_table_to_csv(table=empty_table,
                                                                 model_name=model_name)

    dbtvault_generator.add_seed_config(seed_name=seed_file_name,
                                       seed_config=context.seed_config[model_name])

    logs = context.dbt_test_utils.run_dbt_seed(seed_file_name=seed_file_name)

    if getattr(context, "create_empty_stage", False) and getattr(context, "empty_stage_name", False):
        source_model_name = context.empty_stage_name
    else:
        source_model_name = seed_file_name

    if not vault_structure == "stage":
        metadata = {"source_model": source_model_name, **context.vault_structure_columns[model_name]}

        context.vault_structure_metadata = metadata

        dbtvault_generator.raw_vault_structure(model_name, vault_structure, **metadata)

        logs = context.dbt_test_utils.run_dbt_model(mode="run", model_name=model_name)

    assert "Completed successfully" in logs


@given("I will have a {raw_stage_name} raw stage and I have a {processed_stage_name} processed stage")
def create_empty_stage(context, raw_stage_name, processed_stage_name):
    stage_source_column_headings = list(context.seed_config[raw_stage_name]["+column_types"].keys())
    stage_hashed_column_headings = list(context.hashed_columns[processed_stage_name].keys())
    stage_derived_column_headings = list(context.derived_columns[processed_stage_name].keys())
    stage_headings = stage_source_column_headings + stage_hashed_column_headings + stage_derived_column_headings

    row = Row(cells=[], headings=stage_headings)

    empty_table = Table(headings=stage_headings, rows=row)

    seed_file_name = context.dbt_test_utils.context_table_to_csv(table=empty_table,
                                                                 model_name=processed_stage_name)

    context.create_empty_stage = True

    context.empty_stage_name = seed_file_name

    dbtvault_generator.add_seed_config(seed_name=seed_file_name,
                                       seed_config=context.seed_config[processed_stage_name])

    logs = context.dbt_test_utils.run_dbt_seed(seed_file_name=seed_file_name)

    assert "Completed successfully" in logs


@step("the {model_name} {vault_structure} is already populated with data")
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

    metadata = {"source_model": seed_file_name, **context.vault_structure_columns[model_name]}

    context.vault_structure_metadata = metadata

    dbtvault_generator.raw_vault_structure(model_name, vault_structure, **metadata)

    logs = context.dbt_test_utils.run_dbt_model(mode="run", model_name=model_name)

    assert "Completed successfully" in logs


@step("I load the {model_name} {vault_structure}")
def load_table(context, model_name, vault_structure):
    metadata = {"source_model": context.processed_stage_name, **context.vault_structure_columns[model_name]}

    config = dbtvault_generator.append_end_date_config(context, dict())

    metadata = context.dbt_test_utils.filter_metadata(context, metadata)

    context.vault_structure_metadata = metadata

    dbtvault_generator.raw_vault_structure(model_name=model_name,
                                           vault_structure=vault_structure,
                                           config=config,
                                           **metadata)

    logs = context.dbt_test_utils.run_dbt_model(mode="run", model_name=model_name)

    assert "Completed successfully" in logs


@step("I load the vault")
def load_vault(context):
    models = [name for name in DBTVAULTGenerator.flatten([v for k, v in context.vault_model_names.items()]) if name]

    for model_name in models:
        metadata = {**context.vault_structure_columns[model_name]}

        context.vault_structure_metadata = metadata

        vault_structure = model_name.split("_")[0]

        dbtvault_generator.raw_vault_structure(model_name, vault_structure, **metadata)

    is_full_refresh = context.dbt_test_utils.check_full_refresh(context)

    logs = context.dbt_test_utils.run_dbt_models(mode="run", model_names=models,
                                                 full_refresh=is_full_refresh)

    assert "Completed successfully" in logs


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

    assert "Completed successfully" in logs


@step("the {raw_stage_model_name} is loaded")
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

    assert "Completed successfully" in logs


@step("I create the {processed_stage_name} stage")
def stage_processing(context, processed_stage_name):
    stage_metadata = set_stage_metadata(context, stage_model_name=processed_stage_name)

    args = {k: v for k, v in stage_metadata.items() if k == "hash"}

    dbtvault_generator.raw_vault_structure(model_name=processed_stage_name,
                                           vault_structure="stage",
                                           source_model=context.raw_stage_models,
                                           hashed_columns=context.hashed_columns[processed_stage_name],
                                           derived_columns=context.derived_columns[processed_stage_name],
                                           ranked_columns=context.ranked_columns[processed_stage_name],
                                           include_source_columns=context.include_source_columns)

    logs = context.dbt_test_utils.run_dbt_model(mode="run", model_name=processed_stage_name,
                                                args=args)

    assert "Completed successfully" in logs


@then("the {model_name} table should contain expected data")
def expect_data(context, model_name):
    expected_output_csv_name = context.dbt_test_utils.context_table_to_csv(table=context.table,
                                                                           model_name=f"{model_name}_expected")

    columns_to_compare = context.dbt_test_utils.context_table_to_dict(table=context.table, orient="records")[0]
    compare_column_list = [k for k, v in columns_to_compare.items()]
    unique_id = compare_column_list[0]

    test_yaml = dbtvault_generator.create_test_model_schema_dict(target_model_name=model_name,
                                                                 expected_output_csv=expected_output_csv_name,
                                                                 unique_id=unique_id,
                                                                 columns_to_compare=columns_to_compare)

    dbtvault_generator.append_dict_to_schema_yml(test_yaml)

    dbtvault_generator.add_seed_config(seed_name=expected_output_csv_name,
                                       include_columns=compare_column_list,
                                       seed_config=context.seed_config[model_name])

    context.dbt_test_utils.run_dbt_seed(expected_output_csv_name)

    logs = context.dbt_test_utils.run_dbt_command(["dbt", "test"])

    assert "1 of 1 PASS" in logs
