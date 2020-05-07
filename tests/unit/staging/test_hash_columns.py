import os
from unittest import TestCase

from tests.unit.dbt_test_utils import *


class TestHashColumnsMacro(TestCase):

    @classmethod
    def setUpClass(cls) -> None:

        macro_type = 'staging'

        cls.dbt_test = DBTTestUtils(model_directory=f'{macro_type}/hash_columns')

        os.chdir(TESTS_DBT_ROOT)

    def setUp(self) -> None:

        self.dbt_test.clean_target()

    def test_hash_columns_correctly_generates_hashed_columns_for_single_columns(self):

        model = 'test_hash_columns'

        expected_file_name = 'test_hash_columns_correctly_generates_hashed_columns_for_single_columns'

        var_dict = {
            'columns': {'BOOKING_PK': 'BOOKING_REF',
                        'CUSTOMER_PK': 'CUSTOMER_ID'}
        }

        process_logs = self.dbt_test.run_model(model=model, model_vars=var_dict)

        actual_sql = self.dbt_test.retrieve_compiled_model(model)

        expected_sql = self.dbt_test.retrieve_expected_sql(expected_file_name)

        self.assertIn('Done', process_logs)

        self.assertEqual(expected_sql, actual_sql)

    def test_hash_columns_correctly_generates_hashed_columns_for_composite_columns(self):

        model = 'test_hash_columns'

        expected_file_name = 'test_hash_columns_correctly_generates_hashed_columns_for_composite_columns'

        var_dict = {
            'columns': {'BOOKING_PK': 'BOOKING_REF',
                        'CUSTOMER_DETAILS': ['ADDRESS', 'PHONE', 'NAME']}
        }

        process_logs = self.dbt_test.run_model(model=model, model_vars=var_dict)

        actual_sql = self.dbt_test.retrieve_compiled_model(model)

        expected_sql = self.dbt_test.retrieve_expected_sql(expected_file_name)

        self.assertIn('Done', process_logs)

        self.assertEqual(expected_sql, actual_sql)

    def test_hash_columns_correctly_generates_sorted_hashed_columns_for_composite_columns(self):

        model = 'test_hash_columns'

        expected_file_name = 'test_hash_columns_correctly_generates_sorted_hashed_columns_for_composite_columns'

        var_dict = {
            'columns': {'BOOKING_PK': 'BOOKING_REF',
                        'CUSTOMER_DETAILS': {'columns': ['ADDRESS', 'PHONE', 'NAME'],
                                             'sort': True}},

        }

        process_logs = self.dbt_test.run_model(model=model, model_vars=var_dict)

        actual_sql = self.dbt_test.retrieve_compiled_model(model)

        expected_sql = self.dbt_test.retrieve_expected_sql(expected_file_name)

        self.assertIn('Done', process_logs)

        self.assertEqual(expected_sql, actual_sql)

    def test_hash_columns_correctly_generates_sorted_hashed_columns_for_multiple_composite_columns(self):

        model = 'test_hash_columns'

        expected_file_name = 'test_hash_columns_correctly_generates_sorted_hashed_columns_for_multiple_composite_columns'

        var_dict = {
            'columns': {'BOOKING_PK': 'BOOKING_REF',
                        'CUSTOMER_DETAILS': {'columns': ['ADDRESS', 'PHONE', 'NAME'],
                                             'sort': True},
                        'ORDER_DETAILS': {'columns': ['ORDER_DATE', 'ORDER_AMOUNT'],
                                          'sort': False}}

        }

        process_logs = self.dbt_test.run_model(model=model, model_vars=var_dict)

        actual_sql = self.dbt_test.retrieve_compiled_model(model)

        expected_sql = self.dbt_test.retrieve_expected_sql(expected_file_name)

        self.assertIn('Done', process_logs)

        self.assertEqual(expected_sql, actual_sql)

    def test_hash_columns_correctly_generates_unsorted_hashed_columns_for_composite_columns_mapping(self):

        model = 'test_hash_columns'

        expected_file_name = 'test_hash_columns_correctly_generates_unsorted_hashed_columns_for_composite_columns_mapping'

        var_dict = {
            'columns': {
                'BOOKING_PK': 'BOOKING_REF',
                'CUSTOMER_DETAILS': {
                    'columns': ['ADDRESS', 'PHONE', 'NAME']}},

        }

        process_logs = self.dbt_test.run_model(model=model, model_vars=var_dict)

        actual_sql = self.dbt_test.retrieve_compiled_model(model)

        expected_sql = self.dbt_test.retrieve_expected_sql(expected_file_name)

        self.assertIn('Done', process_logs)

        self.assertEqual(expected_sql, actual_sql)

    def test_hash_columns_correctly_generates_sql_from_yaml(self):

        model = 'test_hash_columns'

        expected_file_name = 'test_hash_columns_correctly_generates_sql_from_yaml'

        process_logs = self.dbt_test.run_model(model=model)

        expected_sql = self.dbt_test.retrieve_expected_sql(expected_file_name)

        actual_sql = self.dbt_test.retrieve_compiled_model(model)

        self.assertIn('Done', process_logs)

        self.assertEqual(expected_sql, actual_sql)

    def test_hash_columns_correctly_generates_sql_with_constants_from_yaml(self):

        model = 'test_hash_columns_with_constants'

        expected_file_name = 'test_hash_columns_correctly_generates_sql_with_constants_from_yaml'

        process_logs = self.dbt_test.run_model(model=model)

        expected_sql = self.dbt_test.retrieve_expected_sql(expected_file_name)

        actual_sql = self.dbt_test.retrieve_compiled_model(model)

        self.assertIn('Done', process_logs)

        self.assertEqual(expected_sql, actual_sql)

    def test_hash_columns_raises_warning_if_mapping_without_sort(self):

        model = 'test_hash_columns_missing_sort'

        expected_file_name = 'test_hash_columns_raises_warning_if_mapping_without_sort'

        process_logs = self.dbt_test.run_model(model=model)

        expected_sql = self.dbt_test.retrieve_expected_sql(expected_file_name)

        actual_sql = self.dbt_test.retrieve_compiled_model(model)

        warning_message = "You provided a list of columns under a 'column' key, " \
                          "but did not provide the 'sort' flag. HASHDIFF columns should be sorted."

        self.assertIn(warning_message, process_logs)

        self.assertEqual(expected_sql, actual_sql)