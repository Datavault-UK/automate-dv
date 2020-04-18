import os
from unittest import TestCase

from tests.unit.dbt_test_utils import *


class TestDeriveColumnsMacro(TestCase):

    @classmethod
    def setUpClass(cls) -> None:

        macro_type = 'staging'

        cls.dbt_test = DBTTestUtils(model_directory=f'{macro_type}/derive_columns')

        os.chdir(TESTS_DBT_ROOT)

        cls.dbt_test.run_model(mode='run', model='add_columns_source')

    def setUp(self) -> None:

        self.dbt_test.clean_target()

    # DERIVE_COLUMNS

    def test_derive_columns_correctly_generates_SQL_with_source_columns(self):

        model = 'test_derive_columns'

        var_dict = {
            'source_table': 'add_columns_source',
            'columns': {"!STG_BOOKING": 'SOURCE',
                        'EFFECTIVE_FROM': 'LOADDATE'}
        }

        process_logs = self.dbt_test.run_model(model=model, model_vars=var_dict)

        actual_sql = self.dbt_test.retrieve_compiled_model(model)

        expected_sql = """'STG_BOOKING' AS SOURCE, EFFECTIVE_FROM AS LOADDATE, TEST_COLUMN_2, """ \
                       """TEST_COLUMN_3, TEST_COLUMN_4, TEST_COLUMN_5, TEST_COLUMN_6, TEST_COLUMN_7, """ \
                       """TEST_COLUMN_8, TEST_COLUMN_9"""

        self.assertIn('Done', process_logs)

        self.assertEqual(expected_sql, actual_sql)


