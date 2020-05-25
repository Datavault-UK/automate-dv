import pytest


@pytest.mark.usefixtures('dbt_test_utils', 'run_seeds')
class TestStageMacro:

    def test_stage_correctly_generates_sql_from_yaml(self):
        process_logs = self.dbt_test_utils.run_dbt_model(model=self.current_test_name)
        actual_sql = self.dbt_test_utils.retrieve_compiled_model(self.current_test_name)
        expected_sql = self.dbt_test_utils.retrieve_expected_sql(self.current_test_name)

        assert 'Done' in process_logs
        assert actual_sql == expected_sql

    def test_stage_correctly_generates_sql_from_yaml_with_source_style(self):
        process_logs_stg = self.dbt_test_utils.run_dbt_model(mode='run', model='raw_source_table')
        process_logs = self.dbt_test_utils.run_dbt_model(mode='run', model=self.current_test_name)
        actual_sql = self.dbt_test_utils.retrieve_compiled_model(self.current_test_name)
        expected_sql = self.dbt_test_utils.retrieve_expected_sql(self.current_test_name)

        assert 'Done' in process_logs
        assert 'Done' in process_logs_stg
        assert actual_sql == expected_sql

    def test_stage_correctly_generates_sql_for_only_source_columns_from_yaml(self):
        process_logs = self.dbt_test_utils.run_dbt_model(mode='run', model=self.current_test_name)
        actual_sql = self.dbt_test_utils.retrieve_compiled_model(self.current_test_name)
        expected_sql = self.dbt_test_utils.retrieve_expected_sql(self.current_test_name)

        assert 'Done' in process_logs
        assert actual_sql == expected_sql

    def test_stage_correctly_generates_sql_for_only_source_columns_and_missing_flag_from_yaml(self):
        process_logs = self.dbt_test_utils.run_dbt_model(mode='run', model=self.current_test_name)
        actual_sql = self.dbt_test_utils.retrieve_compiled_model(self.current_test_name)
        expected_sql = self.dbt_test_utils.retrieve_expected_sql(self.current_test_name)

        assert 'Done' in process_logs
        assert actual_sql == expected_sql

    def test_stage_correctly_generates_sql_for_only_hashing_from_yaml(self):
        process_logs = self.dbt_test_utils.run_dbt_model(mode='run', model=self.current_test_name)
        actual_sql = self.dbt_test_utils.retrieve_compiled_model(self.current_test_name)
        expected_sql = self.dbt_test_utils.retrieve_expected_sql(self.current_test_name)

        assert 'Done' in process_logs
        assert actual_sql == expected_sql

    def test_stage_correctly_generates_sql_for_only_derived_from_yaml(self):
        process_logs = self.dbt_test_utils.run_dbt_model(mode='run', model=self.current_test_name)
        actual_sql = self.dbt_test_utils.retrieve_compiled_model(self.current_test_name)
        expected_sql = self.dbt_test_utils.retrieve_expected_sql(self.current_test_name)

        assert 'Done' in process_logs
        assert actual_sql == expected_sql

    def test_stage_correctly_generates_sql_for_hashing_and_source_from_yaml(self):
        process_logs = self.dbt_test_utils.run_dbt_model(mode='run', model=self.current_test_name)
        actual_sql = self.dbt_test_utils.retrieve_compiled_model(self.current_test_name)
        expected_sql = self.dbt_test_utils.retrieve_expected_sql(self.current_test_name)

        assert 'Done' in process_logs
        assert actual_sql == expected_sql

    def test_stage_raises_error_with_missing_source(self):
        process_logs = self.dbt_test_utils.run_dbt_model(mode='run', model=self.current_test_name)

        assert 'Staging error: Missing source_model configuration. ' \
               'A source model name must be provided.' in process_logs
