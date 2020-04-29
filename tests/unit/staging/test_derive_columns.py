import os
from unittest import TestCase

from tests.unit.dbt_test_utils import *


class TestDeriveColumnsMacro(TestCase):

    @classmethod
    def setUpClass(cls) -> None:

        macro_type = 'staging'

        cls.dbt_test = DBTTestUtils(model_directory=f'{macro_type}/derive_columns')

        os.chdir(TESTS_DBT_ROOT)

        cls.dbt_test.run_model(mode='run', model='raw_source')

    def setUp(self) -> None:

        self.dbt_test.clean_target()

    # DERIVE_COLUMNS

    def test_derive_columns_correctly_generates_SQL_with_source_columns(self):

        model = 'test_derive_columns_with_source_columns'

        var_dict = {
            'source_model': 'raw_source',
            'columns': {'SOURCE': "!STG_BOOKING",
                        'EFFECTIVE_FROM': 'LOADDATE'}
        }

        process_logs = self.dbt_test.run_model(model=model, model_vars=var_dict)

        actual_sql = self.dbt_test.retrieve_compiled_model(model)

        expected_sql = """'STG_BOOKING' AS SOURCE,\n""" \
                       """LOADDATE AS EFFECTIVE_FROM,\n""" \
                       """LOADDATE,\n""" \
                       """CUSTOMER_ID,\n""" \
                       """CUSTOMER_DOB,\n""" \
                       """CUSTOMER_NAME,\n""" \
                       """NATIONALITY,\n""" \
                       """PHONE,\n""" \
                       """TEST_COLUMN_2,\n""" \
                       """TEST_COLUMN_3,\n""" \
                       """TEST_COLUMN_4,\n""" \
                       """TEST_COLUMN_5,\n""" \
                       """TEST_COLUMN_6,\n""" \
                       """TEST_COLUMN_7,\n""" \
                       """TEST_COLUMN_8,\n""" \
                       """TEST_COLUMN_9"""

        self.assertIn('Done', process_logs)

        self.assertEqual(expected_sql, actual_sql)

    def test_derive_columns_correctly_generates_SQL_without_source_columns(self):

        model = 'test_derive_columns_without_source_columns'

        var_dict = {
            'columns': {'SOURCE': "!STG_BOOKING",
                        'LOADDATE': 'EFFECTIVE_FROM'}
        }

        process_logs = self.dbt_test.run_model(model=model, model_vars=var_dict)

        actual_sql = self.dbt_test.retrieve_compiled_model(model)

        expected_sql = """'STG_BOOKING' AS SOURCE,\nEFFECTIVE_FROM AS LOADDATE"""

        self.assertIn('Done', process_logs)

        self.assertEqual(expected_sql, actual_sql)

    def test_derive_columns_correctly_generates_SQL_with_only_source_columns(self):

        model = 'test_derive_columns_with_only_source_columns'

        var_dict = {
            'source_model': 'raw_source'
        }

        process_logs = self.dbt_test.run_model(model=model, model_vars=var_dict)

        actual_sql = self.dbt_test.retrieve_compiled_model(model)

        expected_sql = """LOADDATE,\n""" \
                       """CUSTOMER_ID,\n""" \
                       """CUSTOMER_DOB,\n""" \
                       """CUSTOMER_NAME,\n""" \
                       """NATIONALITY,\n""" \
                       """PHONE,\n""" \
                       """TEST_COLUMN_2,\n""" \
                       """TEST_COLUMN_3,\n""" \
                       """TEST_COLUMN_4,\n""" \
                       """TEST_COLUMN_5,\n""" \
                       """TEST_COLUMN_6,\n""" \
                       """TEST_COLUMN_7,\n""" \
                       """TEST_COLUMN_8,\n""" \
                       """TEST_COLUMN_9"""

        self.assertIn('Done', process_logs)

        self.assertEqual(expected_sql, actual_sql)



