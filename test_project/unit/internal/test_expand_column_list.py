import pytest
from unittest import TestCase


@pytest.mark.usefixtures('dbt_test_utils', 'clean_database')
class TestExpandColumnListMacro(TestCase):
    maxDiff = None

    def test_expand_column_list_correctly_generates_list_with_nesting(self):
        var_dict = {'columns': ['CUSTOMER_PK', ['ORDER_FK', 'BOOKING_FK']]}

        process_logs = self.dbt_test_utils.run_dbt_model(model_name=self.current_test_name, args=var_dict)
        actual_sql = self.dbt_test_utils.retrieve_compiled_model(self.current_test_name)
        expected_sql = self.dbt_test_utils.retrieve_expected_sql(self.current_test_name)

        assert 'Done' in process_logs
        assert 'error' not in process_logs
        self.assertEqual(expected_sql, actual_sql)

    def test_expand_column_list_correctly_generates_list_with_extra_nesting(self):
        var_dict = {'columns': ['CUSTOMER_PK', ['ORDER_FK', ['BOOKING_FK', 'TEST_COLUMN']]]}

        process_logs = self.dbt_test_utils.run_dbt_model(model_name=self.current_test_name, args=var_dict)
        actual_sql = self.dbt_test_utils.retrieve_compiled_model(self.current_test_name)
        expected_sql = self.dbt_test_utils.retrieve_expected_sql(self.current_test_name)

        assert 'Done' in process_logs
        assert 'error' not in process_logs
        self.assertEqual(expected_sql, actual_sql)

    def test_expand_column_list_correctly_generates_list_with_no_nesting(self):
        var_dict = {'columns': ['CUSTOMER_PK', 'ORDER_FK', 'BOOKING_FK']}

        process_logs = self.dbt_test_utils.run_dbt_model(model_name=self.current_test_name, args=var_dict)
        actual_sql = self.dbt_test_utils.retrieve_compiled_model(self.current_test_name)
        expected_sql = self.dbt_test_utils.retrieve_expected_sql(self.current_test_name)

        assert 'Done' in process_logs
        assert 'error' not in process_logs
        self.assertEqual(expected_sql, actual_sql)

    def test_expand_column_list_raises_error_with_missing_columns(self):
        process_logs = self.dbt_test_utils.run_dbt_model(model_name=self.current_test_name)

        assert 'Expected a list of columns, got: None' in process_logs
