from unittest import TestCase
import src.snowflakeDemo.sqlFunctionLibrary as sql
import pandas as pd
import sqlalchemy
import os


class TestSqlScript(TestCase):

    @classmethod
    def setUpClass(cls):
        cls.credentials = sql.get_credentials("./test_configs/test_credentials.json")

    def test_get_credentials(self):
        credentials = sql.get_credentials("./test_configs/test_credentials.json")
        self.assertIsInstance(credentials, dict)

        for item in credentials:
            self.assertIsInstance(credentials[item], str)

    def test_read_in_file_single_statement(self):
        sql_file = sql.read_in_file("./test_configs/SnowflakeHistoryViewTemplateTest.sql")
        self.assertIsInstance(sql_file[0], str)

    def test_read_in_file_multiple_statements(self):
        sql_commands = sql.read_in_file("./test_configs/snowflakeEnvSetupTest.sql")
        self.assertIsInstance(sql_commands, list)
        self.assertTrue(len(sql_commands), 3)

        for query_index in range(len(sql_commands)):
            self.assertTrue(sql_commands[query_index], str)
            self.assertIn(";", sql_commands[query_index])

    def test_flat_file_view_loader(self):
        sql.flat_file_view_loader("./test_configs/flatfileloads/",
                                  credentials_path="./test_configs/test_credentials.json")
        #self.assertIsInstance(sql_commands, list)

    def test_snowflake_connector(self):
        engine = sql.snowflake_connector(self.credentials)
        self.assertIsInstance(engine, sqlalchemy.engine.base.Engine)

