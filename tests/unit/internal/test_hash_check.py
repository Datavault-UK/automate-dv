from unittest import TestCase

from tests.dbt_test_utils import *


class TestHashCheckMacro(TestCase):

    @classmethod
    def setUpClass(cls) -> None:

        macro_type = 'internal'

        cls.dbt_test = DBTTestUtils(model_directory=f'{macro_type}/hash_check')

        os.chdir(TESTS_DBT_ROOT)

        cls.model = 'test_hash_check'

    def setUp(self) -> None:

        self.dbt_test.clean_target()

    def test_hash_check_with_md5_setting(self):

        expected_file_name = 'test_hash_check_with_md5_setting'

        var_dict = {
            'hash': 'MD5',
            'col': '^^'}

        process_logs = self.dbt_test.run_dbt_model(model=self.model, model_vars=var_dict)

        actual_sql = self.dbt_test.retrieve_compiled_model(self.model)

        expected_sql = self.dbt_test.retrieve_expected_sql(expected_file_name)

        self.assertIn('Done', process_logs)

        self.assertEqual(expected_sql, actual_sql)

    def test_hash_check_with_sha_setting(self):

        expected_file_name = 'test_hash_check_with_sha_setting'

        var_dict = {
            'hash': 'SHA',
            'col': '^^'}

        process_logs = self.dbt_test.run_dbt_model(model=self.model, model_vars=var_dict)

        actual_sql = self.dbt_test.retrieve_compiled_model(self.model)

        expected_sql = self.dbt_test.retrieve_expected_sql(expected_file_name)

        self.assertIn('Done', process_logs)

        self.assertEqual(expected_sql, actual_sql)

    def test_hash_check_with_default_setting(self):

        expected_file_name = 'test_hash_check_with_default_setting'

        var_dict = {
            'col': '^^'}

        process_logs = self.dbt_test.run_dbt_model(model=self.model, model_vars=var_dict)

        actual_sql = self.dbt_test.retrieve_compiled_model(self.model)

        expected_sql = self.dbt_test.retrieve_expected_sql(expected_file_name)

        self.assertIn('Done', process_logs)

        self.assertEqual(expected_sql, actual_sql)
