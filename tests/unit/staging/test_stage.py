import pytest


@pytest.mark.usefixtures('dbt_test_utils')
class TestStageMacro:

    def test_stage_correctly_generates_sql_from_yaml(self):
        model = 'test_stage'
        expected_file_name = 'test_stage_correctly_generates_sql_from_yaml'

        process_logs = self.dbt_test_utils.run_dbt_model(model=model)
        actual_sql = self.dbt_test_utils.retrieve_compiled_model(model)
        expected_sql = self.dbt_test_utils.retrieve_expected_sql(expected_file_name)

        assert 'Done' in process_logs
        assert expected_sql == actual_sql

    def test_stage_correctly_generates_sql_from_yaml_with_source_style(self):
        model = 'test_stage_source_relation_style'
        expected_file_name = 'test_stage_correctly_generates_sql_from_yaml_with_source_style'

        self.dbt_test_utils.run_dbt_model(mode='run', model='raw_source_table')
        process_logs = self.dbt_test_utils.run_dbt_model(mode='run', model=model)
        actual_sql = self.dbt_test_utils.retrieve_compiled_model(model)
        expected_sql = self.dbt_test_utils.retrieve_expected_sql(expected_file_name)

        assert 'Done' in process_logs
        assert expected_sql == actual_sql

    def test_stage_correctly_generates_sql_for_only_source_columns_from_yaml(self):
        model = 'test_stage_source_only'
        expected_file_name = 'test_stage_correctly_generates_sql_for_only_source_columns_from_yaml'

        process_logs = self.dbt_test_utils.run_dbt_model(mode='run', model=model)
        actual_sql = self.dbt_test_utils.retrieve_compiled_model(model)
        expected_sql = self.dbt_test_utils.retrieve_expected_sql(expected_file_name)

        assert 'Done' in process_logs
        assert expected_sql == actual_sql

    def test_stage_correctly_generates_sql_for_only_hashing_from_yaml(self):
        model = 'test_stage_hashing_only'
        expected_file_name = 'test_stage_correctly_generates_sql_for_only_hashing_from_yaml'

        process_logs = self.dbt_test_utils.run_dbt_model(mode='run', model=model)
        actual_sql = self.dbt_test_utils.retrieve_compiled_model(model)
        expected_sql = self.dbt_test_utils.retrieve_expected_sql(expected_file_name)

        assert 'Done' in process_logs
        assert expected_sql == actual_sql

    def test_stage_correctly_generates_sql_for_hashing_and_source_from_yaml(self):
        model = 'test_stage_hashing_and_source'
        expected_file_name = 'test_stage_correctly_generates_sql_for_hashing_and_source_from_yaml'

        process_logs = self.dbt_test_utils.run_dbt_model(mode='run', model=model)
        actual_sql = self.dbt_test_utils.retrieve_compiled_model(model)
        expected_sql = self.dbt_test_utils.retrieve_expected_sql(expected_file_name)

        assert 'Done' in process_logs
        assert expected_sql == actual_sql

    def test_stage_raises_error_with_missing_source(self):
        model = 'test_stage_raises_error_with_missing_source'

        process_logs = self.dbt_test_utils.run_dbt_model(mode='run', model=model)

        assert 'Staging error: Missing source_model configuration. A source model name must be provided.' in process_logs
