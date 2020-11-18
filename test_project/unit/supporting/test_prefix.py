import pytest
from unittest import TestCase


@pytest.mark.usefixtures('dbt_test_utils', 'clean_database')
class TestPrefixMacro(TestCase):
    maxDiff = None

    def test_prefix_column_in_single_item_list_is_successful(self):
        var_dict = {'columns': ["CUSTOMER_HASHDIFF"], 'prefix': 'c'}
        process_logs = self.dbt_test_utils.run_dbt_model(model_name=self.current_test_name, args=var_dict)
        actual_sql = self.dbt_test_utils.retrieve_compiled_model(self.current_test_name)
        expected_sql = self.dbt_test_utils.retrieve_expected_sql(self.current_test_name)

        assert 'Done' in process_logs
        self.assertEqual(expected_sql, actual_sql)

    def test_prefix_multiple_columns_is_successful(self):
        var_dict = {'columns': ["CUSTOMER_HASHDIFF", 'CUSTOMER_PK', 'LOADDATE', 'SOURCE'], 'prefix': 'c'}
        process_logs = self.dbt_test_utils.run_dbt_model(model_name=self.current_test_name, args=var_dict)
        actual_sql = self.dbt_test_utils.retrieve_compiled_model(self.current_test_name)
        expected_sql = self.dbt_test_utils.retrieve_expected_sql(self.current_test_name)

        assert 'Done' in process_logs
        self.assertEqual(expected_sql, actual_sql)

    def test_prefix_aliased_column_is_successful(self):
        columns = [{"source_column": "CUSTOMER_HASHDIFF", "alias": "HASHDIFF"}, "CUSTOMER_PK", "LOADDATE"]
        var_dict = {'columns': columns, 'prefix': 'c'}

        process_logs = self.dbt_test_utils.run_dbt_model(model_name=self.current_test_name, args=var_dict)
        actual_sql = self.dbt_test_utils.retrieve_compiled_model(self.current_test_name)
        expected_sql = self.dbt_test_utils.retrieve_expected_sql(self.current_test_name)

        assert 'Done' in process_logs
        self.assertEqual(expected_sql, actual_sql)

    def test_prefix_aliased_column_with_alias_target_as_source_is_successful(self):
        columns = [{"source_column": "CUSTOMER_HASHDIFF", "alias": "HASHDIFF"}, "CUSTOMER_PK", "LOADDATE"]
        var_dict = {'columns': columns, 'prefix': 'c', 'alias_target': 'source'}
        process_logs = self.dbt_test_utils.run_dbt_model(model_name=self.current_test_name, args=var_dict)
        actual_sql = self.dbt_test_utils.retrieve_compiled_model(self.current_test_name)
        expected_sql = self.dbt_test_utils.retrieve_expected_sql(self.current_test_name)

        assert 'Done' in process_logs
        self.assertEqual(expected_sql, actual_sql)

    def test_prefix_aliased_column_with_alias_target_as_target_is_successful(self):
        columns = [{"source_column": "CUSTOMER_HASHDIFF", "alias": "HASHDIFF"}, "CUSTOMER_PK", "LOADDATE"]
        var_dict = {'columns': columns, 'prefix': 'c', 'alias_target': 'target'}
        process_logs = self.dbt_test_utils.run_dbt_model(model_name=self.current_test_name, args=var_dict)
        actual_sql = self.dbt_test_utils.retrieve_compiled_model(self.current_test_name)
        expected_sql = self.dbt_test_utils.retrieve_expected_sql(self.current_test_name)

        assert 'Done' in process_logs
        self.assertEqual(expected_sql, actual_sql)

    def test_prefix_with_no_columns_raises_error(self):
        var_dict = {'prefix': 'c'}

        process_logs = self.dbt_test_utils.run_dbt_model(model_name=self.current_test_name, args=var_dict)

        assert "Invalid parameters provided to prefix macro. Expected: " \
               "(columns [list/string], prefix_str [string]) got: (None, c)" in process_logs

    def test_prefix_with_empty_column_list_raises_error(self):
        var_dict = {'columns': [], 'prefix': 'c'}

        process_logs = self.dbt_test_utils.run_dbt_model(model_name=self.current_test_name, args=var_dict)

        assert "Invalid parameters provided to prefix macro. Expected: " \
               "(columns [list/string], prefix_str [string]) got: ([], c)" in process_logs
