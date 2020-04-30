import logging
import shutil
from pathlib import PurePath, Path
from subprocess import STDOUT, PIPE, Popen

DBT_ROOT = PurePath(__file__).parent
PROJECT_ROOT = PurePath(__file__).parents[2]
TESTS_ROOT = Path(f"{PROJECT_ROOT}/tests")
TESTS_DBT_ROOT = Path(f"{PROJECT_ROOT}/tests/dbtvault_test")
COMPILED_TESTS_DBT_ROOT = Path(f"{PROJECT_ROOT}/tests/dbtvault_test/target/compiled/dbtvault_test/unit")
EXPECTED_OUTPUT_FILE_ROOT = Path(f"{PROJECT_ROOT}/tests/unit/expected_model_output")
FEATURES_ROOT = TESTS_ROOT / 'features'


class DBTTestUtils:

    def __init__(self, model_directory):

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

    def log_process_output(self, pipe_output: PIPE):
        """
        Log the output of a subprocess.

            :param pipe_output: STDOUT of a process
        """

        lines = pipe_output.readlines()

        lines = "".join(lines).splitlines()[:-1]

        for line in lines:
            self.logger.info(f"{line}")

        return lines

    def run_model(self, *, mode='compile', model: str, model_vars=None) -> str:
        """
        Run or Compile a specific dbt model, with optionally provided variables.

            :param mode: dbt command to run, 'run' or 'compile'. Defaults to compile
            :param model: Model name for dbt to run
            :param model_vars: variable dictionary to provide to dbt
            :return Log output of dbt run operation
        """
        command = f"dbt {mode} --full-refresh --models {model}"

        if model_vars:
            yaml_str = str(model_vars).replace('\'', '"')
            command = f"{command} --vars '{yaml_str}'"

        process = Popen(command,
                        shell=True,
                        universal_newlines=True,
                        stdout=PIPE,
                        stderr=STDOUT)

        process.wait()

        with process.stdout:
            output = self.log_process_output(process.stdout)

        return "\n".join(output)

    def retrieve_compiled_model(self, model: str):
        """
        Retrieve the compiled SQL for a specific dbt model

            :param model: Model name to check
            :return: Contents of compiled SQL file
        """

        with open(self.compiled_model_path / f'{model}.sql') as f:
            file = f.readlines()

            return "".join([line for line in file if '--' not in line]).strip()

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
