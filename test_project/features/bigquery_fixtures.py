from behave import fixture

from test_project.test_utils.dbt_test_utils import *

"""
The fixtures here are used to supply runtime metadata to tests, which are provided to the model generator.
"""


@fixture
def set_workdir(_):
    """
    Set the working (run) dir for dbt
    """

    os.chdir(TESTS_DBT_ROOT)


@fixture
def sha(context):
    """
    Augment the metadata for a vault structure load to work with SHA hashing instead of MD5
    """

    context.hashing = "SHA"

    if hasattr(context, "seed_config"):

        config = dict(context.seed_config)

        for k, v in config.items():

            for c, t in config[k]["+column_types"].items():

                if t == "BYTES":
                    config[k]["+column_types"][c] = "BYTES"
                if t == "BYTES":
                    config[k]["+column_types"][c] = "BINARY(32)"

    else:
        raise ValueError("sha fixture used before vault structure fixture.")


@fixture
def staging(context):
    """
    Define the structures and metadata to load a hashed staging layer
    """

    context.seed_config = {

        "STG_CUSTOMER": {
            "+column_types": {
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
            "+column_types": {
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
def single_source_link_bigquery(context):
    """
    Define the structures and metadata to load single-source links
    """

    context.hashed_columns = {
        "STG_CUSTOMER": {
            "CUSTOMER_NATION_PK": ["CUSTOMER_ID", "NATION_ID"],
            "CUSTOMER_FK": "CUSTOMER_ID",
            "NATION_FK": "NATION_ID"
        }
    }

    context.vault_structure_columns = {
        "LINK": {
            "src_pk": "CUSTOMER_NATION_PK",
            "src_fk": ["CUSTOMER_FK", "NATION_FK"],
            "src_ldts": "LOAD_DATE",
            "src_source": "SOURCE"
        }
    }

    context.seed_config = {
        "LINK": {
            "+column_types": {
                "CUSTOMER_NATION_PK": "STRING",
                "CUSTOMER_FK": "STRING",
                "NATION_FK": "STRING",
                "LOAD_DATE": "DATE",
                "SOURCE": "STRING"
            }
        },
        "RAW_STAGE": {
            "+column_types": {
                "CUSTOMER_ID": "STRING",
                "NATION_ID": "STRING",
                "CUSTOMER_NAME": "STRING",
                "CUSTOMER_DOB": "DATE",
                "CUSTOMER_PHONE": "STRING",
                "LOAD_DATE": "DATE",
                "SOURCE": "STRING"
            }
        }
    }

@fixture
def multi_source_link_bigquery(context):
    """
    Define the structures and metadata to load single-source links
    """

    context.hashed_columns = {
        "STG_SAP": {
            "CUSTOMER_NATION_PK": ["CUSTOMER_ID", "NATION_ID"],
            "CUSTOMER_FK": "CUSTOMER_ID",
            "NATION_FK": "NATION_ID"
        },
        "STG_CRM": {
            "CUSTOMER_NATION_PK": ["CUSTOMER_ID", "NATION_ID"],
            "CUSTOMER_FK": "CUSTOMER_ID",
            "NATION_FK": "NATION_ID"
        },
        "STG_WEB": {
            "CUSTOMER_NATION_PK": ["CUSTOMER_ID", "NATION_ID"],
            "CUSTOMER_FK": "CUSTOMER_ID",
            "NATION_FK": "NATION_ID"
        },
    }

    context.vault_structure_columns = {
        "LINK": {
            "src_pk": "CUSTOMER_NATION_PK",
            "src_fk": ["CUSTOMER_FK", "NATION_FK"],
            "src_ldts": "LOAD_DATE",
            "src_source": "SOURCE"
        }
    }

    context.seed_config = {
        "LINK": {
            "+column_types": {
                "CUSTOMER_NATION_PK": "STRING",
                "CUSTOMER_FK": "STRING",
                "NATION_FK": "STRING",
                "LOAD_DATE": "DATE",
                "SOURCE": "STRING"
            }
        },
        "RAW_STAGE_SAP": {
            "+column_types": {
                "CUSTOMER_ID": "STRING",
                "NATION_ID": "STRING",
                "CUSTOMER_NAME": "STRING",
                "CUSTOMER_DOB": "DATE",
                "CUSTOMER_PHONE": "STRING",
                "LOAD_DATE": "DATE",
                "SOURCE": "STRING"
            }
        },
        "RAW_STAGE_CRM": {
            "+column_types": {
                "CUSTOMER_ID": "STRING",
                "NATION_ID": "STRING",
                "CUSTOMER_NAME": "STRING",
                "CUSTOMER_DOB": "DATE",
                "CUSTOMER_PHONE": "STRING",
                "LOAD_DATE": "DATE",
                "SOURCE": "STRING"
            }
        },
        "RAW_STAGE_WEB": {
            "+column_types": {
                "CUSTOMER_ID": "STRING",
                "NATION_ID": "STRING",
                "CUSTOMER_NAME": "STRING",
                "CUSTOMER_DOB": "DATE",
                "CUSTOMER_PHONE": "STRING",
                "LOAD_DATE": "DATE",
                "SOURCE": "STRING"
            }
        }
    }
   
@fixture
def satellite_bigquery(context):
    """
    Define the structures and metadata to load satellites
    """

    context.hashed_columns = {
        "STG_CUSTOMER": {
            "CUSTOMER_PK": "CUSTOMER_ID",
            "HASHDIFF": {"is_hashdiff": True,
                         "columns": ["CUSTOMER_ID", "CUSTOMER_DOB", "CUSTOMER_PHONE", "CUSTOMER_NAME"]}
        },
        "STG_CUSTOMER_TS": {
            "CUSTOMER_PK": "CUSTOMER_ID",
            "HASHDIFF": {"is_hashdiff": True,
                         "columns": ["CUSTOMER_ID", "CUSTOMER_DOB", "CUSTOMER_PHONE", "CUSTOMER_NAME"]}
        },
        "STG_CUSTOMER_NO_PK_HASHDIFF": {
            "CUSTOMER_PK": "CUSTOMER_ID",
            "HASHDIFF": {"is_hashdiff": True,
                         "columns": ["CUSTOMER_DOB", "CUSTOMER_PHONE", "CUSTOMER_NAME"]}
        }
    }

    context.derived_columns = {
        "STG_CUSTOMER": {
            "EFFECTIVE_FROM": "LOAD_DATE"
        },
        "STG_CUSTOMER_TS": {
            "EFFECTIVE_FROM": "LOAD_DATETIME"
        },
        "STG_CUSTOMER_NO_PK_HASHDIFF": {
            "EFFECTIVE_FROM": "LOAD_DATE"
        }
    }

    context.vault_structure_columns = {
        "SATELLITE": {
            "src_pk": "CUSTOMER_PK",
            "src_payload": ["CUSTOMER_NAME", "CUSTOMER_PHONE", "CUSTOMER_DOB"],
            "src_hashdiff": "HASHDIFF",
            "src_eff": "EFFECTIVE_FROM",
            "src_ldts": "LOAD_DATE",
            "src_source": "SOURCE"
        },
        "SATELLITE_TS": {
            "src_pk": "CUSTOMER_PK",
            "src_payload": ["CUSTOMER_NAME", "CUSTOMER_PHONE", "CUSTOMER_DOB"],
            "src_hashdiff": "HASHDIFF",
            "src_eff": "EFFECTIVE_FROM",
            "src_ldts": "LOAD_DATETIME",
            "src_source": "SOURCE"
        }
    }

    context.seed_config = {
        "RAW_STAGE": {
            "+column_types": {
                "CUSTOMER_ID": "NUMERIC",
                "CUSTOMER_NAME": "STRING",
                "CUSTOMER_PHONE": "STRING",
                "CUSTOMER_DOB": "DATE",
                "LOAD_DATE": "DATE",
                "SOURCE": "STRING"
            }
        },
        "RAW_STAGE_TS": {
            "+column_types": {
                "CUSTOMER_ID": "NUMERIC",
                "CUSTOMER_NAME": "STRING",
                "CUSTOMER_PHONE": "STRING",
                "CUSTOMER_DOB": "DATE",
                "LOAD_DATETIME": "DATETIME",
                "SOURCE": "STRING"
            }
        },
        "SATELLITE": {
            "+column_types": {
                "CUSTOMER_PK": "STRING",
                "CUSTOMER_NAME": "STRING",
                "CUSTOMER_PHONE": "STRING",
                "CUSTOMER_DOB": "DATE",
                "HASHDIFF": "STRING",
                "EFFECTIVE_FROM": "DATE",
                "LOAD_DATE": "DATE",
                "SOURCE": "STRING"
            }
        },
        "SATELLITE_TS": {
            "+column_types": {
                "CUSTOMER_PK": "STRING",
                "CUSTOMER_NAME": "STRING",
                "CUSTOMER_PHONE": "STRING",
                "CUSTOMER_DOB": "DATE",
                "HASHDIFF": "STRING",
                "EFFECTIVE_FROM": "DATETIME",
                "LOAD_DATETIME": "DATETIME",
                "SOURCE": "STRING"
            }
        }
    }


@fixture
def satellite_cycle_bigquery(context):
    """
    Define the structures and metadata to perform load cycles for satellites
    """

    context.hashed_columns = {
        "STG_CUSTOMER": {
            "CUSTOMER_PK": "CUSTOMER_ID",
            "HASHDIFF": {"is_hashdiff": True,
                         "columns": ["CUSTOMER_DOB", "CUSTOMER_ID", "CUSTOMER_NAME"]}
        },
        "STG_CUSTOMER_NO_PK_HASHDIFF": {
            "CUSTOMER_PK": "CUSTOMER_ID",
            "HASHDIFF": {"is_hashdiff": True,
                         "columns": ["CUSTOMER_DOB", "CUSTOMER_NAME"]}
        }
    }

    context.stage_columns = {
        "RAW_STAGE":
            ["CUSTOMER_ID",
             "CUSTOMER_NAME",
             "CUSTOMER_DOB",
             "EFFECTIVE_FROM",
             "LOAD_DATE",
             "SOURCE"]
    }

    context.vault_structure_columns = {
        "SATELLITE": {
            "src_pk": "CUSTOMER_PK",
            "src_payload": ["CUSTOMER_NAME", "CUSTOMER_DOB"],
            "src_hashdiff": "HASHDIFF",
            "src_eff": "EFFECTIVE_FROM",
            "src_ldts": "LOAD_DATE",
            "src_source": "SOURCE"
        }
    }

    context.seed_config = {
        "RAW_STAGE": {
            "+column_types": {
                "CUSTOMER_ID": "STRING",
                "CUSTOMER_NAME": "STRING",
                "CUSTOMER_DOB": "DATE",
                "EFFECTIVE_FROM": "DATE",
                "LOAD_DATE": "DATE",
                "SOURCE": "STRING"
            }
        },
        "SATELLITE": {
            "+column_types": {
                "CUSTOMER_PK": "STRING",
                "CUSTOMER_NAME": "STRING",
                "CUSTOMER_DOB": "DATE",
                "HASHDIFF": "STRING",
                "EFFECTIVE_FROM": "DATE",
                "LOAD_DATE": "DATE",
                "SOURCE": "STRING"
            }
        }
    }


@fixture
def t_link_bigquery(context):
    """
    Define the structures and metadata to load transactional links
    """

    context.hashed_columns = {
        "STG_CUSTOMER": {
            "TRANSACTION_PK": ["CUSTOMER_ID", "ORDER_ID", "TRANSACTION_NUMBER"],
            "CUSTOMER_FK": "CUSTOMER_ID",
            "ORDER_FK": "ORDER_ID"
        }
    }

    context.derived_columns = {
        "STG_CUSTOMER": {
            "EFFECTIVE_FROM": "TRANSACTION_DATE"
        }
    }

    context.vault_structure_columns = {
        "T_LINK": {
            "src_pk": "TRANSACTION_PK",
            "src_fk": ["CUSTOMER_FK", "ORDER_FK"],
            "src_payload": ["TRANSACTION_NUMBER", "TRANSACTION_DATE",
                            "TYPE", "AMOUNT"],
            "src_eff": "EFFECTIVE_FROM",
            "src_ldts": "LOAD_DATE",
            "src_source": "SOURCE"
        }
    }

    context.seed_config = {
        "RAW_STAGE": {
            "+column_types": {
                "CUSTOMER_ID": "STRING",
                "ORDER_ID": "STRING",
                "TRANSACTION_NUMBER": "NUMERIC",
                "TRANSACTION_DATE": "DATE",
                "TYPE": "STRING",
                "AMOUNT": "NUMERIC",
                "LOAD_DATE": "DATE",
                "SOURCE": "STRING"
            }
        },
        "T_LINK": {
            "+column_types": {
                "TRANSACTION_PK": "STRING",
                "CUSTOMER_FK": "STRING",
                "ORDER_FK": "STRING",
                "TRANSACTION_NUMBER": "NUMERIC",
                "TRANSACTION_DATE": "DATE",
                "TYPE": "STRING",
                "AMOUNT": "NUMERIC",
                "EFFECTIVE_FROM": "DATE",
                "LOAD_DATE": "DATE",
                "SOURCE": "STRING"
            }
        }
    }
