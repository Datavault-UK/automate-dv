from pandas import DataFrame


def column_count(context, database, schema, table, num_columns):
    sql = ("SELECT COUNT(COLUMN_NAME) AS COLUMN_COUNT FROM {}.INFORMATION_SCHEMA.COLUMNS "
           "WHERE TABLE_CATALOG = '{}' "
           "AND TABLE_SCHEMA = '{}' "
           "AND TABLE_NAME = '{}';".format(database, database, schema, table))

    result = context.testdata.general_sql_statement_to_df(sql)

    if int(result['COLUMN_COUNT'][0]) == num_columns:
        return True
    else:
        return False


def compare_ct_to_db_table(context, table_path, hub=None):
    """
    Compares the context table to the table that exists on the database.
    """
    table_df = context.testdata.context_table_to_df(context.table)

    if hub:
        select = "SELECT CAST(CUSTOMER_PK AS VARCHAR(32)) AS CUSTOMER_PK, CUSTOMERKEY, LOADDATE, SOURCE"
        result_df = DataFrame(context.testdata.get_hub_table_data(select, table_path), dtype=str)

        table_df.columns = map(str.upper, table_df.columns)
        result_df.columns = map(str.upper, result_df.columns)
        table_df['CUSTOMER_PK'] = table_df['CUSTOMER_PK'].str.upper()

    else:
        result_df = DataFrame(context.testdata.get_table_data(table_path), dtype=str)
        result_df.columns = map(str.upper, result_df.columns)

    if result_df.equals(table_df):
        assert True
    else:
        assert False
