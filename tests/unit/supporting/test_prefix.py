from unittest import TestCase

from tests.utils.dbt_test_utils import *


class TestPrefixMacro(TestCase):

    @classmethod
    def setUpClass(cls) -> None:
        macro_type = 'supporting'

        cls.dbt_test = DBTTestUtils(model_directory=f'{macro_type}/prefix')

        os.chdir(TESTS_DBT_ROOT)

    def setUp(self) -> None:
        self.dbt_test.clean_target()

    def test_prefix_column_in_single_item_list_is_successful(self):
        model = 'test_prefix'

        expected_file_name = 'test_prefix_column_in_single_item_list_is_successful'

        var_dict = {
            'columns': ["CUSTOMER_HASHDIFF"], 'prefix': 'c'}

        process_logs = self.dbt_test.run_dbt_model(model=model, model_vars=var_dict)

        actual_sql = self.dbt_test.retrieve_compiled_model(model)

        expected_sql = self.dbt_test.retrieve_expected_sql(expected_file_name)

        self.assertIn('Done', process_logs)

        self.assertEqual(expected_sql, actual_sql)

    def test_prefix_multiple_columns_is_successful(self):
        model = 'test_prefix'

        expected_file_name = 'test_prefix_multiple_columns_is_successful'

        var_dict = {
            'columns': ["CUSTOMER_HASHDIFF", 'CUSTOMER_PK', 'LOADDATE', 'SOURCE'], 'prefix': 'c'}

        process_logs = self.dbt_test.run_dbt_model(model=model, model_vars=var_dict)

        actual_sql = self.dbt_test.retrieve_compiled_model(model)

        expected_sql = self.dbt_test.retrieve_expected_sql(expected_file_name)

        self.assertIn('Done', process_logs)

        self.assertEqual(expected_sql, actual_sql)

    def test_prefix_aliased_column_is_successful(self):
        model = 'test_prefix'

        expected_file_name = 'test_prefix_aliased_column_is_successful'

        columns = [{"source_column": "CUSTOMER_HASHDIFF", "alias": "HASHDIFF"}, "CUSTOMER_PK", "LOADDATE"]

        var_dict = {'columns': columns, 'prefix': 'c'}

        process_logs = self.dbt_test.run_dbt_model(model=model, model_vars=var_dict)

        actual_sql = self.dbt_test.retrieve_compiled_model(model)

        expected_sql = self.dbt_test.retrieve_expected_sql(expected_file_name)

        self.assertIn('Done', process_logs)

        self.assertEqual(expected_sql, actual_sql)

    def test_prefix_aliased_column_with_alias_target_as_source_is_successful(self):
        model = 'test_prefix_alias_target'

        expected_file_name = 'test_prefix_aliased_column_with_alias_target_as_source_is_successful'

        columns = [{
            "source_column": "CUSTOMER_HASHDIFF", "alias": "HASHDIFF"}, "CUSTOMER_PK", "LOADDATE"]

        var_dict = {'columns': columns, 'prefix': 'c', 'alias_target': 'source'}

        process_logs = self.dbt_test.run_dbt_model(model=model, model_vars=var_dict)

        actual_sql = self.dbt_test.retrieve_compiled_model(model)

        expected_sql = self.dbt_test.retrieve_expected_sql(expected_file_name)

        self.assertIn('Done', process_logs)

        self.assertEqual(expected_sql, actual_sql)

    def test_prefix_aliased_column_with_alias_target_as_target_is_successful(self):
        model = 'test_prefix_alias_target'

        expected_file_name = 'test_prefix_aliased_column_with_alias_target_as_target_is_successful'

        columns = [{
            "source_column": "CUSTOMER_HASHDIFF", "alias": "HASHDIFF"}, "CUSTOMER_PK", "LOADDATE"]

        var_dict = {'columns': columns, 'prefix': 'c', 'alias_target': 'target'}

        process_logs = self.dbt_test.run_dbt_model(model=model, model_vars=var_dict)

        actual_sql = self.dbt_test.retrieve_compiled_model(model)

        expected_sql = self.dbt_test.retrieve_expected_sql(expected_file_name)

        self.assertIn('Done', process_logs)

        self.assertEqual(expected_sql, actual_sql)

    def test_prefix_with_no_columns_raises_error(self):
        model = 'test_prefix'

        var_dict = {'prefix': 'c'}

        process_logs = self.dbt_test.run_dbt_model(model=model, model_vars=var_dict)

        self.assertIn("Invalid parameters provided to prefix macro. Expected: "
                      "(columns [list/string], prefix_str [string]) got: (None, c)", process_logs)

    def test_prefix_with_empty_column_list_raises_error(self):
        model = 'test_prefix'

        var_dict = {'columns': [], 'prefix': 'c'}

        process_logs = self.dbt_test.run_dbt_model(model=model, model_vars=var_dict)

        self.assertIn("Invalid parameters provided to prefix macro. Expected: "
                      "(columns [list/string], prefix_str [string]) got: ([], c)", process_logs)
