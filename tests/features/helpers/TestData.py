import pandas as pd
import snowflake.connector as sf
from numpy import NaN
from hashlib import md5
import re
import json


class TestData:

    def __init__(self):
        self.credentials = self.get_credentials("./credentials.json")
        self.connection = sf.connect(user=self.credentials["user"],
                                     password=self.credentials["password"],
                                     account=self.credentials["account_name"],
                                     warehouse=self.credentials["warehouse"],
                                     database=self.credentials["database"],
                                     schema=self.credentials["schema"])
        self.cur = self.connection.cursor()

    @staticmethod
    def get_credentials(path):
        """Gets the required credentials from the json file."""

        with open(path, "r") as read_file:
            credentials = json.load(read_file)

        return credentials

    def context_table_to_df(self, table):
        table_df = pd.DataFrame(columns=table.headings, data=table.rows, dtype=str)

        table_df.columns = map(str.upper, table_df.columns)

        table_df = table_df.apply(self.calc_md5)

        table_df = table_df.replace("<null>", NaN)

        return table_df

    def calc_md5(self, value):

        md5_pattern = "^(?:md5\(')(.*)(?:'\))"

        for index, item in enumerate(value):

            new_item = re.findall(md5_pattern, item)

            if isinstance(new_item, list):

                if new_item:

                    hashed_item = md5(new_item[0].encode('utf-8')).hexdigest()

                    value[index] = hashed_item

        return value

    def drop_and_create(self, database, schema, table_name, columns, materialise="table"):

        self.drop_table(database, schema, table_name, materialise)

        self.create_table(database, schema, table_name, columns, materialise)

    def drop_table(self, database, schema, table_name, materialise):

        if materialise.lower() == "view":

            sql = "DROP VIEW IF EXISTS {}"

        else:

            sql = "DROP TABLE IF EXISTS {}"

        execute_sql = sql.format(database+"."+schema+"."+table_name)

        try:
            self.cur.execute(execute_sql)
        except Warning:
            pass

    def create_table(self, database, schema, table_name, columns, materialise, ref_table=None):

        if materialise.lower() == "view":

            sql = "CREATE VIEW IF NOT EXISTS {} AS SELECT ({}) FROM {} WHERE 1=0"

            execute_sql = sql.format(database+"."+schema+"."+table_name, ", ".join(columns), ref_table)

        else:

            sql = "CREATE TABLE IF NOT EXISTS {} ({})"

            execute_sql = sql.format(database+"."+schema+"."+table_name, ", ".join(columns))

            self.cur.execute(execute_sql)