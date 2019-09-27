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


