from unittest import TestCase

from tests.utils.dbt_test_utils import *


class TestPrefixMacro(TestCase):

    @classmethod
    def setUpClass(cls) -> None:

        macro_type = 'supporting'

        cls.dbt_test = DBTTestUtils(model_directory=f'{macro_type}/hash')

        os.chdir(TESTS_DBT_ROOT)

    def setUp(self) -> None:

        self.dbt_test.clean_target()

    def test_hash_single_column_is_successful(self):

        model = 'test_hash'

        expected_file_name = 'test_hash_single_column_is_successful'

        var_dict = {
            'columns': "CUSTOMER_ID",
            'alias': 'c'}

        process_logs = self.dbt_test.run_dbt_model(model=model, model_vars=var_dict)

        actual_sql = self.dbt_test.retrieve_compiled_model(model)

        expected_sql = self.dbt_test.retrieve_expected_sql(expected_file_name)

        self.assertIn('Done', process_logs)

        self.assertEqual(expected_sql, actual_sql)

    def test_hash_multi_column_with_no_sort_is_successful(self):

        model = 'test_hash'

        expected_file_name = 'test_hash_multi_column_with_no_sort_is_successful'

        var_dict = {
            'columns': ['CUSTOMER_ID', 'PHONE', 'DOB'],
            'alias': 'c'}

        process_logs = self.dbt_test.run_dbt_model(model=model, model_vars=var_dict)

        actual_sql = self.dbt_test.retrieve_compiled_model(model)

        expected_sql = self.dbt_test.retrieve_expected_sql(expected_file_name)

        self.assertIn('Done', process_logs)

        self.assertEqual(expected_sql, actual_sql)

    def test_hash_multi_column_with_sort_is_successful(self):

        model = 'test_hash_with_sort'

        expected_file_name = 'test_hash_multi_column_with_sort_is_successful'

        var_dict = {
            'columns': ['CUSTOMER_ID', 'PHONE', 'DOB'],
            'alias': 'c',
            'sort': 'true'}

        process_logs = self.dbt_test.run_dbt_model(model=model, model_vars=var_dict)

        actual_sql = self.dbt_test.retrieve_compiled_model(model)

        expected_sql = self.dbt_test.retrieve_expected_sql(expected_file_name)

        self.assertIn('Done', process_logs)

        self.assertEqual(expected_sql, actual_sql)
