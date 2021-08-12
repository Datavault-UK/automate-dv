import pytest
from unittest import TestCase


# @pytest.mark.usefixtures('dbt_test_utils', 'clean_database', 'run_seeds')
# class TestDeriveColumnsMacro(TestCase):
#     maxDiff = None
#
#     def test_derive_columns_correctly_generates_sql_with_source_columns(self):
#         var_dict = {'source_model': 'raw_source', 'columns': {'SOURCE': "!STG_BOOKING", 'EFFECTIVE_FROM': 'LOADDATE'}}
#
#         process_logs = self.dbt_test_utils.run_dbt_models(model_name=[self.current_test_name], args=var_dict)
#         expected_sql = self.dbt_test_utils.retrieve_expected_sql(self.current_test_name)
#         actual_sql = self.dbt_test_utils.retrieve_compiled_model(self.current_test_name)
#
#         assert 'Done' in process_logs
#         assert 'SQL compilation error' not in process_logs
#         self.assertEqual(expected_sql, actual_sql)
#
#     def test_derive_columns_correctly_generates_sql_without_source_columns(self):
#         var_dict = {'columns': {'SOURCE': "!STG_BOOKING", 'LOADDATE': 'EFFECTIVE_FROM'}}
#
#         process_logs = self.dbt_test_utils.run_dbt_models(model_name=[self.current_test_name], args=var_dict)
#         actual_sql = self.dbt_test_utils.retrieve_compiled_model(self.current_test_name)
#         expected_sql = self.dbt_test_utils.retrieve_expected_sql(self.current_test_name)
#
#         assert 'Done' in process_logs
#         assert 'SQL compilation error' not in process_logs
#         self.assertEqual(expected_sql, actual_sql)
#
#     def test_derive_columns_raises_error_with_only_source_columns(self):
#         var_dict = {'source_model': 'raw_source'}
#
#         process_logs = self.dbt_test_utils.run_dbt_models(model_names=[self.current_test_name],
#                                                           args=var_dict)
#
#         warning_message = "Invalid column configuration:"
#
#         assert warning_message in process_logs
