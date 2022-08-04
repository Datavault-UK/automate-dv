import logging
import re
from hashlib import md5, sha256

import pandas as pd
from behave.model import Table
from numpy import NaN
from pandas import Series

import test
from env import env_utils


def context_table_to_df(table: Table, use_nan=True) -> pd.DataFrame:
    """
    Converts a context table in a feature file into a pandas DataFrame
        :param table: The context.table from a scenario
        :param use_nan: Replace <null> placeholder with NaN
        :return: DataFrame representation of the provided context table
    """

    table_df = pd.DataFrame(columns=table.headings, data=table.rows)

    table_df = table_df.apply(calc_hash)
    table_df = table_df.apply(parse_hashdiffs)
    table_df = table_df.apply(parse_escapes)
    table_df = table_df.apply(parse_lists)

    if use_nan:
        table_df = table_df.replace("<null>", NaN)

    return table_df


def context_table_to_csv(table: Table, model_name: str) -> str:
    """
    Converts a context table in a feature file into CSV format
        :param table: The context.table from a scenario
        :param model_name: Name of the model to create
        :return: Name of csv file (minus extension)
    """

    table_df = context_table_to_df(table)

    csv_fqn = test.TEMP_SEED_DIR / f'{model_name.lower()}_seed.csv'

    table_df.to_csv(path_or_buf=csv_fqn, index=False)

    test.logger.log(msg=f'Created {csv_fqn.name}', level=logging.DEBUG)

    return csv_fqn.stem


def context_table_to_dicts(table: Table, orient='index', use_nan=True) -> dict:
    """
    Converts a context table in a feature file into a list of dictionaries
        :param use_nan:
        :param table: The context.table from a scenario
        :param orient: orient for df to_dict
        :return: A list containing a dictionary modelled from a context table
    """

    table_df = context_table_to_df(table, use_nan=use_nan)

    table_dicts = table_df.to_dict(orient=orient)

    return table_dicts


# TODO: Look into re-factoring and testing
def context_table_to_model(seed_config: dict, table: Table, model_name: str, target_model_name: str):
    """
    Creates a model from a feature file data table
    This is ONLY for dbt-sqlserver where a model is being used as a seed to avoid implicit data type conversion issues
        :param seed_config: Configuration dict for seed file
        :param table: The context.table from a scenario or a programmatically defined table
        :param model_name: Name of the model to base the feature data table on
        :param target_model_name: Name of the model to create
        :return: Seed file name
    """

    feature_data_list = context_table_to_dicts(table=table, orient="index", use_nan=False)
    column_types = seed_config[model_name]["column_types"]

    sql_command = ""

    if isinstance(feature_data_list, dict):
        feature_data_list = [feature_data_list]

    if len(feature_data_list) == 0 or feature_data_list == [{}]:
        # Empty table
        if len(column_types) > 0:
            select_column_list = []

            for column_name in column_types.keys():
                column_type = column_types[column_name]

                if env_utils.platform() == "sqlserver" and column_type[0:6].upper() == "BINARY":
                    expression = f"CONVERT({column_type}, NULL, 2)"
                else:
                    expression = f"CAST(NULL AS {column_type})"

                select_column_list.append(f"{expression} AS [{column_name}]")

            sql_command = "SELECT " + ",".join(select_column_list) + " WHERE 1=0"

    else:
        sql_command_list = []

        for feature_data in feature_data_list:
            for row_number in feature_data.keys():
                select_column_list = []

                for column_name in feature_data[row_number].keys():
                    column_data = feature_data[row_number][column_name]
                    column_type = column_types[column_name]

                    if column_data.lower() == "<null>" or column_data == "":
                        column_data_for_sql = "NULL"
                    else:
                        column_data_for_sql = f"'{column_data}'"

                    if env_utils.platform() == "sqlserver" and column_type[0:6].upper() == "BINARY":
                        expression = f"CONVERT({column_type}, {column_data_for_sql}, 2)"
                    else:
                        expression = f"CAST({column_data_for_sql} AS {column_type})"

                    select_column_list.append(f"{expression} AS [{column_name}]")

                sql_command_list.append("SELECT " + ",".join(select_column_list))

        sql_command = "\nUNION ALL\n".join(sql_command_list)

    with open(test.TEST_MODELS_ROOT / f"{target_model_name.lower()}_seed.sql", "w") as f:
        f.write(sql_command)

    return f"{target_model_name.lower()}_seed"


def columns_from_context_table(table: Table) -> list:
    """
        Get a List of columns (headers) from a context table
        :param table: The context.table from a scenario
        :return: List of column names in the context table
    """

    table_df = context_table_to_df(table)

    table_dict = table_df.to_dict()

    return list(table_dict.keys())


def parse_hashdiffs(columns_as_series: Series) -> Series:
    """
    Evaluate strings surrounded with hashdiff() and exclude_hashdiff() to
    augment the YAML metadata and configure hashdiff columns for staging.
        :param columns_as_series: Columns from a context.table in Series form.
        :return: Modified series
    """

    standard_pattern = r"^(?:hashdiff\(')(.*)(?:'\))"
    exclude_pattern = r"^(?:exclude_hashdiff\(')(.*)(?:'\))"

    columns = []

    for item in columns_as_series:

        if re.search(standard_pattern, item):
            raw_item = re.findall(standard_pattern, item)[0]
            split_item = str(raw_item).split(",")
            hashdiff_dict = {"is_hashdiff": True,
                             "columns": split_item}

            columns.append(hashdiff_dict)
        elif re.search(exclude_pattern, item):
            raw_item = re.findall(exclude_pattern, item)[0]
            split_item = str(raw_item).split(",")
            hashdiff_dict = {"is_hashdiff": True,
                             "exclude_columns": True,
                             "columns": split_item}

            columns.append(hashdiff_dict)
        else:
            columns.append(item)

    return Series(columns)


def parse_escapes(columns_as_series: Series) -> Series:
    """
    Evaluate strings surrounded with escape() to augment the YAML metadata
    and configure derived column names to be escaped for staging.
        :param columns_as_series: Columns from a context.table in Series form.
        :return: Modified series
    """

    standard_pattern = r"^(?:escape\(')(.*)(?:'\))"

    columns = []

    for item in columns_as_series:

        if isinstance(item, str):
            if re.search(standard_pattern, item):
                raw_item = re.findall(standard_pattern, item)[0]
                if "," in raw_item:
                    processed_item = str(raw_item).split(",")
                else:
                    processed_item = raw_item
                escape_dict = {"source_column": processed_item,
                               "escape": True}

                columns.append(escape_dict)

            else:
                columns.append(item)

        else:
            columns.append(item)

    return Series(columns)


def parse_lists(columns_as_series: Series) -> Series:
    """
    Evaluate strings surrounded with [ ] representing column name lists to augment the YAML metadata
        :param columns_as_series: Columns from a context.table in Series form.
        :return: Modified series
    """

    standard_pattern = r"^(?:\[)(.*)(?:])"

    columns = []

    for item in columns_as_series:

        if isinstance(item, str):
            if re.search(standard_pattern, item):
                raw_item = re.findall(standard_pattern, item)[0]
                processed_item = str(raw_item).split(",")

                columns.append(processed_item)

            else:
                columns.append(item)

        else:
            columns.append(item)

    return Series(columns)


def calc_hash(columns_as_series: Series) -> Series:
    """
    Calculates the MD5 hash for a given value
        :param columns_as_series: A pandas Series of strings for the hash to be calculated on.
        In the form of "md5('1000')" or "sha('1000')"
        :return: Hash (MD5 or SHA) of values as Series (used as column)
    """

    patterns = {
        'md5': {
            'pattern': r"^(?:md5\(')(.*)(?:'\))", 'function': md5},
        'sha': {
            'pattern': r"^(?:sha\(')(.*)(?:'\))", 'function': sha256}}

    hashed_list = []

    for item in columns_as_series:

        active_hash_func = [pattern for pattern in patterns if pattern in item]
        if active_hash_func:
            active_hash_func = active_hash_func[0]
            raw_item = re.findall(patterns[active_hash_func]['pattern'], item)[0]
            hash_func = patterns[active_hash_func]['function']
            hashed_item = str(hash_func(raw_item.encode('utf-8')).hexdigest()).upper()
            hashed_list.append(hashed_item)
        else:
            hashed_list.append(item)

    return Series(hashed_list)


def find_columns_to_ignore(table: Table):
    """
    Gets a list of columns which contain all *, which is shorthand to denote ignoring a column for comparison
        :param table: The context.table from a scenario
        :return: List of columns
    """

    df = context_table_to_df(table)

    return list(df.columns[df.isin(['*']).all()])
