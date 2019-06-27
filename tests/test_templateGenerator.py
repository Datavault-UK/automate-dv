from unittest import TestCase
from snowflakeDemo.dbt_template_generator import TemplateGenerator
from vaultBase.logger import Logger
from vaultBase.cliParse import CLIParse
from vaultBase.configReader import ConfigReader
import os
import logging
from unittest.mock import Mock


class TestTemplateGenerator(TestCase):

    @classmethod
    def setUpClass(cls):
        cls.cli_args = CLIParse("Reconciles data across different environments.", "testTemplateGenerator")
        cls.cli_args.get_config_name = Mock(return_value="./test_configs/templateConfig.ini")
        cls.cli_args.get_log_level = Mock(return_value=logging.INFO)
        cls.log = Logger("testTemplateGenerator", cls.cli_args)
        cls.con_reader = ConfigReader(cls.log, cls.cli_args)
        cls.log.set_config(cls.con_reader)
        cls.template_gen = TemplateGenerator(cls.log, cls.con_reader)
        cls.config = cls.template_gen.config

    def test_hub_template(self):
        hub_columns = "stg.CUSTOMER_PK, stg.CUSTOMERKEY, stg.LOADDATE, stg.SOURCE"
        stg_columns = "a.CUSTOMER_PK, a.CUSTOMERKEY, a.LOADDATE, a.SOURCE"
        hub_pk = "CUSTOMER_PK"
        hub_sql = self.template_gen.hub_template(hub_columns, stg_columns, hub_pk)
        self.assertIsInstance(hub_sql, str)
        self.assertIn("{% if is_incremental() %}", hub_sql)
        self.assertIn("{% else %", hub_sql)
        self.assertIn("{% endif %}", hub_sql)
        self.assertIn(hub_columns, hub_sql)
        self.assertIn(stg_columns, hub_sql)
        self.assertIn(hub_pk, hub_sql)

    def test_alias_adder(self):
        columns_list = ['CUSTOMER_PK', 'CUSTOMERKEY', 'LOADDATE', 'SOURCE']
        columns_string = "CUSTOMER_PK, CUSTOMERKEY, LOADDATE, SOURCE"
        column_list_from_list = self.template_gen.alias_adder("stg", columns_list)
        column_list_from_string = self.template_gen.alias_adder("stg", columns_string)
        self.assertIsInstance(column_list_from_list, list)
        self.assertIsInstance(column_list_from_string, list)
        self.assertEqual(column_list_from_list, ['stg.CUSTOMER_PK', 'stg.CUSTOMERKEY', "stg.LOADDATE", 'stg.SOURCE'])
        self.assertEqual(column_list_from_string, ['stg.CUSTOMER_PK,', 'stg.CUSTOMERKEY,', "stg.LOADDATE,", 'stg.SOURCE'])

    def test_get_hub_keys(self):
        expected_keys = ['customer', 'nation']
        actual_keys = self.template_gen.get_hub_keys()
        self.assertIsInstance(actual_keys, list)
        self.assertEqual(actual_keys, expected_keys)

    def test_get_hub_file_path(self):
        file_path = self.template_gen.get_hub_file_path("customer")
        self.assertIsInstance(file_path, str)
        self.assertEqual(file_path, "../src/snowflakeDemo/models/hub_sat_link_load/hub_test.sql")

    def test_get_hub_name(self):
        hub_name = self.template_gen.get_hub_name("customer")
        self.assertIsInstance(hub_name, str)
        self.assertEqual(hub_name.lower(), "hub_test")

    def test_get_hub_pk(self):
        hub_pk = self.template_gen.get_hub_pk("customer")
        self.assertIsInstance(hub_pk, str)
        self.assertEqual(hub_pk, "CUSTOMER_PK")

    def test_get_hub_columns_as_list(self):
        hub_columns = self.template_gen.get_hub_columns("customer")
        self.assertIsInstance(hub_columns, str)
        self.assertEqual(hub_columns, "stg.CUSTOMER_PK, stg.CUSTOMERKEY, stg.LOADDATE, stg.SOURCE")

    def test_get_hub_columns_as_string(self):
        cli_args = CLIParse("Reconciles data across different environments.", "testTemplateGenerator")
        cli_args.get_config_name = Mock(return_value="./test_configs/templateConfigStringInputs.ini")
        cli_args.get_log_level = Mock(return_value=logging.INFO)
        log = Logger("testTemplateGenerator", cli_args)
        con_reader = ConfigReader(log, cli_args)
        log.set_config(con_reader)
        template_gen = TemplateGenerator(log, con_reader)
        hub_columns = template_gen.get_hub_columns("customer")
        self.assertIsInstance(hub_columns, str)
        self.assertEqual(hub_columns, "stg.CUSTOMER_PK, stg.CUSTOMERKEY, stg.LOADDATE, stg.SOURCE")

    def test_get_stg_columns_list(self):
        stage_columns = self.template_gen.get_stg_columns("customer")
        self.assertIsInstance(stage_columns, str)
        self.assertEqual(stage_columns, "a.CUSTOMER_PK, a.CUSTOMERKEY, a.LOADDATE, a.SOURCE")

    def test_get_stg_columns_string(self):
        cli_args = CLIParse("Reconciles data across different environments.", "testTemplateGenerator")
        cli_args.get_config_name = Mock(return_value="./test_configs/templateConfigStringInputs.ini")
        cli_args.get_log_level = Mock(return_value=logging.INFO)
        log = Logger("testTemplateGenerator", cli_args)
        con_reader = ConfigReader(log, cli_args)
        log.set_config(con_reader)
        template_gen = TemplateGenerator(log, con_reader)
        stage_columns = template_gen.get_stg_columns("customer")
        self.assertIsInstance(stage_columns, str)
        self.assertEqual(stage_columns, "a.CUSTOMER_PK, a.CUSTOMERKEY, a.LOADDATE, a.SOURCE")

    def test_write_to_file(self):
        path = "./test_configs/generated_sql_files/test_write_to_file.sql"
        statement = "SELECT * FROM TABLE"
        self.template_gen.write_to_file(path, statement)
        self.assertTrue(os.path.isfile(path))

        with open(path, 'r') as file:
            file_text = file.read()

        self.assertEqual(file_text, statement)

    def test_write_to_file_file_exists_error_handle(self):
        path = "./test_configs/generated_sql_files/test_write_to_file_error.sql"
        statement = ""
        file = open(path, 'x')
        file.close()
        with self.assertLogs("testTemplateGenerator", logging.ERROR) as cm:
            self.template_gen.write_to_file(path, statement)

        self.assertIn("A file already exists in this path {}. It will be overwritten.".format(path),
                      "".join(cm.output))

    def test_create_sql_files(self):
        hub_keys = self.template_gen.get_hub_keys()
        path_list = []

        for hub_key in hub_keys:
            path = self.config["hubs"][hub_key]["dbt_path"]+self.config["hubs"][hub_key]["name"]+".sql"

            path_list.append(self.config["hubs"][hub_key]["dbt_path"]+"/"+self.config["hubs"][hub_key]["name"]+".sql")

        self.template_gen.create_sql_files()

        for path in path_list:
            self.assertTrue(os.path.isfile(path))

    @classmethod
    def tearDownClass(cls):
        sql_path = "./test_configs/generated_sql_files/"
        log_path = "./logs/"
        file_list = [os.remove(os.path.join(sql_path, file)) for file in os.listdir(sql_path)]
        log_list = [os.remove(os.path.join(log_path, file)) for file in os.listdir(log_path)]