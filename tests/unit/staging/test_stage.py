import os
from unittest import TestCase

from tests.unit.dbt_test_utils import *


class TestStageMacro(TestCase):

    @classmethod
    def setUpClass(cls) -> None:
        macro_type = 'staging'

        cls.dbt_test = DBTTestUtils(model_directory=f'{macro_type}/stage')

        os.chdir(TESTS_DBT_ROOT)

        cls.dbt_test.run_model(mode='run', model='raw_source')

    def setUp(self) -> None:
        self.dbt_test.clean_target()

    def test_stage_correctly_generates_SQL_from_YAML(self):
        model = 'test_stage'

        expected_file_name = 'test_stage_correctly_generates_SQL_from_YAML'

        process_logs = self.dbt_test.run_model(model=model)

        actual_sql = self.dbt_test.retrieve_compiled_model(model)

        expected_sql = self.dbt_test.retrieve_expected_sql(expected_file_name)

        self.assertIn('Done', process_logs)

        self.assertEqual(expected_sql, actual_sql)

    def test_stage_correctly_generates_SQL_from_YAML_with_source_style(self):
        model = 'test_stage_source_relation_style'

        expected_file_name = 'test_stage_correctly_generates_SQL_from_YAML_with_source_style'

        process_logs = self.dbt_test.run_model(mode='run', model=model)

        actual_sql = self.dbt_test.retrieve_compiled_model(model)

        expected_sql = self.dbt_test.retrieve_expected_sql(expected_file_name)

        self.assertIn('Done', process_logs)

        self.assertEqual(expected_sql, actual_sql)

    def test_stage_correctly_generates_SQL_for_only_source_columns_from_YAML(self):
        model = 'test_stage_source_only'

        expected_file_name = 'test_stage_correctly_generates_SQL_for_only_source_columns_from_YAML'

        process_logs = self.dbt_test.run_model(mode='run', model=model)

        actual_sql = self.dbt_test.retrieve_compiled_model(model)

        expected_sql = self.dbt_test.retrieve_expected_sql(expected_file_name)

        self.assertIn('Done', process_logs)

        self.assertEqual(expected_sql, actual_sql)

    def test_stage_correctly_generates_SQL_for_only_hashing_from_YAML(self):
        model = 'test_stage_hashing_only'

        expected_file_name = 'test_stage_correctly_generates_SQL_for_only_hashing_from_YAML'

        process_logs = self.dbt_test.run_model(mode='run', model=model)

        actual_sql = self.dbt_test.retrieve_compiled_model(model)

        expected_sql = self.dbt_test.retrieve_expected_sql(expected_file_name)

        self.assertIn('Done', process_logs)

        self.assertEqual(expected_sql, actual_sql)

    def test_stage_correctly_generates_SQL_for_hashing_and_source_from_YAML(self):
        model = 'test_stage_hashing_and_source'

        expected_file_name = 'test_stage_correctly_generates_SQL_for_hashing_and_source_from_YAML'

        process_logs = self.dbt_test.run_model(mode='run', model=model)

        actual_sql = self.dbt_test.retrieve_compiled_model(model)

        expected_sql = self.dbt_test.retrieve_expected_sql(expected_file_name)

        self.assertIn('Done', process_logs)

        self.assertEqual(expected_sql, actual_sql)

    def test_stage_raises_error_with_missing_source(self):
        model = 'test_stage_raises_error_with_missing_source'

        process_logs = self.dbt_test.run_model(mode='run', model=model)

        self.assertIn('Staging error: Missing source_model configuration. A source model name must be provided.', process_logs)
