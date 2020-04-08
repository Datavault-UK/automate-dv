import os
from unittest import TestCase

from tests.unit.dbt_test_utils import *


class TestPrefixMacro(TestCase):

    @classmethod
    def setUpClass(cls) -> None:

        macro_type = 'supporting'

        cls.dbt_test = DBTTestUtils(model_directory=f'{macro_type}/prefix')

        os.chdir(TESTS_DBT_ROOT)

    def setUp(self) -> None:

        self.dbt_test.clean_target()

    def test_prefix_column_in_single_item_list_is_successful(self):

        model = 'test_prefix'

        var_dict = {
            'columns': ["CUSTOMER_HASHDIFF"],
            'prefix': 'c'}

        process_logs = self.dbt_test.run_model(model=model, model_vars=var_dict)

        actual_sql = self.dbt_test.retrieve_compiled_model(model)

        expected_sql = 'c.CUSTOMER_HASHDIFF'

        self.assertIn('Done', process_logs)

        self.assertEqual(expected_sql, actual_sql)

    def test_prefix_multiple_columns_is_successful(self):

        model = 'test_prefix'

        var_dict = {
            'columns': ["CUSTOMER_HASHDIFF", 'CUSTOMER_PK', 'LOADDATE', 'SOURCE'],
            'prefix': 'c'}

        process_logs = self.dbt_test.run_model(model=model, model_vars=var_dict)

        actual_sql = self.dbt_test.retrieve_compiled_model(model)

        expected_sql = 'c.CUSTOMER_HASHDIFF, c.CUSTOMER_PK, c.LOADDATE, c.SOURCE'

        self.assertIn('Done', process_logs)

        self.assertEqual(expected_sql, actual_sql)

    def test_prefix_aliased_column_is_successful(self):

        model = 'test_prefix'

        columns = [{"source_column": "CUSTOMER_HASHDIFF", "alias": "HASHDIFF"},
                   "CUSTOMER_PK",
                   "LOADDATE"]

        var_dict = {'columns': columns, 'prefix': 'c'}

        process_logs = self.dbt_test.run_model(model=model, model_vars=var_dict)

        actual_sql = self.dbt_test.retrieve_compiled_model(model)

        expected_sql = 'c.CUSTOMER_HASHDIFF, c.CUSTOMER_PK, c.LOADDATE'

        self.assertIn('Done', process_logs)

        self.assertEqual(expected_sql, actual_sql)

