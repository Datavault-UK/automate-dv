from unittest import TestCase
import sqlScript as sql


class TestCreateHistoryStatement(TestCase):

    def test_create_history_statement(self):
        statement = sql.create_history_statement()
        self.assertIsInstance(statement, str)

    def test_create_day_statement(self):
        statement = sql.create_day_statement()
        self.assertIsInstance(statement, str)

