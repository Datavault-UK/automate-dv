import logging
import os
from subprocess import STDOUT, PIPE, Popen

from definitions import TESTS_DBT_ROOT, COMPILED_TESTS_DBT_ROOT


class DBTTestUtils:

    def __init__(self):

        self.compiled_model_path = COMPILED_TESTS_DBT_ROOT / 'alias'

        logging.basicConfig(level=logging.INFO)

        # Setup logging
        self.logger = logging.getLogger('dbt')

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

    def run_model(self, *, model: str, model_vars=None) -> str:
        """
        Run a specific dbt model, with optionally provided variables.

            :param model: Model name for dbt to run
            :param model_vars: variable dictionary to provide to dbt
            :return Log output of dbt run operation
        """
        command = f"dbt compile --models {model}"

        if model_vars:
            command = f"{command} --vars '{model_vars}'"

        process = Popen(command,
                        shell=True,
                        universal_newlines=True,
                        stdout=PIPE,
                        stderr=STDOUT)

        process.wait()

        with process.stdout:
            output = self.log_process_output(process.stdout)

        return "\n".join(output)

    def clean_target(self):
        """
        Run dbt clean.
        """

        os.chdir(TESTS_DBT_ROOT)

        self.compiled_model_path = COMPILED_TESTS_DBT_ROOT / 'alias'

        os.system('dbt clean')

    def retrieve_compiled_model(self, model: str):
        """
        Retrieve the compiled SQL for a specific dbt model

            :param model: Model name to check
            :return: Contents of compiled SQL file
        """

        with open(self.compiled_model_path / f'{model}.sql') as f:
            return f.readline()
