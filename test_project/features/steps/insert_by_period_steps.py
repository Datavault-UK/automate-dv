from behave import *

from test_project.test_utils.dbt_test_utils import DBTVAULTGenerator

use_step_matcher("parse")

dbtvault_generator = DBTVAULTGenerator()


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

    is_full_refresh = context.dbt_test_utils.check_full_refresh(context)

    logs = context.dbt_test_utils.run_dbt_model(mode="run", model_name=model_name,
                                                full_refresh=is_full_refresh)

    assert "Completed successfully" in logs
