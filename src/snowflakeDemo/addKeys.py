import sqlalchemy as sa
import pandas as pd
import sqlFunctionLibrary as sql
import multiprocessing as mp


def query_db(query):
    engine = engine_setup("../configs/credentials.json")
    pd.read_sql_query(query, engine)


def engine_setup(path):

    credentials = sql.get_credentials(path)

    return sql.snowflake_connector(credentials)


sql_queries = sql.read_in_file("PK_add.sql")
pool = mp.Pool(mp.cpu_count())
pool.map(query_db, sql_queries)
