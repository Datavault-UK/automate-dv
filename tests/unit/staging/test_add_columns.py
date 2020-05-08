from unittest import TestCase

import dbt_test_utils


class TestAddColumnsMacro(TestCase):

    @classmethod
    def setUpClass(cls) -> None:

        macro_type = 'staging'

        cls.dbt_test = dbt_test_utils.DBTTestUtils(model_directory=f'{macro_type}/add_columns')

        dbt_test_utils.os.chdir(dbt_test_utils.TESTS_DBT_ROOT)

        cls.dbt_test.run_dbt_model(mode='run', model='raw_source')

    def setUp(self) -> None:

        self.dbt_test.clean_target()

    def test_add_columns_correctly_generates_SQL_with_source_columns(self):
        model = 'test_add_columns'

        expected_file_name = 'test_add_columns_correctly_generates_SQL_with_source_columns'

        var_dict = {
            'source_table': 'raw_source'
        }

        process_logs = self.dbt_test.run_dbt_model(model=model, model_vars=var_dict)

        actual_sql = self.dbt_test.retrieve_compiled_model(model)

        expected_sql = self.dbt_test.retrieve_expected_sql(expected_file_name)

        self.assertIn('Done', process_logs)
        self.assertIn('Warning: This macro (add_columns) is deprecated and '
                      'will be removed in a future release. Use derive_columns instead.',
                      process_logs)

        self.assertEqual(expected_sql, actual_sql)



