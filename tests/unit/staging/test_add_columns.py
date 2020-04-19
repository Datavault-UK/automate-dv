import os
from unittest import TestCase

from tests.unit.dbt_test_utils import *


class TestAddColumnsMacro(TestCase):

    @classmethod
    def setUpClass(cls) -> None:

        macro_type = 'staging'

        cls.dbt_test = DBTTestUtils(model_directory=f'{macro_type}/derive_columns')

        os.chdir(TESTS_DBT_ROOT)

        cls.dbt_test.run_model(mode='run', model='raw_source')

    def setUp(self) -> None:

        self.dbt_test.clean_target()

    # ADD_COLUMNS

    def test_add_columns_correctly_generates_SQL_with_source_columns(self):
        model = 'test_add_columns'

        var_dict = {
            'source_table': 'raw_source'
        }

        process_logs = self.dbt_test.run_model(model=model, model_vars=var_dict)

        actual_sql = self.dbt_test.retrieve_compiled_model(model)

        expected_sql = """'STG_CUSTOMER' AS SOURCE,\n    LOADDATE AS EFFECTIVE_FROM,\n    LOADDATE,\n    TEST_COLUMN_2,""" \
                       """\n    TEST_COLUMN_3,\n    TEST_COLUMN_4,\n    TEST_COLUMN_5,\n    TEST_COLUMN_6,\n    TEST_COLUMN_7,""" \
                       """\n    TEST_COLUMN_8,\n    TEST_COLUMN_9"""

        self.assertIn('Done', process_logs)
        self.assertIn('Warning: This macro (add_columns) is deprecated and '
                      'will be removed in a future release. Use derive_columns instead.',
                      process_logs)

        self.assertEqual(expected_sql, actual_sql)



