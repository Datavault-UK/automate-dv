import glob
import json
import logging
import os
import re
import shutil
import sys
from hashlib import md5, sha256
from pathlib import Path
from typing import List

import pandas as pd
import pexpect
from _pytest.fixtures import FixtureRequest
from behave.model import Table
from numpy import NaN
from pandas import Series

import test
from env import env_utils


def inject_parameters(file_contents: str, parameters: dict):
    """
    Replace placeholders in a file with the provided dictionary
        :param file_contents: String containing expected file contents
        :param parameters: Dictionary of parameters {placeholder: value}
        :return: Parsed/injected file
    """

    if not parameters:
        return file_contents
    else:
        for key, val in parameters.items():
            file_contents = re.sub(rf'\[{key}]', val, file_contents, flags=re.IGNORECASE)

        remaining_placeholders = re.findall("|".join([rf'\[{key}]' for key in parameters.keys()]), file_contents)

        if remaining_placeholders:
            raise ValueError(f"Unable to replace some placeholder values: {', '.join(remaining_placeholders)}")

        return file_contents


def clean_target():
    """
    Deletes content in target folder (compiled SQL)
    Faster than running dbt clean.
    """

    shutil.rmtree(test.TEST_PROJECT_ROOT / 'target', ignore_errors=True)


def clean_seeds(model_name=None):
    """
    Deletes csv files in csv folder.
    """

    if model_name:
        delete_files = [test.TEMP_SEED_DIR / f"{model_name.lower()}.csv"]
    else:
        delete_files = []
        for (dir_path, dir_names, filenames) in os.walk(test.TEMP_SEED_DIR):
            for filename in filenames:
                if filename != ".gitkeep":
                    delete_files.append(Path(dir_path) / filename)

    for file in delete_files:
        if os.path.isfile(file):
            os.remove(file)


def clean_models(model_name=None):
    """
    Deletes models in features folder.
    """

    if model_name:
        delete_files = [test.TEST_MODELS_ROOT / f"{model_name.lower()}.sql"]
    else:
        delete_files = [file for file in glob.glob(str(test.TEST_MODELS_ROOT / '*.sql'), recursive=True)]

    for file in delete_files:
        if os.path.isfile(file):
            os.remove(file)


def create_dummy_model():
    """
    Create dummy model to avoid unused config warning
    """

    with open(test.TEST_MODELS_ROOT / 'dummy.sql', 'w') as f:
        f.write('SELECT 1')


def is_full_refresh(context):
    return getattr(context, 'full_refresh', False)


def is_successful_run(dbt_logs: str):
    return 'Done' in dbt_logs and 'SQL compilation error' not in dbt_logs


def parse_hashdiffs(columns_as_series: Series) -> Series:
    """
    Evaluate strings surrounded with hashdiff() and exclude_hashdiff() to
    augment the YAML metadata and configure hashdiff columns for staging.
        :param columns_as_series: Columns from a context.table in Series form.
        :return: Modified series
    """

    standard_pattern = r"^(?:hashdiff\(')(.*)(?:'\))"
    exclude_pattern = r"^(?:exclude_hashdiff\(')(.*)(?:'\))"

    columns = []

    for item in columns_as_series:

        if re.search(standard_pattern, item):
            raw_item = re.findall(standard_pattern, item)[0]
            split_item = str(raw_item).split(",")
            hashdiff_dict = {"is_hashdiff": True,
                             "columns": split_item}

            columns.append(hashdiff_dict)
        elif re.search(exclude_pattern, item):
            raw_item = re.findall(exclude_pattern, item)[0]
            split_item = str(raw_item).split(",")
            hashdiff_dict = {"is_hashdiff": True,
                             "exclude_columns": True,
                             "columns": split_item}

            columns.append(hashdiff_dict)
        else:
            columns.append(item)

    return Series(columns)


def parse_lists_in_dicts(dicts_with_lists: List[dict]) -> list:
    """
    Convert string representations of lists in dict values, in a list of dicts, or a dict containing list/dict values
        :param dicts_with_lists: A list of dictionaries, or a dict containing list/dict values
    """

    if isinstance(dicts_with_lists, list):

        processed_dicts = []

        check_dicts = [k for k in dicts_with_lists if isinstance(k, dict)]

        if not check_dicts:
            return dicts_with_lists
        else:

            for i, col in enumerate(dicts_with_lists):
                processed_dicts.append(dict())

                if isinstance(col, dict):
                    for k, v in col.items():

                        if {"[", "]"}.issubset(set(str(v))) and isinstance(v, str):
                            v = v.replace("[", "")
                            v = v.replace("]", "")
                            v = [k.strip() for k in v.split(",")]

                        processed_dicts[i][k] = v
                else:
                    processed_dicts[i] = {col: dicts_with_lists[i]}

            return processed_dicts

    elif isinstance(dicts_with_lists, dict):

        processed_dicts = []
        d = []

        check_dicts = [k2 for k2, v2 in dicts_with_lists.items() if isinstance(k2, int) and isinstance(v2, dict)]

        if not check_dicts:
            return dicts_with_lists
        else:

            for k1, v1 in dicts_with_lists.items():
                processed_dicts.append(dict())
                d.append(dict())

                if isinstance(v1, dict):
                    for k, v in v1.items():

                        if {"[", "]"}.issubset(set(str(v))) and isinstance(v, str):
                            v = v.replace("[", "")
                            v = v.replace("]", "")
                            v = [k.strip() for k in v.split(",")]

                        d[k1][k] = v
                else:
                    d = dicts_with_lists[k1]

                processed_dicts[k1] = {k1: d[k1]}

            return processed_dicts

    else:
        return dicts_with_lists


def process_stage_names(context, processed_stage_name):
    """
    Output a list of stage names if multiple stages are being used, or a single stage name if only one.
    """

    if hasattr(context, "processed_stage_name") and not getattr(context, 'disable_union', False):

        stage_names = context.processed_stage_name

        if isinstance(stage_names, list):
            stage_names.append(processed_stage_name)
        else:
            stage_names = [stage_names] + [processed_stage_name]

        stage_names = list(set(stage_names))

        if isinstance(stage_names, list) and len(stage_names) == 1:
            stage_names = stage_names[0]

        return stage_names

    else:
        return processed_stage_name


def filter_metadata(context, metadata: dict) -> dict:
    """
    Remove metadata indicated by fixtures
        :param context: Behave context
        :param metadata: Metadata dictionary containing macro parameters
    """

    if getattr(context, 'disable_payload', False):
        metadata = {k: v for k, v in metadata.items() if k != "src_payload"}

    return metadata


def calc_hash(columns_as_series: Series) -> Series:
    """
    Calculates the MD5 hash for a given value
        :param columns_as_series: A pandas Series of strings for the hash to be calculated on.
        In the form of "md5('1000')" or "sha('1000')"
        :return: Hash (MD5 or SHA) of values as Series (used as column)
    """

    patterns = {
        'md5': {
            'pattern': r"^(?:md5\(')(.*)(?:'\))", 'function': md5},
        'sha': {
            'pattern': r"^(?:sha\(')(.*)(?:'\))", 'function': sha256}}

    hashed_list = []

    for item in columns_as_series:

        active_hash_func = [pattern for pattern in patterns if pattern in item]
        if active_hash_func:
            active_hash_func = active_hash_func[0]
            raw_item = re.findall(patterns[active_hash_func]['pattern'], item)[0]
            hash_func = patterns[active_hash_func]['function']
            hashed_item = str(hash_func(raw_item.encode('utf-8')).hexdigest()).upper()
            hashed_list.append(hashed_item)
        else:
            hashed_list.append(item)

    return Series(hashed_list)


def run_dbt_command(command) -> str:
    """
    Run a command in dbt and capture dbt logs.
        :param command: Command to run.
        :return: dbt logs
    """

    if 'dbt' not in command and isinstance(command, list):
        command = ['dbt'] + command
    elif 'dbt' not in command and isinstance(command, str):
        command = ['dbt', command]

    joined_command = " ".join(command)

    test.logger.log(msg=f"Running on platform {str(env_utils.platform()).upper()}", level=logging.INFO)

    test.logger.log(msg=f"Running with dbt command: {joined_command}", level=logging.INFO)

    child = pexpect.spawn(command=joined_command, cwd=test.TEST_PROJECT_ROOT, encoding="utf-8", timeout=1000)
    child.logfile_read = sys.stdout
    logs = child.read()
    child.close()

    return logs


def run_dbt_seeds(seed_file_names=None, full_refresh=False) -> str:
    """
    Run seed files in dbt
        :return: dbt logs
    """

    if isinstance(seed_file_names, str):
        seed_file_names = [seed_file_names]

    command = ['dbt', 'seed']

    if seed_file_names:
        command.extend(['--select', " ".join(seed_file_names), '--full-refresh'])

    if "full-refresh" not in command and full_refresh:
        command.append('--full-refresh')

    return run_dbt_command(command)


def run_dbt_seed_model(seed_model_name=None) -> str:
    """
    Run seed model files in dbt
        :return: dbt logs
    """

    command = ['dbt', 'run']

    if seed_model_name:
        command.extend(['-m', seed_model_name, '--full-refresh'])

    return run_dbt_command(command)


def run_dbt_models(*, mode='compile', model_names: list, args=None, full_refresh=False) -> str:
    """
    Run or Compile a specific dbt model, with optionally provided variables.
        :param mode: dbt command to run, 'run' or 'compile'. Defaults to compile
        :param model_names: List of model names to run
        :param args: variable dictionary to provide to dbt
        :param full_refresh: Run a full refresh
        :return Log output of dbt run operation
    """

    model_name_string = " ".join(model_names)

    command = ['dbt', mode, '-m', model_name_string]

    if full_refresh:
        command.append('--full-refresh')

    if args:
        args = json.dumps(args)
        command.extend([f"--vars '{args}'"])

    return run_dbt_command(command)


def run_dbt_operation(macro_name: str, args=None) -> str:
    """
    Run a specified macro in dbt, with the given arguments.
        :param macro_name: Name of macro/operation
        :param args: Arguments to provide
        :return: dbt logs
    """
    command = ['run-operation', f'{macro_name}']

    if args:
        args = str(args).replace('\'', '')
        command.extend([f"--args '{args}'"])

    return run_dbt_command(command)


def replace_test_schema():
    """
    Drop and create the TEST schema
    """

    run_dbt_operation(macro_name='recreate_current_schemas')


def create_test_schemas():
    """
    Create TEST schemas
    """

    run_dbt_operation(macro_name='create_test_schemas')


def drop_test_schemas():
    """
    Drop TEST schemas
    """

    run_dbt_operation(macro_name='drop_test_schemas')


def context_table_to_df(table: Table, use_nan=True) -> pd.DataFrame:
    """
    Converts a context table in a feature file into a pandas DataFrame
        :param table: The context.table from a scenario
        :param use_nan: Replace <null> placeholder with NaN
        :return: DataFrame representation of the provided context table
    """

    table_df = pd.DataFrame(columns=table.headings, data=table.rows)

    table_df = table_df.apply(calc_hash)
    table_df = table_df.apply(parse_hashdiffs)

    if use_nan:
        table_df = table_df.replace("<null>", NaN)

    return table_df


def context_table_to_csv(table: Table, model_name: str) -> str:
    """
    Converts a context table in a feature file into CSV format
        :param table: The context.table from a scenario
        :param model_name: Name of the model to create
        :return: Name of csv file (minus extension)
    """

    table_df = context_table_to_df(table)

    csv_fqn = test.TEMP_SEED_DIR / f'{model_name.lower()}_seed.csv'

    table_df.to_csv(path_or_buf=csv_fqn, index=False)

    test.logger.log(msg=f'Created {csv_fqn.name}', level=logging.DEBUG)

    return csv_fqn.stem


def context_table_to_dicts(table: Table, orient='index', use_nan=True) -> dict:
    """
    Converts a context table in a feature file into a list of dictionaries
        :param use_nan:
        :param table: The context.table from a scenario
        :param orient: orient for df to_dict
        :return: A list containing a dictionary modelled from a context table
    """

    table_df = context_table_to_df(table, use_nan=use_nan)

    table_dict = table_df.to_dict(orient=orient)

    table_dicts = parse_lists_in_dicts(table_dict)

    return table_dicts


# TODO: Look into re-factoring and testing
# TODO: replace hard coded square brackets with a function call that mimics internal macro escape_column_name()
def context_table_to_model(seed_config: dict, table: Table, model_name: str, target_model_name: str):
    """
    Creates a model from a feature file data table
    This is ONLY for dbt-sqlserver where a model is being used as a seed to avoid implicit data type conversion issues
        :param seed_config: Configuration dict for seed file
        :param table: The context.table from a scenario or a programmatically defined table
        :param model_name: Name of the model to base the feature data table on
        :param target_model_name: Name of the model to create
        :return: Seed file name
    """

    feature_data_list = context_table_to_dicts(table=table, orient="index", use_nan=False)
    column_types = seed_config[model_name]["column_types"]

    sql_command = ""

    if len(feature_data_list) == 0:
        # Empty table
        if len(column_types) > 0:
            select_column_list = []

            for column_name in column_types.keys():
                column_type = column_types[column_name]

                if env_utils.platform() == "sqlserver" and column_type[0:6].upper() == "BINARY":
                    expression = f"CONVERT({column_type}, NULL, 2)"
                else:
                    expression = f"CAST(NULL AS {column_type})"

                select_column_list.append(f"{expression} AS [{column_name}]")

            sql_command = "SELECT " + ",".join(select_column_list) + " WHERE 1=0"

    else:
        sql_command_list = []

        for feature_data in feature_data_list:
            for row_number in feature_data.keys():
                select_column_list = []

                for column_name in feature_data[row_number].keys():
                    column_data = feature_data[row_number][column_name]
                    column_type = column_types[column_name]

                    if column_data.lower() == "<null>" or column_data == "":
                        column_data_for_sql = "NULL"
                    else:
                        column_data_for_sql = f"'{column_data}'"

                    if env_utils.platform() == "sqlserver" and column_type[0:6].upper() == "BINARY":
                        expression = f"CONVERT({column_type}, {column_data_for_sql}, 2)"
                    else:
                        expression = f"CAST({column_data_for_sql} AS {column_type})"

                    select_column_list.append(f"{expression} AS [{column_name}]")

                sql_command_list.append("SELECT " + ",".join(select_column_list))

        sql_command = "\nUNION ALL\n".join(sql_command_list)

    with open(test.TEST_MODELS_ROOT / f"{target_model_name.lower()}_seed.sql", "w") as f:
        f.write(sql_command)

    return f"{target_model_name.lower()}_seed"


def columns_from_context_table(table: Table) -> list:
    """
        Get a List of columns (headers) from a context table
        :param table: The context.table from a scenario
        :return: List of column names in the context table
    """

    table_df = context_table_to_df(table)

    table_dict = table_df.to_dict()

    return list(table_dict.keys())


def find_columns_to_ignore(table: Table):
    """
    Gets a list of columns which contain all *, which is shorthand to denote ignoring a column for comparison
        :param table: The context.table from a scenario
        :return: List of columns
    """

    df = context_table_to_df(table)

    return list(df.columns[df.isin(['*']).all()])


def retrieve_compiled_model(model_name: str, exclude_comments=True):
    """
    Retrieve the compiled SQL for a specific dbt model
        :param model_name: Model name to check
        :param exclude_comments: Exclude comments from output
        :return: Contents of compiled SQL file
    """

    with open(test.COMPILED_TESTS_DBT_ROOT / f'{model_name}.sql') as f:
        file = f.readlines()

        if exclude_comments:
            file = [line for line in file if '--' not in line]

        return "".join(file).strip()


def retrieve_expected_sql(request: FixtureRequest):
    """
    Retrieve the expected SQL for a specific dbt model
        :param request: pytest request for calling test
        :return: Contents of compiled SQL file
    """

    test_path = Path(request.fspath.strpath)
    macro_folder = test_path.parent.name
    macro_under_test = test_path.stem.split('test_')[1]
    model_name = request.node.name

    with open(test.TEST_MACRO_ROOT / macro_folder / "expected" /
              macro_under_test / env_utils.platform() / f'{model_name}.sql') as f:
        file = f.readlines()

        processed_file = inject_parameters("".join(file), env_utils.set_qualified_names_for_macro_tests())

        return processed_file


def feature_sub_types():
    return {
        'hubs': {
            'main': [
                'hubs'
            ],
            'comppk': [
                'hubs_comppk'
            ],
            'incremental': [
                'hubs_incremental'
            ],
            'pm': [
                'hubs_period_mat'
            ],
            'rank': [
                'hubs_rank_mat'
            ]
        },
        'links': {
            'main': [
                'links',
                'links_comppk'
            ],
            'incremental': [
                'links_incremental'
            ],
            'pm': [
                'links_period_mat'
            ],
            'rank': [
                'links_rank_mat'
            ]
        },
        'sats': {
            'main': [
                'sats',
            ],
            'cycles': [
                'sats_cycles'
            ],
            'incremental': [
                'sats_incremental'
            ],
            'pm': [
                'sats_period_mat_base',
                'sats_period_mat_other'
                'sats_period_mat_inferred_range',
                'sats_period_mat_provided_range',
                'sats_daily',
                'sats_monthly'
            ],
            'rank': [
                'sats_rank_mat'
            ]
        },
        'eff_sats': {
            'main': [
                'eff_sats',
                'eff_sats_multi_part'
            ],
            'auto': [
                'eff_sats_auto_end_dating_detail_base',
                'eff_sats_auto_end_dating_detail_inc',
                'eff_sats_auto_end_dating_incremental'
            ],
            'disabled': [
                'eff_sats_disabled_end_dating',
                'eff_sats_disabled_end_dating_closed_records',
                'eff_sats_disabled_end_dating_incremental'
            ],
            'mat': [
                'eff_sats_period_mat',
                'eff_sats_rank_mat'
            ]
        },
        'ma_sats': {
            '1cdk': [
                'mas_one_cdk_0_base',
                'mas_one_cdk_1_inc',
                'mas_one_cdk_base_sats'
            ],
            '1cdk_cycles': [
                'mas_one_cdk_base_sats_cycles',
                'mas_one_cdk_cycles_duplicates'
            ],
            '2cdk': [
                'mas_two_cdk_0_base',
                'mas_two_cdk_1_inc',
                'mas_two_cdk_base_sats'
            ],
            '2cdk_cycles': [
                'mas_two_cdk_base_sats_cycles',
                'mas_two_cdk_cycles_duplicates'
            ],
            'incremental': [
                'mas_one_cdk_incremental',
                'mas_two_cdk_incremental'
            ],
            'pm': [
                'mas_period_mat',
                'mas_one_cdk_period_duplicates',
                'mas_two_cdk_period_duplicates'
            ],
            'rm': [
                'mas_rank_mat',
                'mas_one_cdk_base_sats_rank_mat'
            ],
            'rm_dup': [
                'mas_one_cdk_rank_duplicates',
                'mas_two_cdk_rank_duplicates'
            ]
        },
        'xts': {
            'main': [
                'xts',
                'xts_comppk'
            ],
            'incremental': [
                'xts_incremental'
            ]
        },
        'pit': {
            'main': [
                'pit'
            ],
            '1sat_base': [
                'pit_one_sat_base',
            ],
            '1sat_inc': [
                'pit_one_sat_inc'
            ],
            '2sat': [
                'pit_two_sat_base',
                'pit_two_sat_inc'
            ]
        },
        'bridge': {
            'inc': [
                'bridge_incremental'
            ],
            '1link': [
                'bridge_one_hub_one_link'
            ],
            '2link': [
                'bridge_one_hub_two_links'
            ],
            '3link': [
                'bridge_one_hub_three_links'
            ]
        },
    }
