import logging
import datetime
import copy
import os
from vaultBase.metaHandler import MetaHandler
from yaml import load, dump

try:
    from yaml import CLoader as Loader, CDumper as Dumper
except ImportError:
    from yaml import Loader, Dumper


class TemplateGenerator:
    """
    Generates sql files from templates using metadata supplied in a configuration file.
    """

    def __init__(self, logger, con_reader):

        self._my_log = logger
        self.config = con_reader.get_config_dict()
        self.additional_file_dict = self.get_additional_file_metadata()
        self.sim_dates = self.get_simulation_dates()

        if isinstance(self.additional_file_dict, dict):

            self.metahandler = MetaHandler(self._my_log, self.additional_file_dict)
            self.metadata = self.metahandler.get_metadata_dict()
            self.update_config()

        self.active_config = self.find_active_tables()

    @staticmethod
    def hub_template(hub_columns, stg_columns1, stg_columns2, hub_pk, stg_name, tags):
        """
        The template for building hub sql statements for DBT.
        :param hub_columns: The target table columns.
        :param stg_columns1: The stage columns used the first sub query that involves the lead statement.
        :param stg_columns2: The stage columns but used in the second sub query when joining the stage and target
                             table on keys that only exist in the stage.
        :param hub_pk: The target table primary key.
        :param stg_name: The name of the staging table.
        :param tags: The tags for DBT to run certain models only.
        :return: The sql statement as a string ready to be written to a file.
        """

        if isinstance(tags, str):
            tags = "'{}'".format(tags)

        hub_statement = ("{{{{config(materialized='incremental', schema='VLT', enabled=true, tags={tags})}}}}\n\n"
                         "{{% set hub_columns = '{hub_columns}' %}}\n"
                         "{{% set stg_columns1 = '{stg_columns1}' %}}\n"
                         "{{% set stg_columns2 = '{stg_columns2}' %}}\n"
                         "{{% set hub_pk = '{hub_pk}' %}}\n"
                         "{{% set stg_name = '{stg_name}' %}}\n\n"
                         "{{{{ hub_template(hub_columns, stg_columns1, hub_pk) }}}}\n\n"
                         "{{% if is_incremental() %}}\n\n"
                         "(select\n {{{{stg_columns2}}}} \nfrom {{{{ref(stg_name)}}}} as a \n"
                         "left join {{{{this}}}} as c on a.{{{{hub_pk}}}}=c.{{{{hub_pk}}}} and c.{{{{hub_pk}}}} "
                         "is null) as b) as stg \n"
                         "where stg.{{{{hub_pk}}}} not in (select {{{{hub_pk}}}} from {{{{this}}}}) "
                         "and stg.FIRST_SEEN is null\n\n"
                         "{{% else %}}\n\n"
                         "{{{{ref(stg_name)}}}} as b) as stg where stg.FIRST_SEEN is null\n\n"
                         "{{% endif %}}").format(tags=tags,
                                                 hub_columns=hub_columns,
                                                 stg_columns1=stg_columns1,
                                                 stg_columns2=stg_columns2,
                                                 hub_pk=hub_pk,
                                                 stg_name=stg_name)
        return hub_statement

    @staticmethod
    def hub_macro_template():
        """
        The template for building the hub macro sql file that the hub sql files use.
        :return: A sql statement as a string ready to be written to a file.
        """

        hub_macro_temp = ("{% macro hub_template(hub_columns, stg_columns1, hub_pk) %}\n\n "
                          "select\n"
                          "{{hub_columns}}\n "
                          "from (\n "
                          "select distinct\n "
                          "{{stg_columns1}}, \n"
                          "lag(b.LOADDATE, 1) over(partition by {{hub_pk}} order by b.loaddate) as FIRST_SEEN\n "
                          "from\n\n"
                          "{% endmacro %}")

        return hub_macro_temp

    @staticmethod
    def link_template(link_columns, stg_columns1, stg_columns2, link_pk, stg_name, tags):
        """
        The template for building the link sql statements for DBT.
        :param link_columns: The target table columns.
        :param stg_columns1: The stage columns used the first sub query that involves the lead statement.
        :param stg_columns2: The stage columns but used in the second sub query when joining the stage and target
                             table on keys that only exist in the stage.
        :param link_pk: The primary key for the target table.
        :param stg_name: The name of the stage table where the stage columns are from.
        :param tags: The tags for DBT to run certain models only.
        :return: A sql statement as a string ready to be written to a file.
        """

        if isinstance(tags, str):
            tags = "'{}'".format(tags)

        link_template = ("{{{{config(materialized='incremental', schema ='VLT', enabled=true, "
                         "tags={tags})}}}}\n\n"
                         "{{% set link_columns = '{link_columns}' %}}\n"
                         "{{% set stg_columns1 = '{stg_columns1}' %}}\n"
                         "{{% set stg_columns2 = '{stg_columns2}' %}}\n"
                         "{{% set link_pk = '{link_pk}' %}}\n"
                         "{{% set stg_name = '{stg_name}' %}}\n\n"
                         "{{{{ link_template(link_columns, stg_columns1, link_pk)}}}}\n\n"
                         "{{% if is_incremental() %}}\n\n"
                         "(select\n {{{{stg_columns2}}}}\nfrom {{{{ref(stg_name)}}}} as a\n"
                         "left join {{{{this}}}} as c on a.{{{{link_pk}}}}=c.{{{{link_pk}}}} and c.{{{{link_pk}}}} "
                         "is null) as b) as stg\n"
                         "where stg.{{{{link_pk}}}} not in (select {{{{link_pk}}}} from {{{{this}}}}) and "
                         "stg.FIRST_SEEN is null\n\n"
                         "{{% else %}}\n\n"
                         "{{{{ref(stg_name)}}}} as b) as stg where stg.FIRST_SEEN is null\n\n"
                         "{{% endif %}}").format(tags=tags,
                                                 link_columns=link_columns,
                                                 stg_columns1=stg_columns1,
                                                 stg_columns2=stg_columns2,
                                                 link_pk=link_pk,
                                                 stg_name=stg_name)

        return link_template

    @staticmethod
    def link_macro_template():
        """
        The template for building the link macor sql file that the link sql files use.
        :return: A sql statement as a string ready to be written to a file.
        """

        link_macro_temp = ("{% macro link_template(link_columns, stg_columns1, link_pk) %}\n\n"
                           "select\n {{link_columns}}\nfrom (\nselect distinct\n {{stg_columns1}},\n "
                           "lag(b.LOADDATE, 1) over(partition by {{link_pk}} order by b.LOADDATE) as FIRST_SEEN\n"
                           "from\n\n{% endmacro %}")

        return link_macro_temp

    @staticmethod
    def sat_template(sat_columns, stg_columns1, stg_columns2, sat_pk, stg_name, tags):
        """
        The template for building the satellite sql statements for DBT.
        :param sat_columns: The target table columns.
        :param stg_columns1: The stage columns used the first sub query that involves the lead statement.
        :param stg_columns2: The stage columns but used in the second sub query when joining the stage and target
                             table on keys that only exist in the stage.
        :param sat_pk: The primary key of the target table.
        :param stg_name: The name of the staging table which the stage columns are from.
        :param tags: The tags for DBT to run certain models only.
        :return: A sql statement as a string ready to be written to a file.
        """

        if isinstance(tags, str):
            tags = "'{}'".format(tags)

        sat_template = ("{{{{config(materialized='incremental', schema='VLT', enabled=true, "
                        "tags={tags})}}}}\n\n"
                        "{{% set sat_columns = '{sat_columns}' %}}\n"
                        "{{% set stg_columns1 = '{stg_columns1}' %}}\n"
                        "{{% set stg_columns2 = '{stg_columns2}' %}}\n"
                        "{{% set sat_pk = '{sat_pk}' %}}\n"
                        "{{% set stg_name = '{stg_name}' %}}\n\n"
                        "{{{{ sat_template(sat_columns, stg_columns1, sat_pk)}}}}\n\n"
                        "{{% if is_incremental() %}}\n\n(select\n {{{{stg_columns2}}}}\n"
                        "from {{{{ref(stg_name)}}}} as a\n"
                        "left join {{{{this}}}} as c on a.{{{{sat_pk}}}}=c.{{{{sat_pk}}}} and c.{{{{sat_pk}}}} is null)"
                        " as b) as stg\n"
                        "where stg.{{{{sat_pk}}}} not in (select {{{{sat_pk}}}} from {{{{this}}}}) "
                        "and stg.LATEST is null\n\n"
                        "{{% else %}}\n\n{{{{ref(stg_name)}}}} as b) as stg where stg.LATEST is null\n\n"
                        "{{% endif %}}").format(tags=tags,
                                                sat_columns=sat_columns,
                                                stg_columns1=stg_columns1,
                                                stg_columns2=stg_columns2,
                                                sat_pk=sat_pk,
                                                stg_name=stg_name)

        return sat_template

    @staticmethod
    def sat_macro_template():
        """
        The template for building the satellite macro sql file that the satellite sql file uses.
        :return: A sql statement as a string ready to be written to a file.
        """

        sat_macro_temp = ("{% macro sat_template(sat_columns, stg_columns1, sat_pk) %}\n\n"
                          "select\n {{sat_columns}}\nfrom (\nselect distinct\n {{stg_columns1}},\n "
                          "lead(b.LOADDATE, 1) over(partition by b.{{sat_pk}} order by b.LOADDATE) as LATEST\n"
                          "from\n\n{% endmacro %}")

        return sat_macro_temp

    @staticmethod
    def dbt_yaml_project_template(history, date):
        """
        Generates a template yaml structure which can be passed on and written to a file for dbt.
        Currently this will not be used in the current version of the Snowflake Demonstrator until future
        development is done in generalising this more.
        :param history: The date from which the history will be built from.
        :param date: The date from which the day load will be built from.
        :return: A string of the yaml structure ready to be written to a yaml file.
        """

        document = """
        name: 'snowflakeDemo'
        version: '1.0'
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
                history_date: {}
                date: {}
                
            snowflake_demo:
                source_creation:
                    enabled: true
                    materialized: "incremental"
                
                stg:
                    enabled: true
                    materialized: view
                    
                hub_sat_link_load:
                    enabled: true 
                    materialized: incremental
                
                feature_sql_files:
                    enabled: false
                    materialized: incremental
                
                star_schema:
                    enabled: true
                    materialized: view
        """.format(history, date)

        return document

    @staticmethod
    def stg_template(section_dict, tags):
        """
        Creates the template for the stage.
        :param section_dict: A dictionary containing the information from the config about a particular stage only.
        :param tags: The tags for DBT to run certain models only.
        :return: An sql string that can be written to a file.
        """
        if isinstance(tags, str):
            tags = "'{}'".format(tags)

        stg_template = ("{{{{ config(materialized='view', schema='STG', tags={}, enabled=true) }}}}"
                        "\n\nselect\n ").format(tags)

        hash_list = []

        for key in section_dict:

            if key == 'stg_table' or key == 'isactive' or key == 'name' or key == 'tags':

                pass

            elif isinstance(section_dict[key], str) and ',' not in section_dict[key]:

                hash_list.append("{{{{ md5_binary('{}', '{}') }}}}".format(section_dict[key], key.upper()))

            else:

                hash_list.append("{{{{ md5_binary_concat({}, '{}') }}}}".format(sorted(section_dict[key]), key.upper()))

        stg_template += ", \n".join(hash_list) + (",\n *, {{{{var('date')}}}} AS LOADDATE, {{{{var('date')}}}} AS "
                                                  "EFFECTIVE_FROM, 'TPCH' AS SOURCE FROM {{{{ref('{}')}}}}"
                                                  ).format(section_dict['stg_table'])

        return stg_template

    @staticmethod
    def md5_binary_macro():
        """
        The template for building the md5_binary macro sql file that the staging sql files use.
        :return: A sql statement as a string ready to be written to a file.
        """

        md5_binary_temp = ("{% macro md5_binary(column, alias) %}\n\n"
                           "MD5_BINARY(UPPER(TRIM(CAST({{column}} AS VARCHAR)))) AS {{alias}}\n\n"
                           "{% endmacro %}")
        return md5_binary_temp

    @staticmethod
    def md5_binary_concat_macro():
        """
        The template for building the md5_binary_concat macro sql file that the staging sql files use.
        :return: A sql statement as a string ready to be written to a file.
        """

        md5_binary_concat_temp = ("{% macro md5_binary_concat(columns, alias) %}\n\nMD5_BINARY(CONCAT(\n\n"
                                  "{% for column in columns -%}\n\n"
                                  "IFNULL(UPPER(TRIM(CAST({{column}} AS VARCHAR))), '^^'), '||',\n\n"
                                  "{%- if loop.last -%}\n\n"
                                  "IFNULL(UPPER(TRIM(CAST({{column}} AS VARCHAR))), '^^')\n\n"
                                  "{%- endif %}\n\n"
                                  "{% endfor -%}\n\n"
                                  ")) AS {{alias}}\n\n"
                                  "{% endmacro %}")
        return md5_binary_concat_temp

    @staticmethod
    def alias_adder(alias, column_list):
        """
        Adds an alias at the start of column names for the sql statements.
        :param alias: The alias as a string.
        :param column_list: The list of columns that the alias will be added.
        :return: A list where the aliases have been added to each element.
        """

        return [(alias + "." + column) for column in column_list]

    @staticmethod
    def data_type_forcer(table_columns, aliased_table_columns, data_types):
        """
        Creates a list of strings that forces the data types to the columns in the sql.
        :param table_columns: The raw column names to be forced.
        :param aliased_table_columns: The aliased column names to be forced.
        :param data_types: Data for for each column.
        :return: A list with each element cast to specific data type (for sql).
        """

        return ["CAST({} AS {}) AS {}".format(aliased_table_columns[index], data_types[index], column)
                for index, column in enumerate(table_columns)]

    def find_active_tables(self):
        """
        Finds all the active table metadata in the config dict and removes them if they're inactive.
        :return: A dictionary containing only active table metadata.
        """

        new_config = copy.deepcopy(self.config)
        table_sections = self.get_table_section_keys()

        for section in table_sections:

            keys = list(new_config[section].keys())

            for table in keys:

                if new_config[section][table]['isactive'] == 'False':

                    del new_config[section][table]

                else:

                    pass

        return new_config

    def get_additional_file_metadata(self):
        """
        Gets a dictionary of just the additional file metadata if it exists.
        :return: A dictionary of the additional file.
        """

        try:

            additional_file_metadata = self.config["additional files"]

            return additional_file_metadata

        except KeyError:

            self._my_log.log("A key error occurred of 'additional_files' not found. If no additional files were "
                             "provided then ignore this message.", logging.WARNING)

            return False

    def update_config(self):
        """
        Updates the config dictionary with the hubs, links, satellite metadata from the additional files.
        """

        for file in self.metadata:

            for table_type in self.metadata[file]:

                self.config[table_type].update(self.metadata[file][table_type])

    def get_simulation_dates(self):
        """
        Gets the dates for which the simulation will iterate over.
        :return: The simulation dates in a dictionary.
        """

        return {key: ("TO_DATE('{}')".format(date)) for (key, date) in self.config['simulation dates'].items()
                if key != "dbt_path"}

    def get_dbt_project_path(self):
        """
        Gets the dbt project file path. Currently unused until DBT project yml file is updated.
        :return: the path for the dbt project file to be created.
        """

        return self.config['simulation dates']['dbt_path'] + 'dbt_project.yml'

    def get_table_section_keys(self):
        """
        Gets a list of keys of the section headings required to build the statements (excludes log settings,
        version, simulation dates, dbt settings, and additional files).
        :return: A list of section heading keys.
        """

        return [key for key in list(self.config.keys()) if key == 'hubs' or key == 'links' or key == 'satellites'
                or key == 'hashing']

    def get_table_header_keys(self, table_sections):
        """
        Gets the keys of all the tables listed in the config file.
        :param table_sections: The sections of the config that contain the metadata for the tables.
        :return:The keys in a dictionary as nested lists.
        """

        table_dict = {}

        for table in table_sections:

            table_dict[table] = list(self.active_config[table].keys())

        return table_dict

    def get_table_name_values(self, table_sections):
        """
        Gets the values for the table name in each section listed in the config file.
        :param table_sections: The sections of the config that contain the metadata for the tables.
        :return: The values in nested lists in a dictionary.
        """

        table_dict = {}

        for table_section in table_sections:

            table_dict[table_section] = []

            for table in self.config[table_section]:

                table_dict[table_section].append(self.config[table_section][table]["name"])

        return table_dict

    def get_table_file_path(self, table_section, table_key, dbt_dir):
        """
        Gets the file path to write the sql file in the dbt model.
        :param table_section: The section key of the config that contain the metadata for the tables.
        :param table_key: The key for the individual table.
        :param dbt_dir: The key for the particular DBT directory path specified in the config.
        :return: A string of the DBT file path to write the model.
        """

        return (self.config['dbt settings'][dbt_dir] + "/{}.sql".format(self.get_table_name(table_section,
                                                                                            table_key)))

    def get_table_name(self, table_section, table_key):
        """
        Gets the name of the table that the sql is being generated for and returns it as a string.
        :param table_section: The section key of the config that contain the metadata for the tables.
        :param table_key: The key for the individual table.
        :return: Name of table as string.
        """

        return self.config[table_section][table_key]["name"]

    def get_stg_table_name(self, table_section, table_key):
        """
        Gets the name of the stage table needed to build the sql statement.
        :param table_section: The section key of the config that contain the metadata for the tables.
        :param table_key: The key for the individual table.
        :return: stage table name as a string.
        """

        return self.config[table_section][table_key]["stg_name"]

    def get_pk(self, table_section, table_key):
        """
        Gets the target table primary key from the config file.
        :param table_section: The section key of the config that contain the metadata for the tables.
        :param table_key: The key for the individual table.
        :return: The table primary key column as a string.
        """

        return self.config[table_section][table_key]["pk"]

    def get_data_types(self, table_section, table_key):
        """
        Formats and gets the data types for the target table columns from the config.
        :param table_section: The section key of the config that contain the metadata for the tables.
        :param table_key: The key for the individual table.
        :return: The data types as a list.
        """
        new_list = []

        for item in self.config[table_section][table_key]["data_types"]:

            new_list.append(item.replace("~", ","))

        self.config[table_section][table_key]["data_types"] = new_list

        return self.config[table_section][table_key]["data_types"]

    def get_table_columns(self, table_section, table_key):
        """
        Formats and gets the table columns required for the sql statement.
        :param table_section: The section key of the config that contain the metadata for the tables.
        :param table_key: The key for the individual table.
        :return: The table columns as a string.
        """

        table_columns = self.config[table_section][table_key]["table_columns"]

        data_types = self.get_data_types(table_section, table_key)

        if isinstance(table_columns, str):

            table_columns = table_columns.split(", ")

            aliased_table_columns = self.alias_adder("stg", table_columns)

            data_type_forced_columns = self.data_type_forcer(table_columns, aliased_table_columns, data_types)

        else:

            aliased_table_columns = self.alias_adder("stg", table_columns)

            data_type_forced_columns = self.data_type_forcer(table_columns, aliased_table_columns, data_types)

        return ", \n".join(data_type_forced_columns)

    def get_stg_columns(self, table_section, table_key, alias):
        """
        Formats and gets the stage columns required to build the sql statements.
        :param table_section: The section key of the config that contain the metadata for the tables.
        :param table_key: The key for the individual table.
        :param alias: The alias assigned to the stage columns.
        :return: The stage columns as a string.
        """

        stg_columns = self.config[table_section][table_key]["stg_columns"]

        if isinstance(stg_columns, str):

            stg_columns = stg_columns.split(", ")

            aliased_stg_columns = self.alias_adder(alias, stg_columns)

            return ", \n".join(aliased_stg_columns)
        else:

            aliased_stg_columns = self.alias_adder(alias, stg_columns)

            return ", \n".join(aliased_stg_columns)

    def get_tags(self, table_section, table_key):
        """
        Gets the tags for each model.
        :param table_section: The section key of the config that contain the metadata for the tables.
        :param table_key: The key for the individual table.
        :return: returns the tags as either a string or a list.
        """

        return self.active_config[table_section][table_key]['tags']

    def write_to_file(self, path, statement):
        """
        Writes the generated statement to a file in the specified directory.
        :param path: The path to write file.
        :param statement: The generated statement.
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
        Gets the statement and creates the files in the correct dbt directories.
        """

        table_sections = self.get_table_section_keys()
        table_keys = self.get_table_header_keys(table_sections)

        for table_key in table_keys:

            for table in table_keys[table_key]:

                try:

                    if table_key == 'hubs':

                        statement = self.hub_template(self.get_table_columns(table_key, table),
                                                      self.get_stg_columns(table_key, table, "b"),
                                                      self.get_stg_columns(table_key, table, "a"),
                                                      self.get_pk(table_key, table),
                                                      self.get_stg_table_name(table_key, table),
                                                      self.get_tags(table_key, table))

                    elif table_key == 'links':

                        statement = self.link_template(self.get_table_columns(table_key, table),
                                                       self.get_stg_columns(table_key, table, "b"),
                                                       self.get_stg_columns(table_key, table, "a"),
                                                       self.get_pk(table_key, table),
                                                       self.get_stg_table_name(table_key, table),
                                                       self.get_tags(table_key, table))

                    elif table_key == 'satellites':

                        statement = self.sat_template(self.get_table_columns(table_key, table),
                                                      self.get_stg_columns(table_key, table, "b"),
                                                      self.get_stg_columns(table_key, table, "a"),
                                                      self.get_pk(table_key, table),
                                                      self.get_stg_table_name(table_key, table),
                                                      self.get_tags(table_key, table))

                    else:

                        statement = self.stg_template(self.active_config[table_key][table],
                                                      self.get_tags(table_key, table))
                        path = self.get_table_file_path(table_key, table, 'stg_path')
                        self._my_log.log("Writing {} template to file in dbt directory...".format(table), logging.INFO)
                        self.write_to_file(path, statement)
                        self._my_log.log("Successfully written sql to file.", logging.INFO)
                        continue

                    path = self.get_table_file_path(table_key, table, 'vault_path')
                    self._my_log.log("Writing {} template to file in dbt directory...".format(table), logging.INFO)
                    self.write_to_file(path, statement)
                    self._my_log.log("Successfully written sql to file.", logging.INFO)

                except KeyError:

                    self._my_log.log(("A KeyError was detected in constructing the {} file from the template. "
                                      "The creation of this file was skipped. Please check the config file.").format(table),
                                     logging.ERROR)

    def create_dbt_project_file(self, history_date, date):
        """
        Gets the yaml statement and dumps it into a yaml file This feature is currently disabled
        in the Snowflake Demonstrator.
        :param history_date: The date from which the history will be built from.
        :param date: The date from which the day load will be built from.
        """

        path = self.get_dbt_project_path()
        document = self.dbt_yaml_project_template(history_date, date)
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

    def create_template_macros(self):
        """
        Creates the macros in the correct location in dbt.
        """
        path = self.config["dbt settings"]["macro_path"]

        self._my_log.log("Creating macros...", logging.INFO)

        self.write_to_file(path + '/hub_template.sql', self.hub_macro_template())
        self.write_to_file(path + "/link_template.sql", self.link_macro_template())
        self.write_to_file(path + "/sat_template.sql", self.sat_macro_template())
        self.write_to_file(path + "/md5_binary.sql", self.md5_binary_macro())
        self.write_to_file(path + "/md5_binary_concat.sql", self.md5_binary_concat_macro())

        self._my_log.log("Macros created.", logging.INFO)

    def clean_files(self):
        """
        Clears the dbt folder of any files related to the files being generated.
        """

        [os.remove(os.path.join(self.config['dbt settings']['vault_path'], file)) for file in os.listdir(
            self.config['dbt settings']['vault_path']) if 'hub' in file or 'link' in file or 'sat' in file]
