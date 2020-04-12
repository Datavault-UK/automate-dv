import os
from unittest import TestCase

from tests.unit.dbt_test_utils import *

class TestAddColumnsMacro(TestCase):

    @classmethod
    def setUpClass(cls) -> None:

        macro_type = 'staging'

        cls.dbt_test = DBTTestUtils(model_directory=f'{macro_type}/add_columns')

        os.chdir(TESTS_DBT_ROOT)

    def setUp(self) -> None:

        self.dbt_test.clean_target()

    # ADD_COLUMNS

    def test_add_columns_with_mapping_correctly_generates_SQL(self):

        model = 'test_add_columns'

        var_dict = {
            'source_table': 'add_columns_source',
            'columns': {"!STG_BOOKING": 'SOURCE', 'EFFECTIVE_FROM': 'LOADDATE'}
        }

        process_logs = self.dbt_test.run_model(model=model, model_vars=var_dict)

        actual_sql = self.dbt_test.retrieve_compiled_model(model)

        expected_sql = """'STG_BOOKING' AS SOURCE, EFFECTIVE_FROM AS LOADDATE"""

        self.assertIn('Done', process_logs)

        self.assertEqual(expected_sql, actual_sql)
