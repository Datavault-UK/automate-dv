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

    # MULTI_HASH

    def test_multi_hash_correctly_generates_hashed_columns_for_single_columns(self):

        model = 'test_multi_hash'

        var_dict = {
            'columns': {'BOOKING_PK': 'BOOKING_REF',
                        'CUSTOMER_PK': 'CUSTOMER_ID'}
        }

        process_logs = self.dbt_test.run_model(model=model, model_vars=var_dict)

        actual_sql = self.dbt_test.retrieve_compiled_model(model)

        expected_sql = """CAST(MD5_BINARY(IFNULL((UPPER(TRIM(CAST(BOOKING_REF AS VARCHAR)))), '^^')) AS """ \
                       """BINARY(16)) AS BOOKING_PK,\n""" \
                       """CAST(MD5_BINARY(IFNULL((UPPER(TRIM(CAST(CUSTOMER_ID AS VARCHAR)))), '^^')) AS """ \
                       """BINARY(16)) AS CUSTOMER_PK"""

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

        expected_sql = """CAST(MD5_BINARY(IFNULL((UPPER(TRIM(CAST(BOOKING_REF AS VARCHAR)))), '^^')) AS """ \
                       """BINARY(16)) AS BOOKING_PK,\n""" \
                       """CAST(MD5_BINARY(CONCAT(\n""" \
                       """    IFNULL(UPPER(TRIM(CAST(ADDRESS AS VARCHAR))), '^^'), '||',\n""" \
                       """    IFNULL(UPPER(TRIM(CAST(PHONE AS VARCHAR))), '^^'), '||',\n""" \
                       """    IFNULL(UPPER(TRIM(CAST(NAME AS VARCHAR))), '^^') )) AS BINARY(16)) AS CUSTOMER_DETAILS"""

        self.assertIn('Done', process_logs)

        self.assertEqual(expected_sql, actual_sql)

    def test_multi_hash_correctly_generates_sorted_hashed_columns_for_composite_columns(self):

        model = 'test_multi_hash'

        var_dict = {
            'columns': {'BOOKING_PK': 'BOOKING_REF',
                        'CUSTOMER_DETAILS': {'columns': ['ADDRESS', 'PHONE', 'NAME'],
                                             'sort': True}},

        }

        process_logs = self.dbt_test.run_model(model=model, model_vars=var_dict)

        actual_sql = self.dbt_test.retrieve_compiled_model(model)

        expected_sql = """CAST(MD5_BINARY(IFNULL((UPPER(TRIM(CAST(BOOKING_REF AS VARCHAR)))), '^^')) AS """ \
                       """BINARY(16)) AS BOOKING_PK,\n""" \
                       """CAST(MD5_BINARY(CONCAT(\n""" \
                       """    IFNULL(UPPER(TRIM(CAST(ADDRESS AS VARCHAR))), '^^'), '||',\n""" \
                       """    IFNULL(UPPER(TRIM(CAST(NAME AS VARCHAR))), '^^'), '||',\n""" \
                       """    IFNULL(UPPER(TRIM(CAST(PHONE AS VARCHAR))), '^^') )) AS BINARY(16)) AS CUSTOMER_DETAILS"""

        self.assertIn('Done', process_logs)

        self.assertEqual(expected_sql, actual_sql)

    def test_multi_hash_correctly_generates_sorted_hashed_columns_for_multiple_composite_columns(self):

        model = 'test_multi_hash'

        var_dict = {
            'columns': {'BOOKING_PK': 'BOOKING_REF',
                        'CUSTOMER_DETAILS': {'columns': ['ADDRESS', 'PHONE', 'NAME'],
                                             'sort': True},
                        'ORDER_DETAILS': {'columns': ['ORDER_DATE', 'ORDER_AMOUNT'],
                                          'sort': False}}

        }

        process_logs = self.dbt_test.run_model(model=model, model_vars=var_dict)

        actual_sql = self.dbt_test.retrieve_compiled_model(model)

        expected_sql = """CAST(MD5_BINARY(IFNULL((UPPER(TRIM(CAST(BOOKING_REF AS VARCHAR)))), '^^')) AS """ \
                       """BINARY(16)) AS BOOKING_PK,\n""" \
                       """CAST(MD5_BINARY(CONCAT(\n""" \
                       """    IFNULL(UPPER(TRIM(CAST(ADDRESS AS VARCHAR))), '^^'), '||',\n""" \
                       """    IFNULL(UPPER(TRIM(CAST(NAME AS VARCHAR))), '^^'), '||',\n""" \
                       """    IFNULL(UPPER(TRIM(CAST(PHONE AS VARCHAR))), '^^') )) AS BINARY(16)) AS CUSTOMER_DETAILS,\n""" \
                       """CAST(MD5_BINARY(CONCAT(\n""" \
                       """    IFNULL(UPPER(TRIM(CAST(ORDER_DATE AS VARCHAR))), '^^'), '||',\n""" \
                       """    IFNULL(UPPER(TRIM(CAST(ORDER_AMOUNT AS VARCHAR))), '^^') )) AS BINARY(16)) AS ORDER_DETAILS"""

        self.assertIn('Done', process_logs)

        self.assertEqual(expected_sql, actual_sql)

    def test_multi_hash_correctly_generates_unsorted_hashed_columns_for_composite_columns_mapping(self):

        model = 'test_multi_hash'

        var_dict = {
            'columns': {
                'BOOKING_PK': 'BOOKING_REF',
                'CUSTOMER_DETAILS': {
                    'columns': ['ADDRESS', 'PHONE', 'NAME']}},

        }

        process_logs = self.dbt_test.run_model(model=model, model_vars=var_dict)

        actual_sql = self.dbt_test.retrieve_compiled_model(model)

        expected_sql = """CAST(MD5_BINARY(IFNULL((UPPER(TRIM(CAST(BOOKING_REF AS VARCHAR)))), '^^')) AS """ \
                       """BINARY(16)) AS BOOKING_PK,\n""" \
                       """CAST(MD5_BINARY(CONCAT(\n""" \
                       """    IFNULL(UPPER(TRIM(CAST(ADDRESS AS VARCHAR))), '^^'), '||',\n""" \
                       """    IFNULL(UPPER(TRIM(CAST(PHONE AS VARCHAR))), '^^'), '||',\n""" \
                       """    IFNULL(UPPER(TRIM(CAST(NAME AS VARCHAR))), '^^') )) AS BINARY(16)) AS CUSTOMER_DETAILS"""

        self.assertIn('Done', process_logs)

        self.assertEqual(expected_sql, actual_sql)