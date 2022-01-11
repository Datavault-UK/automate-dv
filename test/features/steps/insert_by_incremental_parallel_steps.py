from behave import *
from multiprocessing import Process, Manager

from test import dbtvault_generator
from test import dbtvault_harness_utils

import time


@step("I load using {process_count} parallel incremental load the {model_name} {vault_structure}")
@step("I load using {process_count} parallel incremental loads the {model_name} {vault_structure}")
def load_table(context, model_name, vault_structure, process_count):
    metadata = {"source_model": context.processed_stage_name, **context.vault_structure_columns[model_name]}

    config = {"materialized": "vault_incremental_parallel"}

    config = dbtvault_generator.append_end_date_config(context, config)

    metadata = dbtvault_harness_utils.filter_metadata(context, metadata)

    context.vault_structure_metadata = metadata

    dbtvault_generator.raw_vault_structure(model_name=model_name,
                                           vault_structure=vault_structure,
                                           config=config,
                                           **metadata)

    is_full_refresh = dbtvault_harness_utils.is_full_refresh(context)

    manager = Manager()
    process_results = manager.dict()
    processes = []

    for i in range(int(process_count)):
        p = Process(target=dbtvault_harness_utils.parallel_run_dbt_models, args=(i, process_results, model_name, is_full_refresh))
        processes.append(p)
        p.start()
        time.sleep(0.1)

    for p in processes:
        p.join()

    for log in process_results.values():
        assert "Completed successfully" in log



