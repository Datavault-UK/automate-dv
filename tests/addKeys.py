import sqlalchemy as sa
import pandas as pd
from toolz import pipe
# import sqlFunctionLibrary as sql
# import multiprocessing as mp


# def query_db(query):
#     engine = engine_setup("../configs/credentials.json")
#     pd.read_sql_query(query, engine)
#
#
# def engine_setup(path):
#
#     credentials = sql.get_credentials(path)
#
#     return sql.snowflake_connector(credentials)
#
#
# sql_queries = sql.read_in_file("PK_add.sql")
# pool = mp.Pool(mp.cpu_count())
# pool.map(query_db, sql_queries)

class KeyAdder:

    def __init__(self, logger, con_reader):
        self._my_log = logger
        self.config = con_reader.get_config_dict()
        self.connection_details = self.get_connection_settings()
        self.con_string = ("snowflake://{user}:{password}@{account}/"
                           "{database}/{schema}?warehouse={warehouse}?"
                           "role={role}").format(user=self.connection_details['user'],
                                                 password=self.connection_details['password'],
                                                 account=self.connection_details['account'],
                                                 schema=self.connection_details['schema'],
                                                 database=self.connection_details['database'],
                                                 warehouse=self.connection_details['warehouse'],
                                                 role=self.connection_details['role'])
        self.engine = sa.create_engine(self.con_string)

    @staticmethod
    def primary_key_template(table, column):
        """
        Provides a template for the addition of primary keys to the tables.
        :return: An sql statement as a string, ready for execution.
        """
        return "ALTER TABLE {} ADD PRIMARY KEY ({});".format(table, column)

    @staticmethod
    def foreign_key_template(table, key_column, reference_table, reference_column):
        """
        Provides a template for the addition of foreign keys to the tables.
        :param table: the table which the foreign key will apply.
        :param key_column: the column in the table which will become the foreign key.
        :param reference_table: the table which is being referenced for the foreign key.
        :param reference_column: the column in the reference table that will be referenced.
        :return: An sql statement as a string, ready for execution.
        """
        return "ALTER TABLE {} ADD FOREIGN KEY ({}) REFERENCES {}({});".format(table,
                                                                               key_column,
                                                                               reference_table,
                                                                               reference_column)

    def get_connection_settings(self):
        """
        Gets the connection settings from the config file.
        :return: a dictionary of the connection settings.
        """

        return self.config["connections"]["snowflake"]

    def get_primary_keys(self, table_names):
        """
        Gets the primary keys from the config file for each table.
        :return: a dictionary of primary_keys with their associated table.
        """

        pk_dict = {}

        for table in table_names:
            pk_dict[self.config["links"][table]["name"]] = self.config["links"][table]['pk']

        return pk_dict

    def get_foreign_keys(self, table_names):
        """
        Gets the foreign keys for the config file for each table.
        :return: a dictionary of foreign keys with their associated table.
        """

        fk_dict = {}

        for table in table_names:

            name = self.config["links"][table]["name"]
            fk_dict[name] = {}

            for fk in self.config["links"][table]:
                if "fk" in fk or "ref" in fk:

                    fk_dict[name][fk] = self.config["links"][table][fk]

        return fk_dict

    def get_table_name_values(self):
        """
        Gets the table name values from the config file.
        :return: A list of table names.
        """

        table_names = []

        for table in self.config["links"]:

            table_names.append(self.config["links"][table]["name"])

        return table_names

    def get_table_keys(self):

        table_keys = []

        for section in self.config:
            if section == 'hubs' or section == 'links' or section == 'satellites':
                for table_key in list(self.config[section].keys()):
                    table_keys.append(table_key)

        return table_keys

    def get_full_table_path(self, table_names):
        """
        Gets the full table path from the config file
        :return: A dictionary of full table paths.
        """

        full_path_dict = {}

        for table in table_names:

            full_path_dict[table] = self.config["links"][table]["full_table_path"]

        return full_path_dict

    def execute_primary_key_statements(self):
        """
        Executes all the primary key statements from the templates
        """

        table_names = self.get_table_name_values()
        pk_dict = self.get_primary_keys(table_names)
        full_path_dict = self.get_full_table_path(table_names)

        for table in table_names:

            table_path = full_path_dict[table] + "." + table.upper()

            pk_statement = self.primary_key_template(table_path, pk_dict[table])

            self.snowflake_connector(pk_statement)

    def execute_foreign_key_statements(self):
        """
        Executes all the foreign key statements from the templates
        """

        table_names = self.get_table_name_values()
        fk_dict = self.get_foreign_keys(table_names)
        full_path_dict = self.get_full_table_path(table_names)

        for table in table_names:

            table_path = full_path_dict[table] + "." + table.upper()

            for fk in fk_dict[table]:

                if "fk" in fk:

                    ref_table_path = full_path_dict[table] + "." + fk_dict[table]["ref_table" + fk[(len(fk) - 1)]]

                    ref_key = fk_dict[table]["ref" + fk[(len(fk)-1)]]

                    fk_statement = self.foreign_key_template(table_path, fk_dict[table][fk], ref_table_path, ref_key)

                    self.snowflake_connector(fk_statement)

    def snowflake_connector(self, query):

        pd.read_sql_query(query, self.engine)

    def build_pk_template(self, table_name):

        for table_section in self.config:
            if table_section == 'hubs' or table_section == 'links' or table_section == 'satellites':
                if table_name in list(self.config[table_section].keys()):
                    pk = self.config[table_section][table_name]["pk"]
                    full_table = self.config[table_section][table_name]["full_table_path"] + "." + \
                                 self.config[table_section][table_name]["name"]
                    break
                else:
                    pass

        sql = self.primary_key_template(full_table, pk)

        return sql

    def pk_pipe(self, key):
        return pipe(key, self.build_pk_template, self.snowflake_connector)
