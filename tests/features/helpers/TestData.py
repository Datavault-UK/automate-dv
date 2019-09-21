import json
import re
from hashlib import md5

import pandas as pd
from pandas import DataFrame
import snowflake.connector as sf
import sqlalchemy as sa
from numpy import NaN


# TODO: MOVE THIS ALL TO THE VAULTBASE
class TestData:

    def __init__(self, path):
        self.credentials = self.get_credentials(path)
        self.connection = sf.connect(user=self.credentials["user"], password=self.credentials["password"],
                                     account=self.credentials["account_name"], warehouse=self.credentials["warehouse"],
                                     database=self.credentials["database"], schema=self.credentials["schema"])
        self.con_string = ("snowflake://{user}:{password}@{account}/"
                           "{database}/{schema}?warehouse={warehouse}?"
                           "role={role}").format(user=self.credentials['user'], password=self.credentials['password'],
                                                 account=self.credentials['account_name'],
                                                 schema=self.credentials['schema'],
                                                 database=self.credentials['database'],
                                                 warehouse=self.credentials['warehouse'], role=self.credentials['role'])
        self.engine = sa.create_engine(self.con_string)
        self.cur = self.connection.cursor()

    @staticmethod
    def get_credentials(path):
        """Gets the required credentials from the json file."""

        with open(path, "r") as read_file:
            credentials = json.load(read_file)

        return credentials

    def context_table_to_df(self, table, ignore_columns=None, order_by=None):

        table_df = pd.DataFrame(columns=table.headings, data=table.rows, dtype=str)

        table_df.columns = map(str.upper, table_df.columns)

        table_df = table_df.apply(self.calc_md5)

        table_df = table_df.replace("<null>", NaN)

        cols = list(table_df.columns)
        cols.sort()
        table_df = table_df[cols]

        if ignore_columns:
            table_df.drop(ignore_columns, 1, inplace=True)

        if order_by:
            table_df.sort_values(order_by, inplace=True)
            table_df.reset_index(drop=True, inplace=True)

        return table_df

    @staticmethod
    def compare_dataframes(first_frame, second_frame):

        return first_frame.equals(second_frame)

    @staticmethod
    def df_to_dict(df, orient='dict'):

        return df.to_dict(orient=orient)

    def insert_data_from_ct(self, table, table_name, schema):
        table_df = self.context_table_to_df(table)

        table_df.columns = map(str.upper, table_df.columns)

        table_df = table_df.replace("<null>", NaN)

        table_df.to_sql(name=table_name, schema=schema, con=self.engine, index=False, if_exists='append')

    def calc_md5(self, value):

        md5_pattern = "^(?:md5\(')(.*)(?:'\))"

        for index, item in enumerate(value):

            new_item = re.findall(md5_pattern, item)

            if isinstance(new_item, list):

                if new_item:

                    hashed_item = md5(new_item[0].encode('utf-8')).hexdigest()

                    value[index] = hashed_item.upper()

        return value

    def create_schema(self, database, schema):

        sql = "CREATE SCHEMA IF NOT EXISTS {}.{}".format(database, schema)

        connection = self.engine.connect()

        try:
            connection.execute(sql)
        finally:
            connection.close()

    def drop_and_create(self, database, schema, table_name, columns, materialise="table"):

        self.drop_table(database, schema, table_name, materialise)

        self.create_table(database, schema, table_name, columns, materialise)

    def drop_table(self, database, schema, table_name, materialise):

        if materialise.lower() == "view":

            sql = "DROP VIEW IF EXISTS {}"

        else:

            sql = "DROP TABLE IF EXISTS {}"

        execute_sql = sql.format(database + "." + schema + "." + table_name)

        connection = self.engine.connect()

        try:
            connection.execute(execute_sql)
        finally:
            connection.close()

    def create_table(self, database, schema, table_name, columns, materialise, ref_table=None):

        if materialise.lower() == "view":

            sql = "CREATE VIEW IF NOT EXISTS {} AS SELECT ({}) FROM {} WHERE 1=0"

            execute_sql = sql.format(database + "." + schema + "." + table_name, ", ".join(columns), ref_table)

        else:

            sql = "CREATE TABLE IF NOT EXISTS {} ({})"

            execute_sql = sql.format(database + "." + schema + "." + table_name, ", ".join(columns))

        connection = self.engine.connect()

        try:
            connection.execute(execute_sql)
        finally:
            connection.close()

    def general_sql_statement_to_df(self, query):

        result_df = pd.read_sql(query, self.engine)
        result_df.columns = map(str.upper, result_df.columns)

        return result_df

    def execute_sql_from_file(self, filepath):

        with open(filepath, 'r', encoding='utf-8') as f:
            for cur in self.connection.execute_stream(f):
                for ret in cur:
                    print(ret)

    def get_table_data(self, *, database, full_table_name, binary_columns=None,
                       ignore_columns=None, order_by=None) -> pd.DataFrame:
        """
        Gets the provided table's data as a Dataframe
            :param database: The name of the database containing the required table
            :type database: str
            :param full_table_name: Name of the table to query, including DB and schema
            :type full_table_name: str
            :param binary_columns: A list of columns to be converted from BINARY to VARCHAR (hash columns)
            :type binary_columns: list
            :return: Dataframe containing the data for the provided table
        """

        sql = "SELECT {} FROM {}"

        if binary_columns:

            columns = self.create_hash_casts(binary_columns)
        else:
            columns = "*"

        table_name = full_table_name.split(".")[2]
        other_cols = self.get_column_list_for_table(database, table_name)

        diff = list(set(binary_columns).symmetric_difference(set(other_cols)))
        columns = columns + ", " + ", ".join(diff)

        sql = sql.format(columns, full_table_name)

        result = DataFrame(pd.read_sql_query(sql, self.engine), dtype=str)
        result.columns = map(str.upper, result.columns)

        cols = list(result.columns)
        cols.sort()
        result = result[cols]

        if ignore_columns:
            result.drop(ignore_columns, 1, inplace=True)

        if order_by:
            result.sort_values(order_by, inplace=True)
            result.reset_index(drop=True, inplace=True)

        return result

    @staticmethod
    def create_hash_casts(columns) -> str:
        """
        Creates a SQL string with provided columns cast to VARCHAR(32)
        :param columns: A list of columns to be surrounded with casts
        :type columns: list
        :return: A string of generated casts
        """

        cast = "CAST({} AS VARCHAR(32)) AS {}"

        generated_sql = []

        for column in columns:

            column = column.upper()

            generated_sql.append(cast.format(column, column))

        return ", ".join(generated_sql)

    def get_column_list_for_table(self, schema, table_name) -> list:
        """
        Gets a list of columns contained in the table with the given table name, from the given
        schema
        :param schema: Name of the schema
        :type schema: str
        :param table_name: Name of the table
        :type table_name: str
        :return: A list of column names
        """

        sql = "SELECT COLUMN_NAME FROM {}.INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = '{}'".format(schema, table_name.upper())

        result = pd.read_sql_query(sql, self.engine)

        return list(result['column_name'])

    # TODO: Make this more generic (e.g. Run a SQL statement)
    def get_hub_table_data(self, select, table_name):

        sql = "{} FROM {}".format(select, table_name)

        result = pd.read_sql_query(sql, self.engine)

        return result

    def close_connection(self):

        self.engine.connect().close()

        self.engine.dispose()
