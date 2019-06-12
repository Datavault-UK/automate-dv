from unittest import TestCase
import sqlScript as sql
import pandas as pd
import sqlalchemy
import os


class TestSqlScript(TestCase):

    def test_create_history_statement(self):
        statement = sql.create_history_statement()
        self.assertIsInstance(statement, str)

    def test_create_day_statement(self):
        statement = sql.create_day_statement()
        self.assertIsInstance(statement, str)

    def test_execute_statement(self):
        view_name = "test_view_test"
        result = sql.execute_statement(view_name,
                                       "CREATE VIEW {} AS "
                                       "SELECT orderkey, quantity "
                                       "FROM lineitem;".format(view_name))
        self.assertIsInstance(result, pd.DataFrame)

    def test_csv_file_export(self):
        results = {"col1": [0, 1, 2, 3], "col2": [3, 2, 1, 0]}
        sql.csv_file_export(pd.DataFrame.from_dict(results), "./testFlatFiles/test_csv.csv")
        self.assertTrue(os.path.isfile("./testFlatFiles/test_csv.csv"))

    def test_get_credentials(self):
        credentials = sql.get_credentials("./test_configs/test_credentials.json")
        self.assertIsInstance(credentials, dict)

        for item in credentials:
            self.assertIsInstance(credentials[item], str)

