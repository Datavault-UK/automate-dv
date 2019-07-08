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
        cls.cli_args = CLIParse("Generates dbt sql files for the hubs, links, and satellites from a template",
                                "testTemplateGenerator")
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

    def test_hub_template2(self):
        hub_columns = "stg.CUSTOMER_PK, stg.CUSTOMERKEY, stg.LOADDATE, stg.SOURCE"
        stg_columns1 = "b.CUSTOMER_PK, b.CUSTOMERKEY, b.LOADDATE, b.SOURCE"
        stg_columns2 = "a.CUSTOMER_PK, a.CUSTOMERKEY, a.LOADDATE, a.SOURCE"
        hub_pk = "CUSTOMER_PK"
        stg_name = "v_stg_tpch_data"
        hub_sql = self.template_gen.hub_template2(hub_columns, stg_columns1, stg_columns2, hub_pk, stg_name)
        self.assertIsInstance(hub_sql, str)

    def test_hub_macro_template_first_run(self):
        hub_macro_sql = self.template_gen.hub_macro_template()
        self.assertIsInstance(hub_macro_sql, str)
        self.assertIn("{{hub_columns}}", hub_macro_sql)
        self.assertIn("stg_columns1", hub_macro_sql)
        self.assertIn("{{hub_pk}}", hub_macro_sql)
        self.assertNotIn("{{stg_columns2}}", hub_macro_sql)

    # def test_hub_macro_template_increment(self):
    #     hub_macro_sql = self.template_gen.hub_macro_template_increment()
    #     self.assertIsInstance(hub_macro_sql, str)
    #     self.assertIn("{{hub_columns}}", hub_macro_sql)
    #     self.assertIn("{{stg_columns1}}", hub_macro_sql)
    #     self.assertIn("{{hub_pk}}", hub_macro_sql)
    #     self.assertIn("{{ref(stg_name)}}", hub_macro_sql)
    #     self.assertIn("{{stg_columns2}}", hub_macro_sql)

    def test_link_template(self):
        link_columns = "stg.CUSTOMER_NATION_PK, stg.CUSTOMER_PK, stg.NATION_PK, stg.LOADDATE, stg.SOURCE"
        stg_columns = "a.CUSTOMER_NATION_PK, a.CUSTOMER_PK, a.NATION_PK, a.LOADDATE, a.SOURCE"
        link_pk = "CUSTOMER_NATION_PK"
        link_sql = self.template_gen.link_template(link_columns, stg_columns, link_pk)
        self.assertIsInstance(link_sql, str)
        self.assertIn("{% if is_incremental() %}", link_sql)
        self.assertIn("{% else %", link_sql)
        self.assertIn("{% endif %}", link_sql)
        self.assertIn(link_columns, link_sql)
        self.assertIn(stg_columns, link_sql)
        self.assertIn(link_pk, link_sql)

    def test_sat_template(self):
        sat_columns = ("stg.CUSTOMER_HASHDIFF, stg.CUSTOMER_PK, stg.CUSTOMER_NAME, stg.CUSTOMER_PHONE, stg.LOADDATE, "
                       "stg.EFFECTIVE_FROM, stg.SOURCE")
        stg_columns = ("a.CUSTOMER_HASHDIFF, a.CUSTOMER_PK, a.CUSTOMER_NAME, a.CUSTOMER_PHONE, a.LOADDATE, "
                       "a.EFFECTIVE FROM, a.SOURCE")
        sat_pk = "CUSTOMER_HASHDIFF"
        sat_sql = self.template_gen.sat_template(sat_columns, stg_columns, sat_pk)
        self.assertIsInstance(sat_sql, str)
        self.assertIn("{% if is_incremental() %}", sat_sql)
        self.assertIn("{% else %", sat_sql)
        self.assertIn("{% endif %}", sat_sql)
        self.assertIn(sat_columns, sat_sql)
        self.assertIn(stg_columns, sat_sql)
        self.assertIn(sat_pk, sat_sql)

    def test_table_section_keys(self):
        actual = self.template_gen.get_table_section_keys()
        expected = ['hubs', 'links', 'satellites']
        self.assertIsInstance(actual, list)
        self.assertEqual(actual, expected)

    def test_alias_adder(self):
        columns_list = ['CUSTOMER_PK', 'CUSTOMERKEY', 'LOADDATE', 'SOURCE']
        columns_string = "CUSTOMER_PK, CUSTOMERKEY, LOADDATE, SOURCE"
        column_list_from_list = self.template_gen.alias_adder("stg", columns_list)
        column_list_from_string = self.template_gen.alias_adder("stg", columns_string)
        self.assertIsInstance(column_list_from_list, list)
        self.assertIsInstance(column_list_from_string, list)
        self.assertEqual(column_list_from_list, ['stg.CUSTOMER_PK', 'stg.CUSTOMERKEY', "stg.LOADDATE", 'stg.SOURCE'])
        self.assertEqual(column_list_from_string, ['stg.CUSTOMER_PK,', 'stg.CUSTOMERKEY,', "stg.LOADDATE,", 'stg.SOURCE'])

    def test_table_column_with_aliased_column_names_for_list(self):
        cli_args = CLIParse("Reconciles data across different environments.", "testTemplateGenerator")
        cli_args.get_config_name = Mock(return_value="./test_configs/templateConfigWithAliases.ini")
        cli_args.get_log_level = Mock(return_value=logging.INFO)
        log = Logger("testTemplateGenerator", cli_args)
        con_reader = ConfigReader(log, cli_args)
        log.set_config(con_reader)
        template_gen = TemplateGenerator(log, con_reader)
        hub_columns = template_gen.get_table_columns("hubs", "customer")
        expected_hub_string = "stg.CUSTOMER_PK AS PK, stg.CUSTOMERKEY AS BK, stg.LOADDATE, stg.SOURCE"
        stg_columns = template_gen.get_stg_columns("hubs", "customer", "a")
        expected_stg_string = "a.CUSTOMER_PK AS PK, a.CUSTOMERKEY AS BK, a.LOADDATE, a.SOURCE"
        self.assertIsInstance(hub_columns, str)
        self.assertIsInstance(stg_columns, str)
        self.assertEqual(hub_columns, expected_hub_string)
        self.assertEqual(stg_columns, expected_stg_string)

    def test_get_additional_file_metadata(self):
        cli_args = CLIParse("Reconciles data across different environments.", "testTemplateGenerator")
        cli_args.get_config_name = Mock(return_value="./test_configs/additionalFileConfig.ini")
        cli_args.get_log_level = Mock(return_value=logging.INFO)
        log = Logger("testTemplateGenerator", cli_args)
        con_reader = ConfigReader(log, cli_args)
        log.set_config(con_reader)
        template_gen = TemplateGenerator(log, con_reader)
        metadata_dict = template_gen.get_additional_file_metadata()
        expected_dict = {"file1": {"metadata": "./test_additional_files/file1.data"},
                         "file2": {"metadata": "./test_additional_files/file2.data"}}

        updated_config = template_gen.config
        self.assertIsInstance(metadata_dict, dict)
        self.assertIsInstance(updated_config, dict)
        self.assertEqual(expected_dict, metadata_dict)
        self.assertIn("hub1", updated_config['hubs'])
        self.assertIn("link1", updated_config['links'])
        self.assertIn("sat1", updated_config['satellites'])
        self.assertEqual(["col1", "col2", "col3"], updated_config['hubs']['hub1']['table_columns'])

    def test_get_table_header_keys(self):
        expected_keys = {'hubs': ['customer', 'nation'], 'links': ['link_test', 'link_test2'],
                         'satellites': ['sat_test']}
        actual_keys = self.template_gen.get_table_header_keys(['hubs', 'links', 'satellites'])
        self.assertIsInstance(actual_keys, dict)
        self.assertEqual(actual_keys, expected_keys)

    def test_get_table_name_values(self):
        expected_keys = {'hubs': ['hub_test', 'hub_test2'], 'links': ['link_test', 'link_test2'],
                         'satellites': ['sat_test']}
        actual_keys = self.template_gen.get_table_name_values(['hubs', 'links', 'satellites'])
        self.assertIsInstance(actual_keys, dict)
        self.assertEqual(expected_keys, actual_keys)

    def test_get_table_file_path(self):
        file_path = self.template_gen.get_table_file_path("hubs", "customer")
        self.assertIsInstance(file_path, str)
        self.assertEqual(file_path, "../src/snowflakeDemo/models/hub_sat_link_load/hub_test.sql")

    def test_get_table_name(self):
        hub_name = self.template_gen.get_table_name("hubs", "customer")
        self.assertIsInstance(hub_name, str)
        self.assertEqual(hub_name.lower(), "hub_test")

    def test_get_stg_table_name(self):
        stg_name = self.template_gen.get_stg_table_name("hubs", "customer")
        expected_stg_name = "v_stg_tpch_data"
        self.assertIsInstance(stg_name, str)
        self.assertEqual(expected_stg_name, stg_name)

    def test_get_pk(self):
        hub_pk = self.template_gen.get_pk("hubs", "customer")
        self.assertIsInstance(hub_pk, str)
        self.assertEqual(hub_pk, "CUSTOMER_PK")

    def test_get_table_columns_as_list(self):
        hub_columns = self.template_gen.get_table_columns("hubs", "customer")
        self.assertIsInstance(hub_columns, str)
        self.assertEqual(hub_columns, "stg.CUSTOMER_PK, stg.CUSTOMERKEY, stg.LOADDATE, stg.SOURCE")

    def test_get_table_columns_as_string(self):
        cli_args = CLIParse("Reconciles data across different environments.", "testTemplateGenerator")
        cli_args.get_config_name = Mock(return_value="./test_configs/templateConfigStringInputs.ini")
        cli_args.get_log_level = Mock(return_value=logging.INFO)
        log = Logger("testTemplateGenerator", cli_args)
        con_reader = ConfigReader(log, cli_args)
        log.set_config(con_reader)
        template_gen = TemplateGenerator(log, con_reader)
        hub_columns = template_gen.get_table_columns("hubs", "customer")
        self.assertIsInstance(hub_columns, str)
        self.assertEqual(hub_columns, "stg.CUSTOMER_PK, stg.CUSTOMERKEY, stg.LOADDATE, stg.SOURCE")

    def test_get_stg_columns_list(self):
        stage_columns = self.template_gen.get_stg_columns("hubs", "customer", "a")
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
        stage_columns = template_gen.get_stg_columns("hubs", "customer", "a")
        self.assertIsInstance(stage_columns, str)
        self.assertEqual(stage_columns, "a.CUSTOMER_PK, a.CUSTOMERKEY, a.LOADDATE, a.SOURCE")

    def test_get_simulation_dates(self):
        actual_dates = self.template_gen.sim_dates
        expected_dates = {'history_start_date': "'TO_DATE(1992-12-20)'", 'history_end_date': "'TO_DATE(1993-01-01)'",
                          'date1': "'TO_DATE(1993-01-02)'", 'date2': "'TO_DATE(1993-01-03)'",
                          'date3': "'TO_DATE(1993-01-04)'"}
        self.assertIsInstance(actual_dates, dict)
        self.assertEqual(expected_dates, actual_dates)

    def test_get_dbt_project_path(self):
        actual_path = self.template_gen.get_dbt_project_path()
        expected_path = "./test_configs/dbt_project.yml"
        self.assertIsInstance(actual_path, str)
        self.assertEqual(expected_path, actual_path)

    def test_dbt_yaml_project_template(self):
        history_date = "'TO_DATE(1993-01-01)'"
        date = "'TO_DATE(1993-01-02)'"
        document = self.template_gen.dbt_yaml_project_template(history_date, date)
        self.assertIsInstance(document, str)
        self.assertIn("history_start_date: 'TO_DATE(1993-01-01)'", document)
        self.assertIn("history_end_date: 'TO_DATE(1993-01-02)'", document)

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

    def test_get_history_date_difference(self):
        actual_date_diff = self.template_gen.get_history_date_difference()
        expected_date_diff = 12
        self.assertIsInstance(actual_date_diff, int)
        self.assertEqual(expected_date_diff, actual_date_diff)

    def test_create_sql_files(self):
        table_sections = self.template_gen.get_table_section_keys()
        table_keys = self.template_gen.get_table_header_keys(table_sections)
        path_list = []

        for table_key in table_keys:
            for table in table_keys[table_key]:
                path = self.config[table_key][table]["dbt_path"]+"/"+self.config[table_key][table]["name"]+".sql"

                path_list.append(path)

        self.template_gen.create_sql_files()

        for path in path_list:
            self.assertTrue(os.path.isfile(path))

    def test_create_sql_file_key_error_handle(self):
        cli_args = CLIParse("Reconciles data across different environments.", "testTemplateGenerator")
        cli_args.get_config_name = Mock(return_value="./test_configs/keyerror.ini")
        cli_args.get_log_level = Mock(return_value=logging.INFO)
        log = Logger("testTemplateGenerator", cli_args)
        con_reader = ConfigReader(log, cli_args)
        log.set_config(con_reader)
        template_gen = TemplateGenerator(log, con_reader)

        with self.assertLogs("testTemplateGenerator", logging.ERROR) as cm:
            template_gen.create_sql_files()

        self.assertIn(("A KeyError was detected in constructing the sql file from the template. "
                       "Please check the config file."), "".join(cm.output))

    def test_create_dbt_project_file(self):
        path = self.template_gen.get_dbt_project_path()
        history_date = '1993-01-01'
        date = '1993-01-02'

        self.template_gen.create_dbt_project_file(history_date, date)
        self.assertTrue(os.path.isfile(path))

    def test_create_template_macros(self):
        self.template_gen.create_template_macros()
        path_list = ["../src/snowflakeDemo/macros/hub_template.sql"]

        for path in path_list:
            self.assertTrue(os.path.isfile(path))

    @classmethod
    def tearDownClass(cls):
        sql_path = "./test_configs/generated_sql_files/"
        log_path = "./logs/"
        file_list = [os.remove(os.path.join(sql_path, file)) for file in os.listdir(sql_path)]
        log_list = [os.remove(os.path.join(log_path, file)) for file in os.listdir(log_path)]