import pytest


@pytest.mark.usefixtures('dbt_test_utils')
class TestHashMacro:

    def test_hash_single_column_is_successful(self):
        var_dict = {'columns': "CUSTOMER_ID", 'alias': 'CUSTOMER_PK'}
        process_logs = self.dbt_test_utils.run_dbt_model(model=self.current_test_name, model_vars=var_dict)
        actual_sql = self.dbt_test_utils.retrieve_compiled_model(self.current_test_name)
        expected_sql = self.dbt_test_utils.retrieve_expected_sql(self.current_test_name)

        assert 'Done' in process_logs
        assert actual_sql == expected_sql

    def test_hash_single_item_list_column_for_pk_is_successful(self):
        var_dict = {'columns': ["CUSTOMER_ID"], 'alias': 'CUSTOMER_PK'}
        process_logs = self.dbt_test_utils.run_dbt_model(model=self.current_test_name, model_vars=var_dict)
        actual_sql = self.dbt_test_utils.retrieve_compiled_model(self.current_test_name)
        expected_sql = self.dbt_test_utils.retrieve_expected_sql(self.current_test_name)

        assert 'Done' in process_logs
        assert actual_sql == expected_sql

    def test_hash_single_item_list_column_for_hashdiff_is_successful(self):
        var_dict = {'columns': ["CUSTOMER_ID"], 'alias': 'HASHDIFF', 'hashdiff': 'true'}
        process_logs = self.dbt_test_utils.run_dbt_model(model=self.current_test_name, model_vars=var_dict)
        actual_sql = self.dbt_test_utils.retrieve_compiled_model(self.current_test_name)
        expected_sql = self.dbt_test_utils.retrieve_expected_sql(self.current_test_name)

        assert 'Done' in process_logs
        assert actual_sql == expected_sql

    def test_hash_multi_column_as_pk_is_successful(self):
        var_dict = {'columns': ['CUSTOMER_ID', 'PHONE', 'DOB'], 'alias': 'CUSTOMER_PK'}
        process_logs = self.dbt_test_utils.run_dbt_model(model=self.current_test_name, model_vars=var_dict)
        actual_sql = self.dbt_test_utils.retrieve_compiled_model(self.current_test_name)
        expected_sql = self.dbt_test_utils.retrieve_expected_sql(self.current_test_name)

        assert 'Done' in process_logs
        assert actual_sql == expected_sql

    def test_hash_multi_column_as_hashdiff_is_successful(self):
        var_dict = {'columns': ['CUSTOMER_ID', 'PHONE', 'DOB'], 'alias': 'HASHDIFF', 'hashdiff': 'true'}
        process_logs = self.dbt_test_utils.run_dbt_model(model=self.current_test_name, model_vars=var_dict)
        actual_sql = self.dbt_test_utils.retrieve_compiled_model(self.current_test_name)
        expected_sql = self.dbt_test_utils.retrieve_expected_sql(self.current_test_name)

        assert 'Done' in process_logs
        assert actual_sql == expected_sql
