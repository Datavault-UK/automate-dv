import os
from unittest import TestCase

from tests.unit.dbt_test_utils import *


class TestStageMacro(TestCase):

    @classmethod
    def setUpClass(cls) -> None:

        macro_type = 'staging'

        cls.dbt_test = DBTTestUtils(model_directory=f'{macro_type}/stage')

        os.chdir(TESTS_DBT_ROOT)

        cls.dbt_test.run_model(mode='run', model='raw_source')

    def setUp(self) -> None:

        self.dbt_test.clean_target()

    # STAGE

    def test_stage_correctly_generates_SQL_from_YAML(self):
        model = 'test_stage'

        process_logs = self.dbt_test.run_model(model=model)

        actual_sql = self.dbt_test.retrieve_compiled_model(model)

        expected_sql = """SELECT\n\n""" \
                       """CAST(MD5_BINARY(IFNULL((UPPER(TRIM(CAST(CUSTOMER_ID AS VARCHAR)))), '^^')) """ \
                       """AS BINARY(16)) AS CUSTOMER_PK,\n""" \
                       """CAST(MD5_BINARY(CONCAT(\n""" \
                       """    IFNULL(UPPER(TRIM(CAST(CUSTOMER_DOB AS VARCHAR))), '^^'), '||',\n""" \
                       """    IFNULL(UPPER(TRIM(CAST(CUSTOMER_ID AS VARCHAR))), '^^'), '||',\n""" \
                       """    IFNULL(UPPER(TRIM(CAST(CUSTOMER_NAME AS VARCHAR))), '^^') ))\n""" \
                       """AS BINARY(16)) AS CUST_CUSTOMER_HASHDIFF,\n""" \
                       """CAST(MD5_BINARY(CONCAT(\n""" \
                       """    IFNULL(UPPER(TRIM(CAST(CUSTOMER_ID AS VARCHAR))), '^^'), '||',\n""" \
                       """    IFNULL(UPPER(TRIM(CAST(NATIONALITY AS VARCHAR))), '^^'), '||',\n""" \
                       """    IFNULL(UPPER(TRIM(CAST(PHONE AS VARCHAR))), '^^') ))\n""" \
                       """AS BINARY(16)) AS CUSTOMER_HASHDIFF,\n\n""" \
                       """'STG_BOOKING' AS SOURCE,\n""" \
                       """BOOKING_DATE AS EFFECTIVE_FROM,\n""" \
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
                       """TEST_COLUMN_9\n\n""" \
                       """FROM DBT_VAULT.TEST.raw_source""" \

        self.assertIn('Done', process_logs)

        self.assertEqual(expected_sql, actual_sql)

    def test_stage_correctly_generates_SQL_from_YAML_with_source_style(self):
        model = 'test_stage_source_relation_style'

        process_logs = self.dbt_test.run_model(mode='run', model=model)

        actual_sql = self.dbt_test.retrieve_compiled_model(model)

        expected_sql = """SELECT\n\n""" \
                       """CAST(MD5_BINARY(IFNULL((UPPER(TRIM(CAST(CUSTOMER_ID AS VARCHAR)))), '^^')) """ \
                       """AS BINARY(16)) AS CUSTOMER_PK,\n""" \
                       """CAST(MD5_BINARY(CONCAT(\n""" \
                       """    IFNULL(UPPER(TRIM(CAST(CUSTOMER_DOB AS VARCHAR))), '^^'), '||',\n""" \
                       """    IFNULL(UPPER(TRIM(CAST(CUSTOMER_ID AS VARCHAR))), '^^'), '||',\n""" \
                       """    IFNULL(UPPER(TRIM(CAST(CUSTOMER_NAME AS VARCHAR))), '^^') ))\n""" \
                       """AS BINARY(16)) AS CUST_CUSTOMER_HASHDIFF,\n""" \
                       """CAST(MD5_BINARY(CONCAT(\n""" \
                       """    IFNULL(UPPER(TRIM(CAST(CUSTOMER_ID AS VARCHAR))), '^^'), '||',\n""" \
                       """    IFNULL(UPPER(TRIM(CAST(NATIONALITY AS VARCHAR))), '^^'), '||',\n""" \
                       """    IFNULL(UPPER(TRIM(CAST(PHONE AS VARCHAR))), '^^') ))\n""" \
                       """AS BINARY(16)) AS CUSTOMER_HASHDIFF,\n\n""" \
                       """'STG_BOOKING' AS SOURCE,\n""" \
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
                       """TEST_COLUMN_9\n\n""" \
                       """FROM DBT_VAULT.TEST.raw_source""" \

        self.assertIn('Done', process_logs)

        self.assertEqual(expected_sql, actual_sql)

    def test_stage_correctly_generates_SQL_for_only_source_columns_from_YAML(self):
        model = 'test_stage_source_only'

        process_logs = self.dbt_test.run_model(mode='run', model=model)

        actual_sql = self.dbt_test.retrieve_compiled_model(model)

        expected_sql = """SELECT\n\n""" \
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
                       """TEST_COLUMN_9\n\n""" \
                       """FROM DBT_VAULT.TEST.raw_source""" \

        self.assertIn('Done', process_logs)

        self.assertEqual(expected_sql, actual_sql)
