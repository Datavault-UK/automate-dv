from behave import fixture


@fixture
def single_source_hub(context):
    """
    Define the structures and metadata to load single-source hubs
    """

    context.hashed_columns = {
        "STG_CUSTOMER": {
            "CUSTOMER_PK": "CUSTOMER_ID"
        }
    }

    context.vault_structure_columns = {
        "HUB": {
            "src_pk": "CUSTOMER_PK",
            "src_nk": "CUSTOMER_ID",
            "src_ldts": "LOAD_DATE",
            "src_source": "SOURCE"
        }
    }

    context.seed_config = {
        "HUB": {
            "+column_types": {
                "CUSTOMER_PK": "BINARY(16)",
                "CUSTOMER_ID": "VARCHAR",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR"
            }
        },
        "RAW_STAGE": {
            "+column_types": {
                "CUSTOMER_ID": "VARCHAR",
                "CUSTOMER_NAME": "VARCHAR",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR"
            }
        }
    }


@fixture
def multi_source_hub(context):
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
                "PART_ID": "VARCHAR",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR"
            }
        },
        "RAW_STAGE_PARTS": {
            "+column_types": {
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
            "+column_types": {
                "PART_ID": "VARCHAR",
                "SUPPLIER_ID": "VARCHAR",
                "AVAILQTY": "FLOAT",
                "SUPPLYCOST": "NUMBER(38,2)",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR"
            }
        },
        "RAW_STAGE_LINEITEM": {
            "+column_types": {
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


@fixture
def single_source_hub_bigquery(context):
    """
    Define the structures and metadata to load single-source hubs
    """

    context.hashed_columns = {
        "STG_CUSTOMER": {
            "CUSTOMER_PK": "CUSTOMER_ID"
        }
    }

    context.vault_structure_columns = {
        "HUB": {
            "src_pk": "CUSTOMER_PK",
            "src_nk": "CUSTOMER_ID",
            "src_ldts": "LOAD_DATE",
            "src_source": "SOURCE"
        }
    }

    context.seed_config = {
        "HUB": {
            "+column_types": {
                "CUSTOMER_PK": "STRING",
                "CUSTOMER_ID": "STRING",
                "LOAD_DATE": "DATE",
                "SOURCE": "STRING"
            }
        },
        "RAW_STAGE": {
            "+column_types": {
                "CUSTOMER_ID": "STRING",
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
                "PART_PK": "STRING",
                "PART_ID": "STRING",
                "LOAD_DATE": "DATE",
                "SOURCE": "STRING"
            }
        },
        "RAW_STAGE_PARTS": {
            "+column_types": {
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
            "+column_types": {
                "PART_ID": "STRING",
                "SUPPLIER_ID": "STRING",
                "AVAILQTY": "FLOAT",
                "SUPPLYCOST": "NUMERIC",
                "LOAD_DATE": "DATE",
                "SOURCE": "STRING"
            }
        },
        "RAW_STAGE_LINEITEM": {
            "+column_types": {
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


@fixture
def single_source_comppk_hub(context):
    """
    Define the structures and metadata to load single-source hubs with composite PK
    """

    context.hashed_columns = {
        "STG_CUSTOMER": {
            "CUSTOMER_PK": "CUSTOMER_ID"
        }
    }

    context.vault_structure_columns = {
        "HUB": {
            "src_pk": ["CUSTOMER_PK", "CUSTOMER_CK"],
            "src_nk": "CUSTOMER_ID",
            "src_ldts": "LOAD_DATE",
            "src_source": "SOURCE"
        }
    }

    context.seed_config = {
        "HUB": {
            "+column_types": {
                "CUSTOMER_PK": "BINARY(16)",
                "CUSTOMER_CK": "VARCHAR",
                "CUSTOMER_ID": "VARCHAR",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR"
            }
        },
        "RAW_STAGE": {
            "+column_types": {
                "CUSTOMER_ID": "VARCHAR",
                "CUSTOMER_CK": "VARCHAR",
                "CUSTOMER_NAME": "VARCHAR",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR"
            }
        }
    }


@fixture
def single_source_comppk_hub_bigquery(context):
    """
    Define the structures and metadata to load single-source hubs with composite PK
    """

    context.hashed_columns = {
        "STG_CUSTOMER": {
            "CUSTOMER_PK": "CUSTOMER_ID"
        }
    }

    context.vault_structure_columns = {
        "HUB": {
            "src_pk": ["CUSTOMER_PK", "CUSTOMER_CK"],
            "src_nk": "CUSTOMER_ID",
            "src_ldts": "LOAD_DATE",
            "src_source": "SOURCE"
        }
    }

    context.seed_config = {
        "HUB": {
            "+column_types": {
                "CUSTOMER_PK": "STRING",
                "CUSTOMER_CK": "STRING",
                "CUSTOMER_ID": "STRING",
                "LOAD_DATE": "DATE",
                "SOURCE": "STRING"
            }
        },
        "RAW_STAGE": {
            "+column_types": {
                "CUSTOMER_ID": "STRING",
                "CUSTOMER_CK": "STRING",
                "CUSTOMER_NAME": "STRING",
                "LOAD_DATE": "DATE",
                "SOURCE": "STRING"
            }
        }
    }


@fixture
def single_source_comppk_hub_sqlserver(context):
    """
    Define the structures and metadata to load single-source hubs with composite PK
    """

    context.hashed_columns = {
        "STG_CUSTOMER": {
            "CUSTOMER_PK": "CUSTOMER_ID"
        }
    }

    context.vault_structure_columns = {
        "HUB": {
            "src_pk": ["CUSTOMER_PK", "CUSTOMER_CK"],
            "src_nk": "CUSTOMER_ID",
            "src_ldts": "LOAD_DATE",
            "src_source": "SOURCE"
        }
    }

    context.seed_config = {
        "HUB_CUSTOMER": {
            "+column_types": {
                "CUSTOMER_PK": "BINARY(16)",
                "CUSTOMER_CK": "VARCHAR(4)",
                "CUSTOMER_ID": "VARCHAR(4)",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR(4)"
            }
        },
        "HUB_CUSTOMER_SHA": {
            "+column_types": {
                "CUSTOMER_PK": "BINARY(32)",
                "CUSTOMER_CK": "VARCHAR(4)",
                "CUSTOMER_ID": "VARCHAR(4)",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR(4)"
            }
        },
        "HUB": {
            "+column_types": {
                "CUSTOMER_PK": "BINARY(16)",
                "CUSTOMER_CK": "VARCHAR(4)",
                "CUSTOMER_ID": "VARCHAR(4)",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR(4)"
            }
        },
        "RAW_STAGE": {
            "+column_types": {
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
def multi_source_comppk_hub(context):
    """
    Define the structures and metadata to load multi-source hubs with composite PK
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
            "src_pk": ["PART_PK", "PART_CK"],
            "src_nk": "PART_ID",
            "src_ldts": "LOAD_DATE",
            "src_source": "SOURCE"
        }
    }

    context.seed_config = {
        "HUB": {
            "+column_types": {
                "PART_PK": "BINARY(16)",
                "PART_CK": "VARCHAR",
                "PART_ID": "VARCHAR",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR"
            }
        },
        "RAW_STAGE_PARTS": {
            "+column_types": {
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
            "+column_types": {
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
            "+column_types": {
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


@fixture
def multi_source_comppk_hub_bigquery(context):
    """
    Define the structures and metadata to load multi-source hubs with composite PK
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
            "src_pk": ["PART_PK", "PART_CK"],
            "src_nk": "PART_ID",
            "src_ldts": "LOAD_DATE",
            "src_source": "SOURCE"
        }
    }

    context.seed_config = {
        "HUB": {
            "+column_types": {
                "PART_PK": "STRING",
                "PART_CK": "STRING",
                "PART_ID": "STRING",
                "LOAD_DATE": "DATE",
                "SOURCE": "STRING"
            }
        },
        "RAW_STAGE_PARTS": {
            "+column_types": {
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
            "+column_types": {
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
            "+column_types": {
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


@fixture
def multi_source_comppk_hub_sqlserver(context):
    """
    Define the structures and metadata to load multi-source hubs with composite PK
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
            "src_pk": ["PART_PK", "PART_CK"],
            "src_nk": "PART_ID",
            "src_ldts": "LOAD_DATE",
            "src_source": "SOURCE"
        }
    }

    context.seed_config = {
        "HUB": {
            "+column_types": {
                "PART_PK": "BINARY(16)",
                "PART_CK": "VARCHAR(4)",
                "PART_ID": "VARCHAR(4)",
                "LOAD_DATE": "DATETIME",
                "SOURCE": "VARCHAR(4)"
            }
        },
        "RAW_STAGE_PARTS": {
            "+column_types": {
                "PART_ID": "VARCHAR(4)",
                "PART_CK": "VARCHAR(4)",
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
                "PART_CK": "VARCHAR(4)",
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
                "PART_CK": "VARCHAR(4)",
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


@fixture
def single_source_comppknk_hub(context):
    """
    Define the structures and metadata to load single-source hubs with composite PK and NK
    """

    context.hashed_columns = {
        "STG_CUSTOMER": {
            "CUSTOMER_PK1": "CUSTOMER_ID",
            "CUSTOMER_PK2": "CUSTOMER_CK"
        }
    }

    context.vault_structure_columns = {
        "HUB": {
            "src_pk": ["CUSTOMER_PK1", "CUSTOMER_PK2"],
            "src_nk": ["CUSTOMER_ID", "CUSTOMER_CK"],
            "src_ldts": "LOAD_DATE",
            "src_source": "SOURCE"
        }
    }

    context.seed_config = {
        "HUB": {
            "+column_types": {
                "CUSTOMER_PK1": "BINARY(16)",
                "CUSTOMER_PK2": "BINARY(16)",
                "CUSTOMER_ID": "VARCHAR",
                "CUSTOMER_CK": "VARCHAR",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR"
            }
        },
        "RAW_STAGE": {
            "+column_types": {
                "CUSTOMER_ID": "VARCHAR",
                "CUSTOMER_CK": "VARCHAR",
                "CUSTOMER_NAME": "VARCHAR",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR"
            }
        }
    }


@fixture
def single_source_comppknk_hub_bigquery(context):
    """
    Define the structures and metadata to load single-source hubs with composite PK
    """

    context.hashed_columns = {
        "STG_CUSTOMER": {
            "CUSTOMER_PK1": "CUSTOMER_ID",
            "CUSTOMER_PK2": "CUSTOMER_CK"
        }
    }

    context.vault_structure_columns = {
        "HUB": {
            "src_pk": ["CUSTOMER_PK1", "CUSTOMER_PK2"],
            "src_nk": ["CUSTOMER_ID", "CUSTOMER_CK"],
            "src_ldts": "LOAD_DATE",
            "src_source": "SOURCE"
        }
    }

    context.seed_config = {
        "HUB": {
            "+column_types": {
                "CUSTOMER_PK1": "STRING",
                "CUSTOMER_PK2": "STRING",
                "CUSTOMER_ID": "STRING",
                "CUSTOMER_CK": "STRING",
                "LOAD_DATE": "DATE",
                "SOURCE": "STRING"
            }
        },
        "RAW_STAGE": {
            "+column_types": {
                "CUSTOMER_ID": "STRING",
                "CUSTOMER_CK": "STRING",
                "CUSTOMER_NAME": "STRING",
                "LOAD_DATE": "DATE",
                "SOURCE": "STRING"
            }
        }
    }


@fixture
def single_source_comppknk_hub_sqlserver(context):
    """
    Define the structures and metadata to load single-source hubs with composite PK
    """

    context.hashed_columns = {
        "STG_CUSTOMER": {
            "CUSTOMER_PK1": "CUSTOMER_ID",
            "CUSTOMER_PK2": "CUSTOMER_CK"
        }
    }

    context.vault_structure_columns = {
        "HUB": {
            "src_pk": ["CUSTOMER_PK1", "CUSTOMER_PK2"],
            "src_nk": ["CUSTOMER_ID", "CUSTOMER_CK"],
            "src_ldts": "LOAD_DATE",
            "src_source": "SOURCE"
        }
    }

    context.seed_config = {
        "HUB": {
            "+column_types": {
                "CUSTOMER_PK1": "BINARY(16)",
                "CUSTOMER_PK2": "BINARY(16)",
                "CUSTOMER_ID": "VARCHAR(4)",
                "CUSTOMER_CK": "VARCHAR(4)",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR(4)"
            }
        },
        "RAW_STAGE": {
            "+column_types": {
                "CUSTOMER_ID": "VARCHAR(4)",
                "CUSTOMER_CK": "VARCHAR(4)",
                "CUSTOMER_NAME": "VARCHAR(4)",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR(4)"
            }
        }
    }




