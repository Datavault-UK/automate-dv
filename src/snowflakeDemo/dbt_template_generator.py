import logging
import datetime
from toolz import pipe
from yaml import load, dump

try:
    from yaml import CLoader as Loader, CDumper as Dumper
except ImportError:
    from yaml import Loader, Dumper


class TemplateGenerator:

    def __init__(self, logger, con_reader):
        self._my_log = logger
        self.config = con_reader.get_config_dict()
        self.sim_dates = self.get_simulation_dates()

    @staticmethod
    def hub_template(hub_columns, stg_columns, hub_pk):
        """
        Generates the hub sql statement as a string.
        :return: sql statement as a string.
        """

        hub_statement = ("{{{{config(schema='VLT', materialized='incremental', "
                         "unique_key='{}', enabled=true)}}}}\n\n"
                         "SELECT DISTINCT {} \nFROM "
                         "(\nSELECT {}, "
                         "LAG(a.LOADDATE, 1) OVER(PARTITION BY a.{} ORDER BY a.LOADDATE) AS FIRST_SEEN "
                         "\nFROM {{{{ref('v_stg_tpch_data')}}}} AS a) AS stg\n"
                         "{{% if is_incremental() %}}\n"
                         "WHERE stg.{} NOT IN (SELECT {} FROM {{{{this}}}}) "
                         "AND stg.FIRST_SEEN IS NULL\n"
                         "{{% else %}}\n"
                         "WHERE stg.FIRST_SEEN IS NULL\n" 
                         "{{% endif %}}\n" 
                         "LIMIT 10").format(hub_pk, hub_columns,
                                            stg_columns, hub_pk,
                                            hub_pk, hub_pk)

        return hub_statement

    @staticmethod
    def link_template(link_columns, stg_columns, link_pk):
        """
        Generates the link sql statement as a string.
        :return: sql statement as a string.
        """

        link_statement = ("{{{{ config(schema='VLT', materialized='incremental', "
                          "enabled=false, unique_key='{}') }}}}\n\n"
                          "SELECT DISTINCT {} \nFROM "
                          "(\nSELECT {}, \n"
                          "LAG(a.LOADDATE, 1) OVER(PARTITION BY a.{} ORDER BY a.LOADDATE) AS FIRST_SEEN "
                          "\nFROM {{{{ref('v_stg_tpch_data')}}}} AS a) AS stg\n"
                          "{{% if is_incremental() %}}\n"
                          "WHERE stg.{} NOT IN (SELECT {} FROM {{{{this}}}}) "
                          "AND stg.FIRST_SEEN IS NULL\n"
                          "{{% else %}}\n"
                          "WHERE stg.FIRST_SEEN IS NULL\n" 
                          "{{% endif %}}\n" 
                          "LIMIT 10").format(link_pk, link_columns, stg_columns, link_pk, link_pk, link_pk)

        return link_statement

    @staticmethod
    def sat_template(sat_columns, stg_columns, sat_pk):
        """
        Generates the satellite sql statement as a string.
        :return: sql statement as a string.
        """

        sat_statement = ("{{{{ config(schema='VLT', materialized='incremental', enabled=true, "
                         "tags=['history', 'sats'])}}}}\n\n "
                         "SELECT DISTINCT {} \nFROM "
                         "(\nSELECT {}, \n"
                         "LEAD(a.LOADDATE, 1) OVER(PARTITION BY a.{} ORDER BY a.LOADDATE) AS LATEST "
                         "\n FROM {{{{ref('v_stg_tpch_data')}}}} AS a) AS stg\n"
                         "{{% if is_incremental() %}}\n"
                         "WHERE stg.{} NOT IN (SELECT {} FROM {{{{this}}}}) "
                         "AND stg.LATEST IS NULL\n"
                         "{{% else %}}\n"
                         "WHERE stg.LATEST IS NULL\n"
                         "{{% endif %}}\n"
                         "LIMIT 10").format(sat_columns, stg_columns, sat_pk, sat_pk, sat_pk)

        return sat_statement

    @staticmethod
    def dbt_yaml_project_template(history_start_date, history_end_date):
        """
        Generates a template yaml structure which can be passed on and written to a file for dbt.
        :return:
        """

        document = """
        profile: 'my-snowflake-db'
        source-paths: ["models"]
        analysis-paths: ["analysis"] 
        test-paths: ["tests"]
        data-paths: ["data"]
        macro-paths: ["macros"]
        target-path: "target" 
        clean-targets:
            - "target"
            - "dbt_modules"
        
        models:
            vars:
                history_start_date: {}
                history_end_date: {}
                
            snowflake_demo:
                source_creation:
                    tags: "history"
                    enabled: true
                    materialized: "incremental"
                
                stg:
                    tags: "history"
                    enabled: true
                    materialized: view
                    
                hub_sat_link_load:
                    tags: "history"
                    enabled: true 
                    materialized: incremental
        """.format(history_start_date, history_end_date)

        return document

    @staticmethod
    def alias_adder(alias, column_list):
        """
        Adds an alias at the start of column names for the sql statement.
        :param alias: The string that represents the alias.
        :param column_list: The list of columns that the alias will be added to (could be either a string or a list).
        :return: A list that
        """

        if isinstance(column_list, str):
            column_list = column_list.split(", ")
            column_list = [column + "," for column in column_list]
            column_list[len(column_list) - 1] = column_list[len(column_list) - 1].replace(",", "")

        new_column_list = [(alias + "." + column) for column in column_list]

        return new_column_list

    def get_simulation_dates(self):
        """
        Gets the dates for which the simulation will iterate over.
        :return: the simulation dates as a dictionary.
        """

        # date_list = []
        #
        # for date in self.config['simulation dates']:
        #     date_list.append("'TO_DATE({})'".format(self.config['simulation dates'][date]))

        sim_dates = {key: ("'TO_DATE({})'".format(date)) for (key, date) in self.config['simulation dates'].items()
                     if key != "dbt_path"}

        return sim_dates

    def get_history_date_difference(self):
        """
        Calculates the difference in days between the history start date and history end date.
        :return: The number of days between the dates as an integer.
        """

        history_start_date = datetime.datetime.strptime(self.config['simulation dates']['history_start_date'], '%Y-%m-%d')
        history_end_date = datetime.datetime.strptime(self.config['simulation dates']['history_end_date'], '%Y-%m-%d')

        date_diff = history_end_date - history_start_date

        return date_diff.days

    def get_dbt_project_path(self):
        """
        Gets the dbt project file path.
        :return: the path for the dbt project file to be created.
        """

        return self.config['simulation dates']['dbt_path'] + '/' + 'dbt_project.yml'

    def get_table_section_keys(self):
        """
        Gets a list of keys of the section headings required to build the statements (excludes log settings,
        version, and connection settings).
        :return: a list of headings.
        """

        return [key for key in list(self.config.keys()) if key == 'hubs' or key == 'links' or key == 'satellites']

    def get_table_keys(self, table_sections):
        """
        Gets the keys of all the tables listed in the config file.
        :return: returns the keys in a dict.
        """

        table_dict = {}

        for table in table_sections:

            table_dict[table] = list(self.config[table].keys())

        return table_dict

    def get_table_file_path(self, table_section, table_key):
        """
        Gets the file path to write the sql file in the dbt model.
        :return:
        """
        file_path = self.config[table_section][table_key]["dbt_path"] + "/{}.sql".format(self.get_table_name(
            table_section, table_key))
        return file_path

    def get_table_name(self, table_section, table_key):
        """
        Gets the name of the table that the sql is being generated for and returns it as a string.
        :return: name of table as string.
        """

        return self.config[table_section][table_key]["name"]

    def get_pk(self, table_section, table_key):
        """
        Gets the table primary key from the config file.
        :return: The table primary key column as a string.
        """
        return self.config[table_section][table_key]["pk"]

    def get_table_columns(self, table_section, table_key):
        """
        Gets the table columns required for the sql statement.
        :return: The table columns as a string.
        """
        table_columns = self.config[table_section][table_key]["table_columns"]

        if isinstance(table_columns, str):

            aliased_table_columns = self.alias_adder("stg", table_columns)

            return " ".join(aliased_table_columns)
        else:

            aliased_table_columns = self.alias_adder("stg", table_columns)

            return ", ".join(aliased_table_columns)

    def get_stg_columns(self, table_section, table_key):
        """
        Gets the stage columns required to build the table.
        :return: The stage columns as a string.
        """
        stg_columns = self.config[table_section][table_key]["stg_columns"]

        if isinstance(stg_columns, str):

            aliased_stg_columns = self.alias_adder("a", stg_columns)

            return " ".join(aliased_stg_columns)
        else:

            aliased_stg_columns = self.alias_adder("a", stg_columns)

            return ", ".join(aliased_stg_columns)

    def write_to_file(self, path, statement):
        """
        Writes the generated statement to an sql file in the dbt directory.
        :param path: path to write file
        :param statement: the generated sql statement.
        """

        try:
            file = open(path, "x")
            file.close()
            file = open(path, "w")
            file.write(statement)
            file.close()

        except FileExistsError:
            self._my_log.log("A file already exists in this path {}. It will be overwritten.".format(path),
                             logging.ERROR)
            file = open(path, "w")
            file.write(statement)
            file.close()

    def create_sql_files(self):
        """
        Gets the statement and creates the file in the correct dbt directory.
        """

        table_sections = self.get_table_section_keys()
        table_keys = self.get_table_keys(table_sections)

        for table_key in table_keys:
            for table in table_keys[table_key]:

                try:
                    statement = self.hub_template(self.get_table_columns(table_key, table),
                                                  self.get_stg_columns(table_key, table),
                                                  self.get_pk(table_key, table))
                    path = self.get_table_file_path(table_key, table)
                    self._my_log.log("Writing {} template to file in dbt directory...".format(table), logging.INFO)
                    self.write_to_file(path, statement)
                    self._my_log.log("Successfully written sql to file.", logging.INFO)

                except KeyError:

                    self._my_log.log(("A KeyError was detected in constructing the sql file from the template. "
                                      "Please check the config file."), logging.ERROR)

    def create_dbt_project_file(self, history_start_date, history_end_date):
        """
        Gets the yaml statement and dumps it into a yaml file.
        """

        path = self.get_dbt_project_path()
        document = self.dbt_yaml_project_template(history_start_date, history_end_date)
        data = load(document, Loader=Loader)

        try:
            file = open(path, 'x')
            file.close()
            file = open(path, 'w')
            dump(data, file, Dumper=Dumper)
            file.close()

        except FileExistsError:
            self._my_log.log("The dbt profile already exists. It will be overwritten.", logging.ERROR)
            file = open(path, 'w')
            dump(data, file, Dumper=Dumper)
            file.close()

