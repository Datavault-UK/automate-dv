import pytest

model = 'test_hash_check'


@pytest.mark.usefixtures('dbt_test_utils')
class TestHashCheckMacro:

    def test_hash_check_with_md5_setting(self):
        expected_file_name = 'test_hash_check_with_md5_setting'
        var_dict = {'hash': 'MD5', 'col': '^^'}

        process_logs = self.dbt_test_utils.run_dbt_model(model=model, model_vars=var_dict)
        actual_sql = self.dbt_test_utils.retrieve_compiled_model(model)
        expected_sql = self.dbt_test_utils.retrieve_expected_sql(expected_file_name)

        assert 'Done' in process_logs
        assert expected_sql == actual_sql

    def test_hash_check_with_sha_setting(self):
        expected_file_name = 'test_hash_check_with_sha_setting'
        var_dict = {'hash': 'SHA', 'col': '^^'}

        process_logs = self.dbt_test_utils.run_dbt_model(model=model, model_vars=var_dict)
        actual_sql = self.dbt_test_utils.retrieve_compiled_model(model)
        expected_sql = self.dbt_test_utils.retrieve_expected_sql(expected_file_name)

        assert 'Done' in process_logs
        assert expected_sql == actual_sql

    def test_hash_check_with_default_setting(self):
        expected_file_name = 'test_hash_check_with_default_setting'
        var_dict = {'col': '^^'}

        process_logs = self.dbt_test_utils.run_dbt_model(model=model, model_vars=var_dict)
        actual_sql = self.dbt_test_utils.retrieve_compiled_model(model)
        expected_sql = self.dbt_test_utils.retrieve_expected_sql(expected_file_name)

        assert 'Done' in process_logs
        assert expected_sql == actual_sql
