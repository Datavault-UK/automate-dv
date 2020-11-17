import pytest
from unittest import TestCase


@pytest.mark.usefixtures('dbt_test_utils', 'clean_database')
class TestAsConstantMacro(TestCase):
    maxDiff = None

    def test_as_constant_single_correctly_generates_string(self):
        var_dict = {'column_str': '!STG_BOOKING'}
        process_logs = self.dbt_test_utils.run_dbt_model(model_name=self.current_test_name, args=var_dict)
        actual_sql = self.dbt_test_utils.retrieve_compiled_model(self.current_test_name)
        expected_sql = self.dbt_test_utils.retrieve_expected_sql(self.current_test_name)

        assert 'Done' in process_logs
        self.assertEqual(expected_sql, actual_sql)
