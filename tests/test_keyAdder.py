from unittest import TestCase
from snowflakeDemo.dbt_template_generator import TemplateGenerator
from snowflakeDemo.addKeys import KeyAdder
from vaultBase.logger import Logger
from vaultBase.cliParse import CLIParse
from vaultBase.configReader import ConfigReader
import os
import logging
from unittest.mock import Mock


class TestKeyAdder(TestCase):

    @classmethod
    def setUpClass(cls):
        cls.cli_args = CLIParse("Adds keys to the tables where required", "testKeyAdder")
        cls.cli_args.get_config_name = Mock(return_value="./test_configs/keyAddConfig.ini")
        cls.cli_args.get_log_level = Mock(return_value=logging.INFO)
        cls.log = Logger("testKeyAdder", cls.cli_args)
        cls.con_reader = ConfigReader(cls.log, cls.cli_args)
        cls.log.set_config(cls.con_reader)
        cls.key_adder = KeyAdder(cls.log, cls.con_reader)

    def test_get_connection_settings(self):
        con_dict = self.key_adder.get_connection_settings()
        expected_keys = ['user', 'password', 'account', 'database', 'warehouse', 'schema', 'role']
        self.assertIsInstance(con_dict, dict)

        for key in expected_keys:
            self.assertIn(key, con_dict)

    def test_primary_key_template(self):
        actual_statement = self.key_adder.primary_key_template("DV_PROTOTYPE_DB.SRC_VLT.LINK_CUSTOMER_NATION",
                                                               "CUSTOMER_NATION_PK")
        expected_statement = ("ALTER TABLE DV_PROTOTYPE_DB.SRC_VLT.LINK_CUSTOMER_NATION "
                              "ADD PRIMARY KEY (CUSTOMER_NATION_PK);")
        self.assertIsInstance(actual_statement, str)
        self.assertEqual(actual_statement, expected_statement)

    def test_foreign_key_template(self):
        actual_statement = self.key_adder.foreign_key_template("DV_PROTOTYPE_DB.SRC_VLT.LINK_CUSTOMER_NATION",
                                                               "CUSTOMER_PK",
                                                               "DV_PROTOTYPE_DB.SRC_VLT.HUB_CUSTOMER",
                                                               "CUSTOMER_PK")
        expected_statement = ("ALTER TABLE DV_PROTOTYPE_DB.SRC_VLT.LINK_CUSTOMER_NATION "
                              "ADD FOREIGN KEY (CUSTOMER_PK) REFERENCES "
                              "DV_PROTOTYPE_DB.SRC_VLT.HUB_CUSTOMER(CUSTOMER_PK);")

        self.assertIsInstance(actual_statement, str)
        self.assertEqual(actual_statement, expected_statement)

    def test_get_primary_keys(self):
        actual_pk = self.key_adder.get_primary_keys(['link_test', 'link_test2'])
        expected_pk = {"link_test": "CUSTOMER_NATION_PK", "link_test2": "NATION_REGION_PK"}
        self.assertIsInstance(actual_pk, dict)
        self.assertEqual(actual_pk, expected_pk)

    def test_get_foreign_keys(self):
        actual_fk = self.key_adder.get_foreign_keys(['link_test', 'link_test2'])
        expected_fk = {"link_test": {"fk1": "CUSTOMER_PK", "fk2": "NATION_PK", "ref1": "CUSTOMER_PK",
                                     "ref2": "NATION_PK", "ref_table1": "HUB_TEST1", "ref_table2": "HUB_TEST2"},
                       "link_test2": {"fk1": "NATION_PK", "fk2": "REGION_PK", "ref1": "NATION_PK",
                                      "ref2": "REGION_PK", "ref_table1": "HUB_TEST1", "ref_table2": "HUB_TEST3"}}
        self.assertIsInstance(actual_fk, dict)
        self.assertEqual(actual_fk, expected_fk)

    def test_get_table_name_value(self):
        actual_names = self.key_adder.get_table_name_values()
        expected_names = ['link_test', 'link_test2']
        self.assertIsInstance(actual_names, list)
        self.assertEqual(actual_names, expected_names)

    def test_get_table_keys(self):
        actual_key_list = self.key_adder.get_table_keys()
        expected_key_list = ["customer", "nation", "link_test", "link_test2"]
        self.assertIsInstance(actual_key_list, list)
        self.assertEqual(expected_key_list, actual_key_list)

    def test_get_full_table_path(self):
        actual = self.key_adder.get_full_table_path(['link_test', 'link_test2'])
        expected = {'link_test': 'DV_PROTOTYPE_DB.SRC_VLT', 'link_test2': 'DV_PROTOTYPE_DB.SRC_VLT'}
        self.assertIsInstance(actual, dict)
        self.assertEqual(actual, expected)

    def test_execute_primary_key_statements(self):
        actual = self.key_adder.execute_primary_key_statements()
        expected = ("ALTER TABLE DV_PROTOTYPE_DB.SRC_VLT.LINK_TEST2 "
                    "ADD PRIMARY KEY (NATION_REGION_PK);")
        self.assertIsInstance(actual, str)
        self.assertEqual(actual, expected)

    def test_execute_foreign_key_statements(self):
        actual = self.key_adder.execute_foreign_key_statements()
        expected = ("ALTER TABLE DV_PROTOTYPE_DB.SRC_VLT.LINK_TEST2 "
                    "ADD FOREIGN KEY (REGION_PK) REFERENCES "
                    "DV_PROTOTYPE_DB.SRC_VLT.HUB_TEST3(REGION_PK);")
        self.assertIsInstance(actual, str)
        self.assertEqual(actual, expected)

    def test_build_pk_template(self):
        table_name = 'customer'
        sql = self.key_adder.build_pk_template(table_name)
        expected_sql = "ALTER TABLE DV_PROTOTYPE_DB.SRC_VLT.hub_test ADD PRIMARY KEY (CUSTOMER_PK);"
        self.assertIsInstance(sql, str)
        self.assertEqual(expected_sql, sql)