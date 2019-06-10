from vaultBase.connector import Connector
from vaultBase.logger import Logger
from vaultBase.cliParse import CLIParse
import sqlalchemy
import pandas as pd


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
    # con_settings = "MYSQL+pymysql://root:Password123!!@192.168.1.98/sql_tests"
    # log = Logger("connections", cli_args)
    # connector = Connector(log, con_settings)

    con_string = "mysql+pymysql://root:Password123!!@192.168.1.98/sql_tests"

    engine = sqlalchemy.create_engine(con_string)

    connection = engine.connect()

    connection.execute(statement)

    result = pd.read_sql_table("test_view_history", con_string)

    drop_view(view_name, connection)

    return result


def drop_view(view_name, connection):
    """Dropping the view after it has been returned as a panda's dataframe."""

    statement = "DROP VIEW {};".format(view_name)

    connection.execute(statement)


def csv_file_export(result, path):
    """Exports the Panda's dataframe as a CSV file."""

    result.to_csv(path, header=False)


statement = create_history_statement()
result = execute_statement("test_view_history", statement)
csv_file_export(result, "/home/dev/PycharmProjects/SnowflakeDemo/src/flatFiles/history.csv")
