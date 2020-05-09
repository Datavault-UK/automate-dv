from unittest import TestCase

from tests.dbt_test_utils import *



class TestAsConstantMacro(TestCase):

    @classmethod
    def setUpClass(cls) -> None:

        macro_type = 'internal'

        cls.dbt_test = DBTTestUtils(model_directory=f'{macro_type}/as_constant')

        os.chdir(TESTS_DBT_ROOT)

    def setUp(self) -> None:

        self.dbt_test.clean_target()

    def test_as_constant_single_correctly_generates_string(self):

        model = 'test_as_constant'

        expected_file_name = 'test_as_constant_single_correctly_generates_string'

        var_dict = {
            'column_str': '!STG_BOOKING'
        }

        process_logs = self.dbt_test.run_dbt_model(model=model, model_vars=var_dict)

        actual_sql = self.dbt_test.retrieve_compiled_model(model)

        expected_sql = self.dbt_test.retrieve_expected_sql(expected_file_name)

        self.assertIn('Done', process_logs)

        self.assertEqual(actual_sql, expected_sql)
