from behave import fixture


# Snowflake


@fixture
def staging_snowflake(context):
    """
    Define the structures and metadata to load a hashed staging layer
    """

    context.seed_config = {

        "STG_CUSTOMER": {
            "column_types": {
                "CUSTOMER_ID": "VARCHAR",
                "CUSTOMER_NAME": "VARCHAR",
                "CUSTOMER_DOB": "VARCHAR",
                "CUSTOMER_PHONE": "VARCHAR",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR",
                "CUSTOMER_PK": "BINARY(16)",
                "HASHDIFF": "BINARY(16)",
                "EFFECTIVE_FROM": "DATE"
            }
        },
        "RAW_STAGE": {
            "column_types": {
                "CUSTOMER_ID": "VARCHAR",
                "CUSTOMER_NAME": "VARCHAR",
                "CUSTOMER_DOB": "VARCHAR",
                "CUSTOMER_PHONE": "VARCHAR",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR"
            }
        }
    }


@fixture
def staging_escaped_snowflake(context):
    """
    Define the structures and metadata to load a hashed staging layer
    """

    context.seed_config = {

        "STG_CUSTOMER": {
            "column_types": {
                "CUSTOMER_ID": "VARCHAR",
                "CUSTOMER NAME": "VARCHAR",
                "CUSTOMER_DOB": "VARCHAR",
                "CUSTOMER_PHONE": "VARCHAR",
                "LOAD_DATE": "DATE",
                "CUSTOMER_PK": "BINARY(16)",
                "HASHDIFF": "BINARY(16)",
                "EFFECTIVE_FROM": "DATE",
                "SOURCE": "VARCHAR",
                "COLUMN": "VARCHAR",
                "CUSTOMER_NAME": "VARCHAR",
                "DBTVAULT_RANK": "VARCHAR",
                "DBTVAULT_RANK2": "VARCHAR"
            }
        },
        "RAW_STAGE": {
            "column_types": {
                "CUSTOMER_ID": "VARCHAR",
                "CUSTOMER NAME": "VARCHAR",
                "CUSTOMER_DOB": "VARCHAR",
                "CUSTOMER_PHONE": "VARCHAR",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR"
            }
        }
    }


# BigQuery


@fixture
def staging_bigquery(context):
    """
    Define the structures and metadata to load a hashed staging layer
    """

    context.seed_config = {

        "STG_CUSTOMER": {
            "column_types": {
                "CUSTOMER_ID": "STRING",
                "CUSTOMER_NAME": "STRING",
                "CUSTOMER_DOB": "STRING",
                "CUSTOMER_PHONE": "STRING",
                "LOAD_DATE": "DATE",
                "SOURCE": "STRING",
                "CUSTOMER_PK": "STRING",
                "HASHDIFF": "STRING",
                "EFFECTIVE_FROM": "DATE"
            }
        },
        "RAW_STAGE": {
            "column_types": {
                "CUSTOMER_ID": "STRING",
                "CUSTOMER_NAME": "STRING",
                "CUSTOMER_DOB": "STRING",
                "CUSTOMER_PHONE": "STRING",
                "LOAD_DATE": "DATE",
                "SOURCE": "STRING"
            }
        }
    }


@fixture
def staging_escaped_bigquery(context):
    """
    Define the structures and metadata to load a hashed staging layer
    """

    context.seed_config = {

        "STG_CUSTOMER": {
            "column_types": {
                "CUSTOMER_ID": "STRING",
                "CUSTOMER NAME": "STRING",
                "CUSTOMER_DOB": "STRING",
                "CUSTOMER_PHONE": "STRING",
                "LOAD_DATE": "DATE",
                "CUSTOMER_PK": "STRING",
                "HASHDIFF": "STRING",
                "EFFECTIVE_FROM": "DATE",
                "SOURCE": "STRING",
                "COLUMN": "STRING",
                "CUSTOMER_NAME": "STRING",
                "DBTVAULT_RANK": "STRING",
                "DBTVAULT_RANK2": "STRING"
            }
        },
        "RAW_STAGE": {
            "column_types": {
                "CUSTOMER_ID": "STRING",
                "CUSTOMER NAME": "STRING",
                "CUSTOMER_DOB": "STRING",
                "CUSTOMER_PHONE": "STRING",
                "LOAD_DATE": "DATE",
                "SOURCE": "STRING"
            }
        }
    }


# SQLServer


@fixture
def staging_sqlserver(context):
    """
    Define the structures and metadata to load a hashed staging layer
    """

    context.seed_config = {

        "STG_CUSTOMER": {
            "column_types": {
                "CUSTOMER_ID": "VARCHAR(5)",
                "CUSTOMER_NAME": "VARCHAR(10)",
                "CUSTOMER_DOB": "VARCHAR(10)",
                "CUSTOMER_PHONE": "VARCHAR(20)",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR(10)",
                "CUSTOMER_PK": "BINARY(16)",
                "HASHDIFF": "BINARY(16)",
                "EFFECTIVE_FROM": "DATE",
                "DBTVAULT_RANK": "INT",
                "CUSTOMER_NK": "VARCHAR(30)",
                "CUSTOMER_DOB_UK": "VARCHAR(10)"
            }
        },
        "STG_CUSTOMER_HASH": {
            "column_types": {
                "CUSTOMER_ID": "BINARY(16)",
                "CUSTOMER_NAME": "VARCHAR(10)",
                "CUSTOMER_DOB": "VARCHAR(10)",
                "CUSTOMER_PHONE": "VARCHAR(20)",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR(10)",
                "CUSTOMER_PK": "BINARY(16)",
                "HASHDIFF": "BINARY(16)",
                "EFFECTIVE_FROM": "DATE",
                "DBTVAULT_RANK": "INT",
                "CUSTOMER_NK": "VARCHAR(30)",
                "CUSTOMER_DOB_UK": "VARCHAR(10)"
            }
        },
        "STG_CUSTOMER_CONCAT": {
            "column_types": {
                "CUSTOMER_ID": "VARCHAR(5)",
                "CUSTOMER_NAME": "VARCHAR(10)",
                "CUSTOMER_DOB": "VARCHAR(10)",
                "CUSTOMER_PHONE": "VARCHAR(20)",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR(10)",
                "CUSTOMER_PK": "BINARY(16)",
                "HASHDIFF": "BINARY(16)",
                "EFFECTIVE_FROM": "DATE",
                "DBTVAULT_RANK": "INT",
                "DBTVAULT_RANK2": "INT",
                "CUSTOMER_NK": "VARCHAR(30)",
                "CUSTOMER_DOB_UK": "VARCHAR(10)",
                "DERIVED_CONCAT": "VARCHAR(50)"
            }
        },
        "RAW_STAGE": {
            "column_types": {
                "CUSTOMER_ID": "VARCHAR(5)",
                "CUSTOMER_NAME": "VARCHAR(10)",
                "CUSTOMER_DOB": "VARCHAR(10)",
                "CUSTOMER_PHONE": "VARCHAR(20)",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR(10)"
            }
        }
    }


@fixture
def staging_escaped_sqlserver(context):
    """
    Define the structures and metadata to load a hashed staging layer
    """

    context.seed_config = {

        "STG_CUSTOMER": {
            "column_types": {
                "CUSTOMER_ID": "BINARY(16)",
                "CUSTOMER NAME": "VARCHAR(10)",
                "CUSTOMER_DOB": "VARCHAR(10)",
                "CUSTOMER_PHONE": "VARCHAR(20)",
                "LOAD_DATE": "DATE",
                "CUSTOMER_PK": "BINARY(16)",
                "HASHDIFF": "BINARY(16)",
                "EFFECTIVE_FROM": "DATE",
                "SOURCE": "VARCHAR(10)",
                "COLUMN": "VARCHAR(50)",
                "CUSTOMER_NAME": "VARCHAR(10)",
                "DBTVAULT_RANK": "INT",
                "DBTVAULT_RANK2": "INT"
            }
        },
        "STG_CUSTOMER_CONCAT": {
            "column_types": {
                "CUSTOMER_ID": "VARCHAR(5)",
                "CUSTOMER_NAME": "VARCHAR(10)",
                "CUSTOMER NAME": "VARCHAR(10)",
                "CUSTOMER_DOB": "VARCHAR(10)",
                "CUSTOMER_PHONE": "VARCHAR(20)",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR(10)",
                "CUSTOMER_PK": "BINARY(16)",
                "HASHDIFF": "BINARY(16)",
                "EFFECTIVE_FROM": "DATE",
                "DBTVAULT_RANK": "INT",
                "DBTVAULT_RANK2": "INT",
                "CUSTOMER_NK": "VARCHAR(30)",
                "CUSTOMER_DOB_UK": "VARCHAR(10)",
                "DERIVED_CONCAT": "VARCHAR(50)"
            }
        },
        "RAW_STAGE": {
            "column_types": {
                "CUSTOMER_ID": "VARCHAR(5)",
                "CUSTOMER NAME": "VARCHAR(10)",
                "CUSTOMER_DOB": "VARCHAR(10)",
                "CUSTOMER_PHONE": "VARCHAR(20)",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR(10)"
            }
        }
    }
