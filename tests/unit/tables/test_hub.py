import pytest


@pytest.mark.usefixtures('dbt_test_utils')
class TestHubMacro:

    def test_hub_macro_correctly_generates_sql_for_single_source(self):
        model = 'test_hub_macro_single_source'
        expected_file_name = 'test_hub_macro_single_source'

        process_logs = self.dbt_test_utils.run_dbt_model(model=model, full_refresh=True)
        actual_sql = self.dbt_test_utils.retrieve_compiled_model(model)
        expected_sql = self.dbt_test_utils.retrieve_expected_sql(expected_file_name)

        assert 'Done' in process_logs
        assert expected_sql == actual_sql

    def test_hub_macro_correctly_generates_sql_for_incremental_single_source(self):
        model = 'test_hub_macro_single_source'
        expected_file_name = 'test_hub_macro_incremental_single_source'

        process_logs_first_run = self.dbt_test_utils.run_dbt_model(mode='run', model=model, full_refresh=True)
        process_logs_inc_run = self.dbt_test_utils.run_dbt_model(mode='run', model=model)
        actual_sql = self.dbt_test_utils.retrieve_compiled_model(model)
        expected_sql = self.dbt_test_utils.retrieve_expected_sql(expected_file_name)

        assert 'Done' in process_logs_first_run
        assert 'Done' in process_logs_inc_run
        assert expected_sql == actual_sql

    def test_hub_macro_correctly_generates_sql_for_multi_source(self):
        model = 'test_hub_macro_multi_source'
        expected_file_name = 'test_hub_macro_multi_source'

        process_logs = self.dbt_test_utils.run_dbt_model(model=model, full_refresh=True)
        actual_sql = self.dbt_test_utils.retrieve_compiled_model(model)
        expected_sql = self.dbt_test_utils.retrieve_expected_sql(expected_file_name)

        assert 'Done' in process_logs
        assert expected_sql == actual_sql

    def test_hub_macro_correctly_generates_sql_for_incremental_multi_source(self):
        model = 'test_hub_macro_multi_source'
        expected_file_name = 'test_hub_macro_incremental_multi_source'

        process_logs_first_run = self.dbt_test_utils.run_dbt_model(mode='run', model=model, full_refresh=True)
        process_logs_inc_run = self.dbt_test_utils.run_dbt_model(mode='run', model=model)
        actual_sql = self.dbt_test_utils.retrieve_compiled_model(model)
        expected_sql = self.dbt_test_utils.retrieve_expected_sql(expected_file_name)

        assert 'Done' in process_logs_first_run
        assert 'Done' in process_logs_inc_run
        assert expected_sql == actual_sql
