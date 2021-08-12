import pytest
from unittest import TestCase

#
# @pytest.mark.usefixtures('dbt_test_utils', 'clean_database', 'run_seeds')
# class TestStageMacro(TestCase):
#     maxDiff = None
#
#     def test_stage_correctly_generates_sql_from_yaml(self):
#         process_logs = self.dbt_test_utils.run_dbt_models(model_names=[self.current_test_name])
#         actual_sql = self.dbt_test_utils.retrieve_compiled_model(self.current_test_name)
#         expected_sql = self.dbt_test_utils.retrieve_expected_sql(self.current_test_name)
#
#         assert 'Done' in process_logs
#         assert 'SQL compilation error' not in process_logs
#
#         self.assertEqual(expected_sql, actual_sql)
#
#     def test_stage_correctly_generates_sql_from_yaml_with_ranked(self):
#         process_logs = self.dbt_test_utils.run_dbt_models(model_names=[self.current_test_name])
#         actual_sql = self.dbt_test_utils.retrieve_compiled_model(self.current_test_name)
#         expected_sql = self.dbt_test_utils.retrieve_expected_sql(self.current_test_name)
#
#         assert 'Done' in process_logs
#         assert 'SQL compilation error' not in process_logs
#
#         self.assertEqual(expected_sql, actual_sql)
#
#     def test_stage_correctly_generates_sql_from_yaml_with_composite_pk(self):
#         process_logs = self.dbt_test_utils.run_dbt_models(model_names=[self.current_test_name])
#         actual_sql = self.dbt_test_utils.retrieve_compiled_model(self.current_test_name)
#         expected_sql = self.dbt_test_utils.retrieve_expected_sql(self.current_test_name)
#
#         assert 'Done' in process_logs
#         assert 'SQL compilation error' not in process_logs
#
#         self.assertEqual(expected_sql, actual_sql)
#
#     def test_stage_correctly_generates_sql_from_yaml_with_source_style(self):
#         process_logs_stg = self.dbt_test_utils.run_dbt_models(mode='run', model_names=['raw_source_table'])
#         process_logs = self.dbt_test_utils.run_dbt_models(mode='run', model_names=[self.current_test_name])
#         actual_sql = self.dbt_test_utils.retrieve_compiled_model(self.current_test_name)
#         expected_sql = self.dbt_test_utils.retrieve_expected_sql(self.current_test_name)
#
#         assert 'Done' in process_logs
#         assert 'SQL compilation error' not in process_logs
#
#         self.assertEqual(expected_sql, actual_sql)
#
#     def test_stage_correctly_generates_sql_for_only_source_columns_from_yaml(self):
#         process_logs = self.dbt_test_utils.run_dbt_models(mode='run', model_names=[self.current_test_name])
#         actual_sql = self.dbt_test_utils.retrieve_compiled_model(self.current_test_name)
#         expected_sql = self.dbt_test_utils.retrieve_expected_sql(self.current_test_name)
#
#         assert 'Done' in process_logs
#         assert 'SQL compilation error' not in process_logs
#
#         self.assertEqual(expected_sql, actual_sql)
#
#     def test_stage_correctly_generates_sql_for_only_source_columns_and_missing_flag_from_yaml(self):
#         process_logs = self.dbt_test_utils.run_dbt_models(mode='run', model_names=[self.current_test_name])
#         actual_sql = self.dbt_test_utils.retrieve_compiled_model(self.current_test_name)
#         expected_sql = self.dbt_test_utils.retrieve_expected_sql(self.current_test_name)
#
#         assert 'Done' in process_logs
#         assert 'SQL compilation error' not in process_logs
#
#         self.assertEqual(expected_sql, actual_sql)
#
#     def test_stage_correctly_generates_sql_for_only_hashing_from_yaml(self):
#         process_logs = self.dbt_test_utils.run_dbt_models(mode='run', model_names=[self.current_test_name])
#         actual_sql = self.dbt_test_utils.retrieve_compiled_model(self.current_test_name)
#         expected_sql = self.dbt_test_utils.retrieve_expected_sql(self.current_test_name)
#
#         assert 'Done' in process_logs
#         assert 'SQL compilation error' not in process_logs
#
#         self.assertEqual(expected_sql, actual_sql)
#
#     def test_stage_correctly_generates_sql_for_only_derived_from_yaml(self):
#         process_logs = self.dbt_test_utils.run_dbt_models(mode='run', model_names=[self.current_test_name])
#         actual_sql = self.dbt_test_utils.retrieve_compiled_model(self.current_test_name)
#         expected_sql = self.dbt_test_utils.retrieve_expected_sql(self.current_test_name)
#
#         assert 'Done' in process_logs
#         assert 'SQL compilation error' not in process_logs
#
#         self.assertEqual(expected_sql, actual_sql)
#
#     def test_stage_correctly_generates_sql_for_only_ranked_from_yaml(self):
#         process_logs = self.dbt_test_utils.run_dbt_models(mode='run', model_names=[self.current_test_name])
#         actual_sql = self.dbt_test_utils.retrieve_compiled_model(self.current_test_name)
#         expected_sql = self.dbt_test_utils.retrieve_expected_sql(self.current_test_name)
#
#         assert 'Done' in process_logs
#         assert 'SQL compilation error' not in process_logs
#
#         self.assertEqual(expected_sql, actual_sql)
#
#     def test_stage_correctly_generates_sql_for_hashing_and_source_from_yaml(self):
#         process_logs = self.dbt_test_utils.run_dbt_models(mode='run', model_names=[self.current_test_name])
#         actual_sql = self.dbt_test_utils.retrieve_compiled_model(self.current_test_name)
#         expected_sql = self.dbt_test_utils.retrieve_expected_sql(self.current_test_name)
#
#         assert 'Done' in process_logs
#         assert 'SQL compilation error' not in process_logs
#
#         self.assertEqual(expected_sql, actual_sql)
#
#     def test_stage_correctly_generates_sql_for_hashing_and_source_from_yaml_for_single_hash(self):
#         process_logs = self.dbt_test_utils.run_dbt_models(mode='run', model_names=[self.current_test_name])
#         actual_sql = self.dbt_test_utils.retrieve_compiled_model(self.current_test_name)
#         expected_sql = self.dbt_test_utils.retrieve_expected_sql(self.current_test_name)
#
#         assert 'Done' in process_logs
#         assert 'SQL compilation error' not in process_logs
#
#         self.assertEqual(expected_sql, actual_sql)
#
#     def test_stage_correctly_generates_sql_for_hashing_and_source_from_yaml_for_single_hash_and_include(self):
#         process_logs = self.dbt_test_utils.run_dbt_models(mode='run', model_names=[self.current_test_name])
#         actual_sql = self.dbt_test_utils.retrieve_compiled_model(self.current_test_name)
#         expected_sql = self.dbt_test_utils.retrieve_expected_sql(self.current_test_name)
#
#         assert 'Done' in process_logs
#         assert 'SQL compilation error' not in process_logs
#
#         self.assertEqual(expected_sql, actual_sql)
#
#     def test_stage_correctly_generates_sql_for_hashing_and_source_from_yaml_for_multi_hash_and_include(self):
#         process_logs = self.dbt_test_utils.run_dbt_models(mode='run', model_names=[self.current_test_name])
#         actual_sql = self.dbt_test_utils.retrieve_compiled_model(self.current_test_name)
#         expected_sql = self.dbt_test_utils.retrieve_expected_sql(self.current_test_name)
#
#         assert 'Done' in process_logs
#         assert 'SQL compilation error' not in process_logs
#
#         self.assertEqual(expected_sql, actual_sql)
#
#     def test_stage_correctly_generates_sql_for_hashing_and_derived_from_yaml(self):
#         process_logs = self.dbt_test_utils.run_dbt_models(mode='run', model_names=[self.current_test_name])
#         actual_sql = self.dbt_test_utils.retrieve_compiled_model(self.current_test_name)
#         expected_sql = self.dbt_test_utils.retrieve_expected_sql(self.current_test_name)
#
#         assert 'Done' in process_logs
#         assert 'SQL compilation error' not in process_logs
#
#         self.assertEqual(expected_sql, actual_sql)
#
#     def test_stage_correctly_generates_sql_for_derived_and_source_from_yaml(self):
#         process_logs = self.dbt_test_utils.run_dbt_models(mode='run', model_names=[self.current_test_name])
#         actual_sql = self.dbt_test_utils.retrieve_compiled_model(self.current_test_name)
#         expected_sql = self.dbt_test_utils.retrieve_expected_sql(self.current_test_name)
#
#         assert 'Done' in process_logs
#         assert 'SQL compilation error' not in process_logs
#
#         self.assertEqual(expected_sql, actual_sql)
#
#     def test_stage_correctly_generates_sql_for_hashing_with_exclude_flag(self):
#         process_logs = self.dbt_test_utils.run_dbt_models(mode='run', model_names=[self.current_test_name])
#         actual_sql = self.dbt_test_utils.retrieve_compiled_model(self.current_test_name)
#         expected_sql = self.dbt_test_utils.retrieve_expected_sql(self.current_test_name)
#
#         assert 'Done' in process_logs
#         assert 'SQL compilation error' not in process_logs
#
#         self.assertEqual(expected_sql, actual_sql)
#
#     def test_stage_correctly_generates_sql_for_hashing_with_exclude_flag_no_columns(self):
#         process_logs = self.dbt_test_utils.run_dbt_models(mode='run', model_names=[self.current_test_name])
#         actual_sql = self.dbt_test_utils.retrieve_compiled_model(self.current_test_name)
#         expected_sql = self.dbt_test_utils.retrieve_expected_sql(self.current_test_name)
#
#         assert 'Done' in process_logs
#         assert 'SQL compilation error' not in process_logs
#
#         self.assertEqual(expected_sql, actual_sql)
#
#     def test_stage_correctly_generates_sql_for_only_hashing_with_exclude_flag(self):
#         process_logs = self.dbt_test_utils.run_dbt_models(mode='run', model_names=[self.current_test_name])
#         actual_sql = self.dbt_test_utils.retrieve_compiled_model(self.current_test_name)
#         expected_sql = self.dbt_test_utils.retrieve_expected_sql(self.current_test_name)
#
#         assert 'Done' in process_logs
#         assert 'SQL compilation error' not in process_logs
#
#         self.assertEqual(expected_sql, actual_sql)
#
#     def test_stage_correctly_generates_sql_for_only_source_and_hashing_with_exclude_flag(self):
#         process_logs = self.dbt_test_utils.run_dbt_models(mode='run', model_names=[self.current_test_name])
#         actual_sql = self.dbt_test_utils.retrieve_compiled_model(self.current_test_name)
#         expected_sql = self.dbt_test_utils.retrieve_expected_sql(self.current_test_name)
#
#         assert 'Done' in process_logs
#         assert 'SQL compilation error' not in process_logs
#
#         self.assertEqual(expected_sql, actual_sql)
#
#     def test_stage_raises_error_with_missing_source(self):
#         process_logs = self.dbt_test_utils.run_dbt_models(mode='run', model_names=[self.current_test_name])
#
#         assert 'Staging error: Missing source_model configuration. ' \
#                'A source model name must be provided.' in process_logs
