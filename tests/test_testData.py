from unittest import TestCase
from unittest.mock import Mock
import snowflake.connector as sf
import pandas as pd
import json
from tests.features.helpers.TestData import TestData


class TestTestData(TestCase):

    @classmethod
    def setUpClass(cls):
        cls.testdata = TestData("./test_configs/credentials.json")

    def test_get_credentials(self):
        credentials = self.testdata.get_credentials("./test_configs/credentials.json")
        key_values = ["user", "password", "account_name", "warehouse", "database", "schema"]
        self.assertIsInstance(credentials, dict)
        self.assertEqual(key_values, list(credentials.keys()))

    def test_create_schema(self):
        self.testdata.create_schema("DV_PROTOTYPE_DB", "SRC")
        results = self.snowflake_test_connector("CREATE SCHEMA IF NOT EXISTS DV_PROTOTYPE_DB.TEST_SRC")
        self.snowflake_test_connector("DROP SCHEMA DV_PROTOTYPE_DB.TEST_SRC")

    @staticmethod
    def snowflake_test_connector(query):
        with open("./test_configs/credentials.json", "r") as read_file:
            credentials = json.load(read_file)

        connection = sf.connect(user=credentials["user"],
                                password=credentials["password"],
                                account=credentials["account_name"],
                                warehouse=credentials["warehouse"],
                                database=credentials["database"],
                                schema=credentials["schema"])

        cur = connection.cursor()

        result = cur.execute(query)

        cur.close()

        return result


