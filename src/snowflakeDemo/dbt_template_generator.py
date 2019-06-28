import logging


class TemplateGenerator:

    def __init__(self, logger, con_reader):
        self._my_log = logger
        self.config = con_reader.get_config_dict()

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
                          "(\nSELECT {}, "
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

    def get_table_section_keys(self):
        """
        Gets a list of keys of the section headings required to build the statements (excludes log settings,
        version, and connection settings).
        :return: a list of headings.
        """

        return [key for key in list(self.config.keys()) if key == 'hubs' or key == 'links' or key =='satellite']

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
        Gets the name of the hub that the sql is being generated for and returns it as a string.
        :return: name of hub as string.
        """

        return self.config[table_section][table_key]["name"]

    def get_hub_pk(self, table_section, table_key):
        """
        Gets the hub primary key from the config file.
        :return: The hub primary key column as a string.
        """
        return self.config[table_section][table_key]["pk"]

    def get_hub_columns(self, table_section, table_key):
        """
        Gets the hub columns required for the sql statement.
        :return: The hub columns as a string.
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
        Gets the stage columns required to build the hub.
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
                statement = self.hub_template(self.get_hub_columns(table_key, table),
                                              self.get_stg_columns(table_key, table),
                                              self.get_hub_pk(table_key, table))
                path = self.get_table_file_path(table_key, table)
                self.write_to_file(path, statement)
