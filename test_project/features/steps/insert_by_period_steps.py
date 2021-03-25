from behave import *

from test_project.test_utils.dbt_test_utils import DBTVAULTGenerator

use_step_matcher("parse")

dbtvault_generator = DBTVAULTGenerator()


@step("I insert by period into the {model_name} {vault_structure} "
      "by {period} with date range: {start_date} to {stop_date}")
def load_table(context, model_name, vault_structure, period, start_date=None, stop_date=None):
    metadata = {"source_model": context.processed_stage_name,
                **context.vault_structure_columns[model_name]}

    config = {"materialized": "vault_insert_by_period",
              "target_timestamp_field": "LOAD_DATE",
              "start_date": start_date,
              "stop_date": stop_date,
              "period": period}

    config = dbtvault_generator.append_end_date_config(context, config)

    context.vault_structure_metadata = metadata

    dbtvault_generator.raw_vault_structure(model_name=model_name,
                                           vault_structure=vault_structure,
                                           config=config,
                                           **metadata)

    is_full_refresh = context.dbt_test_utils.check_full_refresh(context)

    logs = context.dbt_test_utils.run_dbt_model(mode="run", model_name=model_name,
                                                full_refresh=is_full_refresh)

    assert "Completed successfully" in logs


@step("I insert by period into the {model_name} {vault_structure} "
      "by {period} with start date: {start_date}")
def load_table(context, model_name, vault_structure, period, start_date=None):
    metadata = {"source_model": context.processed_stage_name,
                **context.vault_structure_columns[model_name]}

    config = {"materialized": "vault_insert_by_period",
              "target_timestamp_field": "LOAD_DATE",
              "start_date": start_date,
              "period": period}

    config = dbtvault_generator.append_end_date_config(context, config)

    context.vault_structure_metadata = metadata

    dbtvault_generator.raw_vault_structure(model_name=model_name,
                                           vault_structure=vault_structure,
                                           config=config,
                                           **metadata)

    is_full_refresh = context.dbt_test_utils.check_full_refresh(context)

    logs = context.dbt_test_utils.run_dbt_model(mode="run", model_name=model_name,
                                                full_refresh=is_full_refresh)

    assert "Completed successfully" in logs


@step("I insert by period into the {model_name} {vault_structure} by {period}")
def load_table(context, model_name, vault_structure, period):
    metadata = {"source_model": context.processed_stage_name,
                **context.vault_structure_columns[model_name]}

    config = {"materialized": "vault_insert_by_period",
              "target_timestamp_field": "LOAD_DATE",
              "date_source_models": context.processed_stage_name,
              "period": period}

    config = dbtvault_generator.append_end_date_config(context, config)

    context.vault_structure_metadata = metadata

    dbtvault_generator.raw_vault_structure(model_name=model_name,
                                           vault_structure=vault_structure,
                                           config=config,
                                           **metadata)

    is_full_refresh = context.dbt_test_utils.check_full_refresh(context)

    logs = context.dbt_test_utils.run_dbt_model(mode="run", model_name=model_name,
                                                full_refresh=is_full_refresh)

    assert "Completed successfully" in logs


@step("I insert by period, with a waterlevel table into the {model_name} "
      "{vault_structure} by {period}")
def load_table(context, model_name, vault_structure, period):
    stg_tables = [x for x in context.processed_stage_name if 'stg' in x.lower()]
    date_source_models_tables = [x for x in context.processed_stage_name if 'waterlevel' in x.lower()]

    metadata = {"source_model": stg_tables,
                **context.vault_structure_columns[model_name]}

    config = context.mat_config[model_name]

    config = dbtvault_generator.append_end_date_config(context, config)

    context.vault_structure_metadata = metadata

    dbtvault_generator.raw_vault_structure(model_name=model_name,
                                           vault_structure=vault_structure,
                                           config=config,
                                           depends_on=date_source_models_tables,
                                           **metadata)

    is_full_refresh = context.dbt_test_utils.check_full_refresh(context)

    logs = context.dbt_test_utils.run_dbt_model(mode="run", model_name=model_name,
                                                full_refresh=is_full_refresh)

    assert "Completed successfully" in logs
