import pytest
from unittest import TestCase


@pytest.mark.usefixtures('dbt_test_utils', 'clean_database')
class TestEscapeMacro(TestCase):
    maxDiff = None

    def test_escape_string_with_single_quotes_is_successful(self):
        var_dict = {'columns': 'COLUMN1'}
        process_logs = self.dbt_test_utils.run_dbt_model(model_name=self.current_test_name, args=var_dict)
        actual_sql = self.dbt_test_utils.retrieve_compiled_model(self.current_test_name)
        expected_sql = self.dbt_test_utils.retrieve_expected_sql(self.current_test_name)

        assert 'Done' in process_logs
        assert 'SQL compilation error' not in process_logs
        self.assertEqual(expected_sql, actual_sql)

    def test_escape_string_with_double_quotes_is_successful(self):
        var_dict = {'columns': "COLUMN1"}
        process_logs = self.dbt_test_utils.run_dbt_model(model_name=self.current_test_name, args=var_dict)
        actual_sql = self.dbt_test_utils.retrieve_compiled_model(self.current_test_name)
        expected_sql = self.dbt_test_utils.retrieve_expected_sql(self.current_test_name)

        assert 'Done' in process_logs
        assert 'SQL compilation error' not in process_logs
        self.assertEqual(expected_sql, actual_sql)

    def test_escape_single_item_list_with_single_quotes_is_successful(self):
        var_dict = {'columns': ['COLUMN1']}
        process_logs = self.dbt_test_utils.run_dbt_model(model_name=self.current_test_name, args=var_dict)
        actual_sql = self.dbt_test_utils.retrieve_compiled_model(self.current_test_name)
        expected_sql = self.dbt_test_utils.retrieve_expected_sql(self.current_test_name)

        assert 'Done' in process_logs
        assert 'SQL compilation error' not in process_logs
        self.assertEqual(expected_sql, actual_sql)

    def test_escape_single_item_list_with_double_quotes_is_successful(self):
        var_dict = {'columns': ["COLUMN1"]}
        process_logs = self.dbt_test_utils.run_dbt_model(model_name=self.current_test_name, args=var_dict)
        actual_sql = self.dbt_test_utils.retrieve_compiled_model(self.current_test_name)
        expected_sql = self.dbt_test_utils.retrieve_expected_sql(self.current_test_name)

        assert 'Done' in process_logs
        assert 'SQL compilation error' not in process_logs
        self.assertEqual(expected_sql, actual_sql)

    def test_escape_multiple_item_list_with_single_quotes_is_successful(self):
        var_dict = {'columns': ['COLUMN1', 'COLUMN_2', 'COLUMN-3', '_COLUMN4', 'COLUMN 5']}
        process_logs = self.dbt_test_utils.run_dbt_model(model_name=self.current_test_name, args=var_dict)
        actual_sql = self.dbt_test_utils.retrieve_compiled_model(self.current_test_name)
        expected_sql = self.dbt_test_utils.retrieve_expected_sql(self.current_test_name)

        assert 'Done' in process_logs
        assert 'SQL compilation error' not in process_logs
        self.assertEqual(expected_sql, actual_sql)

    def test_escape_multiple_item_list_with_double_quotes_is_successful(self):
        var_dict = {'columns': ["COLUMN1", "COLUMN_2", "COLUMN-3", "_COLUMN4", "COLUMN 5"]}
        process_logs = self.dbt_test_utils.run_dbt_model(model_name=self.current_test_name, args=var_dict)
        actual_sql = self.dbt_test_utils.retrieve_compiled_model(self.current_test_name)
        expected_sql = self.dbt_test_utils.retrieve_expected_sql(self.current_test_name)

        assert 'Done' in process_logs
        assert 'SQL compilation error' not in process_logs
        self.assertEqual(expected_sql, actual_sql)

    def test_escape_multiple_item_list_with_single_and_double_quotes_is_successful(self):
        var_dict = {'columns': ["COLUMN1", 'COLUMN_2', 'COLUMN-3', "_COLUMN4", "COLUMN 5"]}
        process_logs = self.dbt_test_utils.run_dbt_model(model_name=self.current_test_name, args=var_dict)
        actual_sql = self.dbt_test_utils.retrieve_compiled_model(self.current_test_name)
        expected_sql = self.dbt_test_utils.retrieve_expected_sql(self.current_test_name)

        assert 'Done' in process_logs
        assert 'SQL compilation error' not in process_logs
        self.assertEqual(expected_sql, actual_sql)

    def test_escape_no_column_list_raises_error(self):
        var_dict = {}

        process_logs = self.dbt_test_utils.run_dbt_model(model_name=self.current_test_name, args=var_dict)

        assert "Expected a column name or a list of column names, got: None" in process_logs

    def test_escape_empty_column_string_raises_error(self):
        var_dict = {'columns': ''}

        process_logs = self.dbt_test_utils.run_dbt_model(model_name=self.current_test_name, args=var_dict)

        assert "Expected a column name or a list of column names, got: None" in process_logs

    def test_escape_empty_column_list_raises_error(self):
        var_dict = {'columns': []}

        process_logs = self.dbt_test_utils.run_dbt_model(model_name=self.current_test_name, args=var_dict)

        assert "Expected a column name or a list of column names, got: None" in process_logs

    def test_escape_string_not_a_string_raises_error(self):
        var_dict = {'columns': 123}

        process_logs = self.dbt_test_utils.run_dbt_model(model_name=self.current_test_name, args=var_dict)

        assert "Invalid column name(s) provided. Must be a string or a list of strings." in process_logs

    def test_escape_column_list_not_strings_raises_error(self):
        var_dict = {'columns': [123, {'a': 'b'}]}

        process_logs = self.dbt_test_utils.run_dbt_model(model_name=self.current_test_name, args=var_dict)

        assert "Invalid column name(s) provided. Must be a string." in process_logs
