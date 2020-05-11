from unittest import TestCase

from tests.utils.dbt_test_utils import *


class TestHashColumnsMacro(TestCase):

    @classmethod
    def setUpClass(cls) -> None:

        macro_type = 'staging'

        cls.dbt_test = DBTTestUtils(model_directory=f'{macro_type}/multi_hash')

        os.chdir(TESTS_DBT_ROOT)

    def setUp(self) -> None:

        self.dbt_test.clean_target()

    def test_multi_hash_correctly_generates_hashed_columns(self):

        model = 'test_multi_hash'

        expected_file_name = 'test_multi_hash_correctly_generates_hashed_columns'

        process_logs = self.dbt_test.run_dbt_model(model=model)

        actual_sql = self.dbt_test.retrieve_compiled_model(model)

        expected_sql = self.dbt_test.retrieve_expected_sql(expected_file_name)

        self.assertIn('Done', process_logs)

        self.assertEqual(expected_sql, actual_sql)
