from unittest import TestCase
import sqlScript as sql
import pandas as pd
import sqlalchemy


class TestCreateHistoryStatement(TestCase):

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

    def test_get_credentials(self):
        credentials = sql.get_credentials("./")

