from pandas import DataFrame


def column_count(context, database, schema, table, num_columns):

    sql = ("SELECT COUNT(COLUMN_NAME) AS COLUMN_COUNT FROM DV_PROTOTYPE_DB.INFORMATION_SCHEMA.COLUMNS "
           "WHERE TABLE_CATALOG = '{}' "
           "AND TABLE_SCHEMA = '{}' "
           "AND TABLE_NAME = '{}';".format(database, schema, table))

    result = context.testdata.general_sql_statement_to_df(sql)

    if result['COLUMN_COUNT'][0] == num_columns:
        return True
    else:
        return False


def compare_ct_to_db_table(context, table_path):
    """
    Compares the context table to the table that exists on the database.
    """
    table_df = context.testdata.context_table_to_df(context.table)
    result_df = DataFrame(context.testdata.get_table_data(table_path), dtype=str)

    if result_df.equals(table_df):
        assert True
    else:
        assert False
