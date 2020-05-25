import pytest


@pytest.mark.usefixtures('dbt_test_utils', 'run_seeds')
class TestDeriveColumnsMacro:

    def test_derive_columns_correctly_generates_sql_with_source_columns(self):
        var_dict = {'source_models': 'raw_source', 'columns': {'SOURCE': "!STG_BOOKING", 'EFFECTIVE_FROM': 'LOADDATE'}}

        process_logs = self.dbt_test_utils.run_dbt_model(model=self.current_test_name, model_vars=var_dict)
        expected_sql = self.dbt_test_utils.retrieve_expected_sql(self.current_test_name)
        actual_sql = self.dbt_test_utils.retrieve_compiled_model(self.current_test_name)

        assert 'Done' in process_logs
        assert actual_sql == expected_sql

    def test_derive_columns_correctly_generates_sql_without_source_columns(self):
        var_dict = {'columns': {'SOURCE': "!STG_BOOKING", 'LOADDATE': 'EFFECTIVE_FROM'}}

        process_logs = self.dbt_test_utils.run_dbt_model(model=self.current_test_name, model_vars=var_dict)
        actual_sql = self.dbt_test_utils.retrieve_compiled_model(self.current_test_name)
        expected_sql = self.dbt_test_utils.retrieve_expected_sql(self.current_test_name)

        assert 'Done' in process_logs
        assert actual_sql == expected_sql

    def test_derive_columns_correctly_generates_sql_with_only_source_columns(self):
        var_dict = {'source_models': 'raw_source'}

        process_logs = self.dbt_test_utils.run_dbt_model(model=self.current_test_name, model_vars=var_dict)
        actual_sql = self.dbt_test_utils.retrieve_compiled_model(self.current_test_name)
        expected_sql = self.dbt_test_utils.retrieve_expected_sql(self.current_test_name)

        assert 'Done' in process_logs
        assert actual_sql == expected_sql
