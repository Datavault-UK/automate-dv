import os
from unittest import TestCase

from definitions import TESTS_DBT_ROOT
from tests.unit.dbt_test_utils import DBTTestUtils


class TestAliasMacro(TestCase):

    @classmethod
    def setUpClass(cls) -> None:

        cls.dbt_test = DBTTestUtils()

        os.chdir(TESTS_DBT_ROOT)

    def setUp(self) -> None:

        self.dbt_test.clean_target()

    # ALIAS

    def test_alias_single_correctly_generates_SQL(self):

        model = 'test_alias_single'

        var_dict = {
            'source_column': {
                "source_column": "CUSTOMER_HASHDIFF",
                "alias": "HASHDIFF"},
            'prefix': 'c'}

        process_logs = self.dbt_test.run_model(model=model, model_vars=var_dict)

        actual_sql = self.dbt_test.retrieve_compiled_model(model)

        expected_sql = 'c.CUSTOMER_HASHDIFF AS HASHDIFF'

        self.assertIn('Done', process_logs)

        self.assertEqual(actual_sql, expected_sql)

    def test_alias_single_with_incorrect_column_format_in_metadata_raises_error(self):

        model = 'test_alias_single'

        var_dict = {'source_column': {}, 'prefix': 'c'}

        process_logs = self.dbt_test.run_model(model=model, model_vars=var_dict)

        self.assertIn(model, process_logs)
        self.assertIn('Invalid alias configuration:',
                      process_logs)

    def test_alias_single_with_missing_column_metadata_raises_error(self):

        model = 'test_alias_single'

        var_dict = {'source_column': '', 'prefix': 'c'}

        process_logs = self.dbt_test.run_model(model=model, model_vars=var_dict)

        self.assertIn(model, process_logs)

        self.assertIn('Invalid alias configuration:',
                      process_logs)

    # ALIAS_ALL

    def test_alias_all_correctly_generates_SQL_for_full_alias_list_with_prefix(self):

        model = 'test_alias_all'

        columns = [{"source_column": "CUSTOMER_HASHDIFF", "alias": "HASHDIFF"},
                   {"source_column": "ORDER_HASHDIFF", "alias": "HASHDIFF"},
                   {"source_column": "BOOKING_HASHDIFF", "alias": "HASHDIFF"}]

        var_dict = {'columns': columns, 'prefix': 'c'}

        process_logs = self.dbt_test.run_model(model=model, model_vars=var_dict)

        expected_sql = 'c.CUSTOMER_HASHDIFF AS HASHDIFF, ' \
                       'c.ORDER_HASHDIFF AS HASHDIFF, ' \
                       'c.BOOKING_HASHDIFF AS HASHDIFF'

        actual_sql = self.dbt_test.retrieve_compiled_model(model)

        self.assertIn('Done.', process_logs)
        self.assertEqual(expected_sql, actual_sql)

    def test_alias_all_correctly_generates_SQL_for_partial_alias_list_with_prefix(self):

        model = 'test_alias_all'

        columns = [{"source_column": "CUSTOMER_HASHDIFF", "alias": "HASHDIFF"},
                   "ORDER_HASHDIFF",
                   {"source_column": "BOOKING_HASHDIFF", "alias": "HASHDIFF"}]

        var_dict = {'columns': columns, 'prefix': 'c'}

        process_logs = self.dbt_test.run_model(model=model, model_vars=var_dict)

        expected_sql = 'c.CUSTOMER_HASHDIFF AS HASHDIFF, ' \
                       'c.ORDER_HASHDIFF, ' \
                       'c.BOOKING_HASHDIFF AS HASHDIFF'

        actual_sql = self.dbt_test.retrieve_compiled_model(model)

        self.assertIn('Done.', process_logs)
        self.assertEqual(expected_sql, actual_sql)

    def test_alias_all_correctly_generates_SQL_for_full_alias_list_without_prefix(self):

        model = 'test_alias_all_without_prefix'

        columns = [{"source_column": "CUSTOMER_HASHDIFF", "alias": "HASHDIFF"},
                   {"source_column": "ORDER_HASHDIFF", "alias": "HASHDIFF"},
                   {"source_column": "BOOKING_HASHDIFF", "alias": "HASHDIFF"}]

        var_dict = {'columns': columns}

        process_logs = self.dbt_test.run_model(model=model, model_vars=var_dict)

        expected_sql = 'CUSTOMER_HASHDIFF AS HASHDIFF, ' \
                       'ORDER_HASHDIFF AS HASHDIFF, ' \
                       'BOOKING_HASHDIFF AS HASHDIFF'

        actual_sql = self.dbt_test.retrieve_compiled_model(model)

        self.assertIn('Done.', process_logs)
        self.assertEqual(expected_sql, actual_sql)

    def test_alias_all_correctly_generates_SQL_for_partial_alias_list_without_prefix(self):

        model = 'test_alias_all_without_prefix'

        columns = [{"source_column": "CUSTOMER_HASHDIFF", "alias": "HASHDIFF"},
                   "ORDER_HASHDIFF",
                   {"source_column": "BOOKING_HASHDIFF", "alias": "HASHDIFF"}]

        var_dict = {'columns': columns}

        process_logs = self.dbt_test.run_model(model=model, model_vars=var_dict)

        expected_sql = 'CUSTOMER_HASHDIFF AS HASHDIFF, ' \
                       'ORDER_HASHDIFF, ' \
                       'BOOKING_HASHDIFF AS HASHDIFF'

        actual_sql = self.dbt_test.retrieve_compiled_model(model)

        self.assertIn('Done.', process_logs)

        self.assertEqual(expected_sql, actual_sql)
