from unittest import TestCase

from tests.utils.dbt_test_utils import *


class TestHubMacro(TestCase):

    @classmethod
    def setUpClass(cls) -> None:
        macro_type = 'tables'

        cls.dbt_test = DBTTestUtils(model_directory=f'{macro_type}/hub')

        os.chdir(TESTS_DBT_ROOT)

        cls.dbt_test.run_dbt_seed()

    def setUp(self) -> None:
        self.dbt_test.clean_target()

    def test_hub_macro_correctly_generates_sql_for_single_source(self):
        model = 'test_hub_macro_single_source'

        expected_file_name = 'test_hub_macro_single_source'

        process_logs = self.dbt_test.run_dbt_model(model=model)

        actual_sql = self.dbt_test.retrieve_compiled_model(model)

        expected_sql = self.dbt_test.retrieve_expected_sql(expected_file_name)

        self.assertIn('Done', process_logs)

        self.assertEqual(expected_sql, actual_sql)

    def test_hub_macro_correctly_generates_sql_for_incremental_single_source(self):
        model = 'test_hub_macro_incremental_single_source'

        expected_file_name = 'test_hub_macro_incremental_single_source'

        process_logs_first_run = self.dbt_test.run_dbt_model(mode='run', model=model, full_refresh=True)

        process_logs_inc_run = self.dbt_test.run_dbt_model(mode='run', model=model)

        actual_sql = self.dbt_test.retrieve_compiled_model(model)

        expected_sql = self.dbt_test.retrieve_expected_sql(expected_file_name)

        self.assertIn('Done', process_logs_first_run)
        self.assertIn('Done', process_logs_inc_run)

        self.assertEqual(expected_sql, actual_sql)

    def test_hub_macro_correctly_generates_sql_for_multi_source(self):
        model = 'test_hub_macro_multi_source'

        expected_file_name = 'test_hub_macro_multi_source'

        process_logs = self.dbt_test.run_dbt_model(model=model)

        actual_sql = self.dbt_test.retrieve_compiled_model(model)

        expected_sql = self.dbt_test.retrieve_expected_sql(expected_file_name)

        self.assertIn('Done', process_logs)

        self.assertEqual(expected_sql, actual_sql)

    def test_hub_macro_correctly_generates_sql_for_incremental_multi_source(self):
        model = 'test_hub_macro_incremental_multi_source'

        expected_file_name = 'test_hub_macro_incremental_multi_source'

        process_logs_first_run = self.dbt_test.run_dbt_model(mode='run', model=model, full_refresh=True)

        process_logs_inc_run = self.dbt_test.run_dbt_model(mode='run', model=model)

        actual_sql = self.dbt_test.retrieve_compiled_model(model)

        expected_sql = self.dbt_test.retrieve_expected_sql(expected_file_name)

        self.assertIn('Done', process_logs_first_run)
        self.assertIn('Done', process_logs_inc_run)

        self.assertEqual(expected_sql, actual_sql)
