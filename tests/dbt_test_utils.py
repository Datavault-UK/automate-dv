import logging
import os
import glob
import re
import shutil
from hashlib import md5, sha256
from pathlib import PurePath, Path
from subprocess import PIPE, Popen, run

import pandas as pd
from behave.model import Table
from behave.runner import Context
from pandas import Series

PROJECT_ROOT = PurePath(__file__).parents[1]
PROFILE_DIR = Path(f"{PROJECT_ROOT}/profiles")
TESTS_ROOT = Path(f"{PROJECT_ROOT}/tests")
TESTS_DBT_ROOT = Path(f"{PROJECT_ROOT}/tests/dbtvault_test")
COMPILED_TESTS_DBT_ROOT = Path(f"{TESTS_ROOT}/dbtvault_test/target/compiled/dbtvault_test/unit")
EXPECTED_OUTPUT_FILE_ROOT = Path(f"{TESTS_ROOT}/unit/expected_model_output")
FEATURES_ROOT = TESTS_ROOT / 'features'
CSV_DIR = TESTS_DBT_ROOT / 'data/temp'

if not os.getenv('DBT_PROFILES_DIR'):

    os.environ['DBT_PROFILES_DIR'] = str(PROFILE_DIR)


class DBTTestUtils:
    """
    Utilities for running dbt under test
    """

    def __init__(self, model_directory=''):

        self.compiled_model_path = COMPILED_TESTS_DBT_ROOT / model_directory

        self.expected_sql_file_path = EXPECTED_OUTPUT_FILE_ROOT / model_directory

        logging.basicConfig(level=logging.INFO)

        # Setup logging
        self.logger = logging.getLogger('dbt')

        if not self.logger.handlers:
            ch = logging.StreamHandler()
            ch.setLevel(logging.DEBUG)
            formatter = logging.Formatter('(%(name)s) %(levelname)s: %(message)s')
            ch.setFormatter(formatter)

            self.logger.addHandler(ch)
            self.logger.setLevel(logging.DEBUG)
            self.logger.propagate = False

    def run_dbt_command(self, command: str) -> str:
        """
        Run a dbt command using the invoke cli.
            :param command: A dbt command to run (everything after > dbt ..)
            :return: dbt logs
        """

        def escape_ansi(line):
            """
            Remove ANSI escape sequences from logs
                :param line: logs string
            """
            ansi_escape = re.compile(r'(\x9B|\x1B\[)[0-?]*[ -\/]*[@-~]')
            return ansi_escape.sub('', line)

        inv_command = ['pipenv', 'run', 'inv', 'run-dbt', '-p', 'test', '-d', f'{command}']

        logs = run(inv_command, check=True, capture_output=True)

        logs = escape_ansi(str(logs.stdout, 'utf-8'))

        self.logger.log(msg=logs, level=logging.DEBUG)

        return logs

    def run_dbt_seed(self, seed_file_name=None) -> str:
        """
        Run dbt seeds in full refresh mode
            :param seed_file_name: Name of the specific seed file to run
            :return: dbt logs
        """

        command = f'seed --full-refresh'

        if seed_file_name:
            command = f'{command} --select {seed_file_name}'

        logs = self.run_dbt_command(command)

        return logs

    def run_dbt_model(self, *, mode='compile', model: str, model_vars=None, full_refresh=False,
                      include_model_deps=False, include_tag=False) -> str:
        """
        Run or Compile a specific dbt model, with optionally provided variables.

            :param mode: dbt command to run, 'run' or 'compile'. Defaults to compile
            :param model: Model name for dbt to run
            :param model_vars: variable dictionary to provide to dbt
            :param full_refresh: Run a full refresh
            :param include_model_deps: Include model dependencies (+)
            :param include_tag: Include tag string (tag:)
            :return Log output of dbt run operation
        """

        if include_tag:
            model = f'tag:{model}'

        if include_model_deps:
            model = f'+{model}'

        if full_refresh:
            command = f"{mode} --full-refresh -m {model}"
        else:
            command = f"{mode} -m {model}"

        if model_vars:
            yaml_str = str(model_vars).replace('\'', '')
            command = f"{command} --vars {yaml_str}"

        logs = self.run_dbt_command(command)

        return logs

    def run_dbt_operation(self, op_name: str, args: dict):
        """
        Run a specified macro in dbt, with the given arguments.
            :param op_name: Name of macro/operation
            :param args: Arguments to provide
            :return: dbt logs
        """

        args = str(args).replace('\'', '')

        command = f"run-operation {op_name} --args '{args}'"

        logs = self.run_dbt_command(command)

        return logs

    def retrieve_compiled_model(self, model: str, exclude_comments=True):
        """
        Retrieve the compiled SQL for a specific dbt model

            :param model: Model name to check
            :param exclude_comments: Exclude comments from output
            :return: Contents of compiled SQL file
        """

        with open(self.compiled_model_path / f'{model}.sql') as f:
            file = f.readlines()

            if exclude_comments:
                file = [line for line in file if '--' not in line]

            return "".join(file).strip()

    def retrieve_expected_sql(self, file_name: str):
        """
        Retrieve the expected SQL for a specific dbt model

            :param file_name: File name to check
            :return: Contents of compiled SQL file
        """

        with open(self.expected_sql_file_path / f'{file_name}.sql') as f:
            file = f.readlines()

            return "".join(file)

    @staticmethod
    def clean_target():
        """
        Deletes content in target folder (compiled SQL)
        Faster than running dbt clean.
        """

        target = TESTS_DBT_ROOT / 'target'

        shutil.rmtree(target, ignore_errors=True)

    @staticmethod
    def clean_csv():
        """
        Deletes content in csv folder.
        """

        delete_files = [file for file in glob.glob(str(CSV_DIR / '*.csv'), recursive=True)]

        for file in delete_files:
            os.remove(file)

    @staticmethod
    def calc_hash(columns_as_series) -> Series:
        """
        Calculates the MD5 hash for a given value
            :param columns_as_series: A pandas Series of strings for the hash to be calculated on.
            In the form of "md5('1000')" or "sha('1000')"
            :type columns_as_series: Series
            :return:  Hash (MD5 or SHA) of values as Series (used as column)
        """

        for index, item in enumerate(columns_as_series):

            patterns = {
                'md5': {
                    'active': True if 'md5' in item else False,
                    'pattern': "^(?:md5\(')(.*)(?:'\))",
                    'function': md5},
                'sha': {
                    'active': True if 'sha' in item else False,
                    'pattern': "^(?:sha\(')(.*)(?:'\))",
                    'function': sha256}}

            active_algorithm = [patterns[sel] for sel in patterns.keys() if patterns[sel]['active']]

            if active_algorithm:
                pattern = active_algorithm[0]['pattern']
                algorithm = active_algorithm[0]['function']

                new_item = re.findall(pattern, item)

                if isinstance(new_item, list):

                    if new_item:

                        hashed_item = algorithm(new_item[0].encode('utf-8')).hexdigest()

                        columns_as_series[index] = str(hashed_item).upper()

        return columns_as_series

    def context_table_to_csv(self, table: Table, context: Context, model_name: str):
        """
        Converts a context table in a feature file into a pandas DataFrame
            :param table: The context.table from a feature file
            :param context: Behave context
            :param model_name: Name of the model to create
            :return: A pandas DataFrame modelled from a context table
        """

        table_df = pd.DataFrame(columns=table.headings, data=table.rows)

        table_df.apply(self.calc_hash)

        csv_fqn = CSV_DIR / f'{context.feature.name.lower()}_{model_name.lower()}.csv'

        table_df.to_csv(csv_fqn, index=False)

        self.logger.log(msg=f'Created {csv_fqn.name}', level=logging.DEBUG)

        return csv_fqn.stem
