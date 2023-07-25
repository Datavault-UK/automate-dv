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
                "EFFECTIVE_FROM": "DATE",
                "AUTOMATE_DV_RANK": "VARCHAR"
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
                "AUTOMATE_DV_RANK": "VARCHAR",
                "AUTOMATE_DV_RANK2": "VARCHAR"
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


@fixture
def staging_null_columns_snowflake(context):
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
                "EFFECTIVE_FROM": "DATE",
                "AUTOMATE_DV_RANK": "VARCHAR",
                "CUSTOMER_ID_ORIGINAL": "VARCHAR",
                "CUSTOMER_REF": "VARCHAR",
                "CUSTOMER_REF_ORIGINAL": "VARCHAR",
                "ORDER_ID": "VARCHAR",
                "ORDER_ID_ORIGINAL": "VARCHAR",
                "ORDER_LINE": "VARCHAR",
                "ORDER_LINE_ORIGINAL": "VARCHAR",
                "CUSTOMER_NAME_ORIGINAL": "VARCHAR",
                "CUSTOMER_DOB_ORIGINAL": "VARCHAR"
            }
        },
        "RAW_STAGE": {
            "column_types": {
                "CUSTOMER_ID": "VARCHAR",
                "CUSTOMER_NAME": "VARCHAR",
                "CUSTOMER_DOB": "VARCHAR",
                "CUSTOMER_PHONE": "VARCHAR",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR",
                "CUSTOMER_REF": "VARCHAR",
                "ORDER_ID": "VARCHAR",
                "ORDER_LINE": "VARCHAR"
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
                "AUTOMATE_DV_RANK": "STRING",
                "AUTOMATE_DV_RANK2": "STRING"
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


@fixture
def staging_null_columns_bigquery(context):
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
                "EFFECTIVE_FROM": "DATE",
                "AUTOMATE_DV_RANK": "STRING",
                "CUSTOMER_ID_ORIGINAL": "STRING",
                "CUSTOMER_REF": "STRING",
                "CUSTOMER_REF_ORIGINAL": "STRING",
                "ORDER_ID": "STRING",
                "ORDER_ID_ORIGINAL": "STRING",
                "ORDER_LINE_ORIGINAL": "STRING",
                "CUSTOMER_NAME_ORIGINAL": "STRING",
                "CUSTOMER_DOB_ORIGINAL": "STRING"
            }
        },
        "RAW_STAGE": {
            "column_types": {
                "CUSTOMER_ID": "STRING",
                "CUSTOMER_NAME": "STRING",
                "CUSTOMER_DOB": "STRING",
                "CUSTOMER_PHONE": "STRING",
                "LOAD_DATE": "DATE",
                "SOURCE": "STRING",
                "CUSTOMER_REF": "STRING",
                "ORDER_ID": "STRING",
                "ORDER_LINE": "STRING"
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
                "AUTOMATE_DV_RANK": "INT",
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
                "AUTOMATE_DV_RANK": "INT",
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
                "AUTOMATE_DV_RANK": "INT",
                "AUTOMATE_DV_RANK2": "INT",
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
                "AUTOMATE_DV_RANK": "INT",
                "AUTOMATE_DV_RANK2": "INT"
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
                "AUTOMATE_DV_RANK": "INT",
                "AUTOMATE_DV_RANK2": "INT",
                "DERIVED_CONCAT": "VARCHAR(50)"
            }
        },
        "STG_CUSTOMER_NAME": {
            "column_types": {
                "CUSTOMER_ID": "VARCHAR(5)",
                "CUSTOMER_NAME": "VARCHAR(10)",
                "CUSTOMER NAME": "VARCHAR(10)",
                "CUSTOMER_DOB": "VARCHAR(10)",
                "CUSTOMER_PHONE": "VARCHAR(20)",
                "LOAD_DATE": "DATE",
                "CUSTOMER_PK": "BINARY(16)",
                "HASHDIFF": "BINARY(16)",
                "EFFECTIVE_FROM": "DATE",
                "SOURCE": "VARCHAR(10)",
                "DERIVED_CONCAT": "VARCHAR(50)",
                "AUTOMATE_DV_RANK": "INT",
                "AUTOMATE_DV_RANK2": "INT"
            }
        },
        "STG_CUSTOMER_NAME_DOB": {
            "column_types": {
                "CUSTOMER_ID": "VARCHAR(5)",
                "CUSTOMER_NAME": "VARCHAR(10)",
                "CUSTOMER NAME": "VARCHAR(10)",
                "CUSTOMER_DOB": "VARCHAR(10)",
                "CUSTOMER DOB": "VARCHAR(10)",
                "CUSTOMER_PHONE": "VARCHAR(20)",
                "LOAD_DATE": "DATE",
                "CUSTOMER_PK": "BINARY(16)",
                "HASHDIFF": "BINARY(16)",
                "EFFECTIVE_FROM": "DATE",
                "SOURCE": "VARCHAR(10)",
                "CUSTOMER_DOB_UK": "VARCHAR(10)",
                "AUTOMATE_DV_RANK": "INT",
                "AUTOMATE_DV_RANK2": "INT",
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
        },
        "RAW_STAGE_NAME_DOB": {
            "column_types": {
                "CUSTOMER_ID": "VARCHAR(5)",
                "CUSTOMER NAME": "VARCHAR(10)",
                "CUSTOMER DOB": "VARCHAR(10)",
                "CUSTOMER_PHONE": "VARCHAR(20)",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR(10)"
            }
        }
    }


@fixture
def staging_null_columns_sqlserver(context):
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
                "AUTOMATE_DV_RANK": "INT",
                "CUSTOMER_ID_ORIGINAL": "VARCHAR(5)",
                "CUSTOMER_REF": "VARCHAR(10)",
                "CUSTOMER_REF_ORIGINAL": "VARCHAR(10)",
                "ORDER_ID": "VARCHAR(10)",
                "ORDER_ID_ORIGINAL": "VARCHAR(10)",
                "ORDER_LINE": "VARCHAR(10)",
                "ORDER_LINE_ORIGINAL": "VARCHAR(10)",
                "CUSTOMER_NAME_ORIGINAL": "VARCHAR(10)",
                "CUSTOMER_DOB_ORIGINAL": "VARCHAR(10)"
            }
        },
        "RAW_STAGE": {
            "column_types": {
                "CUSTOMER_ID": "VARCHAR(5)",
                "CUSTOMER_NAME": "VARCHAR(10)",
                "CUSTOMER_DOB": "VARCHAR(10)",
                "CUSTOMER_PHONE": "VARCHAR(20)",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR(10)",
                "CUSTOMER_REF": "VARCHAR(10)",
                "ORDER_ID": "VARCHAR(10)",
                "ORDER_LINE": "VARCHAR(10)"
            }
        }
    }


# Databricks

@fixture
def staging_databricks(context):
    """
    Define the structures and metadata to load a hashed staging layer
    """

    context.seed_config = {

        "STG_CUSTOMER": {
            "column_types": {
                "CUSTOMER_ID": "VARCHAR(100)",
                "CUSTOMER_NAME": "VARCHAR(100)",
                "CUSTOMER_DOB": "VARCHAR(100)",
                "CUSTOMER_PHONE": "VARCHAR(100)",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR(100)",
                "CUSTOMER_PK": "STRING",
                "HASHDIFF": "STRING",
                "EFFECTIVE_FROM": "DATE",
                "AUTOMATE_DV_RANK": "VARCHAR(100)"
            }
        },
        "RAW_STAGE": {
            "column_types": {
                "CUSTOMER_ID": "VARCHAR(100)",
                "CUSTOMER_NAME": "VARCHAR(100)",
                "CUSTOMER_DOB": "VARCHAR(100)",
                "CUSTOMER_PHONE": "VARCHAR(100)",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR(100)"
            }
        }
    }


@fixture
def staging_escaped_databricks(context):
    """
    Define the structures and metadata to load a hashed staging layer
    """

    context.seed_config = {

        "STG_CUSTOMER": {
            "column_types": {
                "CUSTOMER_ID": "VARCHAR(100)",
                "CUSTOMER NAME": "VARCHAR(100)",
                "CUSTOMER_DOB": "VARCHAR(100)",
                "CUSTOMER_PHONE": "VARCHAR(100)",
                "LOAD_DATE": "DATE",
                "CUSTOMER_PK": "STRING",
                "HASHDIFF": "STRING",
                "EFFECTIVE_FROM": "DATE",
                "SOURCE": "VARCHAR(100)",
                "COLUMN": "VARCHAR(100)",
                "CUSTOMER_NAME": "VARCHAR(100)",
                "AUTOMATE_DV_RANK": "VARCHAR(100)",
                "AUTOMATE_DV_RANK2": "VARCHAR(100)"
            }
        },
        "RAW_STAGE": {
            "column_types": {
                "CUSTOMER_ID": "VARCHAR(100)",
                "CUSTOMER NAME": "VARCHAR(100)",
                "CUSTOMER_DOB": "VARCHAR(100)",
                "CUSTOMER_PHONE": "VARCHAR(100)",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR(100)"
            }
        }
    }


@fixture
def staging_null_columns_databricks(context):
    """
    Define the structures and metadata to load a hashed staging layer
    """

    context.seed_config = {

        "STG_CUSTOMER": {
            "column_types": {
                "CUSTOMER_ID": "VARCHAR(100)",
                "CUSTOMER_NAME": "VARCHAR(100)",
                "CUSTOMER_DOB": "VARCHAR(100)",
                "CUSTOMER_PHONE": "VARCHAR(100)",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR(100)",
                "CUSTOMER_PK": "STRING",
                "HASHDIFF": "STRING",
                "EFFECTIVE_FROM": "DATE",
                "AUTOMATE_DV_RANK": "VARCHAR(100)",
                "CUSTOMER_ID_ORIGINAL": "VARCHAR(100)",
                "CUSTOMER_REF": "VARCHAR(100)",
                "CUSTOMER_REF_ORIGINAL": "VARCHAR(100)",
                "ORDER_ID": "VARCHAR(100)",
                "ORDER_ID_ORIGINAL": "VARCHAR(100)",
                "ORDER_LINE": "VARCHAR(100)",
                "ORDER_LINE_ORIGINAL": "VARCHAR(100)",
                "CUSTOMER_NAME_ORIGINAL": "VARCHAR(100)",
                "CUSTOMER_DOB_ORIGINAL": "VARCHAR(100)"
            }
        },
        "RAW_STAGE": {
            "column_types": {
                "CUSTOMER_ID": "VARCHAR(100)",
                "CUSTOMER_NAME": "VARCHAR(100)",
                "CUSTOMER_DOB": "VARCHAR(100)",
                "CUSTOMER_PHONE": "VARCHAR(100)",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR(100)",
                "CUSTOMER_REF": "VARCHAR(100)",
                "ORDER_ID": "VARCHAR(100)",
                "ORDER_LINE": "VARCHAR(100)"
            }
        }
    }


# Postgres

@fixture
def staging_postgres(context):
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
                "CUSTOMER_PK": "BYTEA",
                "HASHDIFF": "BYTEA",
                "EFFECTIVE_FROM": "DATE",
                "AUTOMATE_DV_RANK": "VARCHAR",
                "CUSTOMER_NK": "VARCHAR",
                "DERIVED_CONCAT": "VARCHAR",
                "AUTOMATE_DV_RANK2": "VARCHAR",
            }
        },
        "STG_CUSTOMER_HASH": {
            "column_types": {
                "CUSTOMER_ID": "BYTEA",
                "CUSTOMER_NAME": "VARCHAR(10)",
                "CUSTOMER_DOB": "VARCHAR(10)",
                "CUSTOMER_PHONE": "VARCHAR(20)",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR(10)",
                "CUSTOMER_PK": "BYTEA",
                "HASHDIFF": "BYTEA",
                "EFFECTIVE_FROM": "DATE",
                "AUTOMATE_DV_RANK": "INT",
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
                "CUSTOMER_PK": "BYTEA",
                "HASHDIFF": "BYTEA",
                "EFFECTIVE_FROM": "DATE",
                "AUTOMATE_DV_RANK": "INT",
                "AUTOMATE_DV_RANK2": "INT",
                "CUSTOMER_NK": "VARCHAR(30)",
                "CUSTOMER_DOB_UK": "VARCHAR(10)",
                "DERIVED_CONCAT": "VARCHAR(50)"
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
def staging_escaped_postgres(context):
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
                "CUSTOMER_PK": "BYTEA",
                "HASHDIFF": "BYTEA",
                "EFFECTIVE_FROM": "DATE",
                "SOURCE": "VARCHAR",
                "COLUMN": "VARCHAR",
                "CUSTOMER_NAME": "VARCHAR",
                "AUTOMATE_DV_RANK": "VARCHAR",
                "AUTOMATE_DV_RANK2": "VARCHAR"
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


@fixture
def staging_null_columns_postgres(context):
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
                "CUSTOMER_PK": "BYTEA",
                "HASHDIFF": "BYTEA",
                "EFFECTIVE_FROM": "DATE",
                "AUTOMATE_DV_RANK": "VARCHAR",
                "CUSTOMER_ID_ORIGINAL": "VARCHAR",
                "CUSTOMER_REF": "VARCHAR",
                "CUSTOMER_REF_ORIGINAL": "VARCHAR",
                "ORDER_ID": "VARCHAR",
                "ORDER_ID_ORIGINAL": "VARCHAR",
                "ORDER_LINE": "VARCHAR",
                "ORDER_LINE_ORIGINAL": "VARCHAR",
                "CUSTOMER_NAME_ORIGINAL": "VARCHAR",
                "CUSTOMER_DOB_ORIGINAL": "VARCHAR"
            }
        },
        "RAW_STAGE": {
            "column_types": {
                "CUSTOMER_ID": "VARCHAR",
                "CUSTOMER_NAME": "VARCHAR",
                "CUSTOMER_DOB": "VARCHAR",
                "CUSTOMER_PHONE": "VARCHAR",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR",
                "CUSTOMER_REF": "VARCHAR",
                "ORDER_ID": "VARCHAR",
                "ORDER_LINE": "VARCHAR"
            }
        }
    }


@fixture
def hashing_snowflake(context):
    context.seed_config = {

        "sample_data": {
            "column_types": {
                "VALUE_STRING": "VARCHAR"

            }
        }
    }


@fixture
def hashing_bigquery(context):
    context.seed_config = {

        "SAMPLE_DATA": {
            "column_types": {
                "VALUE_STRING": "STRING"

            }
        }
    }


@fixture
def hashing_sqlserver(context):
    context.seed_config = {

        "SAMPLE_DATA": {
            "column_types": {
                "VALUE_STRING": "VARCHAR(50)"

            }
        }
    }

@fixture
def hashing_databricks(context):
    context.seed_config = {

        "SAMPLE_DATA": {
            "column_types": {
                "VALUE_STRING": "VARCHAR"

            }
        }
    }

@fixture
def hashing_postgres(context):
    context.seed_config = {

        "sample_data": {
            "column_types": {
                "VALUE_STRING": "VARCHAR"

            }
        }
    }

