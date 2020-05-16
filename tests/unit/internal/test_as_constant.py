import pytest


@pytest.mark.usefixtures('dbt_test_utils')
class TestAsConstantMacro:

    def test_as_constant_single_correctly_generates_string(self):
        model = 'test_as_constant'

        var_dict = {'column_str': '!STG_BOOKING'}
        process_logs = self.dbt_test_utils.run_dbt_model(model=model, model_vars=var_dict)
        actual_sql = self.dbt_test_utils.retrieve_compiled_model(model)
        expected_sql = self.dbt_test_utils.retrieve_expected_sql(self.current_test_name)

        assert 'Done' in process_logs
        assert actual_sql == expected_sql
