from behave import *

from test import automate_dv_generator, step_helpers, dbt_runner


@step("I insert by period into the {model_name} {vault_structure} "
      "by {period} with date range: {start_date} to {stop_date} and LDTS {timestamp_field}")
def load_table(context, model_name, vault_structure, period, start_date, stop_date, timestamp_field):
    metadata = {"source_model": context.processed_stage_name,
                **context.vault_structure_columns[model_name]}

    config = {"materialized": "vault_insert_by_period",
              "timestamp_field": timestamp_field,
              "start_date": start_date,
              "stop_date": stop_date,
              "period": period}

    config = automate_dv_generator.append_end_date_config(context, config)

    context.vault_structure_metadata = metadata

    automate_dv_generator.raw_vault_structure(model_name=model_name,
                                              vault_structure=vault_structure,
                                              config=config,
                                              **metadata)

    is_full_refresh = step_helpers.is_full_refresh(context)

    dbt_result, dbt_logs = dbt_runner.run_dbt_models(dbt_class=context.dbt, mode="run", model_names=[model_name],
                                                     full_refresh=is_full_refresh)

    assert dbt_result


@step("I insert by period into the {model_name} {vault_structure} by {period}")
def load_table(context, model_name, vault_structure, period):
    metadata = {"source_model": context.processed_stage_name,
                **context.vault_structure_columns[model_name]}

    config = {"materialized": "vault_insert_by_period",
              "timestamp_field": "LOAD_DATE",
              "date_source_models": context.processed_stage_name,
              "period": period}

    config = automate_dv_generator.append_end_date_config(context, config)
    config = automate_dv_generator.append_model_text_config(context, config)

    context.vault_structure_metadata = metadata

    automate_dv_generator.raw_vault_structure(model_name=model_name,
                                              vault_structure=vault_structure,
                                              config=config,
                                              **metadata)

    is_full_refresh = step_helpers.is_full_refresh(context)

    dbt_result, dbt_logs = dbt_runner.run_dbt_models(dbt_class=context.dbt, mode="run", model_names=[model_name],
                                                     full_refresh=is_full_refresh, return_logs=True)

    assert dbt_result


@step("if I insert by period into the {model_name} {vault_structure} "
      "by {period} this will fail with \"{error_message}\" error")
def load_table(context, model_name, vault_structure, period, error_message):
    metadata = {"source_model": context.processed_stage_name,
                **context.vault_structure_columns[model_name]}

    config = {"materialized": "vault_insert_by_period",
              "timestamp_field": "LOAD_DATE",
              "date_source_models": context.processed_stage_name,
              "period": period}

    config = automate_dv_generator.append_end_date_config(context, config)
    config = automate_dv_generator.append_model_text_config(context, config)

    context.vault_structure_metadata = metadata

    automate_dv_generator.raw_vault_structure(model_name=model_name,
                                              vault_structure=vault_structure,
                                              config=config,
                                              **metadata)

    is_full_refresh = step_helpers.is_full_refresh(context)

    dbt_result, dbt_logs = dbt_runner.run_dbt_models(dbt_class=context.dbt, mode="run", model_names=[model_name],
                                                     full_refresh=is_full_refresh, return_logs=True)

    assert error_message in dbt_logs


@step("I insert by period starting from {start_date} by {period} into the {model_name} {vault_structure} with LDTS {"
      "timestamp_field}")
def load_table(context, start_date, period, model_name, vault_structure, timestamp_field):
    metadata = {"source_model": context.processed_stage_name,
                **context.vault_structure_columns[model_name]}

    config = {"materialized": "vault_insert_by_period",
              "timestamp_field": timestamp_field,
              "start_date": start_date,
              "period": period}

    config = automate_dv_generator.append_end_date_config(context, config)

    context.vault_structure_metadata = metadata

    automate_dv_generator.raw_vault_structure(model_name=model_name,
                                              vault_structure=vault_structure,
                                              config=config,
                                              **metadata)

    is_full_refresh = step_helpers.is_full_refresh(context)

    dbt_result, dbt_logs = dbt_runner.run_dbt_models(dbt_class=context.dbt, mode="run", model_names=[model_name],
                                                     full_refresh=is_full_refresh)

    assert dbt_result


@step("I insert by period starting from {start_date} by {period} into the {model_name} {vault_structure}")
def load_table(context, start_date, period, model_name, vault_structure):
    metadata = {"source_model": context.processed_stage_name,
                **context.vault_structure_columns[model_name]}

    config = {"materialized": "vault_insert_by_period",
              "timestamp_field": "LOAD_DATE",
              "start_date": start_date,
              "period": period}

    config = automate_dv_generator.append_end_date_config(context, config)

    context.vault_structure_metadata = metadata

    automate_dv_generator.raw_vault_structure(model_name=model_name,
                                              vault_structure=vault_structure,
                                              config=config,
                                              **metadata)

    is_full_refresh = step_helpers.is_full_refresh(context)

    dbt_result, dbt_logs = dbt_runner.run_dbt_models(dbt_class=context.dbt, mode="run", model_names=[model_name],
                                                     full_refresh=is_full_refresh)

    assert dbt_result
