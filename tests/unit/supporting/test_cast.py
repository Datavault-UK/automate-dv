import pytest


@pytest.mark.usefixtures('dbt_test_utils')
class TestCastMacro:

    def test_cast_single_column_as_single_is_successful(self):
        var_dict = {'columns': ["CUSTOMER_ID"]}
        process_logs = self.dbt_test_utils.run_dbt_model(model=self.current_test_name, model_vars=var_dict)
        actual_sql = self.dbt_test_utils.retrieve_compiled_model(self.current_test_name)
        expected_sql = self.dbt_test_utils.retrieve_expected_sql(self.current_test_name)

        assert 'Done' in process_logs
        assert actual_sql == expected_sql

    def test_cast_single_column_as_single_with_prefix_is_successful(self):
        var_dict = {'columns': ["CUSTOMER_ID"], 'prefix': 'c'}
        process_logs = self.dbt_test_utils.run_dbt_model(model=self.current_test_name, model_vars=var_dict)
        actual_sql = self.dbt_test_utils.retrieve_compiled_model(self.current_test_name)
        expected_sql = self.dbt_test_utils.retrieve_expected_sql(self.current_test_name)

        assert 'Done' in process_logs
        assert actual_sql == expected_sql

    def test_cast_single_column_as_triple_is_successful(self):
        var_dict = {'columns': [["CUSTOMER_ID", 'VARCHAR(16)', 'CUSTOMER_PK']]}
        process_logs = self.dbt_test_utils.run_dbt_model(model=self.current_test_name, model_vars=var_dict)
        actual_sql = self.dbt_test_utils.retrieve_compiled_model(self.current_test_name)
        expected_sql = self.dbt_test_utils.retrieve_expected_sql(self.current_test_name)

        assert 'Done' in process_logs
        assert actual_sql == expected_sql

    def test_cast_single_column_as_triple_with_prefix_is_successful(self):
        var_dict = {'columns': [["CUSTOMER_ID", 'VARCHAR(16)', 'CUSTOMER_PK']], 'prefix': 'c'}
        process_logs = self.dbt_test_utils.run_dbt_model(model=self.current_test_name, model_vars=var_dict)
        actual_sql = self.dbt_test_utils.retrieve_compiled_model(self.current_test_name)
        expected_sql = self.dbt_test_utils.retrieve_expected_sql(self.current_test_name)

        assert 'Done' in process_logs
        assert actual_sql == expected_sql

    def test_cast_multi_columns_as_triple_is_successful(self):
        var_dict = {'columns': [["CUSTOMER_ID", 'VARCHAR(16)', 'CUSTOMER_PK'],
                                ["BOOKING_ID", 'VARCHAR(16)', 'BOOKING_PK']]}
        process_logs = self.dbt_test_utils.run_dbt_model(model=self.current_test_name, model_vars=var_dict)
        actual_sql = self.dbt_test_utils.retrieve_compiled_model(self.current_test_name)
        expected_sql = self.dbt_test_utils.retrieve_expected_sql(self.current_test_name)

        assert 'Done' in process_logs
        assert actual_sql == expected_sql

    def test_cast_multi_columns_as_triple_with_prefix_is_successful(self):
        var_dict = {'columns': [["CUSTOMER_ID", 'VARCHAR(16)', 'CUSTOMER_PK'],
                                ["BOOKING_ID", 'VARCHAR(16)', 'BOOKING_PK']], 'prefix': 'c'}
        process_logs = self.dbt_test_utils.run_dbt_model(model=self.current_test_name, model_vars=var_dict)
        actual_sql = self.dbt_test_utils.retrieve_compiled_model(self.current_test_name)
        expected_sql = self.dbt_test_utils.retrieve_expected_sql(self.current_test_name)

        assert 'Done' in process_logs
        assert actual_sql == expected_sql
