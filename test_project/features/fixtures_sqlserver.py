from behave import fixture

"""
MSSQL specific fixtures for use with dbt-sqlserver adapter
The fixtures here are used to supply runtime metadata to MSSQL specific tests, which are provided to the model generator.
"""


@fixture
def staging_sqlserver(context):
    """
    Define the structures and metadata to load a hashed staging layer
    """

    context.seed_config = {

        "STG_CUSTOMER": {
            "+column_types": {
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
            "+column_types": {
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
        "RAW_STAGE": {
            "+column_types": {
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
def single_source_hub_sqlserver(context):
    """
    Define the structures and metadata to load single-source hubs
    """

    context.hashed_columns = {
        "STG_CUSTOMER": {
            "CUSTOMER_PK": "CUSTOMER_ID"
        },
        "STG_CUSTOMER_HASHLIST": {
            "CUSTOMER_PK": ["CUSTOMER_ID", "CUSTOMER_NAME"]
        }
    }

    context.vault_structure_columns = {
        "HUB_CUSTOMER": {
            "src_pk": "CUSTOMER_PK",
            "src_nk": "CUSTOMER_ID",
            "src_ldts": "LOAD_DATE",
            "src_source": "SOURCE"
        },
        "HUB_CUSTOMER_SHA": {
            "src_pk": "CUSTOMER_PK",
            "src_nk": "CUSTOMER_ID",
            "src_ldts": "LOAD_DATE",
            "src_source": "SOURCE"
        },
        "HUB": {
            "src_pk": "CUSTOMER_PK",
            "src_nk": "CUSTOMER_ID",
            "src_ldts": "LOAD_DATE",
            "src_source": "SOURCE"
        }
    }

    context.seed_config = {
        "HUB_CUSTOMER": {
            "+column_types": {
                "CUSTOMER_PK": "BINARY(16)",
                "CUSTOMER_ID": "VARCHAR(4)",
                "LOAD_DATE": "DATETIME",
                "SOURCE": "VARCHAR(4)"
            }
        },
        "HUB_CUSTOMER_SHA": {
            "+column_types": {
                "CUSTOMER_PK": "BINARY(32)",
                "CUSTOMER_ID": "VARCHAR(4)",
                "LOAD_DATE": "DATETIME",
                "SOURCE": "VARCHAR(4)"
            }
        },
        "HUB": {
            "+column_types": {
                "CUSTOMER_PK": "BINARY(16)",
                "CUSTOMER_ID": "VARCHAR(4)",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR(4)"
            }
        },
        "RAW_STAGE": {
            "+column_types": {
                "CUSTOMER_ID": "VARCHAR(4)",
                "CUSTOMER_NAME": "VARCHAR(5)",
                "CUSTOMER_DOB": "DATE",
                "LOAD_DATE": "DATETIME",
                "SOURCE": "VARCHAR(4)"
            }
        }
    }


@fixture
def multi_source_hub_sqlserver(context):
    """
    Define the structures and metadata to load multi-source hubs
    """

    context.hashed_columns = {
        "STG_PARTS": {
            "PART_PK": "PART_ID"
        },
        "STG_SUPPLIER": {
            "PART_PK": "PART_ID",
            "SUPPLIER_PK": "SUPPLIER_ID"
        },
        "STG_LINEITEM": {
            "PART_PK": "PART_ID",
            "SUPPLIER_PK": "SUPPLIER_ID",
            "ORDER_PK": "ORDER_ID"
        }
    }

    context.vault_structure_columns = {
        "HUB": {
            "src_pk": "PART_PK",
            "src_nk": "PART_ID",
            "src_ldts": "LOAD_DATE",
            "src_source": "SOURCE"
        }
    }

    context.seed_config = {
        "HUB": {
            "+column_types": {
                "PART_PK": "BINARY(16)",
                "PART_ID": "VARCHAR(4)",
                "LOAD_DATE": "DATETIME",
                "SOURCE": "VARCHAR(4)"
            }
        },
        "RAW_STAGE_PARTS": {
            "+column_types": {
                "PART_ID": "VARCHAR(4)",
                "PART_NAME": "VARCHAR(10)",
                "PART_TYPE": "VARCHAR(10)",
                "PART_SIZE": "VARCHAR(2)",
                "PART_RETAILPRICE": "DECIMAL(11,2)",
                "LOAD_DATE": "DATETIME",
                "SOURCE": "VARCHAR(4)"
            }
        },
        "RAW_STAGE_SUPPLIER": {
            "+column_types": {
                "PART_ID": "VARCHAR(4)",
                "SUPPLIER_ID": "VARCHAR(2)",
                "AVAILQTY": "INT",
                "SUPPLYCOST": "DECIMAL(11,2)",
                "LOAD_DATE": "DATETIME",
                "SOURCE": "VARCHAR(4)"
            }
        },
        "RAW_STAGE_LINEITEM": {
            "+column_types": {
                "ORDER_ID": "VARCHAR(5)",
                "PART_ID": "VARCHAR(4)",
                "SUPPLIER_ID": "VARCHAR(2)",
                "LINENUMBER": "INT",
                "QUANTITY": "INT",
                "EXTENDED_PRICE": "DECIMAL(11,2)",
                "DISCOUNT": "DECIMAL(11,2)",
                "LOAD_DATE": "DATETIME",
                "SOURCE": "VARCHAR(4)"
            }
        }
    }
