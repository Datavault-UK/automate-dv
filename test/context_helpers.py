import pandas as pd
from behave.model import Table

from test import dbt_file_utils
import test
from test import dbt_runner


def context_table_to_df(table: Table) -> pd.DataFrame:
    table_df = pd.DataFrame(columns=table.headings, data=table.rows)

    return table_df


def context_table_to_seed(table: Table, model_name: str) -> str:
    table_df = context_table_to_df(table)

    csv_fqn = test.TEMP_SEED_DIR / f'{model_name.lower()}.csv'

    table_df.to_csv(path_or_buf=csv_fqn, index=False)

    return csv_fqn.stem


def sample_data_to_database(context, model_name: str):
    table = context.table

    input_seed_name = context_table_to_seed(table, model_name)

    if hasattr(context, 'seed_config') and hasattr(context, 'sample_table_name'):
        dbt_file_utils.write_seed_properties(input_seed_name,
                                             context.seed_config[context.sample_table_name])
    else:
        dbt_file_utils.write_seed_properties(input_seed_name, {'column_types': {k: 'VARCHAR' for k in table.headings}})

    seeds_logs = dbt_runner.run_dbt_seeds([input_seed_name], full_refresh=True)

    assert "Completed successfully" in seeds_logs

    return input_seed_name
