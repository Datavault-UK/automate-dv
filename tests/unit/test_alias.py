import json
import os
import subprocess
from unittest import TestCase
import logging
from time import sleep
from definitions import TESTS_DBT_ROOT, COMPILED_TESTS_DBT_ROOT


class TestAliasMacro(TestCase):

    def log_process_output(self, pipe_output):

        lines = pipe_output.readlines()

        lines = "".join(lines).splitlines()[:-1]

        for line in lines:
            self.logger.info(f"{line}")

    @classmethod
    def setUpClass(cls) -> None:

        logging.basicConfig(level=logging.INFO)

        # Setup logging
        cls.logger = logging.getLogger('dbt')

        ch = logging.StreamHandler()
        ch.setLevel(logging.DEBUG)
        formatter = logging.Formatter('(%(name)s) %(levelname)s: %(message)s')
        ch.setFormatter(formatter)

        cls.logger.addHandler(ch)
        cls.logger.propagate = False

    @classmethod
    def setUp(cls) -> None:

        os.chdir(TESTS_DBT_ROOT)

        cls.model_path = COMPILED_TESTS_DBT_ROOT / 'alias'

        os.system('dbt clean')

    def test_alias_single(self):

        model = 'test_alias_single'

        column = {"source_column": "CUSTOMER_HASHDIFF", "alias": "HASHDIFF"}

        var_dict = {'column_pair': column, 'prefix': 'c'}

        command = f"dbt compile --models {model} --vars '{var_dict}'"

        process = subprocess.Popen(command,
                                   shell=True,
                                   universal_newlines=True,
                                   stdout=subprocess.PIPE,
                                   stderr=subprocess.STDOUT)

        exitcode = process.wait()

        with process.stdout:

            with self.assertLogs(logger=self.logger, level=logging.INFO) as cm:
                self.log_process_output(process.stdout)

                self.assertIn('Done.', cm.output[-1])

        with open(self.model_path / f'{model}.sql') as f:

            self.assertEqual(f.readline(), 'c.CUSTOMER_HASHDIFF AS HASHDIFF')

    def test_alias_multi(self):

        model = 'test_alias_multi'

        column = [{"source_column": "CUSTOMER_HASHDIFF", "alias": "HASHDIFF"},
                  {"source_column": "ORDER_HASHDIFF", "alias": "HASHDIFF"},
                  {"source_column": "BOOKING_HASHDIFF", "alias": "HASHDIFF"}]

        var_dict = json.dumps({'column_pair': column, 'prefix': 'c'})

        command = f"""dbt compile --models {model} --vars "{var_dict}" """

        process = subprocess.Popen(command,
                                   shell=True,
                                   universal_newlines=True,
                                   stdout=subprocess.PIPE,
                                   stderr=subprocess.PIPE)

        output = " ".join(process.communicate())

        self.assertIn('Done', output)

        with open(self.model_path / f'{model}.sql') as f:

            expected_sql = 'c.CUSTOMER_HASHDIFF AS HASHDIFF, ' \
                           'c.ORDER_HASHDIFF AS HASHDIFF, ' \
                           'c.BOOKING_HASHDIFF AS HASHDIFF, '

            self.assertEqual(f.readline(), expected_sql)
