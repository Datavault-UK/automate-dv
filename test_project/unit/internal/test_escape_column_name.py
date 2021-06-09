import pytest
from unittest import TestCase

# TODO: change "columns" and "var_dict" contents for each unittest
# TODO: create the associated .sql test files in '../test_project/dbtvault_test/models/unit/internal/escape_column_name'


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

#
# #########################
#     def test_escape_multiple_columns_is_successful(self):
#         var_dict = {'columns': ["CUSTOMER_HASHDIFF", 'CUSTOMER_PK', 'LOADDATE', 'SOURCE']}
#         process_logs = self.dbt_test_utils.run_dbt_model(model_name=self.current_test_name, args=var_dict)
#         actual_sql = self.dbt_test_utils.retrieve_compiled_model(self.current_test_name)
#         expected_sql = self.dbt_test_utils.retrieve_expected_sql(self.current_test_name)
#
#         assert 'Done' in process_logs
#         assert 'SQL compilation error' not in process_logs
#         self.assertEqual(expected_sql, actual_sql)
#
#     def test_escape_aliased_column_is_successful(self):
#         columns = [{"source_column": "CUSTOMER_HASHDIFF", "alias": "HASHDIFF"}, "CUSTOMER_PK", "LOADDATE"]
#         var_dict = {'columns': columns, 'prefix': 'c'}
#
#         process_logs = self.dbt_test_utils.run_dbt_model(model_name=self.current_test_name, args=var_dict)
#         actual_sql = self.dbt_test_utils.retrieve_compiled_model(self.current_test_name)
#         expected_sql = self.dbt_test_utils.retrieve_expected_sql(self.current_test_name)
#
#         assert 'Done' in process_logs
#         assert 'SQL compilation error' not in process_logs
#         self.assertEqual(expected_sql, actual_sql)
#
#     def test_escape_aliased_column_with_alias_target_as_source_is_successful(self):
#         columns = [{"source_column": "CUSTOMER_HASHDIFF", "alias": "HASHDIFF"}, "CUSTOMER_PK", "LOADDATE"]
#         var_dict = {'columns': columns}
#         process_logs = self.dbt_test_utils.run_dbt_model(model_name=self.current_test_name, args=var_dict)
#         actual_sql = self.dbt_test_utils.retrieve_compiled_model(self.current_test_name)
#         expected_sql = self.dbt_test_utils.retrieve_expected_sql(self.current_test_name)
#
#         assert 'Done' in process_logs
#         assert 'SQL compilation error' not in process_logs
#         self.assertEqual(expected_sql, actual_sql)
#
#     def test_escape_aliased_column_with_alias_target_as_target_is_successful(self):
#         columns = [{"source_column": "CUSTOMER_HASHDIFF", "alias": "HASHDIFF"}, "CUSTOMER_PK", "LOADDATE"]
#         var_dict = {'columns': columns}
#         process_logs = self.dbt_test_utils.run_dbt_model(model_name=self.current_test_name, args=var_dict)
#         actual_sql = self.dbt_test_utils.retrieve_compiled_model(self.current_test_name)
#         expected_sql = self.dbt_test_utils.retrieve_expected_sql(self.current_test_name)
#
#         assert 'Done' in process_logs
#         assert 'SQL compilation error' not in process_logs
#         self.assertEqual(expected_sql, actual_sql)
#
#     def test_escape_with_no_columns_raises_error(self):
#         var_dict = {}
#
#         process_logs = self.dbt_test_utils.run_dbt_model(model_name=self.current_test_name, args=var_dict)
#
#         assert "Invalid parameters provided to escape column name macro. Expected: " \
#                "(columns [list/string] got: None" in process_logs
#
#     def test_escape_with_empty_column_list_raises_error(self):
#         var_dict = {'columns': []}
#
#         process_logs = self.dbt_test_utils.run_dbt_model(model_name=self.current_test_name, args=var_dict)
#
#         assert "Invalid parameters provided to escape column name macro. Expected: " \
#                "(columns [list/string] got: []" in process_logs
