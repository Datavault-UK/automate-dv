import os
from unittest import TestCase

from tests.unit.dbt_test_utils import *


class TestMultiHashMacro(TestCase):

    @classmethod
    def setUpClass(cls) -> None:

        macro_type = 'staging'

        cls.dbt_test = DBTTestUtils(model_directory=f'{macro_type}/multi_hash')

        os.chdir(TESTS_DBT_ROOT)

    def setUp(self) -> None:

        self.dbt_test.clean_target()

    @staticmethod
    def generate_hashes_for_test(hash_dict, hash_alg, hash_size):
        """
        Generate a string containing expected SQL for the multi_hash macro
        """

        hash_string = ''

        for i, item in enumerate(hash_dict['columns'].items()):

            alias, cols = item

            if isinstance(cols, list):
                hash_string += f"CAST({hash_alg}(CONCAT("
                for k, col in enumerate(cols):
                    hash_string += f"""IFNULL(UPPER(TRIM(CAST({col} AS VARCHAR))), '^^'), '||',"""
                    if k + 1 == len(cols):
                        hash_string += f"""IFNULL(UPPER(TRIM(CAST({col} AS VARCHAR))), '^^') )) """ \
                                       f"""AS BINARY({hash_size})) AS {alias}"""
            else:

                hash_string += \
                    f"""CAST({hash_alg}(IFNULL((UPPER(TRIM(CAST({cols} AS VARCHAR)))), '^^')) AS BINARY(16)) AS {alias}"""

            if i + 1 < len(hash_dict['columns']):

                hash_string += ',\n'

        return hash_string

    # MULTI_HASH

    def test_multi_hash_correctly_generates_hashed_columns_for_single_columns(self):

        model = 'test_multi_hash'

        var_dict = {
            'columns': {'BOOKING_PK': 'BOOKING_REF',
                        'CUSTOMER_PK': 'CUSTOMER_ID'}
        }

        process_logs = self.dbt_test.run_model(model=model, model_vars=var_dict)

        actual_sql = self.dbt_test.retrieve_compiled_model(model)

        expected_sql = self.generate_hashes_for_test(var_dict, 16, 'MD5')

        self.assertIn('Done', process_logs)

        self.assertEqual(expected_sql, actual_sql)

    def test_multi_hash_correctly_generates_hashed_columns_for_composite_columns(self):

        model = 'test_multi_hash'

        var_dict = {
            'columns': {'BOOKING_PK': 'BOOKING_REF',
                        'CUSTOMER_DETAILS': ['ADDRESS', 'PHONE', 'NAME']}
        }

        process_logs = self.dbt_test.run_model(model=model, model_vars=var_dict)

        actual_sql = self.dbt_test.retrieve_compiled_model(model)

        expected_sql = self.generate_hashes_for_test(var_dict, 16, 'MD5_BINARY')

        self.assertIn('Done', process_logs)

        self.assertEqual(expected_sql, actual_sql)


