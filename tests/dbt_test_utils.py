import glob
import logging
import os
import re
import shutil
from hashlib import md5, sha256
from pathlib import PurePath, Path
from subprocess import PIPE, Popen, STDOUT

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

    def __init__(self, model_directory=None):

        # Setup logging
        self.logger = logging.getLogger('dbt')

        logging.basicConfig(level=logging.INFO)

        if not self.logger.handlers:
            ch = logging.StreamHandler()
            ch.setLevel(logging.DEBUG)
            formatter = logging.Formatter('(%(name)s) %(levelname)s: %(message)s')
            ch.setFormatter(formatter)

            self.logger.addHandler(ch)
            self.logger.setLevel(logging.DEBUG)
            self.logger.propagate = False

        if model_directory:
            self.compiled_model_path = COMPILED_TESTS_DBT_ROOT / model_directory
            self.expected_sql_file_path = EXPECTED_OUTPUT_FILE_ROOT / model_directory
        else:

            self.logger.warning('Model directory unset.')

    def run_command(self, command) -> str:
        """
        Run a command in dbt and capture dbt logs.
            :param command: Command to run.
            :return: dbt logs
        """

        if 'dbt' not in command and isinstance(command, list):
            dbt_cmd = ['dbt']
            dbt_cmd.extend(command)
            command = dbt_cmd
        elif 'dbt' not in command and isinstance(command, str):
            command = ['dbt', command]

        p = Popen(command, stdout=PIPE, stderr=STDOUT)

        stdout, _ = p.communicate()

        p.wait()

        logs = stdout.decode('utf-8')

        self.logger.log(msg=f"Running with dbt command: {' '.join(command)}", level=logging.DEBUG)

        self.logger.log(msg=logs, level=logging.DEBUG)

        return logs

    def run_dbt_seed(self, seed_file_name=None) -> str:
        """
        Run seed files in dbt
            :return: dbt logs
        """

        command = ['dbt', 'seed', '--full-refresh']

        if seed_file_name:
            command.extend(['--select', seed_file_name])

        return self.run_command(command)

    def run_dbt_model(self, *, mode='compile', model_name: str, args=None, full_refresh=False, include_model_deps=False,
                      include_tag=False) -> str:
        """
        Run or Compile a specific dbt model, with optionally provided variables.

            :param mode: dbt command to run, 'run' or 'compile'. Defaults to compile
            :param model_name: Model name for dbt to run
            :param args: variable dictionary to provide to dbt
            :param full_refresh: Run a full refresh
            :param include_model_deps: Include model dependencies (+)
            :param include_tag: Include tag string (tag:)
            :return Log output of dbt run operation
        """

        if include_tag:
            model_name = f'tag:{model_name}'

        if include_model_deps:
            model_name = f'+{model_name}'

        if full_refresh:
            command = ['dbt', mode, '--full-refresh', '-m', model_name]
        else:
            command = ['dbt', mode, '-m', model_name]

        if args:
            yaml_str = str(args).replace('\'', '"')
            command.extend(['--vars', yaml_str])

        return self.run_command(command)

    def run_dbt_operation(self, macro_name: str, args: dict) -> str:
        """
        Run a specified macro in dbt, with the given arguments.
            :param macro_name: Name of macro/operation
            :param args: Arguments to provide
            :return: dbt logs
        """

        args = str(args).replace('\'', '')

        command = ['run-operation', f'{macro_name}', '--args', f'{args}']

        return self.run_command(command)

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
                    'active': True if 'md5' in item else False, 'pattern': "^(?:md5\(')(.*)(?:'\))", 'function': md5},
                'sha': {
                    'active'  : True if 'sha' in item else False, 'pattern': "^(?:sha\(')(.*)(?:'\))",
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

    @staticmethod
    def context_table_to_df(table: Table) -> pd.DataFrame:
        """
        Converts a context table in a feature file into a pandas DataFrame
            :param table: The context.table from a feature file
            :return: DataFrame representation of the provide context table
        """

        return pd.DataFrame(columns=table.headings, data=table.rows)

    def context_table_to_csv(self, table: Table, context: Context, model_name: str) -> str:
        """
        Converts a context table in a feature file into a dictionary
            :param table: The context.table from a feature file
            :param context: Behave context
            :param model_name: Name of the model to create
            :return: Name of csv file (minus extension)
        """

        table_df = self.context_table_to_df(table)

        table_df.apply(self.calc_hash)

        csv_fqn = CSV_DIR / f'{context.feature.name.lower()}_{model_name.lower()}.csv'

        table_df.to_csv(csv_fqn, index=False)

        self.logger.log(msg=f'Created {csv_fqn.name}', level=logging.DEBUG)

        return csv_fqn.stem

    def context_table_to_dict(self, table: Table):
        """
        Converts a context table in a feature file into a pandas DataFrame
            :param table: The context.table from a feature file
            :return: A pandas DataFrame modelled from a context table
        """

        table_df = self.context_table_to_df(table)

        table_df.apply(self.calc_hash)

        table_dict = table_df.to_dict(orient='index')

        return table_dict
