import logging
import os
import shutil
from pathlib import PurePath, Path
from subprocess import PIPE, Popen

DBT_ROOT = PurePath(__file__).parent
PROJECT_ROOT = PurePath(__file__).parents[2]
PROFILE_DIR = Path(f"{PROJECT_ROOT}/profiles")
TESTS_ROOT = Path(f"{PROJECT_ROOT}/tests")
TESTS_DBT_ROOT = Path(f"{PROJECT_ROOT}/tests/dbtvault_test")
COMPILED_TESTS_DBT_ROOT = Path(f"{PROJECT_ROOT}/tests/dbtvault_test/target/compiled/dbtvault_test/unit")
EXPECTED_OUTPUT_FILE_ROOT = Path(f"{PROJECT_ROOT}/tests/unit/expected_model_output")
FEATURES_ROOT = TESTS_ROOT / 'features'

if not os.getenv('DBT_PROFILES_DIR'):

    os.environ['DBT_PROFILES_DIR'] = str(PROFILE_DIR)


class DBTTestUtils:

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
            self.logger.propagate = False

    @staticmethod
    def run_dbt_seed():

        p = Popen(['dbt', 'seed', '--full-refresh'], stdout=PIPE)

        stdout, _ = p.communicate()

        p.wait()

        logs = stdout.decode('utf-8')

        return logs

    @staticmethod
    def run_dbt_model(*, mode='compile', model: str, model_vars=None, full_refresh=False, include_model_deps=False,
                      include_tag=False) -> str:
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
            command = ['dbt', mode, '--full-refresh', '-m', model]
        else:
            command = ['dbt', mode, '-m', model]

        if model_vars:
            yaml_str = str(model_vars).replace('\'', '"')
            command.extend(['--vars', yaml_str])

        p = Popen(command, stdout=PIPE)

        stdout, _ = p.communicate()

        p.wait()

        logs = stdout.decode('utf-8')

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
