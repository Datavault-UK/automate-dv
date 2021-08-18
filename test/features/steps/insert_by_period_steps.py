from behave import *

import dbtvault_generator
import dbtvault_harness_utils


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

    config = dbtvault_generator.append_end_date_config(context, config)

    context.vault_structure_metadata = metadata

    dbtvault_generator.raw_vault_structure(model_name=model_name,
                                           vault_structure=vault_structure,
                                           config=config,
                                           **metadata)

    is_full_refresh = dbtvault_harness_utils.is_full_refresh(context)

    logs = dbtvault_harness_utils.run_dbt_models(mode="run", model_names=[model_name],
                                                 full_refresh=is_full_refresh)

    assert "Completed successfully" in logs


@step("I insert by period into the {model_name} {vault_structure} by {period}")
def load_table(context, model_name, vault_structure, period):
    metadata = {"source_model": context.processed_stage_name,
                **context.vault_structure_columns[model_name]}

    config = {"materialized": "vault_insert_by_period",
              "timestamp_field": "LOAD_DATE",
              "date_source_models": context.processed_stage_name,
              "period": period}

    config = dbtvault_generator.append_end_date_config(context, config)

    context.vault_structure_metadata = metadata

    dbtvault_generator.raw_vault_structure(model_name=model_name,
                                           vault_structure=vault_structure,
                                           config=config,
                                           **metadata)

    is_full_refresh = dbtvault_harness_utils.is_full_refresh(context)

    logs = dbtvault_harness_utils.run_dbt_models(mode="run", model_names=[model_name],
                                                 full_refresh=is_full_refresh)

    assert "Completed successfully" in logs
