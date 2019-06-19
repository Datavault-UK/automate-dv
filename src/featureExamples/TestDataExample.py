import os

import pandas as pd
from configobj import ConfigObj
from numpy import NaN
from vaultBase.cliParse import CLIParse
from vaultBase.configReader import ConfigReader
from vaultBase.connector import Connector
from vaultBase.logger import Logger
from hashlib import md5
import re


class TestData:

    def __init__(self):
        program_name = "SnowflakeDemonstrator"

        cli_args = CLIParse("Simulates a data vault using Snowflake.", program_name)

        cli_args.set_config_name("tests/features/helpers/config/config_tests")

        self.my_log = Logger(program_name, cli_args)
        self.config = ConfigReader(self.my_log, cli_args)
        self.my_log.set_config(self.config)

        self.cons = {
            "VAULT": Connector(self.my_log, self.config.get_connection_settings("VAULT")),
            'STAGE': Connector(self.my_log, self.config.get_connection_settings("STAGE")),
            'WATERLEVEL': Connector(self.my_log, self.config.get_connection_settings("WATERLEVEL")),
            'SNOWFLAKE': Connector(self.my_log, self.config.get_connection_settings("SNOWFLAKE"))}

    def context_table_to_df(self, table):
        table_df = pd.DataFrame(columns=table.headings, data=table.rows, dtype=str)

        table_df.columns = map(str.upper, table_df.columns)

        table_df = table_df.apply(self.calc_md5)

        table_df = table_df.replace("<null>", NaN)

        return table_df

    @staticmethod
    def context_table_to_dict(table):
        table_dict = {**dict([table.headings]), **dict(table.rows)}

        return table_dict

    def config_file_from_ct(self, c_table, file_name):
        config = ConfigObj()
        config.filename = os.path.join("./tests/features/helpers/config", file_name)

        table = self.context_table_to_dict(c_table)

        for key in table:

            config[key] = table[key]

        config.write()

    @staticmethod
    def config_file_from_dict(dictionary, file_name):
        config = ConfigObj()
        config.filename = os.path.join("./tests/features/helpers/config", file_name)

        for key in dictionary:

            config[key] = dictionary[key]

        config.write()

    def calc_md5(self, value):

        md5_pattern = "^(?:md5\(')(.*)(?:'\))"

        for index, item in enumerate(value):

            new_item = re.findall(md5_pattern, item)

            if isinstance(new_item, list):

                if new_item:

                    hashed_item = md5(new_item[0].encode('utf-8')).hexdigest()

                    value[index] = hashed_item

        return value

    def insert_data_from_ct(self, table, table_name, con_name):
        table_df = self.context_table_to_df(table)

        table_df.columns = map(str.upper, table_df.columns)

        table_df = table_df.replace("<null>", NaN)

        table_df.to_sql(name=table_name, con=self.cons[con_name].get_engine(), index=False, if_exists='append')

    def drop_and_create(self, table_name, columns, con_name):
        self.drop_table(table_name, con_name)

        self.create_table(table_name, columns, con_name)

    def get_table_data(self, table_name, con_name):
        sql = "SELECT * FROM {}"

        execute_sql = sql.format(table_name)

        return self.cons[con_name].query(execute_sql)

    def get_waterlevel_for_table(self, table_name):

        df = self.cons['WATERLEVEL'].query(
            "SELECT LOAD_DATETIME FROM WATERLEVEL WHERE TABLE_NAME = '{}'".format(table_name))

        return df['LOAD_DATETIME'][0]

    def set_waterlevel_for_table(self, table_name, waterlevel):

        sql = "INSERT INTO WATERLEVEL VALUES('{table_name}', '{waterlevel}')".format(table_name=table_name,
                                                                                     waterlevel=waterlevel)

        self.cons['WATERLEVEL'].execute("TRUNCATE TABLE WATERLEVEL;")
        self.cons['WATERLEVEL'].execute(sql)

    def create_table(self, table_name, columns, con_name):
        sql = "CREATE TABLE IF NOT EXISTS {} ({})"

        execute_sql = sql.format(table_name, ", ".join(columns))

        self.cons[con_name].execute(execute_sql)

    def drop_table(self, table_name, con_name):
        sql = "DROP TABLE IF EXISTS {}"

        execute_sql = sql.format(table_name)

        try:
            self.cons[con_name].execute(execute_sql)
        except Warning:
            pass

    def drop_view(self, view_name, con_name):
        sql = "DROP VIEW IF EXISTS {}"

        execute_sql = sql.format(view_name)

        try:
            self.cons[con_name].execute(execute_sql)
        except Warning:
            pass

    def create_non_null_view_from_table(self, table_name, pk_list, con_name):

        sql = "CREATE VIEW {}_view AS SELECT * FROM {} WHERE {}"

        pk_sql = "{} IS NOT NULL"

        pk_string = " AND ".join(pk_sql.format(pk) for pk in pk_list)

        execute_sql = sql.format(table_name, table_name, pk_string)

        self.cons[con_name].execute(execute_sql)

    def truncate_table(self, table_name, con_name):
        sql = "TRUNCATE TABLE {}"

        execute_sql = sql.format(table_name)

        try:
            self.cons[con_name].execute(execute_sql)
        except Warning:
            pass
