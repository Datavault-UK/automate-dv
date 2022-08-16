from behave import fixture


def set_vault_structure_definition(context):
    context.vault_structure_columns = {
        "HUB": {
            "src_pk": "CUSTOMER_PK",
            "src_nk": "CUSTOMER_ID",
            "src_ldts": "LOAD_DATE",
            "src_source": "SOURCE"
        },
        "HUB_AC": {
            "src_pk": "CUSTOMER_PK",
            "src_nk": "CUSTOMER_ID",
            "src_ldts": "LOAD_DATE",
            "src_extra_columns": "CUSTOMER_MT_ID",
            "src_source": "SOURCE"
        },
        "HUB_AC_MULTI": {
            "src_pk": "CUSTOMER_PK",
            "src_nk": "CUSTOMER_ID",
            "src_ldts": "LOAD_DATE",
            "src_extra_columns": [
                "CUSTOMER_MT_ID",
                "CUSTOMER_CK"
            ],
            "src_source": "SOURCE"
        }
    }


def set_staging_definition(context):
    context.hashed_columns = {
        "STG_CUSTOMER": {
            "CUSTOMER_PK": "CUSTOMER_ID"
        },
        "STG_PARTS": {
            "PART_PK": "PART_ID"
        },
        "STG_SUPPLIER": {
            "PART_PK": "PART_ID"
        },
        "STG_LINEITEM": {
            "PART_PK": "PART_ID"
        },
    }


def set_metadata(context):
    set_vault_structure_definition(context)

    set_staging_definition(context)


# Snowflake


@fixture
def single_source_hub_snowflake(context):
    """
    Define the structures and metadata to load single-source hubs
    """

    set_metadata(context)

    context.seed_config = {
        "HUB": {
            "column_types": {
                "CUSTOMER_PK": "BINARY(16)",
                "CUSTOMER_ID": "VARCHAR",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR"
            }
        },
        "HUB_AC": {
            "column_types": {
                "CUSTOMER_PK": "BINARY(16)",
                "CUSTOMER_ID": "VARCHAR",
                "CUSTOMER_MT_ID": "VARCHAR",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR"
            }
        },
        "HUB_AC_MULTI": {
            "column_types": {
                "CUSTOMER_PK": "BINARY(16)",
                "CUSTOMER_ID": "VARCHAR",
                "CUSTOMER_MT_ID": "VARCHAR",
                "CUSTOMER_CK": "VARCHAR",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR"
            }
        },
        "RAW_STAGE": {
            "column_types": {
                "CUSTOMER_ID": "VARCHAR",
                "CUSTOMER_NAME": "VARCHAR",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR"
            }
        }
    }


@fixture
def single_source_comp_pk_hub_snowflake(context):
    """
    Define the structures and metadata to load single-source hubs with composite PK
    """

    set_metadata(context)

    context.vault_structure_columns['HUB'] = {
        "src_pk": ["CUSTOMER_PK", "CUSTOMER_CK"],
        "src_nk": "CUSTOMER_ID",
        "src_ldts": "LOAD_DATE",
        "src_source": "SOURCE"
    }

    context.seed_config = {
        "HUB_CUSTOMER": {
            "column_types": {
                "CUSTOMER_PK": "BINARY(16)",
                "CUSTOMER_CK": "VARCHAR(4)",
                "CUSTOMER_ID": "VARCHAR(4)",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR(4)"
            }
        },
        "HUB_CUSTOMER_SHA": {
            "column_types": {
                "CUSTOMER_PK": "BINARY(32)",
                "CUSTOMER_CK": "VARCHAR(4)",
                "CUSTOMER_ID": "VARCHAR(4)",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR(4)"
            }
        },
        "HUB": {
            "column_types": {
                "CUSTOMER_PK": "BINARY(16)",
                "CUSTOMER_CK": "VARCHAR",
                "CUSTOMER_ID": "VARCHAR",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR"
            }
        },
        "RAW_STAGE": {
            "column_types": {
                "CUSTOMER_ID": "VARCHAR",
                "CUSTOMER_CK": "VARCHAR",
                "CUSTOMER_NAME": "VARCHAR",
                "CUSTOMER_DOB": "DATE",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR"
            }
        }
    }


@fixture
def single_source_comp_pk_nk_hub_snowflake(context):
    """
    Define the structures and metadata to load single-source hubs with composite PK and NK
    """

    set_metadata(context)

    context.vault_structure_columns['HUB'] = {
        "src_pk": ["CUSTOMER_PK", "CUSTOMER_EMP_DEP_HK"],
        "src_nk": ["CUSTOMER_ID", "CUSTOMER_CK"],
        "src_ldts": "LOAD_DATE",
        "src_source": "SOURCE"
    }

    context.hashed_columns['STG_CUSTOMER'] = {
        "CUSTOMER_EMP_DEP_HK": "CUSTOMER_CK",
        "CUSTOMER_PK": "CUSTOMER_ID"
    }

    context.seed_config = {
        "HUB": {
            "column_types": {
                "CUSTOMER_PK": "BINARY(16)",
                "CUSTOMER_EMP_DEP_HK": "BINARY(16)",
                "CUSTOMER_ID": "VARCHAR",
                "CUSTOMER_CK": "VARCHAR",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR"
            }
        },
        "RAW_STAGE": {
            "column_types": {
                "CUSTOMER_ID": "VARCHAR",
                "CUSTOMER_CK": "VARCHAR",
                "CUSTOMER_NAME": "VARCHAR",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR"
            }
        }
    }


@fixture
def multi_source_hub_snowflake(context):
    """
    Define the structures and metadata to load multi-source hubs
    """

    set_metadata(context)

    context.vault_structure_columns['HUB'] = {
        "src_pk": "PART_PK",
        "src_nk": "PART_ID",
        "src_ldts": "LOAD_DATE",
        "src_source": "SOURCE"
    }

    context.vault_structure_columns['HUB_AC'] = {
        "src_pk": "PART_PK",
        "src_nk": "PART_ID",
        "src_extra_columns": "CUSTOMER_MT_ID",
        "src_ldts": "LOAD_DATE",
        "src_source": "SOURCE"
    }

    context.seed_config = {
        "HUB": {
            "column_types": {
                "PART_PK": "BINARY(16)",
                "PART_ID": "VARCHAR",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR"
            }
        },
        "HUB_AC": {
            "column_types": {
                "PART_PK": "BINARY(16)",
                "PART_ID": "VARCHAR",
                "CUSTOMER_MT_ID": "VARCHAR",
                "CUSTOMER_CK": "VARCHAR",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR"
            }
        },
        "RAW_STAGE_PARTS": {
            "column_types": {
                "PART_ID": "VARCHAR",
                "PART_NAME": "VARCHAR",
                "PART_TYPE": "VARCHAR",
                "PART_SIZE": "VARCHAR",
                "PART_RETAILPRICE": "NUMBER(38,2)",
                "CUSTOMER_MT_ID": "VARCHAR",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR"
            }
        },
        "RAW_STAGE_SUPPLIER": {
            "column_types": {
                "PART_ID": "VARCHAR",
                "SUPPLIER_ID": "VARCHAR",
                "CUSTOMER_MT_ID": "VARCHAR",
                "AVAILQTY": "FLOAT",
                "SUPPLYCOST": "NUMBER(38,2)",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR"
            }
        },
        "RAW_STAGE_LINEITEM": {
            "column_types": {
                "ORDER_ID": "VARCHAR",
                "PART_ID": "VARCHAR",
                "CUSTOMER_MT_ID": "VARCHAR",
                "SUPPLIER_ID": "VARCHAR",
                "LINENUMBER": "FLOAT",
                "QUANTITY": "FLOAT",
                "EXTENDED_PRICE": "NUMBER(38,2)",
                "DISCOUNT": "NUMBER(38,2)",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR"
            }
        }
    }


@fixture
def multi_source_comp_pk_hub_snowflake(context):
    """
    Define the structures and metadata to load multi-source hubs with composite PK
    """

    set_metadata(context)

    context.vault_structure_columns['HUB'] = {
        "src_pk": ["PART_PK", "PART_CK"],
        "src_nk": "PART_ID",
        "src_ldts": "LOAD_DATE",
        "src_source": "SOURCE"
    }

    context.seed_config = {
        "HUB": {
            "column_types": {
                "PART_PK": "BINARY(16)",
                "PART_CK": "VARCHAR",
                "PART_ID": "VARCHAR",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR"
            }
        },
        "RAW_STAGE_PARTS": {
            "column_types": {
                "PART_ID": "VARCHAR",
                "PART_CK": "VARCHAR",
                "PART_NAME": "VARCHAR",
                "PART_TYPE": "VARCHAR",
                "PART_SIZE": "VARCHAR",
                "PART_RETAILPRICE": "NUMBER(38,2)",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR"
            }
        },
        "RAW_STAGE_SUPPLIER": {
            "column_types": {
                "PART_ID": "VARCHAR",
                "PART_CK": "VARCHAR",
                "SUPPLIER_ID": "VARCHAR",
                "AVAILQTY": "FLOAT",
                "SUPPLYCOST": "NUMBER(38,2)",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR"
            }
        },
        "RAW_STAGE_LINEITEM": {
            "column_types": {
                "ORDER_ID": "VARCHAR",
                "PART_ID": "VARCHAR",
                "PART_CK": "VARCHAR",
                "SUPPLIER_ID": "VARCHAR",
                "LINENUMBER": "FLOAT",
                "QUANTITY": "FLOAT",
                "EXTENDED_PRICE": "NUMBER(38,2)",
                "DISCOUNT": "NUMBER(38,2)",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR"
            }
        }
    }


# BigQuery


@fixture
def single_source_hub_bigquery(context):
    """
    Define the structures and metadata to load single-source hubs
    """

    set_metadata(context)

    context.seed_config = {
        "HUB": {
            "column_types": {
                "CUSTOMER_PK": "STRING",
                "CUSTOMER_ID": "STRING",
                "LOAD_DATE": "DATE",
                "SOURCE": "STRING"
            }
        },
        "HUB_AC": {
            "column_types": {
                "CUSTOMER_PK": "STRING",
                "CUSTOMER_ID": "STRING",
                "CUSTOMER_MT_ID": "STRING",
                "LOAD_DATE": "DATE",
                "SOURCE": "STRING"
            }
        },
        "HUB_AC_MULTI": {
            "column_types": {
                "CUSTOMER_PK": "STRING",
                "CUSTOMER_ID": "STRING",
                "CUSTOMER_MT_ID": "STRING",
                "CUSTOMER_CK": "STRING",
                "LOAD_DATE": "DATE",
                "SOURCE": "STRING"
            }
        },
        "RAW_STAGE": {
            "column_types": {
                "CUSTOMER_ID": "STRING",
                "CUSTOMER_MT_ID": "STRING",
                "CUSTOMER_NAME": "STRING",
                "LOAD_DATE": "DATE",
                "SOURCE": "STRING"
            }
        }
    }


@fixture
def single_source_comp_pk_hub_bigquery(context):
    """
    Define the structures and metadata to load single-source hubs with composite PK
    """

    set_metadata(context)

    context.vault_structure_columns = {
        **context.vault_structure_columns,
        **{
            'HUB': {
                "src_pk": ["CUSTOMER_PK", "CUSTOMER_CK"],
                "src_nk": "CUSTOMER_ID",
                "src_ldts": "LOAD_DATE",
                "src_source": "SOURCE"
            }
        }}

    context.seed_config = {
        "HUB": {
            "column_types": {
                "CUSTOMER_PK": "STRING",
                "CUSTOMER_CK": "STRING",
                "CUSTOMER_ID": "STRING",
                "LOAD_DATE": "DATE",
                "SOURCE": "STRING"
            }
        },
        "RAW_STAGE": {
            "column_types": {
                "CUSTOMER_ID": "STRING",
                "CUSTOMER_CK": "STRING",
                "CUSTOMER_NAME": "STRING",
                "LOAD_DATE": "DATE",
                "SOURCE": "STRING"
            }
        }
    }


@fixture
def single_source_comp_pk_nk_hub_bigquery(context):
    """
    Define the structures and metadata to load single-source hubs with composite PK
    """

    set_metadata(context)

    context.vault_structure_columns = {
        **context.vault_structure_columns,
        **{
            'HUB': {
                "src_pk": ["CUSTOMER_PK", "CUSTOMER_EMP_DEP_HK"],
                "src_nk": ["CUSTOMER_ID", "CUSTOMER_CK"],
                "src_ldts": "LOAD_DATE",
                "src_source": "SOURCE"
            }
        }}

    context.hashed_columns['STG_CUSTOMER'] = {
        **context.hashed_columns['STG_CUSTOMER'],
        **{
            'CUSTOMER_EMP_DEP_HK': 'CUSTOMER_CK'
        }}

    context.seed_config = {
        "HUB": {
            "column_types": {
                "CUSTOMER_PK": "STRING",
                "CUSTOMER_EMP_DEP_HK": "STRING",
                "CUSTOMER_ID": "STRING",
                "CUSTOMER_CK": "STRING",
                "LOAD_DATE": "DATE",
                "SOURCE": "STRING"
            }
        },
        "RAW_STAGE": {
            "column_types": {
                "CUSTOMER_ID": "STRING",
                "CUSTOMER_CK": "STRING",
                "CUSTOMER_NAME": "STRING",
                "LOAD_DATE": "DATE",
                "SOURCE": "STRING"
            }
        }
    }


@fixture
def multi_source_hub_bigquery(context):
    """
    Define the structures and metadata to load multi-source hubs
    """

    set_metadata(context)

    context.vault_structure_columns = {
        **context.vault_structure_columns,
        **{
            'HUB': {
                "src_pk": "PART_PK",
                "src_nk": "PART_ID",
                "src_ldts": "LOAD_DATE",
                "src_source": "SOURCE"
            },
            'HUB_AC': {
                "src_pk": "PART_PK",
                "src_nk": "PART_ID",
                "src_ldts": "LOAD_DATE",
                "src_extra_columns": "CUSTOMER_MT_ID",
                "src_source": "SOURCE"
            }
        }}

    context.seed_config = {
        "HUB": {
            "column_types": {
                "PART_PK": "STRING",
                "PART_ID": "STRING",
                "LOAD_DATE": "DATE",
                "SOURCE": "STRING"
            }
        },
        "HUB_AC": {
            "column_types": {
                "PART_PK": "STRING",
                "PART_ID": "STRING",
                "CUSTOMER_MT_ID": "STRING",
                "LOAD_DATE": "DATE",
                "SOURCE": "STRING"
            }
        },
        "RAW_STAGE_PARTS": {
            "column_types": {
                "PART_ID": "STRING",
                "PART_NAME": "STRING",
                "PART_TYPE": "STRING",
                "PART_SIZE": "STRING",
                "PART_RETAILPRICE": "NUMERIC",
                "LOAD_DATE": "DATE",
                "SOURCE": "STRING"
            }
        },
        "RAW_STAGE_SUPPLIER": {
            "column_types": {
                "PART_ID": "STRING",
                "SUPPLIER_ID": "STRING",
                "AVAILQTY": "FLOAT",
                "SUPPLYCOST": "NUMERIC",
                "LOAD_DATE": "DATE",
                "SOURCE": "STRING"
            }
        },
        "RAW_STAGE_LINEITEM": {
            "column_types": {
                "ORDER_ID": "STRING",
                "PART_ID": "STRING",
                "SUPPLIER_ID": "STRING",
                "LINENUMBER": "FLOAT",
                "QUANTITY": "FLOAT",
                "EXTENDED_PRICE": "NUMERIC",
                "DISCOUNT": "NUMERIC",
                "LOAD_DATE": "DATE",
                "SOURCE": "STRING"
            }
        }
    }


@fixture
def multi_source_comp_pk_hub_bigquery(context):
    """
    Define the structures and metadata to load multi-source hubs with composite PK
    """

    set_metadata(context)

    context.vault_structure_columns = {
        **context.vault_structure_columns,
        **{
            'HUB': {
                "src_pk": ["PART_PK", "PART_CK"],
                "src_nk": "PART_ID",
                "src_ldts": "LOAD_DATE",
                "src_source": "SOURCE"
            }
        }}

    context.seed_config = {
        "HUB": {
            "column_types": {
                "PART_PK": "STRING",
                "PART_CK": "STRING",
                "PART_ID": "STRING",
                "LOAD_DATE": "DATE",
                "SOURCE": "STRING"
            }
        },
        "RAW_STAGE_PARTS": {
            "column_types": {
                "PART_ID": "STRING",
                "PART_CK": "STRING",
                "PART_NAME": "STRING",
                "PART_TYPE": "STRING",
                "PART_SIZE": "STRING",
                "PART_RETAILPRICE": "NUMERIC",
                "LOAD_DATE": "DATE",
                "SOURCE": "STRING"
            }
        },
        "RAW_STAGE_SUPPLIER": {
            "column_types": {
                "PART_ID": "STRING",
                "PART_CK": "STRING",
                "SUPPLIER_ID": "STRING",
                "AVAILQTY": "FLOAT",
                "SUPPLYCOST": "NUMERIC",
                "LOAD_DATE": "DATE",
                "SOURCE": "STRING"
            }
        },
        "RAW_STAGE_LINEITEM": {
            "column_types": {
                "ORDER_ID": "STRING",
                "PART_ID": "STRING",
                "PART_CK": "STRING",
                "SUPPLIER_ID": "STRING",
                "LINENUMBER": "FLOAT",
                "QUANTITY": "FLOAT",
                "EXTENDED_PRICE": "NUMERIC",
                "DISCOUNT": "NUMERIC",
                "LOAD_DATE": "DATE",
                "SOURCE": "STRING"
            }
        }
    }


# SQLServer


@fixture
def single_source_hub_sqlserver(context):
    """
    Define the structures and metadata to load single-source hubs
    """

    set_metadata(context)

    context.seed_config = {
        "HUB_CUSTOMER": {
            "column_types": {
                "CUSTOMER_PK": "BINARY(16)",
                "CUSTOMER_ID": "VARCHAR(4)",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR(4)"
            }
        },
        "HUB_CUSTOMER_SHA": {
            "column_types": {
                "CUSTOMER_PK": "BINARY(32)",
                "CUSTOMER_ID": "VARCHAR(4)",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR(4)"
            }
        },
        "HUB": {
            "column_types": {
                "CUSTOMER_PK": "BINARY(16)",
                "CUSTOMER_ID": "VARCHAR(4)",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR(4)"
            }
        },
        "HUB_AC": {
            "column_types": {
                "CUSTOMER_PK": "BINARY(16)",
                "CUSTOMER_ID": "VARCHAR(4)",
                "CUSTOMER_MT_ID": "VARCHAR(13)",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR(4)"
            }
        },
        "HUB_AC_MULTI": {
            "column_types": {
                "CUSTOMER_PK": "BINARY(16)",
                "CUSTOMER_ID": "VARCHAR(4)",
                "CUSTOMER_MT_ID": "VARCHAR(13)",
                "CUSTOMER_CK": "VARCHAR(13)",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR(4)"
            }
        },
        "RAW_STAGE": {
            "column_types": {
                "CUSTOMER_ID": "VARCHAR(4)",
                "CUSTOMER_MT_ID": "VARCHAR(13)",
                "CUSTOMER_CK": "VARCHAR(13)",
                "CUSTOMER_NAME": "VARCHAR(5)",
                "CUSTOMER_DOB": "DATE",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR(4)"
            }
        }
    }


@fixture
def single_source_comp_pk_hub_sqlserver(context):
    """
    Define the structures and metadata to load single-source hubs with composite PK
    """

    set_metadata(context)

    context.vault_structure_columns['HUB'] = {
        "src_pk": ["CUSTOMER_PK", "CUSTOMER_CK"],
        "src_nk": "CUSTOMER_ID",
        "src_ldts": "LOAD_DATE",
        "src_source": "SOURCE"
    }

    context.seed_config = {
        "HUB_CUSTOMER": {
            "column_types": {
                "CUSTOMER_PK": "BINARY(16)",
                "CUSTOMER_CK": "VARCHAR(4)",
                "CUSTOMER_ID": "VARCHAR(4)",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR(4)"
            }
        },
        "HUB_CUSTOMER_SHA": {
            "column_types": {
                "CUSTOMER_PK": "BINARY(32)",
                "CUSTOMER_CK": "VARCHAR(4)",
                "CUSTOMER_ID": "VARCHAR(4)",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR(4)"
            }
        },
        "HUB": {
            "column_types": {
                "CUSTOMER_PK": "BINARY(16)",
                "CUSTOMER_CK": "VARCHAR(4)",
                "CUSTOMER_ID": "VARCHAR(4)",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR(4)"
            }
        },
        "RAW_STAGE": {
            "column_types": {
                "CUSTOMER_ID": "VARCHAR(4)",
                "CUSTOMER_CK": "VARCHAR(4)",
                "CUSTOMER_NAME": "VARCHAR(5)",
                "CUSTOMER_DOB": "DATE",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR(4)"
            }
        }
    }


@fixture
def single_source_comp_pk_nk_hub_sqlserver(context):
    """
    Define the structures and metadata to load single-source hubs with composite PK
    """

    set_metadata(context)

    context.vault_structure_columns['HUB'] = {
        "src_pk": ["CUSTOMER_PK", "CUSTOMER_EMP_DEP_HK"],
        "src_nk": ["CUSTOMER_ID", "CUSTOMER_CK"],
        "src_ldts": "LOAD_DATE",
        "src_source": "SOURCE"
    }

    context.hashed_columns['STG_CUSTOMER'] = {
        "CUSTOMER_EMP_DEP_HK": "CUSTOMER_CK",
        "CUSTOMER_PK": "CUSTOMER_ID"
    }

    context.seed_config = {
        "HUB": {
            "column_types": {
                "CUSTOMER_PK": "BINARY(16)",
                "CUSTOMER_EMP_DEP_HK": "BINARY(16)",
                "CUSTOMER_ID": "VARCHAR(4)",
                "CUSTOMER_CK": "VARCHAR(4)",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR(4)"
            }
        },
        "RAW_STAGE": {
            "column_types": {
                "CUSTOMER_ID": "VARCHAR(4)",
                "CUSTOMER_CK": "VARCHAR(4)",
                "CUSTOMER_NAME": "VARCHAR(4)",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR(4)"
            }
        }
    }


@fixture
def multi_source_hub_sqlserver(context):
    """
    Define the structures and metadata to load multi-source hubs
    """

    set_metadata(context)

    context.vault_structure_columns['HUB'] = {
        "src_pk": "PART_PK",
        "src_nk": "PART_ID",
        "src_ldts": "LOAD_DATE",
        "src_source": "SOURCE"
    }

    context.vault_structure_columns['HUB_AC'] = {
        "src_pk": "PART_PK",
        "src_nk": "PART_ID",
        "src_extra_columns": "CUSTOMER_MT_ID",
        "src_ldts": "LOAD_DATE",
        "src_source": "SOURCE"
    }

    context.seed_config = {
        "HUB": {
            "column_types": {
                "PART_PK": "BINARY(16)",
                "PART_ID": "VARCHAR(4)",
                "LOAD_DATE": "DATETIME2",
                "SOURCE": "VARCHAR(4)"
            }
        },
        "HUB_AC": {
            "column_types": {
                "PART_PK": "BINARY(16)",
                "PART_ID": "VARCHAR(4)",
                "CUSTOMER_MT_ID": "VARCHAR(13)",
                "CUSTOMER_CK": "VARCHAR(11)",
                "LOAD_DATE": "DATETIME2",
                "SOURCE": "VARCHAR(4)"
            }
        },
        "RAW_STAGE_PARTS": {
            "column_types": {
                "PART_ID": "VARCHAR(4)",
                "PART_NAME": "VARCHAR(10)",
                "PART_TYPE": "VARCHAR(10)",
                "PART_SIZE": "VARCHAR(2)",
                "PART_RETAILPRICE": "DECIMAL(11,2)",
                "CUSTOMER_MT_ID": "VARCHAR(13)",
                "LOAD_DATE": "DATETIME2",
                "SOURCE": "VARCHAR(4)"
            }
        },
        "RAW_STAGE_SUPPLIER": {
            "column_types": {
                "PART_ID": "VARCHAR(4)",
                "SUPPLIER_ID": "VARCHAR(2)",
                "CUSTOMER_MT_ID": "VARCHAR(13)",
                "AVAILQTY": "INT",
                "SUPPLYCOST": "DECIMAL(11,2)",
                "LOAD_DATE": "DATETIME2",
                "SOURCE": "VARCHAR(4)"
            }
        },
        "RAW_STAGE_LINEITEM": {
            "column_types": {
                "ORDER_ID": "VARCHAR(5)",
                "PART_ID": "VARCHAR(4)",
                "CUSTOMER_MT_ID": "VARCHAR(13)",
                "SUPPLIER_ID": "VARCHAR(2)",
                "LINENUMBER": "INT",
                "QUANTITY": "INT",
                "EXTENDED_PRICE": "DECIMAL(11,2)",
                "DISCOUNT": "DECIMAL(11,2)",
                "LOAD_DATE": "DATETIME2",
                "SOURCE": "VARCHAR(4)"
            }
        }
    }


@fixture
def multi_source_comp_pk_hub_sqlserver(context):
    """
    Define the structures and metadata to load multi-source hubs with composite PK
    """

    set_metadata(context)

    context.vault_structure_columns['HUB'] = {
        "src_pk": ["PART_PK", "PART_CK"],
        "src_nk": "PART_ID",
        "src_ldts": "LOAD_DATE",
        "src_source": "SOURCE"
    }

    context.seed_config = {
        "HUB": {
            "column_types": {
                "PART_PK": "BINARY(16)",
                "PART_CK": "VARCHAR(4)",
                "PART_ID": "VARCHAR(4)",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR(4)"
            }
        },
        "RAW_STAGE_PARTS": {
            "column_types": {
                "PART_ID": "VARCHAR(4)",
                "PART_CK": "VARCHAR(4)",
                "PART_NAME": "VARCHAR(10)",
                "PART_TYPE": "VARCHAR(10)",
                "PART_SIZE": "VARCHAR(2)",
                "PART_RETAILPRICE": "DECIMAL(11,2)",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR(4)"
            }
        },
        "RAW_STAGE_SUPPLIER": {
            "column_types": {
                "PART_ID": "VARCHAR(4)",
                "PART_CK": "VARCHAR(4)",
                "SUPPLIER_ID": "VARCHAR(2)",
                "AVAILQTY": "INT",
                "SUPPLYCOST": "DECIMAL(11,2)",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR(4)"
            }
        },
        "RAW_STAGE_LINEITEM": {
            "column_types": {
                "ORDER_ID": "VARCHAR(5)",
                "PART_ID": "VARCHAR(4)",
                "PART_CK": "VARCHAR(4)",
                "SUPPLIER_ID": "VARCHAR(2)",
                "LINENUMBER": "INT",
                "QUANTITY": "INT",
                "EXTENDED_PRICE": "DECIMAL(11,2)",
                "DISCOUNT": "DECIMAL(11,2)",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR(4)"
            }
        }
    }


# Databricks


@fixture
def single_source_hub_databricks(context):
    """
    Define the structures and metadata to load single-source hubs
    """

    set_metadata(context)

    context.seed_config = {
        "HUB": {
            "column_types": {
                "CUSTOMER_PK": "BINARY",
                "CUSTOMER_ID": "VARCHAR(100)",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR(100)"
            }
        },
        "RAW_STAGE": {
            "column_types": {
                "CUSTOMER_ID": "VARCHAR(100)",
                "CUSTOMER_NAME": "VARCHAR(100)",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR(100)"
            }
        }
    }


@fixture
def multi_source_hub_databricks(context):
    """
    Define the structures and metadata to load multi-source hubs
    """

    set_metadata(context)

    context.seed_config = {
        "HUB": {
            "column_types": {
                "PART_PK": "BINARY(16)",
                "PART_ID": "VARCHAR",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR"
            }
        },
        "RAW_STAGE_PARTS": {
            "column_types": {
                "PART_ID": "VARCHAR",
                "PART_NAME": "VARCHAR",
                "PART_TYPE": "VARCHAR",
                "PART_SIZE": "VARCHAR",
                "PART_RETAILPRICE": "NUMBER(38,2)",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR"
            }
        },
        "RAW_STAGE_SUPPLIER": {
            "column_types": {
                "PART_ID": "VARCHAR",
                "SUPPLIER_ID": "VARCHAR",
                "AVAILQTY": "FLOAT",
                "SUPPLYCOST": "NUMBER(38,2)",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR"
            }
        },
        "RAW_STAGE_LINEITEM": {
            "column_types": {
                "ORDER_ID": "VARCHAR",
                "PART_ID": "VARCHAR",
                "SUPPLIER_ID": "VARCHAR",
                "LINENUMBER": "FLOAT",
                "QUANTITY": "FLOAT",
                "EXTENDED_PRICE": "NUMBER(38,2)",
                "DISCOUNT": "NUMBER(38,2)",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR"
            }
        }
    }
