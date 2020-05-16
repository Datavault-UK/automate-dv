import pytest


@pytest.mark.usefixtures('dbt_test_utils')
class TestHashMacro:

    def test_hash_single_column_is_successful(self):
        model = 'test_hash'
        expected_file_name = 'test_hash_single_column_is_successful'

        var_dict = {'columns': "CUSTOMER_ID", 'alias': 'c'}
        process_logs = self.dbt_test_utils.run_dbt_model(model=model, model_vars=var_dict)
        actual_sql = self.dbt_test_utils.retrieve_compiled_model(model)
        expected_sql = self.dbt_test_utils.retrieve_expected_sql(expected_file_name)

        assert 'Done' in process_logs
        assert expected_sql == actual_sql

    def test_hash_multi_column_with_no_sort_is_successful(self):
        model = 'test_hash'
        expected_file_name = 'test_hash_multi_column_with_no_sort_is_successful'

        var_dict = {'columns': ['CUSTOMER_ID', 'PHONE', 'DOB'], 'alias': 'c'}
        process_logs = self.dbt_test_utils.run_dbt_model(model=model, model_vars=var_dict)
        actual_sql = self.dbt_test_utils.retrieve_compiled_model(model)
        expected_sql = self.dbt_test_utils.retrieve_expected_sql(expected_file_name)

        assert 'Done' in process_logs
        assert expected_sql == actual_sql

    def test_hash_multi_column_with_sort_is_successful(self):
        model = 'test_hash_with_sort'
        expected_file_name = 'test_hash_multi_column_with_sort_is_successful'

        var_dict = {'columns': ['CUSTOMER_ID', 'PHONE', 'DOB'], 'alias': 'c', 'sort': 'true'}
        process_logs = self.dbt_test_utils.run_dbt_model(model=model, model_vars=var_dict)
        actual_sql = self.dbt_test_utils.retrieve_compiled_model(model)
        expected_sql = self.dbt_test_utils.retrieve_expected_sql(expected_file_name)

        assert 'Done' in process_logs
        assert expected_sql == actual_sql
