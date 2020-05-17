import pytest


@pytest.mark.usefixtures('dbt_test_utils')
class TestAliasMacro:

    def test_check_relation_returns_true_for_ref(self):
        process_logs = self.dbt_test_utils.run_dbt_model(model=self.current_test_name)

        assert 'True' in process_logs
        assert 'Done' in process_logs

    def test_check_relation_returns_true_for_source(self):
        process_logs = self.dbt_test_utils.run_dbt_model(model=self.current_test_name)

        assert 'True' in process_logs
        assert 'Done' in process_logs

    def test_check_relation_returns_false_for_non_relation(self):
        process_logs = self.dbt_test_utils.run_dbt_model(model=self.current_test_name)

        assert 'False' in process_logs
        assert 'Done' in process_logs
