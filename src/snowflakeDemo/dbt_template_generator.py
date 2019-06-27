import logging


class TemplateGenerator:

    def __init__(self, logger, con_reader):
        self._my_log = logger
        self.config = con_reader.get_config_dict()

    @staticmethod
    def hub_template(hub_columns, stg_columns, hub_pk):
        """
        Generates the hub sql statement as a string
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
    def alias_adder(alias, column_list):
        """
        Adds an alias at the start of column names for the sql statement.
        :param alias: The string that represents the alias.
        :param column_list: The list of columns that the alias will be added to (could be either a string or a list).
        :return: A list that
        """
        new_column_list = []

        if isinstance(column_list, str):
            column_list = column_list.split()

        for column in column_list:
            new_column_list.append(alias + "." + column)

        return new_column_list

    def get_hub_keys(self):
        """
        Gets the keys of all the hubs in listed in the config file.
        :return: returns the keys in a list.
        """
        return list(self.config["hubs"].keys())

    def get_hub_file_path(self, hub_key):
        """
        Gets the file path to write the sql file in the dbt model.
        :return:
        """
        file_path = self.config["hubs"][hub_key]["dbt_path"] + "/{}.sql".format(self.get_hub_name(hub_key))
        return file_path

    def get_hub_name(self, hub_key):
        """
        Gets the name of the hub that the sql is being generated for and returns it as a string.
        :return: name of hub as string.
        """

        return self.config["hubs"][hub_key]["name"]

    def get_hub_pk(self, hub_key):
        """
        Gets the hub primary key from the config file.
        :return: The hub primar key column as a string.
        """
        return self.config["hubs"][hub_key]["hub_pk"]

    def get_hub_columns(self, hub_key):
        """
        Gets the hub columns required for the sql statement.
        :return: The hub columns as a string.
        """
        hub_columns = self.config["hubs"][hub_key]["hub_columns"]

        if isinstance(hub_columns, str):

            aliased_hub_columns = self.alias_adder("stg", hub_columns)

            return " ".join(aliased_hub_columns)
        else:

            aliased_hub_columns = self.alias_adder("stg", hub_columns)

            return ", ".join(aliased_hub_columns)

    def get_stg_columns(self, hub_key):
        """
        Gets the stage columns required to build the hub.
        :return: The stage columns as a string.
        """
        stg_columns = self.config["hubs"][hub_key]["stg_columns"]

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

        for hub_key in self.get_hub_keys():

            hub_statement = self.hub_template(self.get_hub_columns(hub_key),
                                              self.get_stg_columns(hub_key),
                                              self.get_hub_pk(hub_key))
            path = self.get_hub_file_path(hub_key)
            self.write_to_file(path, hub_statement)