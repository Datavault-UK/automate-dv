import pytest

from harness_utils import dbtvault_harness_utils

vault_structure = "hub"


@pytest.mark.single_source_hub
def test_hub_macro_correctly_generates_sql_for_single_source(request):

    dbt_logs = dbtvault_harness_utils.run_dbt_models(model_names=[request.node.name],
                                                     full_refresh=True)
    actual_sql = dbtvault_harness_utils.retrieve_compiled_model(request.node.name)
    expected_sql = dbtvault_harness_utils.retrieve_expected_sql(request)

    assert dbtvault_harness_utils.is_successful_run(dbt_logs)
    assert expected_sql == actual_sql

# def test_hub_macro_correctly_generates_sql_for_single_source_multi_nk():
#     process_logs = dbtvault_harness_utils.run_dbt_models(model_names=[self.current_test_name], full_refresh=True)
#     actual_sql = dbtvault_harness_utils.retrieve_compiled_model(self.current_test_name)
#     expected_sql = dbtvault_harness_utils.retrieve_expected_sql(self.current_test_name)
#
#     assert 'Done' in process_logs
#     assert 'SQL compilation error' not in process_logs
#     self.assertEqual(expected_sql, actual_sql)
#
#
# def test_hub_macro_correctly_generates_sql_for_incremental_single_source():
#     process_logs_first_run = dbtvault_harness_utils.run_dbt_models(mode='run', model_names=[self.current_test_name],
#                                                                 full_refresh=True)
#     process_logs_inc_run = dbtvault_harness_utils.run_dbt_models(mode='run', model_names=[self.current_test_name])
#     actual_sql = dbtvault_harness_utils.retrieve_compiled_model(self.current_test_name)
#     expected_sql = dbtvault_harness_utils.retrieve_expected_sql(self.current_test_name)
#
#     assert 'Done' in process_logs_first_run
#     assert 'Done' in process_logs_inc_run
#     self.assertEqual(expected_sql, actual_sql)
#
#
# def test_hub_macro_correctly_generates_sql_for_incremental_single_source_multi_nk():
#     process_logs_first_run = dbtvault_harness_utils.run_dbt_models(mode='run', model_names=[self.current_test_name],
#                                                                 full_refresh=True)
#     process_logs_inc_run = dbtvault_harness_utils.run_dbt_models(mode='run', model_names=[self.current_test_name])
#     actual_sql = dbtvault_harness_utils.retrieve_compiled_model(self.current_test_name)
#     expected_sql = dbtvault_harness_utils.retrieve_expected_sql(self.current_test_name)
#
#     assert 'Done' in process_logs_first_run
#     assert 'Done' in process_logs_inc_run
#     self.assertEqual(expected_sql, actual_sql)
#
#
# def test_hub_macro_correctly_generates_sql_for_multi_source():
#     process_logs = dbtvault_harness_utils.run_dbt_models(model_names=[self.current_test_name], full_refresh=True)
#     actual_sql = dbtvault_harness_utils.retrieve_compiled_model(self.current_test_name)
#     expected_sql = dbtvault_harness_utils.retrieve_expected_sql(self.current_test_name)
#
#     assert 'Done' in process_logs
#     assert 'SQL compilation error' not in process_logs
#     self.assertEqual(expected_sql, actual_sql)
#
#
# def test_hub_macro_correctly_generates_sql_for_multi_source_multi_nk():
#     process_logs = dbtvault_harness_utils.run_dbt_models(model_names=[self.current_test_name], full_refresh=True)
#     actual_sql = dbtvault_harness_utils.retrieve_compiled_model(self.current_test_name)
#     expected_sql = dbtvault_harness_utils.retrieve_expected_sql(self.current_test_name)
#
#     assert 'Done' in process_logs
#     assert 'SQL compilation error' not in process_logs
#     self.assertEqual(expected_sql, actual_sql)
#
#
# def test_hub_macro_correctly_generates_sql_for_incremental_multi_source():
#     process_logs_first_run = dbtvault_harness_utils.run_dbt_models(mode='run', model_names=[self.current_test_name],
#                                                                 full_refresh=True)
#     process_logs_inc_run = dbtvault_harness_utils.run_dbt_models(mode='run', model_names=[self.current_test_name])
#     actual_sql = dbtvault_harness_utils.retrieve_compiled_model(self.current_test_name)
#     expected_sql = dbtvault_harness_utils.retrieve_expected_sql(self.current_test_name)
#
#     assert 'Done' in process_logs_first_run
#     assert 'Done' in process_logs_inc_run
#     self.assertEqual(expected_sql, actual_sql)
#
#
# def test_hub_macro_correctly_generates_sql_for_incremental_multi_source_multi_nk():
#     process_logs_first_run = dbtvault_harness_utils.run_dbt_models(mode='run', model_names=[self.current_test_name],
#                                                                 full_refresh=True)
#     process_logs_inc_run = dbtvault_harness_utils.run_dbt_models(mode='run', model_names=[self.current_test_name])
#     actual_sql = dbtvault_harness_utils.retrieve_compiled_model(self.current_test_name)
#     expected_sql = dbtvault_harness_utils.retrieve_expected_sql(self.current_test_name)
#
#     assert 'Done' in process_logs_first_run
#     assert 'Done' in process_logs_inc_run
#     self.assertEqual(expected_sql, actual_sql)
