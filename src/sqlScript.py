# from vaultBase.connector import Connector
# from vaultBase.logger import Logger
# from vaultBase.cliParse import CLIParse
import sqlalchemy
import pandas as pd
import snowflake.connector as sf
import json

def create_history_statement():
    """Creating a sql statement to create a view of the history of the data."""

    history_statement = ("CREATE VIEW test_view_history AS "
                         "SELECT l.orderkey, l.quantity, "
                         "CASE "
                         "WHEN l.shipdate > '2010-01-10' THEN NULL "
                         "ELSE l.shipdate "
                         "END AS shipdate, "
                         "CASE "
                         "WHEN l.commitdate > '2010-01-10' THEN NULL "
                         "ELSE l.commitdate "
                         "END AS commitdate, "
                         "CASE "
                         "WHEN l.receiptdate > '2010-01-10' THEN NULL "
                         "ELSE l.receiptdate "
                         "END AS receiptdate, "
                         "o.orderdate, o.comment "
                         "FROM lineitem AS l "
                         "LEFT JOIN orders AS o ON l.orderkey=o.orderkey "
                         "WHERE o.orderdate <= '2010-01-10';")
    return history_statement


def create_day_statement():
    """Creating a sql statement to create a view for a day of data."""

    day_statement = ("CREATE VIEW test_view_history AS "
                     "SELECT l.orderkey, l.quantity, "
                     "CASE "
                     "WHEN l.shipdate > '2010-01-10' THEN NULL "
                     "ELSE l.shipdate "
                     "END AS shipdate, "
                     "CASE "
                     "WHEN l.commitdate > '2010-01-10' THEN NULL "
                     "ELSE l.commitdate "
                     "END AS commitdate, "
                     "CASE "
                     "WHEN l.receiptdate > '2010-01-10' THEN NULL "
                     "ELSE l.receiptdate "
                     "END AS receiptdate, "
                     "o.orderdate, o.comment "
                     "FROM lineitem AS l "
                     "LEFT JOIN orders AS o ON l.orderkey=o.orderkey "
                     "WHERE o.orderdate BETWEEN '2010-01-10' AND '2010-01-15';")

    return day_statement


def execute_statement(view_name, statement):
    """Executing the sql statements against the database (currently a mysql database)."""

    # program_name = 'sqlScript'
    #
    # cli_args = CLIParse('Generates and executes sql statements', program_name)
    # con_settings = "mysql+pymysql://root:Password123!!@192.168.1.98/sql_tests"
    # log = Logger("connections", cli_args)
    # connector = Connector(log, con_settings)
    #
    # connector.query(statement)

    con_settings = "mysql+pymysql://root:Password123!!@192.168.1.98/sql_tests"

    engine = sqlalchemy.create_engine(con_settings)

    connector = engine.connect()

    connector.execute(statement)

    result = pd.read_sql_table(view_name, con_settings)

    drop_view(view_name, connector)

    return result


def drop_view(view_name, connector):
    """Dropping the view after it has been returned as a panda's dataframe."""

    statement = "DROP VIEW {};".format(view_name)

    connector.execute(statement)


def csv_file_export(result, path):
    """Exports the Panda's dataframe as a CSV file."""

    result.to_csv(path)


def snowflake_connector(path, query):
    "Connects to the Snowflake database."

    credentials = get_credentials(path)

    connection = sf.connect(user=credentials["user"],
                            password=credentials["password"],
                            account=credentials["account_name"],
                            warehouse=credentials["warehouse"],
                            database=credentials["database"],
                            schema=credentials["schema"])

    cur = connection.cursor(sf.DictCursor)
    try:
        results = cur.execute(query)
        results_df = pd.DataFrame(results.fetchall())
        print(results_df)
    finally:
        cur.close()
    print(type(cur))


def get_credentials(path):
    """Gets the required credentials from the json file."""

    with open(path, "r") as read_file:
        credentials = json.load(read_file)

    return credentials

# def snowflake_type_to_dict(sf_type):
#
#     results_dict = {}
#
#     for row in sf_type:



# statement = create_history_statement()
# result = execute_statement("test_view_history", statement)
# csv_file_export(result, "/home/dev/PycharmProjects/SnowflakeDemo/src/flatFiles/history.csv")
query = "SELECT * FROM NATION_SF_10 LIMIT 10"
snowflake_connector("./configs/credentials.json", query)
