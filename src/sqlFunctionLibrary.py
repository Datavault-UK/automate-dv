# from vaultBase.connector import Connector
# from vaultBase.logger import Logger
# from vaultBase.cliParse import CLIParse
import sqlalchemy
import pandas as pd
import snowflake.connector as sf
import json
import os
from codecs import open


def snowflake_connector(filepath, credentials_path):
    """Connects to the Snowflake database."""

    credentials = get_credentials(credentials_path)

    connection = sf.connect(user=credentials["user"],
                            password=credentials["password"],
                            account=credentials["account_name"],
                            warehouse=credentials["warehouse"],
                            database=credentials["database"],
                            schema=credentials["schema"])

    #cur = connection.cursor()

    with open(filepath, 'r', encoding='utf-8') as f:
        for cur in connection.execute_stream(f):
            for ret in cur:
                print(ret)
    # try:
    #     results = cur.execute(query)
    #     # results_df = pd.DataFrame(results.fetchall())
    #     # print(results_df)
    # finally:
    #     cur.close()
    # #print(type(cur))


def get_credentials(path):
    """Gets the required credentials from the json file."""

    with open(path, "r") as read_file:
        credentials = json.load(read_file)

    return credentials


# def read_in_file(filepath):
#     """
#     Finds and reads in the sql file and cleans it.
#
#         :return: sql_file.
#     """
#     fd = open(filepath, 'r')
#     sql_file = fd.read()
#     fd.close()
#     sql_file = sql_file.replace('\n', "")
#     sql_file = sql_file.replace('\t', "")
#     sql_file.format("")
#     sql_commands = [command + ";" for command in sql_file.split(";") if command]
#     return sql_commands


def flat_file_view_loader(filepath, credentials_path="./configs/credentials.json"):
    """
    Puts the flat file load sql statements in an order and then executes them against the
    Snowflake database.
    """
    files = os.listdir(filepath)

    for file in files:
        if ".sql" in file:
            snowflake_connector(filepath+file, credentials_path)


# statement = create_history_statement()
# result = execute_statement("test_view_history", statement)
# csv_file_export(result, "/home/dev/PycharmProjects/SnowflakeDemo/src/flatFiles/history.csv")
# query = "SELECT * FROM NATION_SF_10 LIMIT 10"
# snowflake_connector("./configs/credentials.json", query)
