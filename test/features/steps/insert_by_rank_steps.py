from behave import *

from test import dbtvault_generator, step_helpers, dbt_runner


@step("I insert by rank into the {model_name} {vault_structure} with a {rank_column} rank column")
def rank_insert(context, model_name, vault_structure, rank_column):
    metadata = {"source_model": context.processed_stage_name,
                **context.vault_structure_columns[model_name]}

    config = {"materialized": "vault_insert_by_rank",
              "rank_column": rank_column,
              "rank_source_models": context.processed_stage_name}

    context.vault_structure_metadata = metadata

    dbtvault_generator.raw_vault_structure(model_name=model_name,
                                           vault_structure=vault_structure,
                                           config=config,
                                           **metadata)

    is_full_refresh = step_helpers.is_full_refresh(context)

    logs = dbt_runner.run_dbt_models(mode="run", model_names=[model_name],
                                     full_refresh=is_full_refresh)

    assert "Completed successfully" in logs


@step("I insert by rank into the {model_name} {vault_structure}")
def rank_insert(context, model_name, vault_structure):
    metadata = {"source_model": context.processed_stage_name,
                **context.vault_structure_columns[model_name]}

    rank_column = context.rank_column

    config = {"materialized": "vault_insert_by_rank",
              "rank_column": rank_column,
              "rank_source_models": context.processed_stage_name}

    context.vault_structure_metadata = metadata

    dbtvault_generator.raw_vault_structure(model_name=model_name,
                                           vault_structure=vault_structure,
                                           config=config,
                                           **metadata)

    is_full_refresh = step_helpers.is_full_refresh(context)

    logs = dbt_runner.run_dbt_models(mode="run", model_names=[model_name],
                                     full_refresh=is_full_refresh)

    assert "Completed successfully" in logs


@step("I have a rank column {rank_column} in the {stage_name} stage partitioned by {"
      "partition_by_column} and ordered by {order_by_column}")
def define_rank_column(context, rank_column, stage_name, partition_by_column, order_by_column):
    if hasattr(context, 'ranked_columns'):

        if not context.ranked_columns.get(stage_name, None):
            context.ranked_columns[stage_name] = dict()

        context.ranked_columns[stage_name] = (
            {**context.ranked_columns[stage_name],
                rank_column: {
                    "partition_by": partition_by_column,
                    "order_by": order_by_column
                }
            }
        )

    else:

        context.ranked_columns = {stage_name: {rank_column: {
            "partition_by": partition_by_column,
            "order_by": order_by_column
        }}}

    context.rank_column = rank_column
