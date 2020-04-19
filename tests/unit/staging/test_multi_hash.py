import os
from unittest import TestCase

from tests.unit.dbt_test_utils import *


class TestHashColumnsMacro(TestCase):

    @classmethod
    def setUpClass(cls) -> None:

        macro_type = 'staging'

        cls.dbt_test = DBTTestUtils(model_directory=f'{macro_type}/hash_columns')

        os.chdir(TESTS_DBT_ROOT)

    def setUp(self) -> None:

        self.dbt_test.clean_target()

    # MULTI_HASH

    def test_multi_hash_correctly_generates_hashed_columns(self):

        model = 'test_multi_hash'

        process_logs = self.dbt_test.run_model(model=model)

        actual_sql = self.dbt_test.retrieve_compiled_model(model)

        expected_sql = """SELECT\n\n""" \
                       """    CAST(MD5_BINARY(IFNULL((UPPER(TRIM(CAST(CUSTOMER_ID AS VARCHAR)))), '^^')) AS BINARY(16)) AS CUSTOMER_PK, \n\n""" \
                       """    CAST(MD5_BINARY(CONCAT(\n""" \
                       """        IFNULL(UPPER(TRIM(CAST(CUSTOMER_DOB AS VARCHAR))), '^^'), '||',\n""" \
                       """        IFNULL(UPPER(TRIM(CAST(CUSTOMER_ID AS VARCHAR))), '^^'), '||',\n""" \
                       """        IFNULL(UPPER(TRIM(CAST(CUSTOMER_NAME AS VARCHAR))), '^^') )) AS BINARY(16)) AS CUST_CUSTOMER_HASHDIFF, \n\n""" \
                       """    CAST(MD5_BINARY(CONCAT(\n""" \
                       """        IFNULL(UPPER(TRIM(CAST(CUSTOMER_DOB AS VARCHAR))), '^^'), '||',\n""" \
                       """        IFNULL(UPPER(TRIM(CAST(CUSTOMER_ID AS VARCHAR))), '^^'), '||',\n""" \
                       """        IFNULL(UPPER(TRIM(CAST(CUSTOMER_NAME AS VARCHAR))), '^^') )) AS BINARY(16)) AS CUSTOMER_HASHDIFF"""

        self.assertIn('Done', process_logs)

        self.assertEqual(expected_sql, actual_sql)
