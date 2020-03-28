import os
import subprocess
from unittest import TestCase

from definitions import TESTS_DBT_ROOT, COMPILED_TESTS_DBT_ROOT


class TestAliasMacro(TestCase):

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

        output = subprocess.check_output(command,
                                         shell=True,
                                         universal_newlines=True)

        self.assertIn('Done', output)

        with open(self.model_path / f'{model}.sql') as f:

            self.assertEqual(f.readline(), 'c.CUSTOMER_HASHDIFF AS HASHDIFF')

    def test_alias_multi(self):

        model = 'test_alias_multi'

        column = [{"source_column": "CUSTOMER_HASHDIFF", "alias": "HASHDIFF"},
                  {"source_column": "ORDER_HASHDIFF", "alias": "HASHDIFF"},
                  {"source_column": "BOOKING_HASHDIFF", "alias": "HASHDIFF"}]

        var_dict = {'column_pair': column, 'prefix': 'c'}

        command = f"dbt compile --models {model} --vars '{var_dict}'"

        output = subprocess.check_output(command,
                                         shell=True,
                                         universal_newlines=True)

        self.assertIn('Done', output)

        with open(self.model_path / f'{model}.sql') as f:

            expected_sql = 'c.CUSTOMER_HASHDIFF AS HASHDIFF, ' \
                           'c.ORDER_HASHDIFF AS HASHDIFF, ' \
                           'c.BOOKING_HASHDIFF AS HASHDIFF, '

            self.assertEqual(f.readline(), expected_sql)
