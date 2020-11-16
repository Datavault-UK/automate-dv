import pytest


@pytest.mark.usefixtures('dbt_test_utils', 'clean_database', 'run_seeds')
class TestLinkMacro:

    def test_link_macro_correctly_generates_sql_for_single_source(self):
        process_logs = self.dbt_test_utils.run_dbt_model(model_name=self.current_test_name, full_refresh=True)
        actual_sql = self.dbt_test_utils.retrieve_compiled_model(self.current_test_name)
        expected_sql = self.dbt_test_utils.retrieve_expected_sql(self.current_test_name)

        assert 'Done' in process_logs
        self.assertEqual(expected_sql, actual_sql)

    def test_link_macro_correctly_generates_sql_for_incremental_single_source(self):
        process_logs_first_run = self.dbt_test_utils.run_dbt_model(mode='run', model_name=self.current_test_name,
                                                                   full_refresh=True)
        process_logs_inc_run = self.dbt_test_utils.run_dbt_model(mode='run', model_name=self.current_test_name)
        actual_sql = self.dbt_test_utils.retrieve_compiled_model(self.current_test_name)
        expected_sql = self.dbt_test_utils.retrieve_expected_sql(self.current_test_name)

        assert 'Done' in process_logs_first_run
        assert 'Done' in process_logs_inc_run
        self.assertEqual(expected_sql, actual_sql)

    def test_link_macro_correctly_generates_sql_for_multi_source(self):
        process_logs = self.dbt_test_utils.run_dbt_model(model_name=self.current_test_name, full_refresh=True)
        actual_sql = self.dbt_test_utils.retrieve_compiled_model(self.current_test_name)
        expected_sql = self.dbt_test_utils.retrieve_expected_sql(self.current_test_name)

        assert 'Done' in process_logs
        self.assertEqual(expected_sql, actual_sql)

    def test_link_macro_correctly_generates_sql_for_incremental_multi_source(self):
        process_logs_first_run = self.dbt_test_utils.run_dbt_model(mode='run', model_name=self.current_test_name,
                                                                   full_refresh=True)
        process_logs_inc_run = self.dbt_test_utils.run_dbt_model(mode='run', model_name=self.current_test_name)
        actual_sql = self.dbt_test_utils.retrieve_compiled_model(self.current_test_name)
        expected_sql = self.dbt_test_utils.retrieve_expected_sql(self.current_test_name)

        assert 'Done' in process_logs_first_run
        assert 'Done' in process_logs_inc_run
        self.assertEqual(expected_sql, actual_sql)
