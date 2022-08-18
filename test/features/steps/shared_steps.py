import copy

from behave import *
from behave.model import Table, Row

from env import env_utils
from test import dbtvault_generator, dbt_runner, behave_helpers, context_utils, step_helpers


def set_stage_metadata(context, stage_model_name) -> dict:
    """
        Setup the context to include required staging metadata and return as a dictionary to
        support providing the variables in the command line to dbt instead
    """

    context.processed_stage_name = step_helpers.process_stage_names(context, stage_model_name)

    context.include_source_columns = getattr(context, "include_source_columns", True)

    context.hashing = getattr(context, "hashing", "MD5")

    context.null_key_required = getattr(context, "null_key_required", "-1")

    context.null_key_optional = getattr(context, "null_key_optional", "-2")

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

    if not getattr(context, "null_columns", None):
        context.null_columns = dict()
        context.null_columns[stage_model_name] = dict()
    else:
        if not context.null_columns.get(stage_model_name, None):
            context.null_columns[stage_model_name] = dict()

    dbt_vars = {
        "include_source_columns": context.include_source_columns,
        "hashed_columns": context.hashed_columns,
        "derived_columns": context.derived_columns,
        "null_columns": context.null_columns,
        "hash": context.hashing,
        "null_key_required": context.null_key_required,
        "null_key_optional": context.null_key_optional
    }

    return dbt_vars


@given("the {model_name} table does not exist")
def check_exists(context, model_name):
    logs = dbt_runner.run_dbt_operation(macro_name="check_model_exists",
                                        args={"model_name": model_name})

    context.target_model_name = model_name

    assert f"Model {model_name} does not exist." in logs


@given("the raw vault contains empty tables")
def clear_schema(context):
    behave_helpers.replace_test_schema()

    model_names = context_utils.context_table_to_dicts(table=context.table,
                                                       orient="list")

    context.vault_model_names = model_names

    models = [name for name in dbtvault_generator.flatten([v for k, v in model_names.items()]) if name]

    seed_file_names = []

    for model_name in models:
        headings_dict = dbtvault_generator.evaluate_hashdiff(copy.deepcopy(context.vault_structure_columns[model_name]))

        headings = dbtvault_generator.extract_column_names(context, model_name, headings_dict)

        row = Row(cells=[], headings=headings)

        empty_table = Table(headings=headings, rows=row)

        seed_file_name = context_utils.context_table_to_csv(table=empty_table,
                                                            model_name=model_name)

        dbtvault_generator.add_seed_config(seed_name=seed_file_name,
                                           seed_config=context.seed_config[model_name])

        seed_file_names.append(seed_file_name)

    logs = dbt_runner.run_dbt_seeds(seed_file_names=seed_file_names)

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
        headings = dbtvault_generator.extract_column_names(context, model_name, columns[model_name])

    row = Row(cells=[], headings=headings)

    empty_table = Table(headings=headings, rows=row)

    seed_file_name = context_utils.context_table_to_csv(table=empty_table,
                                                        model_name=model_name)

    dbtvault_generator.add_seed_config(seed_name=seed_file_name,
                                       seed_config=context.seed_config[model_name])

    logs = dbt_runner.run_dbt_seeds(seed_file_names=[seed_file_name])

    if getattr(context, "create_empty_stage", False) and getattr(context, "empty_stage_name", False):
        source_model_name = context.empty_stage_name
    else:
        source_model_name = seed_file_name

    if not vault_structure == "stage":
        metadata = {"source_model": source_model_name, **context.vault_structure_columns[model_name]}

        context.vault_structure_metadata = metadata

        dbtvault_generator.raw_vault_structure(model_name, vault_structure, **metadata)

        logs = dbt_runner.run_dbt_models(mode="run", model_names=[model_name])

    assert "Completed successfully" in logs


@given("I have an empty {raw_stage_name} raw stage")
def create_empty_stage(context, raw_stage_name):
    stage_headings = list(context.seed_config[raw_stage_name]["column_types"].keys())

    row = Row(cells=[], headings=stage_headings)

    empty_table = Table(headings=stage_headings, rows=row)

    seed_file_name = context_utils.context_table_to_csv(table=empty_table,
                                                        model_name=raw_stage_name)

    context.create_empty_stage = True

    context.empty_stage_name = seed_file_name

    dbtvault_generator.add_seed_config(seed_name=seed_file_name,
                                       seed_config=context.seed_config[raw_stage_name])

    logs = dbt_runner.run_dbt_seeds(seed_file_names=[seed_file_name])

    context.raw_stage_name = raw_stage_name

    assert "Completed successfully" in logs


@given("I have an empty {processed_stage_name} primed stage")
def create_empty_stage(context, processed_stage_name):

    if not getattr(context, "null_columns", None):
        context.null_columns = dict()
        context.null_columns[processed_stage_name] = dict()
    else:
        if not context.null_columns.get(processed_stage_name, None):
            context.null_columns[processed_stage_name] = dict()

    stage_source_column_headings = list(context.seed_config[context.raw_stage_name]["column_types"].keys())
    stage_hashed_column_headings = list(context.hashed_columns[processed_stage_name].keys())
    stage_derived_column_headings = list(context.derived_columns[processed_stage_name].keys())
    stage_null_column_headings_list = []
    for v in list(context.null_columns[processed_stage_name].values()):
        if isinstance(v, list):
            stage_null_column_headings_list.extend(v)
        else:
            stage_null_column_headings_list.append(v)
    stage_null_column_headings = list(v + "_ORIGINAL" for v in stage_null_column_headings_list)

    stage_headings = stage_source_column_headings + stage_hashed_column_headings \
                     + stage_derived_column_headings + stage_null_column_headings

    row = Row(cells=[], headings=stage_headings)

    empty_table = Table(headings=stage_headings, rows=row)

    seed_file_name = context_utils.context_table_to_csv(table=empty_table,
                                                        model_name=processed_stage_name)

    context.create_empty_stage = True

    context.empty_stage_name = seed_file_name

    dbtvault_generator.add_seed_config(seed_name=seed_file_name,
                                       seed_config=context.seed_config[processed_stage_name])

    logs = dbt_runner.run_dbt_seeds(seed_file_names=[seed_file_name])

    assert "Completed successfully" in logs


@step("the {model_name} {vault_structure} is already populated with data")
@given("the {model_name} {vault_structure} is already populated with data")
def load_populated_table(context, model_name, vault_structure):
    """
    Create a table with data pre-populated from the context table.
    """

    if env_utils.platform() == "sqlserver":
        # Workaround for MSSQL not permitting certain implicit data type conversions while loading nvarchar csv file data
        # into expected data table, e.g. nvarchar -- > binary

        seed_model_name = context_utils.context_table_to_model(context.seed_config, context.table,
                                                               model_name=model_name,
                                                               target_model_name=model_name)

        context.target_model_name = model_name

        metadata = {"source_model": seed_model_name, **context.vault_structure_columns[model_name]}

        context.vault_structure_metadata = metadata

        dbtvault_generator.raw_vault_structure(model_name, vault_structure, **metadata)

        seed_logs = dbt_runner.run_dbt_seed_model(seed_model_name=seed_model_name)

        metadata = {"source_model": seed_model_name, **context.vault_structure_columns[model_name]}

        context.vault_structure_metadata = metadata

        dbtvault_generator.raw_vault_structure(model_name, vault_structure, **metadata)

        logs = dbt_runner.run_dbt_models(mode="run", model_names=[model_name])

        assert "Completed successfully" in seed_logs
        assert "Completed successfully" in logs

    else:

        context.target_model_name = model_name

        seed_file_name = context_utils.context_table_to_csv(table=context.table,
                                                            model_name=model_name)

        dbtvault_generator.add_seed_config(seed_name=seed_file_name,
                                           seed_config=context.seed_config[model_name])

        dbt_runner.run_dbt_seeds(seed_file_names=[seed_file_name])

        metadata = {"source_model": seed_file_name, **context.vault_structure_columns[model_name]}

        context.vault_structure_metadata = metadata

        dbtvault_generator.raw_vault_structure(model_name, vault_structure, **metadata)

        logs = dbt_runner.run_dbt_models(mode="run", model_names=[model_name])

        assert "Completed successfully" in logs


@step("I load the {model_name} {vault_structure}")
def load_table(context, model_name, vault_structure):
    metadata = {"source_model": context.processed_stage_name,
                **context.vault_structure_columns[model_name]}

    config = dbtvault_generator.append_end_date_config(context, dict())

    metadata = step_helpers.filter_metadata(context, metadata)

    context.vault_structure_metadata = metadata

    dbtvault_generator.raw_vault_structure(model_name=model_name,
                                           vault_structure=vault_structure,
                                           config=config,
                                           **metadata)

    logs = dbt_runner.run_dbt_models(mode="run", model_names=[model_name])

    assert "Completed successfully" in logs


@step("I load the vault")
def load_vault(context):
    models = {k: list(filter(None, dbtvault_generator.flatten(v)))
              for k, v in context.vault_model_names.items()}
    model_names = []

    for vault_structure, model_list in models.items():
        for model_name in model_list:
            metadata = {**context.vault_structure_columns[model_name]}

            context.vault_structure_metadata = metadata

            config = dbtvault_generator.append_end_date_config(context, dict())

            dbtvault_generator.raw_vault_structure(model_name, vault_structure, config=config, **metadata)
            model_names.append(model_name)

    is_full_refresh = step_helpers.is_full_refresh(context)

    logs = dbt_runner.run_dbt_models(mode="run", model_names=model_names,
                                     full_refresh=is_full_refresh)

    assert "Completed successfully" in logs


@given("the {raw_stage_model_name} table contains data")
def create_csv(context, raw_stage_model_name):
    """Creates a CSV file in the data folder"""

    if env_utils.platform() == "sqlserver":
        # Workaround for MSSQL not permitting certain implicit data type conversions while loading nvarchar csv file data
        # into expected data table, e.g. nvarchar -- > binary

        # Delete any seed CSV file created by an earlier step to avoid dbt conflict with the seed table about to be created
        behave_helpers.clean_seeds(raw_stage_model_name.lower() + "_seed")

        seed_model_name = context_utils.context_table_to_model(context.seed_config, context.table,
                                                               model_name=raw_stage_model_name,
                                                               target_model_name=raw_stage_model_name)

        context.target_model_name = raw_stage_model_name

        logs = dbt_runner.run_dbt_seed_model(seed_model_name=seed_model_name)

        context.raw_stage_models = seed_model_name

        context.raw_stage_model_name = raw_stage_model_name

        assert "Completed successfully" in logs

    else:

        seed_file_name = context_utils.context_table_to_csv(table=context.table,
                                                            model_name=raw_stage_model_name)

        dbtvault_generator.add_seed_config(seed_name=seed_file_name,
                                           seed_config=context.seed_config[raw_stage_model_name])

        logs = dbt_runner.run_dbt_seeds(seed_file_names=[seed_file_name])

        context.raw_stage_models = seed_file_name

        context.raw_stage_model_name = raw_stage_model_name

        assert "Completed successfully" in logs


@step("the {table_name} table is created and populated with data")
def create_csv(context, table_name):
    """Creates a CSV file in the data folder, creates a seed table, and then loads a table using the seed table"""

    if env_utils.platform() == "sqlserver":
        # Workaround for MSSQL not permitting certain implicit data type conversions while loading nvarchar csv file data
        # into expected data table, e.g. nvarchar -- > binary

        # Delete any seed CSV file created by an earlier step to avoid dbt conflict with the seed table about to be created
        behave_helpers.clean_seeds(table_name.lower() + "_seed")

        seed_model_name = context_utils.context_table_to_model(context.seed_config, context.table,
                                                               model_name=table_name,
                                                               target_model_name=table_name)

        context.target_model_name = table_name

        seed_logs = dbt_runner.run_dbt_seed_model(seed_model_name=seed_model_name)

        stage_metadata = set_stage_metadata(context, stage_model_name=table_name)

        args = {k: v for k, v in stage_metadata.items() if k == "hash" or k == "null_key_required" or k == "null_key_optional"}

        dbtvault_generator.raw_vault_structure(model_name=table_name,
                                               vault_structure='stage',
                                               source_model=seed_model_name,
                                               config={'materialized': 'table'})

        run_logs = dbt_runner.run_dbt_models(mode="run", model_names=[table_name],
                                             args=args, full_refresh=True)

        context.raw_stage_models = seed_model_name

        assert "Completed successfully" in seed_logs
        assert "Completed successfully" in run_logs

    else:

        seed_file_name = context_utils.context_table_to_csv(table=context.table,
                                                            model_name=table_name)

        dbtvault_generator.add_seed_config(seed_name=seed_file_name,
                                           seed_config=context.seed_config[table_name])

        seed_logs = dbt_runner.run_dbt_seeds(seed_file_names=[seed_file_name])

        stage_metadata = set_stage_metadata(context, stage_model_name=table_name)

        args = {k: v for k, v in stage_metadata.items() if k == "hash" or k == "null_key_required" or k == "null_key_optional"}

        dbtvault_generator.raw_vault_structure(model_name=table_name,
                                               vault_structure='stage',
                                               source_model=seed_file_name,
                                               config={'materialized': 'table'})

        run_logs = dbt_runner.run_dbt_models(mode="run", model_names=[table_name],
                                             args=args, full_refresh=True)

        context.raw_stage_models = seed_file_name

        assert "Completed successfully" in seed_logs
        assert "Completed successfully" in run_logs


@step("the {raw_stage_model_name} is loaded")
def create_csv(context, raw_stage_model_name):
    """Creates a CSV file in the data folder
    """

    if env_utils.platform() == "sqlserver":
        # Workaround for MSSQL not permitting certain implicit data type conversions while loading nvarchar csv file data
        # into expected data table, e.g. nvarchar -- > binary

        # Delete any seed CSV file created by an earlier step to avoid dbt conflict with the seed table about to be created
        # For MSSQL must delete any existing copy of the seed file if present, e.g. multiple loads
        # For Snowflake deletion of seed file is not required but does not cause a problem if performed
        behave_helpers.clean_seeds(raw_stage_model_name.lower() + "_seed")

        context.raw_stage_model_name = raw_stage_model_name

        seed_model_name = context_utils.context_table_to_model(context.seed_config, context.table,
                                                               model_name=raw_stage_model_name,
                                                               target_model_name=raw_stage_model_name)

        context.target_model_name = raw_stage_model_name

        logs = dbt_runner.run_dbt_seed_model(seed_model_name=seed_model_name)

        context.raw_stage_models = seed_model_name

        assert "Completed successfully" in logs

    else:

        context.raw_stage_model_name = raw_stage_model_name

        seed_file_name = context_utils.context_table_to_csv(table=context.table,
                                                            model_name=raw_stage_model_name)

        dbtvault_generator.add_seed_config(seed_name=seed_file_name,
                                           seed_config=context.seed_config[raw_stage_model_name])

        logs = dbt_runner.run_dbt_seeds(seed_file_names=[seed_file_name])

        context.raw_stage_models = seed_file_name

        assert "Completed successfully" in logs


@step("I stage the {processed_stage_name} data")
def stage_processing(context, processed_stage_name):
    stage_metadata = set_stage_metadata(context, stage_model_name=processed_stage_name)

    args = {k: v for k, v in stage_metadata.items() if k == "hash" or k == "null_key_required" or k == "null_key_optional"}

    dbtvault_generator.raw_vault_structure(model_name=processed_stage_name,
                                           vault_structure="stage",
                                           source_model=context.raw_stage_models,
                                           hashed_columns=context.hashed_columns[processed_stage_name],
                                           derived_columns=context.derived_columns[processed_stage_name],
                                           ranked_columns=context.ranked_columns[processed_stage_name],
                                           null_columns=context.null_columns[processed_stage_name],
                                           include_source_columns=context.include_source_columns)

    logs = dbt_runner.run_dbt_models(mode="run", model_names=[processed_stage_name],
                                     args=args)

    assert "Completed successfully" in logs


@then("the {model_name} table should contain expected data")
def expect_data(context, model_name):
    if env_utils.platform() == "sqlserver":
        # Workaround for MSSQL not permitting certain implicit data type conversions while loading nvarchar csv file data
        # into expected data table, e.g. nvarchar -- > binary

        # Delete any seed CSV or model SQL file created by an earlier step to avoid dbt conflict with the seed table about to be created
        behave_helpers.clean_seeds(model_name.lower() + "_expected_seed")
        behave_helpers.clean_models(model_name.lower() + "_expected_seed")

        seed_model_name = context_utils.context_table_to_model(context.seed_config, context.table,
                                                               model_name=model_name,
                                                               target_model_name=f"{model_name}_EXPECTED")

        context.target_model_name = seed_model_name

        seed_logs = dbt_runner.run_dbt_seed_model(seed_model_name=seed_model_name)

        columns_to_compare = context.table.headings
        unique_id = columns_to_compare[0]

        test_yaml = dbtvault_generator.create_test_model_schema_dict(target_model_name=model_name,
                                                                     expected_output_csv=seed_model_name,
                                                                     unique_id=unique_id,
                                                                     columns_to_compare=columns_to_compare)

        dbtvault_generator.append_dict_to_schema_yml(test_yaml)

        logs = dbt_runner.run_dbt_command(["dbt", "test"])

        assert "Completed successfully" in seed_logs
        assert "1 of 1 PASS" in logs

    else:

        expected_output_csv_name = context_utils.context_table_to_csv(table=context.table,
                                                                      model_name=f"{model_name}_expected")

        columns_to_compare = context.table.headings
        unique_id = columns_to_compare[0]

        test_yaml = dbtvault_generator.create_test_model_schema_dict(target_model_name=model_name,
                                                                     expected_output_csv=expected_output_csv_name,
                                                                     unique_id=unique_id,
                                                                     columns_to_compare=columns_to_compare)

        dbtvault_generator.append_dict_to_schema_yml(test_yaml)

        dbtvault_generator.add_seed_config(seed_name=expected_output_csv_name,
                                           include_columns=columns_to_compare,
                                           seed_config=context.seed_config[model_name])

        dbt_runner.run_dbt_seeds(seed_file_names=[expected_output_csv_name])

        logs = dbt_runner.run_dbt_command(["dbt", "test"])

        assert "1 of 1 PASS" in logs


@then("the {model_name} table should be empty")
def expect_data(context, model_name):
    if env_utils.platform() == "sqlserver":

        # Delete any seed CSV or model SQL file created by an earlier step to avoid dbt conflict with the seed table about to be created
        behave_helpers.clean_seeds(model_name.lower() + "_expected_seed")
        behave_helpers.clean_models(model_name.lower() + "_expected_seed")

        # Create seed file with no data rows
        expected_model_name = f"{model_name}_EXPECTED"

        table_headings = list(context.seed_config[model_name]["column_types"].keys())
        row = Row(cells=[], headings=table_headings)

        empty_table = Table(headings=table_headings, rows=row)

        seed_file_name = context_utils.context_table_to_csv(table=empty_table,
                                                            model_name=expected_model_name)

        # Create empty expected data table using empty seed file
        dbtvault_generator.add_seed_config(seed_name=seed_file_name,
                                           seed_config=context.seed_config[model_name])

        seed_logs = dbt_runner.run_dbt_seeds(seed_file_names=[seed_file_name])

        # Run comparison test between target table and expected data table
        unique_id = context.vault_structure_columns[model_name]['src_pk']

        test_yaml = dbtvault_generator.create_test_model_schema_dict(target_model_name=model_name,
                                                                     expected_output_csv=seed_file_name,
                                                                     unique_id=unique_id,
                                                                     columns_to_compare=table_headings)

        dbtvault_generator.append_dict_to_schema_yml(test_yaml)

        logs = dbt_runner.run_dbt_command(["dbt", "test"])

        assert "Completed successfully" in seed_logs
        assert "1 of 1 PASS" in logs

    else:

        table_headings = list(context.seed_config[model_name]["column_types"].keys())
        row = Row(cells=[], headings=table_headings)

        empty_table = Table(headings=table_headings, rows=row)

        expected_output_csv_name = context_utils.context_table_to_csv(table=empty_table,
                                                                      model_name=f"{model_name}_expected")

        columns_to_compare = table_headings
        unique_id = columns_to_compare[0]

        test_yaml = dbtvault_generator.create_test_model_schema_dict(target_model_name=model_name,
                                                                     expected_output_csv=expected_output_csv_name,
                                                                     unique_id=unique_id,
                                                                     columns_to_compare=columns_to_compare)

        dbtvault_generator.append_dict_to_schema_yml(test_yaml)

        dbtvault_generator.add_seed_config(seed_name=expected_output_csv_name,
                                           include_columns=columns_to_compare,
                                           seed_config=context.seed_config[model_name])

        dbt_runner.run_dbt_seeds(seed_file_names=[expected_output_csv_name])

        logs = dbt_runner.run_dbt_command(["dbt", "test"])

        assert "1 of 1 PASS" in logs
