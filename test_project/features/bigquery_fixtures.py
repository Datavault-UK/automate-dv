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
                "CUSTOMER_PK": "BYTES",
                "HASHDIFF": "BYTES",
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
                "TRANSACTION_NUMBER": "STRING",
                "TRANSACTION_DATE": "DATE",
                "TYPE": "STRING",
                "AMOUNT": "STRING",
                "LOAD_DATE": "DATE",
                "SOURCE": "STRING"
            }
        },
        "T_LINK": {
            "+column_types": {
                "TRANSACTION_PK": "STRING",
                "CUSTOMER_FK": "STRING",
                "ORDER_FK": "STRING",
                "TRANSACTION_NUMBER": "STRING",
                "TRANSACTION_DATE": "DATE",
                "TYPE": "STRING",
                "AMOUNT": "STRING",
                "EFFECTIVE_FROM": "DATE",
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
                "CUSTOMER_PK": "BYTES",
                "CUSTOMER_NAME": "STRING",
                "CUSTOMER_PHONE": "STRING",
                "CUSTOMER_DOB": "DATE",
                "HASHDIFF": "BYTES",
                "EFFECTIVE_FROM": "DATE",
                "LOAD_DATE": "DATE",
                "SOURCE": "STRING"
            }
        },
        "SATELLITE_TS": {
            "+column_types": {
                "CUSTOMER_PK": "BYTES",
                "CUSTOMER_NAME": "STRING",
                "CUSTOMER_PHONE": "STRING",
                "CUSTOMER_DOB": "DATE",
                "HASHDIFF": "BYTES",
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
                "CUSTOMER_PK": "BYTES",
                "CUSTOMER_NAME": "STRING",
                "CUSTOMER_DOB": "DATE",
                "HASHDIFF": "BYTES",
                "EFFECTIVE_FROM": "DATE",
                "LOAD_DATE": "DATE",
                "SOURCE": "STRING"
            }
        }
    }


@fixture
def eff_satellite_bigquery(context):
    """
    Define the structures and metadata to load effectivity satellites
    """

    context.hashed_columns = {
        "STG_CUSTOMER": {
            "CUSTOMER_ORDER_PK": ["CUSTOMER_ID", "ORDER_ID"],
            "CUSTOMER_PK": "CUSTOMER_ID",
            "ORDER_PK": "ORDER_ID"
        }
    }

    context.vault_structure_columns = {
        "EFF_SAT": {
            "src_pk": "CUSTOMER_ORDER_PK",
            "src_dfk": ["ORDER_PK"],
            "src_sfk": "CUSTOMER_PK",
            "src_start_date": "START_DATE",
            "src_end_date": "END_DATE",
            "src_eff": "EFFECTIVE_FROM",
            "src_ldts": "LOAD_DATE",
            "src_source": "SOURCE"
        }
    }

    context.seed_config = {
        "RAW_STAGE": {
            "+column_types": {
                "CUSTOMER_ID": "NUMERIC",
                "ORDER_ID": "STRING",
                "START_DATE": "DATE",
                "END_DATE": "DATE",
                "LOAD_DATE": "DATE",
                "SOURCE": "STRING"
            }
        },
        "EFF_SAT": {
            "+column_types": {
                "CUSTOMER_ORDER_PK": "BYTES",
                "CUSTOMER_PK": "BYTES",
                "ORDER_PK": "BYTES",
                "START_DATE": "DATE",
                "END_DATE": "DATE",
                "EFFECTIVE_FROM": "DATE",
                "LOAD_DATE": "DATE",
                "SOURCE": "STRING"
            }
        }
    }


@fixture
def eff_satellite_testing_auto_end_dating_bigquery(context):
    """
    Define the structures and metadata to load effectivity satellites
    """

    context.hashed_columns = {
        "STG_CUSTOMER_ORDER": {
            "CUSTOMER_ORDER_PK": ["CUSTOMER_ID", "ORDER_ID"],
            "CUSTOMER_PK": "CUSTOMER_ID",
            "ORDER_PK": "ORDER_ID"
        },
        "STG_ORDER_CUSTOMER": {
            "ORDER_CUSTOMER_PK": ["CUSTOMER_ID", "ORDER_ID"],
            "CUSTOMER_PK": "CUSTOMER_ID",
            "ORDER_PK": "ORDER_ID"
        }
    }

    context.vault_structure_columns = {
        "LINK_CUSTOMER_ORDER": {
            "source_model": "STG_CUSTOMER_ORDER",
            "src_pk": "CUSTOMER_ORDER_PK",
            "src_fk": ["CUSTOMER_PK", "ORDER_PK"],
            "src_ldts": "LOAD_DATETIME",
            "src_source": "SOURCE"
        },
        "LINK_ORDER_CUSTOMER": {
            "source_model": "STG_ORDER_CUSTOMER",
            "src_pk": "ORDER_CUSTOMER_PK",
            "src_fk": ["CUSTOMER_PK", "ORDER_PK"],
            "src_ldts": "LOAD_DATETIME",
            "src_source": "SOURCE"
        },
        "EFF_SAT_CUSTOMER_ORDER": {
            "source_model": "STG_CUSTOMER_ORDER",
            "src_pk": "CUSTOMER_ORDER_PK",
            "src_dfk": ["CUSTOMER_PK"],
            "src_sfk": "ORDER_PK",
            "src_start_date": "START_DATE",
            "src_end_date": "END_DATE",
            "src_eff": "EFFECTIVE_FROM",
            "src_ldts": "LOAD_DATETIME",
            "src_source": "SOURCE"
        },
        "EFF_SAT_ORDER_CUSTOMER": {
            "source_model": "STG_ORDER_CUSTOMER",
            "src_pk": "ORDER_CUSTOMER_PK",
            "src_dfk": ["ORDER_PK"],
            "src_sfk": "CUSTOMER_PK",
            "src_start_date": "START_DATE",
            "src_end_date": "END_DATE",
            "src_eff": "EFFECTIVE_FROM",
            "src_ldts": "LOAD_DATETIME",
            "src_source": "SOURCE"
        }
    }

    context.seed_config = {
        "RAW_STAGE_CUSTOMER_ORDER": {
            "+column_types": {
                "CUSTOMER_ID": "STRING",
                "ORDER_ID": "STRING",
                "START_DATE": "DATETIME",
                "END_DATE": "DATETIME",
                "EFFECTIVE_FROM": "DATETIME",
                "LOAD_DATETIME": "DATETIME",
                "SOURCE": "STRING"
            }
        },
        "RAW_STAGE_ORDER_CUSTOMER": {
            "+column_types": {
                "CUSTOMER_ID": "STRING",
                "ORDER_ID": "STRING",
                "START_DATE": "DATETIME",
                "END_DATE": "DATETIME",
                "EFFECTIVE_FROM": "DATETIME",
                "LOAD_DATETIME": "DATETIME",
                "SOURCE": "STRING"
            }
        },
        "LINK_CUSTOMER_ORDER": {
            "+column_types": {
                "CUSTOMER_ORDER_PK": "BYTES",
                "CUSTOMER_PK": "BYTES",
                "ORDER_PK": "BYTES",
                "LOAD_DATETIME": "DATETIME",
                "SOURCE": "STRING"
            }
        },
        "LINK_ORDER_CUSTOMER": {
            "+column_types": {
                "ORDER_CUSTOMER_PK": "BYTES",
                "CUSTOMER_PK": "BYTES",
                "ORDER_PK": "BYTES",
                "LOAD_DATETIME": "DATETIME",
                "SOURCE": "STRING"
            }
        },
        "EFF_SAT_CUSTOMER_ORDER": {
            "+column_types": {
                "CUSTOMER_ORDER_PK": "BYTES",
                "CUSTOMER_PK": "BYTES",
                "ORDER_PK": "BYTES",
                "START_DATE": "DATETIME",
                "END_DATE": "DATETIME",
                "EFFECTIVE_FROM": "DATETIME",
                "LOAD_DATETIME": "DATETIME",
                "SOURCE": "STRING"
            }
        },
        "EFF_SAT_ORDER_CUSTOMER": {
            "+column_types": {
                "ORDER_CUSTOMER_PK": "BYTES",
                "CUSTOMER_PK": "BYTES",
                "ORDER_PK": "BYTES",
                "START_DATE": "DATETIME",
                "END_DATE": "DATETIME",
                "EFFECTIVE_FROM": "DATETIME",
                "LOAD_DATETIME": "DATETIME",
                "SOURCE": "STRING"
            }
        }
    }


@fixture
def eff_satellite_multipart_bigquery(context):
    """
    Define the structures and metadata to load effectivity satellites with multipart keys
    """

    context.hashed_columns = {
        "STG_CUSTOMER": {
            "CUSTOMER_ORDER_PK": ["CUSTOMER_ID", "ORDER_ID", "NATION_ID", "PLATFORM_ID", "ORGANISATION_ID"],
            "CUSTOMER_PK": "CUSTOMER_ID",
            "NATION_PK": "NATION_ID",
            "ORDER_PK": "ORDER_ID",
            "PLATFORM_PK": "PLATFORM_ID",
            "ORGANISATION_PK": "ORGANISATION_ID"
        }
    }

    context.vault_structure_columns = {
        "EFF_SAT": {
            "src_pk": "CUSTOMER_ORDER_PK",
            "src_dfk": ["ORDER_PK", "PLATFORM_PK", "ORGANISATION_PK"],
            "src_sfk": ["CUSTOMER_PK", "NATION_PK"],
            "src_start_date": "START_DATE",
            "src_end_date": "END_DATE",
            "src_eff": "EFFECTIVE_FROM",
            "src_ldts": "LOAD_DATE",
            "src_source": "SOURCE"
        }
    }

    context.seed_config = {
        "RAW_STAGE": {
            "+column_types": {
                "CUSTOMER_ID": "NUMERIC",
                "NATION_ID": "STRING",
                "ORDER_ID": "STRING",
                "PLATFORM_ID": "STRING",
                "ORGANISATION_ID": "STRING",
                "START_DATE": "DATE",
                "END_DATE": "DATE",
                "LOAD_DATE": "DATE",
                "SOURCE": "STRING"
            }
        },
        "EFF_SAT": {
            "+column_types": {
                "CUSTOMER_ORDER_PK": "BYTES",
                "ORDER_PK": "BYTES",
                "PLATFORM_PK": "BYTES",
                "ORGANISATION_PK": "BYTES",
                "CUSTOMER_PK": "BYTES",
                "NATION_PK": "BYTES",
                "START_DATE": "DATE",
                "END_DATE": "DATE",
                "EFFECTIVE_FROM": "DATE",
                "LOAD_DATE": "DATE",
                "SOURCE": "STRING"
            }
        }
    }


def bridge_bigquery(context):
    """
    Define the structures and metadata to perform bridge load
    """

    context.vault_structure_type = "bridge"

    context.hashed_columns = {
        "STG_CUSTOMER_ORDER": {
            "CUSTOMER_PK": "CUSTOMER_ID",
            "CUSTOMER_FK": "CUSTOMER_ID",
            "ORDER_PK": "ORDER_ID",
            "ORDER_FK": "ORDER_ID",
            "CUSTOMER_ORDER_PK": {"is_hashdiff": True,
                                  "columns": ["CUSTOMER_ID", "ORDER_ID"]
                                  },
        },
        "STG_ORDER_PRODUCT": {
            "ORDER_PK": "ORDER_ID",
            "ORDER_FK": "ORDER_ID",
            "PRODUCT_PK": "PRODUCT_ID",
            "PRODUCT_FK": "PRODUCT_ID",
            "ORDER_PRODUCT_PK": {"is_hashdiff": True,
                                 "columns": ["ORDER_ID", "PRODUCT_ID"]
                                 }
        },
        "STG_PRODUCT_COMPONENT": {
            "PRODUCT_PK": "PRODUCT_ID",
            "PRODUCT_FK": "PRODUCT_ID",
            "COMPONENT_PK": "COMPONENT_ID",
            "COMPONENT_FK": "COMPONENT_ID",
            "PRODUCT_COMPONENT_PK": {"is_hashdiff": True,
                                     "columns": ["COMPONENT_ID", "PRODUCT_ID"]
                                     }
        }
    }

    context.derived_columns = {
        "STG_CUSTOMER_ORDER": {
            "EFFECTIVE_FROM": "LOAD_DATETIME",
            "START_DATE": "LOAD_DATETIME"
        },
        "STG_ORDER_PRODUCT": {
            "EFFECTIVE_FROM": "LOAD_DATETIME",
            "START_DATE": "LOAD_DATETIME"
        },
        "STG_PRODUCT_COMPONENT": {
            "EFFECTIVE_FROM": "LOAD_DATETIME",
            "START_DATE": "LOAD_DATETIME"
        }
    }

    context.vault_structure_columns = {
        "HUB_CUSTOMER": {
            "source_model": "STG_CUSTOMER_ORDER",
            "src_pk": "CUSTOMER_PK",
            "src_nk": "CUSTOMER_ID",
            "src_ldts": "LOAD_DATETIME",
            "src_source": "SOURCE"
        },
        "LINK_CUSTOMER_ORDER": {
            "source_model": "STG_CUSTOMER_ORDER",
            "src_pk": "CUSTOMER_ORDER_PK",
            "src_fk": ["CUSTOMER_FK", "ORDER_FK"],
            "src_ldts": "LOAD_DATETIME",
            "src_source": "SOURCE"
        },
        "LINK_ORDER_PRODUCT": {
            "source_model": "STG_ORDER_PRODUCT",
            "src_pk": "ORDER_PRODUCT_PK",
            "src_fk": ["ORDER_FK", "PRODUCT_FK"],
            "src_ldts": "LOAD_DATETIME",
            "src_source": "SOURCE"
        },
        "LINK_PRODUCT_COMPONENT": {
            "source_model": "STG_PRODUCT_COMPONENT",
            "src_pk": "PRODUCT_COMPONENT_PK",
            "src_fk": ["PRODUCT_FK", "COMPONENT_FK"],
            "src_ldts": "LOAD_DATETIME",
            "src_source": "SOURCE"
        },
        "EFF_SAT_CUSTOMER_ORDER": {
            "source_model": "STG_CUSTOMER_ORDER",
            "src_pk": "CUSTOMER_ORDER_PK",
            "src_dfk": ["ORDER_FK"],
            "src_sfk": ["CUSTOMER_FK"],
            "src_start_date": "START_DATE",
            "src_end_date": "END_DATE",
            "src_eff": "EFFECTIVE_FROM",
            "src_ldts": "LOAD_DATETIME",
            "src_source": "SOURCE"
        },
        "EFF_SAT_ORDER_PRODUCT": {
            "source_model": "STG_ORDER_PRODUCT",
            "src_pk": "ORDER_PRODUCT_PK",
            "src_dfk": ["ORDER_FK"],
            "src_sfk": ["PRODUCT_FK"],
            "src_start_date": "START_DATE",
            "src_end_date": "END_DATE",
            "src_eff": "EFFECTIVE_FROM",
            "src_ldts": "LOAD_DATETIME",
            "src_source": "SOURCE"
        },
        "EFF_SAT_PRODUCT_COMPONENT": {
            "source_model": "STG_PRODUCT_COMPONENT",
            "src_pk": "PRODUCT_COMPONENT_PK",
            "src_dfk": ["COMPONENT_FK"],
            "src_sfk": ["PRODUCT_FK"],
            "src_start_date": "START_DATE",
            "src_end_date": "END_DATE",
            "src_eff": "EFFECTIVE_FROM",
            "src_ldts": "LOAD_DATETIME",
            "src_source": "SOURCE"
        },
        "BRIDGE_CUSTOMER_ORDER": {
            "source_model": "HUB_CUSTOMER",
            "src_pk": "CUSTOMER_PK",
            "src_ldts": "LOAD_DATETIME",
            "as_of_dates_table": "AS_OF_DATE",
            "bridge_walk": {
                "CUSTOMER_ORDER": {
                    "bridge_link_pk": "LINK_CUSTOMER_ORDER_PK",
                    "bridge_end_date": "EFF_SAT_CUSTOMER_ORDER_ENDDATE",
                    "bridge_load_date": "EFF_SAT_CUSTOMER_ORDER_LOADDATE",
                    "link_table": "LINK_CUSTOMER_ORDER",
                    "link_pk": "CUSTOMER_ORDER_PK",
                    "link_fk1": "CUSTOMER_FK",
                    "link_fk2": "ORDER_FK",
                    "eff_sat_table": "EFF_SAT_CUSTOMER_ORDER",
                    "eff_sat_pk": "CUSTOMER_ORDER_PK",
                    "eff_sat_end_date": "END_DATE",
                    "eff_sat_load_date": "LOAD_DATETIME"
                }
            },
            "stage_tables_ldts":
                {
                    "STG_CUSTOMER_ORDER": "LOAD_DATETIME"
                }
        },
        "BRIDGE_CUSTOMER_ORDER_PRODUCT": {
            "source_model": "HUB_CUSTOMER",
            "src_pk": "CUSTOMER_PK",
            "src_ldts": "LOAD_DATETIME",
            "as_of_dates_table": "AS_OF_DATE",
            "bridge_walk": {
                "CUSTOMER_ORDER": {
                    "bridge_link_pk": "LINK_CUSTOMER_ORDER_PK",
                    "bridge_end_date": "EFF_SAT_CUSTOMER_ORDER_ENDDATE",
                    "bridge_load_date": "EFF_SAT_CUSTOMER_ORDER_LOADDATE",
                    "link_table": "LINK_CUSTOMER_ORDER",
                    "link_pk": "CUSTOMER_ORDER_PK",
                    "link_fk1": "CUSTOMER_FK",
                    "link_fk2": "ORDER_FK",
                    "eff_sat_table": "EFF_SAT_CUSTOMER_ORDER",
                    "eff_sat_pk": "CUSTOMER_ORDER_PK",
                    "eff_sat_end_date": "END_DATE",
                    "eff_sat_load_date": "LOAD_DATETIME"
                },
                "ORDER_PRODUCT": {
                    "bridge_link_pk": "LINK_ORDER_PRODUCT_PK",
                    "bridge_end_date": "EFF_SAT_ORDER_PRODUCT_ENDDATE",
                    "bridge_load_date": "EFF_SAT_ORDER_PRODUCT_LOADDATE",
                    "link_table": "LINK_ORDER_PRODUCT",
                    "link_pk": "ORDER_PRODUCT_PK",
                    "link_fk1": "ORDER_FK",
                    "link_fk2": "PRODUCT_FK",
                    "eff_sat_table": "EFF_SAT_ORDER_PRODUCT",
                    "eff_sat_pk": "ORDER_PRODUCT_PK",
                    "eff_sat_end_date": "END_DATE",
                    "eff_sat_load_date": "LOAD_DATETIME"
                }
            },
            "stage_tables_ldts":
                {
                    "STG_CUSTOMER_ORDER": "LOAD_DATETIME",
                    "STG_ORDER_PRODUCT": "LOAD_DATETIME"
                }
        },
        "BRIDGE_CUSTOMER_ORDER_PRODUCT_COMPONENT": {
            "source_model": "HUB_CUSTOMER",
            "src_pk": "CUSTOMER_PK",
            "src_ldts": "LOAD_DATETIME",
            "as_of_dates_table": "AS_OF_DATE",
            "bridge_walk": {
                "CUSTOMER_ORDER": {
                    "bridge_link_pk": "LINK_CUSTOMER_ORDER_PK",
                    "bridge_end_date": "EFF_SAT_CUSTOMER_ORDER_ENDDATE",
                    "bridge_load_date": "EFF_SAT_CUSTOMER_ORDER_LOADDATE",
                    "link_table": "LINK_CUSTOMER_ORDER",
                    "link_pk": "CUSTOMER_ORDER_PK",
                    "link_fk1": "CUSTOMER_FK",
                    "link_fk2": "ORDER_FK",
                    "eff_sat_table": "EFF_SAT_CUSTOMER_ORDER",
                    "eff_sat_pk": "CUSTOMER_ORDER_PK",
                    "eff_sat_end_date": "END_DATE",
                    "eff_sat_load_date": "LOAD_DATETIME"
                },
                "ORDER_PRODUCT": {
                    "bridge_link_pk": "LINK_ORDER_PRODUCT_PK",
                    "bridge_end_date": "EFF_SAT_ORDER_PRODUCT_ENDDATE",
                    "bridge_load_date": "EFF_SAT_ORDER_PRODUCT_LOADDATE",
                    "link_table": "LINK_ORDER_PRODUCT",
                    "link_pk": "ORDER_PRODUCT_PK",
                    "link_fk1": "ORDER_FK",
                    "link_fk2": "PRODUCT_FK",
                    "eff_sat_table": "EFF_SAT_ORDER_PRODUCT",
                    "eff_sat_pk": "ORDER_PRODUCT_PK",
                    "eff_sat_end_date": "END_DATE",
                    "eff_sat_load_date": "LOAD_DATETIME"
                },
                "PRODUCT_COMPONENT": {
                    "bridge_link_pk": "LINK_PRODUCT_COMPONENT_PK",
                    "bridge_end_date": "EFF_SAT_PRODUCT_COMPONENT_ENDDATE",
                    "bridge_load_date": "EFF_SAT_PRODUCT_COMPONENT_LOADDATE",
                    "link_table": "LINK_PRODUCT_COMPONENT",
                    "link_pk": "PRODUCT_COMPONENT_PK",
                    "link_fk1": "PRODUCT_FK",
                    "link_fk2": "COMPONENT_FK",
                    "eff_sat_table": "EFF_SAT_PRODUCT_COMPONENT",
                    "eff_sat_pk": "PRODUCT_COMPONENT_PK",
                    "eff_sat_end_date": "END_DATE",
                    "eff_sat_load_date": "LOAD_DATETIME"
                }
            },
            "stage_tables_ldts":
                {
                    "STG_CUSTOMER_ORDER": "LOAD_DATETIME",
                    "STG_ORDER_PRODUCT": "LOAD_DATETIME",
                    "STG_PRODUCT_COMPONENT": "LOAD_DATETIME"
                }
        }
   }

    context.stage_columns = {
        "RAW_CUSTOMER_ORDER":
            ["CUSTOMER_ID",
             "ORDER_ID",
             "LOAD_DATETIME",
             "END_DATE"
             "SOURCE"],
        "RAW_ORDER_PRODUCT":
            ["ORDER_ID",
             "PRODUCT_ID",
             "LOAD_DATETIME",
             "END_DATE"
             "SOURCE"],
        "RAW_PRODUCT_COMPONENT":
            ["PRODUCT_ID",
             "COMPONENT_ID",
             "LOAD_DATETIME",
             "END_DATE"
             "SOURCE"]
    }

    context.seed_config = {
        "RAW_CUSTOMER_ORDER": {
            "+column_types": {
                "CUSTOMER_ID": "STRING",
                "ORDER_ID": "STRING",
                "LOAD_DATETIME": "DATETIME",
                "END_DATE": "DATETIME",
                "SOURCE": "STRING"
            }
        },
        "RAW_ORDER_PRODUCT": {
            "+column_types": {
                "ORDER_ID": "STRING",
                "PRODUCT_ID": "STRING",
                "LOAD_DATETIME": "DATETIME",
                "END_DATE": "DATETIME",
                "SOURCE": "STRING"
            }
        },
        "RAW_PRODUCT_COMPONENT": {
            "+column_types": {
                "PRODUCT_ID": "STRING",
                "COMPONENT_ID": "STRING",
                "LOAD_DATETIME": "DATETIME",
                "END_DATE": "DATETIME",
                "SOURCE": "STRING"
            }
        },
        "HUB_CUSTOMER": {
            "+column_types": {
                "CUSTOMER_PK": "BYTES",
                "CUSTOMER_ID": "STRING",
                "LOAD_DATETIME": "DATETIME",
                "SOURCE": "STRING"
            }
        },
        "LINK_CUSTOMER_ORDER": {
            "+column_types": {
                "CUSTOMER_ORDER_PK": "BYTES",
                "CUSTOMER_FK": "BYTES",
                "ORDER_FK": "BYTES",
                "LOAD_DATETIME": "DATETIME",
                "SOURCE": "STRING"
            }
        },
        "LINK_ORDER_PRODUCT": {
            "+column_types": {
                "ORDER_PRODUCT_PK": "BYTES",
                "ORDER_FK": "BYTES",
                "PRODUCT_FK": "BYTES",
                "LOAD_DATETIME": "DATETIME",
                "SOURCE": "STRING"
            }
        },
        "LINK_PRODUCT_COMPONENT": {
            "+column_types": {
                "PRODUCT_COMPONENT_PK": "BYTES",
                "PRODUCT_FK": "BYTES",
                "COMPONENT_FK": "BYTES",
                "LOAD_DATETIME": "DATETIME",
                "SOURCE": "STRING"
            }
        },
        "EFF_SAT_CUSTOMER_ORDER": {
            "+column_types": {
                "CUSTOMER_ORDER_PK": "BYTES",
                "CUSTOMER_FK": "BYTES",
                "ORDER_FK": "BYTES",
                "START_DATE": "DATETIME",
                "END_DATE": "DATETIME",
                "EFFECTIVE_FROM": "DATETIME",
                "LOAD_DATETIME": "DATETIME",
                "SOURCE": "STRING"
            }
        },
        "EFF_SAT_ORDER_PRODUCT": {
            "+column_types": {
                "ORDER_PRODUCT_PK": "BYTES",
                "ORDER_FK": "BYTES",
                "PRODUCT_FK": "BYTES",
                "START_DATE": "DATETIME",
                "END_DATE": "DATETIME",
                "EFFECTIVE_FROM": "DATETIME",
                "LOAD_DATETIME": "DATETIME",
                "SOURCE": "STRING"
            }
        },
        "EFF_SAT_PRODUCT_COMPONENT": {
            "+column_types": {
                "PRODUCT_COMPONENT_PK": "BYTES",
                "PRODUCT_FK": "BYTES",
                "COMPONENT_FK": "BYTES",
                "START_DATE": "DATETIME",
                "END_DATE": "DATETIME",
                "EFFECTIVE_FROM": "DATETIME",
                "LOAD_DATETIME": "DATETIME",
                "SOURCE": "STRING"
            }
        },
        "AS_OF_DATE": {
            "+column_types": {
                "AS_OF_DATE": "DATETIME"
            }
        },
        "BRIDGE_CUSTOMER_ORDER": {
            "+column_types": {
                "CUSTOMER_PK": "BYTES",
                "AS_OF_DATE": "DATETIME",
                "LINK_CUSTOMER_ORDER_PK": "BYTES",
            }
        },
        "BRIDGE_CUSTOMER_ORDER_PRODUCT": {
            "+column_types": {
                "CUSTOMER_PK": "BYTES",
                "AS_OF_DATE": "DATETIME",
                "LINK_CUSTOMER_ORDER_PK": "BYTES",
                "LINK_ORDER_PRODUCT_PK": "BYTES",
            }
        },
        "BRIDGE_CUSTOMER_ORDER_PRODUCT_COMPONENT": {
            "+column_types": {
                "CUSTOMER_PK": "BYTES",
                "AS_OF_DATE": "DATETIME",
                "LINK_CUSTOMER_ORDER_PK": "BYTES",
                "LINK_ORDER_PRODUCT_PK": "BYTES",
                "LINK_PRODUCT_COMPONENT_PK": "BYTES",
            }
        }
    }


@fixture
def pit_bigquery(context):
    """
    Define the structures and metadata to perform PIT load
    """

    context.vault_structure_type = "pit"

    context.hashed_columns = {
        "STG_CUSTOMER_DETAILS": {
            "CUSTOMER_PK": "CUSTOMER_ID",
            "HASHDIFF": {"is_hashdiff": True,
                         "columns": ["CUSTOMER_ADDRESS", "CUSTOMER_DOB", "CUSTOMER_NAME"]
                         }
        },
        "STG_CUSTOMER_LOGIN": {
            "CUSTOMER_PK": "CUSTOMER_ID",
            "HASHDIFF": {"is_hashdiff": True,
                         "columns": ["DEVICE_USED", "LAST_LOGIN_DATE"]
                         }
        },
        "STG_CUSTOMER_PROFILE": {
            "CUSTOMER_PK": "CUSTOMER_ID",
            "HASHDIFF": {"is_hashdiff": True,
                         "columns": ["DASHBOARD_COLOUR", "DISPLAY_NAME"]
                         }
        }
    }

    context.derived_columns = {
        "STG_CUSTOMER_DETAILS": {
            "EFFECTIVE_FROM": "LOAD_DATE"
        },
        "STG_CUSTOMER_LOGIN": {
            "EFFECTIVE_FROM": "LOAD_DATE"
        },
        "STG_CUSTOMER_PROFILE": {
            "EFFECTIVE_FROM": "LOAD_DATE"
        }
    }

    context.vault_structure_columns = {
        "HUB_CUSTOMER": {
            "source_model": ["STG_CUSTOMER_DETAILS",
                             "STG_CUSTOMER_LOGIN",
                             "STG_CUSTOMER_PROFILE"],
            "src_pk": "CUSTOMER_PK",
            "src_nk": "CUSTOMER_ID",
            "src_ldts": "LOAD_DATE",
            "src_source": "SOURCE"
        },
        "SAT_CUSTOMER_DETAILS": {
            "source_model": "STG_CUSTOMER_DETAILS",
            "src_pk": "CUSTOMER_PK",
            "src_hashdiff": "HASHDIFF",
            "src_payload": ["CUSTOMER_NAME", "CUSTOMER_ADDRESS", "CUSTOMER_DOB"],
            "src_eff": "EFFECTIVE_FROM",
            "src_ldts": "LOAD_DATE",
            "src_source": "SOURCE"
        },
        "SAT_CUSTOMER_LOGIN": {
            "source_model": "STG_CUSTOMER_LOGIN",
            "src_pk": "CUSTOMER_PK",
            "src_hashdiff": "HASHDIFF",
            "src_payload": ["LAST_LOGIN_DATE", "DEVICE_USED"],
            "src_eff": "EFFECTIVE_FROM",
            "src_ldts": "LOAD_DATE",
            "src_source": "SOURCE"
        },
        "SAT_CUSTOMER_PROFILE": {
            "source_model": "STG_CUSTOMER_PROFILE",
            "src_pk": "CUSTOMER_PK",
            "src_hashdiff": "HASHDIFF",
            "src_payload": ["DASHBOARD_COLOUR", "DISPLAY_NAME"],
            "src_eff": "EFFECTIVE_FROM",
            "src_ldts": "LOAD_DATE",
            "src_source": "SOURCE"
        },
        "PIT_CUSTOMER": {
            "source_model": "HUB_CUSTOMER",
            "src_pk": "CUSTOMER_PK",
            "as_of_dates_table": "AS_OF_DATE",
            "satellites":
                {
                    "SAT_CUSTOMER_DETAILS": {
                        "pk":
                            {"PK": "CUSTOMER_PK"},
                        "ldts":
                            {"LDTS": "LOAD_DATE"}
                    },
                    "SAT_CUSTOMER_LOGIN": {
                        "pk":
                            {"PK": "CUSTOMER_PK"},
                        "ldts":
                            {"LDTS": "LOAD_DATE"}
                    },
                    "SAT_CUSTOMER_PROFILE": {
                        "pk":
                            {"PK": "CUSTOMER_PK"},
                        "ldts":
                            {"LDTS": "LOAD_DATE"}
                    }
                },
            "stage_tables":
                {
                    "STG_CUSTOMER_DETAILS": "LOAD_DATE",
                    "STG_CUSTOMER_LOGIN": "LOAD_DATE",
                    "STG_CUSTOMER_PROFILE": "LOAD_DATE"
                },
            "src_ldts": "LOAD_DATE"
        }
    }

    context.stage_columns = {
        "RAW_STAGE_DETAILS":
            ["CUSTOMER_ID",
             "CUSTOMER_NAME",
             "CUSTOMER_ADDRESS",
             "CUSTOMER_DOB",
             "LOAD_DATE",
             "SOURCE"]
        ,
        "RAW_STAGE_LOGIN":
            ["CUSTOMER_ID",
             "LAST_LOGIN_DATE",
             "DEVICE_USED",
             "LOAD_DATE",
             "SOURCE"]
        ,
        "RAW_STAGE_PROFILE":
            ["CUSTOMER_ID",
             "DASHBOARD_COLOUR",
             "DISPLAY_NAME",
             "LOAD_DATE",
             "SOURCE"]
    }

    context.seed_config = {
        "RAW_STAGE_DETAILS": {
            "+column_types": {
                "CUSTOMER_ID": "STRING",
                "CUSTOMER_NAME": "STRING",
                "CUSTOMER_ADDRESS": "STRING",
                "CUSTOMER_DOB": "DATE",
                "LOAD_DATE": "DATETIME",
                "SOURCE": "STRING"
            }
        },
        "RAW_STAGE_LOGIN": {
            "+column_types": {
                "CUSTOMER_ID": "STRING",
                "LAST_LOGIN_DATE": "DATETIME",
                "DEVICE_USED": "STRING",
                "LOAD_DATE": "DATETIME",
                "SOURCE": "STRING"
            }
        },
        "RAW_STAGE_PROFILE": {
            "+column_types": {
                "CUSTOMER_ID": "STRING",
                "DASHBOARD_COLOUR": "STRING",
                "DISPLAY_NAME": "STRING",
                "LOAD_DATE": "DATETIME",
                "SOURCE": "STRING"
            }
        },
        "HUB_CUSTOMER": {
            "+column_types": {
                "CUSTOMER_PK": "BYTES",
                "CUSTOMER_ID": "STRING",
                "LOAD_DATE": "DATETIME",
                "SOURCE": "STRING"
            }
        },
        "SAT_CUSTOMER_DETAILS": {
            "+column_types": {
                "CUSTOMER_PK": "BYTES",
                "HASHDIFF": "BYTES",
                "CUSTOMER_NAME": "STRING",
                "CUSTOMER_ADDRESS": "STRING",
                "CUSTOMER_DOB": "DATE",
                "EFFECTIVE_FROM": "DATETIME",
                "LOAD_DATE": "DATETIME",
                "SOURCE": "STRING"
            }
        },
        "SAT_CUSTOMER_LOGIN": {
            "+column_types": {
                "CUSTOMER_PK": "BYTES",
                "HASHDIFF": "BYTES",
                "DEVICE_USED": "STRING",
                "LAST_LOGIN_DATE": "DATETIME",
                "EFFECTIVE_FROM": "DATETIME",
                "LOAD_DATE": "DATETIME",
                "SOURCE": "STRING"
            }
        },
        "SAT_CUSTOMER_PROFILE": {
            "+column_types": {
                "CUSTOMER_PK": "BYTES",
                "HASHDIFF": "BYTES",
                "DASHBOARD_COLOUR": "STRING",
                "DISPLAY_NAME": "STRING",
                "EFFECTIVE_FROM": "DATETIME",
                "LOAD_DATE": "DATETIME",
                "SOURCE": "STRING"
            }
        },
        "AS_OF_DATE": {
            "+column_types": {
                "AS_OF_DATE": "DATETIME"
            }
        },
        "PIT_CUSTOMER": {
            "+column_types": {
                "AS_OF_DATE": "DATETIME",
                "CUSTOMER_PK": "BYTES",
                "SAT_CUSTOMER_DETAILS_PK": "BYTES",
                "SAT_CUSTOMER_DETAILS_LDTS": "DATETIME",
                "SAT_CUSTOMER_LOGIN_PK": "BYTES",
                "SAT_CUSTOMER_LOGIN_LDTS": "DATETIME",
                "SAT_CUSTOMER_PROFILE_PK": "BYTES",
                "SAT_CUSTOMER_PROFILE_LDTS": "DATETIME"
            }
        }
    }


@fixture
def pit_one_sat_bigquery(context):
    """
    Define the structures and metadata to perform PIT load
    """

    context.vault_structure_type = "pit"

    context.hashed_columns = {
        "STG_CUSTOMER_DETAILS": {
            "CUSTOMER_PK": "CUSTOMER_ID",
            "HASHDIFF": {"is_hashdiff": True,
                         "columns": ["CUSTOMER_ADDRESS", "CUSTOMER_DOB", "CUSTOMER_NAME"]
                         }
        },
        "STG_CUSTOMER_DETAILS_TS": {
            "CUSTOMER_PK": "CUSTOMER_ID",
            "HASHDIFF": {"is_hashdiff": True,
                         "columns": ["CUSTOMER_ADDRESS", "CUSTOMER_DOB", "CUSTOMER_NAME"]
                         }
        }
    }

    context.derived_columns = {
        "STG_CUSTOMER_DETAILS": {
            "EFFECTIVE_FROM": "LOAD_DATE"
        },
        "STG_CUSTOMER_DETAILS_TS": {
            "EFFECTIVE_FROM": "LOAD_DATETIME"
        }
    }

    context.vault_structure_columns = {
        "HUB_CUSTOMER": {
            "source_model": ["STG_CUSTOMER_DETAILS",
                             ],
            "src_pk": "CUSTOMER_PK",
            "src_nk": "CUSTOMER_ID",
            "src_ldts": "LOAD_DATE",
            "src_source": "SOURCE"
        },
        "HUB_CUSTOMER_TS": {
            "source_model": ["STG_CUSTOMER_DETAILS_TS",
                             ],
            "src_pk": "CUSTOMER_PK",
            "src_nk": "CUSTOMER_ID",
            "src_ldts": "LOAD_DATETIME",
            "src_source": "SOURCE"
        },
        "SAT_CUSTOMER_DETAILS": {
            "source_model": "STG_CUSTOMER_DETAILS",
            "src_pk": "CUSTOMER_PK",
            "src_hashdiff": "HASHDIFF",
            "src_payload": ["CUSTOMER_NAME", "CUSTOMER_ADDRESS", "CUSTOMER_DOB"],
            "src_eff": "EFFECTIVE_FROM",
            "src_ldts": "LOAD_DATE",
            "src_source": "SOURCE"
        },
        "SAT_CUSTOMER_DETAILS_TS": {
            "source_model": "STG_CUSTOMER_DETAILS_TS",
            "src_pk": "CUSTOMER_PK",
            "src_hashdiff": "HASHDIFF",
            "src_payload": ["CUSTOMER_NAME", "CUSTOMER_ADDRESS", "CUSTOMER_DOB"],
            "src_eff": "EFFECTIVE_FROM",
            "src_ldts": "LOAD_DATETIME",
            "src_source": "SOURCE"
        },
        "PIT_CUSTOMER": {
            "source_model": "HUB_CUSTOMER",
            "src_pk": "CUSTOMER_PK",
            "as_of_dates_table": "AS_OF_DATE",
            "satellites":
                {
                    "SAT_CUSTOMER_DETAILS": {
                        "pk":
                            {"PK": "CUSTOMER_PK"},
                        "ldts":
                            {"LDTS": "LOAD_DATE"}
                    }
                },
            "stage_tables":
                {
                    "STG_CUSTOMER_DETAILS": "LOAD_DATE",
                },
            "src_ldts": "LOAD_DATE"
        },
        "PIT_CUSTOMER_TS": {
            "source_model": "HUB_CUSTOMER_TS",
            "src_pk": "CUSTOMER_PK",
            "as_of_dates_table": "AS_OF_DATE",
            "satellites":
                {
                    "SAT_CUSTOMER_DETAILS_TS": {
                        "pk":
                            {"PK": "CUSTOMER_PK"},
                        "ldts":
                            {"LDTS": "LOAD_DATETIME"}
                    }
                },
            "stage_tables":
                {
                    "STG_CUSTOMER_DETAILS_TS": "LOAD_DATETIME",
                },
            "src_ldts": "LOAD_DATETIME"
        },
        "PIT_CUSTOMER_LG": {
            "source_model": "HUB_CUSTOMER_TS",
            "src_pk": "CUSTOMER_PK",
            "as_of_dates_table": "AS_OF_DATE",
            "satellites":
                {
                    "SAT_CUSTOMER_DETAILS_TS": {
                        "pk":
                            {"PK": "CUSTOMER_PK"},
                        "ldts":
                            {"LDTS": "LOAD_DATETIME"}
                    }
                },
            "stage_tables":
                {
                    "STG_CUSTOMER_DETAILS_TS": "LOAD_DATETIME",
                },
            "src_ldts": "LOAD_DATETIME"
        },
        "PIT_CUSTOMER_HG": {
            "source_model": "HUB_CUSTOMER",
            "src_pk": "CUSTOMER_PK",
            "as_of_dates_table": "AS_OF_DATE",
            "satellites":
                {
                    "SAT_CUSTOMER_DETAILS": {
                        "pk":
                            {"PK": "CUSTOMER_PK"},
                        "ldts":
                            {"LDTS": "LOAD_DATE"}
                    }
                },
            "stage_tables":
                {
                    "STG_CUSTOMER_DETAILS": "LOAD_DATE",
                },
            "src_ldts": "LOAD_DATE"
        }
    }

    context.stage_columns = {
        "RAW_STAGE_DETAILS":
            ["CUSTOMER_ID",
             "CUSTOMER_NAME",
             "CUSTOMER_ADDRESS",
             "CUSTOMER_DOB",
             "LOAD_DATE",
             "SOURCE"],
        "RAW_STAGE_DETAILS_TS":
            ["CUSTOMER_ID",
             "CUSTOMER_NAME",
             "CUSTOMER_ADDRESS",
             "CUSTOMER_DOB",
             "LOAD_DATETIME",
             "SOURCE"]
    }

    context.seed_config = {
        "RAW_STAGE_DETAILS": {
            "+column_types": {
                "CUSTOMER_ID": "STRING",
                "CUSTOMER_NAME": "STRING",
                "CUSTOMER_ADDRESS": "STRING",
                "CUSTOMER_DOB": "DATE",
                "LOAD_DATE": "DATE",
                "SOURCE": "STRING"
            }
        },
        "RAW_STAGE_DETAILS_TS": {
            "+column_types": {
                "CUSTOMER_ID": "STRING",
                "CUSTOMER_NAME": "STRING",
                "CUSTOMER_ADDRESS": "STRING",
                "CUSTOMER_DOB": "DATE",
                "LOAD_DATETIME": "DATETIME",
                "SOURCE": "STRING"
            }
        },
        "HUB_CUSTOMER": {
            "+column_types": {
                "CUSTOMER_PK": "BYTES",
                "CUSTOMER_ID": "STRING",
                "LOAD_DATE": "DATE",
                "SOURCE": "STRING"
            }
        },
        "HUB_CUSTOMER_TS": {
            "+column_types": {
                "CUSTOMER_PK": "BYTES",
                "CUSTOMER_ID": "STRING",
                "LOAD_DATETIME": "DATETIME",
                "SOURCE": "STRING"
            }
        },
        "SAT_CUSTOMER_DETAILS": {
            "+column_types": {
                "CUSTOMER_PK": "BYTES",
                "HASHDIFF": "BYTES",
                "CUSTOMER_NAME": "STRING",
                "CUSTOMER_ADDRESS": "STRING",
                "CUSTOMER_DOB": "DATE",
                "EFFECTIVE_FROM": "DATE",
                "LOAD_DATE": "DATE",
                "SOURCE": "STRING"
            }
        },
        "SAT_CUSTOMER_DETAILS_TS": {
            "+column_types": {
                "CUSTOMER_PK": "BYTES",
                "HASHDIFF": "BYTES",
                "CUSTOMER_NAME": "STRING",
                "CUSTOMER_ADDRESS": "STRING",
                "CUSTOMER_DOB": "DATE",
                "EFFECTIVE_FROM": "DATETIME",
                "LOAD_DATETIME": "DATETIME",
                "SOURCE": "STRING"
            }
        },
        "AS_OF_DATE": {
            "+column_types": {
                "AS_OF_DATE": "DATETIME"
            }
        },
        "PIT_CUSTOMER": {
            "+column_types": {
                "AS_OF_DATE": "DATETIME",
                "CUSTOMER_PK": "BYTES",
                "SAT_CUSTOMER_DETAILS_PK": "BYTES",
                "SAT_CUSTOMER_DETAILS_LDTS": "DATETIME"
            }
        },
        "PIT_CUSTOMER_TS": {
            "+column_types": {
                "AS_OF_DATE": "DATETIME",
                "CUSTOMER_PK": "BYTES",
                "SAT_CUSTOMER_DETAILS_TS_PK": "BYTES",
                "SAT_CUSTOMER_DETAILS_TS_LDTS": "DATETIME"
            }
        },
        "PIT_CUSTOMER_LG": {
            "+column_types": {
                "AS_OF_DATE": "DATETIME",
                "CUSTOMER_PK": "BYTES",
                "SAT_CUSTOMER_DETAILS_TS_PK": "BYTES",
                "SAT_CUSTOMER_DETAILS_TS_LDTS": "DATETIME"
            }
        },
        "PIT_CUSTOMER_HG": {
            "+column_types": {
                "AS_OF_DATE": "DATETIME",
                "CUSTOMER_PK": "BYTES",
                "SAT_CUSTOMER_DETAILS_PK": "BYTES",
                "SAT_CUSTOMER_DETAILS_LDTS": "DATETIME"
            }
        }
    }


@fixture
def pit_two_sats_bigquery(context):
    """
    Define the structures and metadata to perform PIT load
    """

    context.vault_structure_type = "pit"

    context.hashed_columns = {
        "STG_CUSTOMER_DETAILS": {
            "CUSTOMER_PK": "CUSTOMER_ID",
            "HASHDIFF": {"is_hashdiff": True,
                         "columns": ["CUSTOMER_ADDRESS", "CUSTOMER_DOB", "CUSTOMER_NAME"]
                         }
        },
        "STG_CUSTOMER_DETAILS_TS": {
            "CUSTOMER_PK": "CUSTOMER_ID",
            "HASHDIFF": {"is_hashdiff": True,
                         "columns": ["CUSTOMER_ADDRESS", "CUSTOMER_DOB", "CUSTOMER_NAME"]
                         }
        },
        "STG_CUSTOMER_LOGIN": {
            "CUSTOMER_PK": "CUSTOMER_ID",
            "HASHDIFF": {"is_hashdiff": True,
                         "columns": ["DEVICE_USED", "LAST_LOGIN_DATE"]
                         }
        },
        "STG_CUSTOMER_LOGIN_TS": {
            "CUSTOMER_PK": "CUSTOMER_ID",
            "HASHDIFF": {"is_hashdiff": True,
                         "columns": ["DEVICE_USED", "LAST_LOGIN_DATE"]
                         }
        }
    }

    context.derived_columns = {
        "STG_CUSTOMER_DETAILS": {
            "EFFECTIVE_FROM": "LOAD_DATE"
        },
        "STG_CUSTOMER_DETAILS_TS": {
            "EFFECTIVE_FROM": "LOAD_DATETIME"
        },
        "STG_CUSTOMER_LOGIN": {
            "EFFECTIVE_FROM": "LOAD_DATE"
        },
        "STG_CUSTOMER_LOGIN_TS": {
            "EFFECTIVE_FROM": "LOAD_DATETIME"
        }
    }

    context.vault_structure_columns = {
        "HUB_CUSTOMER": {
            "source_model": ["STG_CUSTOMER_DETAILS",
                             ],
            "src_pk": "CUSTOMER_PK",
            "src_nk": "CUSTOMER_ID",
            "src_ldts": "LOAD_DATE",
            "src_source": "SOURCE"
        },
        "HUB_CUSTOMER_TS": {
            "source_model": ["STG_CUSTOMER_DETAILS_TS",
                             ],
            "src_pk": "CUSTOMER_PK",
            "src_nk": "CUSTOMER_ID",
            "src_ldts": "LOAD_DATETIME",
            "src_source": "SOURCE"
        },
        "SAT_CUSTOMER_DETAILS": {
            "source_model": "STG_CUSTOMER_DETAILS",
            "src_pk": "CUSTOMER_PK",
            "src_hashdiff": "HASHDIFF",
            "src_payload": ["CUSTOMER_NAME", "CUSTOMER_ADDRESS", "CUSTOMER_DOB"],
            "src_eff": "EFFECTIVE_FROM",
            "src_ldts": "LOAD_DATE",
            "src_source": "SOURCE"
        },
        "SAT_CUSTOMER_DETAILS_TS": {
            "source_model": "STG_CUSTOMER_DETAILS_TS",
            "src_pk": "CUSTOMER_PK",
            "src_hashdiff": "HASHDIFF",
            "src_payload": ["CUSTOMER_NAME", "CUSTOMER_ADDRESS", "CUSTOMER_DOB"],
            "src_eff": "EFFECTIVE_FROM",
            "src_ldts": "LOAD_DATETIME",
            "src_source": "SOURCE"
        },
        "SAT_CUSTOMER_LOGIN": {
            "source_model": "STG_CUSTOMER_LOGIN",
            "src_pk": "CUSTOMER_PK",
            "src_hashdiff": "HASHDIFF",
            "src_payload": ["DEVICE_USED", "LAST_LOGIN_DATE"],
            "src_eff": "EFFECTIVE_FROM",
            "src_ldts": "LOAD_DATE",
            "src_source": "SOURCE"
        },
        "SAT_CUSTOMER_LOGIN_TS": {
            "source_model": "STG_CUSTOMER_LOGIN_TS",
            "src_pk": "CUSTOMER_PK",
            "src_hashdiff": "HASHDIFF",
            "src_payload": ["DEVICE_USED", "LAST_LOGIN_DATE"],
            "src_eff": "EFFECTIVE_FROM",
            "src_ldts": "LOAD_DATETIME",
            "src_source": "SOURCE"
        },
        "PIT_CUSTOMER": {
            "source_model": "HUB_CUSTOMER",
            "src_pk": "CUSTOMER_PK",
            "as_of_dates_table": "AS_OF_DATE",
            "satellites":
                {
                    "SAT_CUSTOMER_DETAILS": {
                        "pk":
                            {"PK": "CUSTOMER_PK"},
                        "ldts":
                            {"LDTS": "LOAD_DATE"}
                    },
                    "SAT_CUSTOMER_LOGIN": {
                        "pk":
                            {"PK": "CUSTOMER_PK"},
                        "ldts":
                            {"LDTS": "LOAD_DATE"}
                    }
                },
            "stage_tables":
                {
                    "STG_CUSTOMER_DETAILS": "LOAD_DATE",
                    "STG_CUSTOMER_LOGIN": "LOAD_DATE"
                },
            "src_ldts": "LOAD_DATE"
        },
        "PIT_CUSTOMER_TS": {
            "source_model": "HUB_CUSTOMER_TS",
            "src_pk": "CUSTOMER_PK",
            "as_of_dates_table": "AS_OF_DATE",
            "satellites":
                {
                    "SAT_CUSTOMER_DETAILS_TS": {
                        "pk":
                            {"PK": "CUSTOMER_PK"},
                        "ldts":
                            {"LDTS": "LOAD_DATETIME"}
                    },
                    "SAT_CUSTOMER_LOGIN_TS": {
                        "pk":
                            {"PK": "CUSTOMER_PK"},
                        "ldts":
                            {"LDTS": "LOAD_DATETIME"}
                    }
                },
            "stage_tables":
                {
                    "STG_CUSTOMER_DETAILS_TS": "LOAD_DATETIME",
                    "STG_CUSTOMER_LOGIN_TS": "LOAD_DATETIME",
                },
            "src_ldts": "LOAD_DATETIME"
        },
        "PIT_CUSTOMER_LG": {
            "source_model": "HUB_CUSTOMER_TS",
            "src_pk": "CUSTOMER_PK",
            "as_of_dates_table": "AS_OF_DATE",
            "satellites":
                {
                    "SAT_CUSTOMER_DETAILS_TS": {
                        "pk":
                            {"PK": "CUSTOMER_PK"},
                        "ldts":
                            {"LDTS": "LOAD_DATETIME"}
                    },
                    "SAT_CUSTOMER_LOGIN_TS": {
                        "pk":
                            {"PK": "CUSTOMER_PK"},
                        "ldts":
                            {"LDTS": "LOAD_DATETIME"}
                    }
                },
            "stage_tables":
                {
                    "STG_CUSTOMER_DETAILS_TS": "LOAD_DATETIME",
                    "STG_CUSTOMER_LOGIN_TS": "LOAD_DATETIME",
                },
            "src_ldts": "LOAD_DATETIME"
        },
        "PIT_CUSTOMER_HG": {
            "source_model": "HUB_CUSTOMER",
            "src_pk": "CUSTOMER_PK",
            "as_of_dates_table": "AS_OF_DATE",
            "satellites":
                {
                    "SAT_CUSTOMER_DETAILS": {
                        "pk":
                            {"PK": "CUSTOMER_PK"},
                        "ldts":
                            {"LDTS": "LOAD_DATE"}
                    },
                    "SAT_CUSTOMER_LOGIN": {
                        "pk":
                            {"PK": "CUSTOMER_PK"},
                        "ldts":
                            {"LDTS": "LOAD_DATE"}
                    }
                },
            "stage_tables":
                {
                    "STG_CUSTOMER_DETAILS": "LOAD_DATE",
                    "STG_CUSTOMER_LOGIN": "LOAD_DATE",
                },
            "src_ldts": "LOAD_DATE"
        }
    }

    context.stage_columns = {
        "RAW_STAGE_DETAILS":
            ["CUSTOMER_ID",
             "CUSTOMER_NAME",
             "CUSTOMER_ADDRESS",
             "CUSTOMER_DOB",
             "LOAD_DATE",
             "SOURCE"],
        "RAW_STAGE_DETAILS_TS":
            ["CUSTOMER_ID",
             "CUSTOMER_NAME",
             "CUSTOMER_ADDRESS",
             "CUSTOMER_DOB",
             "LOAD_DATETIME",
             "SOURCE"],
        "RAW_STAGE_LOGIN":
            ["CUSTOMER_ID",
             "LAST_LOGIN_DATE",
             "DEVICE_USED",
             "LOAD_DATE",
             "SOURCE"],
        "RAW_STAGE_LOGIN_TS":
            ["CUSTOMER_ID",
             "LAST_LOGIN_DATE",
             "DEVICE_USED",
             "LOAD_DATETIME",
             "SOURCE"]
    }

    context.seed_config = {
        "RAW_STAGE_DETAILS": {
            "+column_types": {
                "CUSTOMER_ID": "STRING",
                "CUSTOMER_NAME": "STRING",
                "CUSTOMER_ADDRESS": "STRING",
                "CUSTOMER_DOB": "DATE",
                "LOAD_DATE": "DATE",
                "SOURCE": "STRING"
            }
        },
        "RAW_STAGE_DETAILS_TS": {
            "+column_types": {
                "CUSTOMER_ID": "STRING",
                "CUSTOMER_NAME": "STRING",
                "CUSTOMER_ADDRESS": "STRING",
                "CUSTOMER_DOB": "DATE",
                "LOAD_DATETIME": "DATETIME",
                "SOURCE": "STRING"
            }
        },
        "RAW_STAGE_LOGIN": {
            "+column_types": {
                "CUSTOMER_ID": "STRING",
                "LAST_LOGIN_DATE": "DATETIME",
                "DEVICE_USED": "STRING",
                "LOAD_DATE": "DATE",
                "SOURCE": "STRING"
            }
        },
        "RAW_STAGE_LOGIN_TS": {
            "+column_types": {
                "CUSTOMER_ID": "STRING",
                "LAST_LOGIN_DATE": "DATETIME",
                "DEVICE_USED": "STRING",
                "LOAD_DATETIME": "DATETIME",
                "SOURCE": "STRING"
            }
        },
        "HUB_CUSTOMER": {
            "+column_types": {
                "CUSTOMER_PK": "BYTES",
                "CUSTOMER_ID": "STRING",
                "LOAD_DATE": "DATE",
                "SOURCE": "STRING"
            }
        },
        "HUB_CUSTOMER_TS": {
            "+column_types": {
                "CUSTOMER_PK": "BYTES",
                "CUSTOMER_ID": "STRING",
                "LOAD_DATETIME": "DATETIME",
                "SOURCE": "STRING"
            }
        },
        "SAT_CUSTOMER_DETAILS": {
            "+column_types": {
                "CUSTOMER_PK": "BYTES",
                "HASHDIFF": "BYTES",
                "CUSTOMER_NAME": "STRING",
                "CUSTOMER_ADDRESS": "STRING",
                "CUSTOMER_DOB": "DATE",
                "EFFECTIVE_FROM": "DATE",
                "LOAD_DATE": "DATE",
                "SOURCE": "STRING"
            }
        },
        "SAT_CUSTOMER_DETAILS_TS": {
            "+column_types": {
                "CUSTOMER_PK": "BYTES",
                "HASHDIFF": "BYTES",
                "CUSTOMER_NAME": "STRING",
                "CUSTOMER_ADDRESS": "STRING",
                "CUSTOMER_DOB": "DATE",
                "EFFECTIVE_FROM": "DATETIME",
                "LOAD_DATETIME": "DATETIME",
                "SOURCE": "STRING"
            }
        },
        "SAT_CUSTOMER_LOGIN": {
            "+column_types": {
                "CUSTOMER_PK": "BYTES",
                "HASHDIFF": "BYTES",
                "DEVICE_USED": "STRING",
                "LAST_LOGIN_DATE": "DATETIME",
                "EFFECTIVE_FROM": "DATE",
                "LOAD_DATE": "DATE",
                "SOURCE": "STRING"
            }
        },
        "SAT_CUSTOMER_LOGIN_TS": {
            "+column_types": {
                "CUSTOMER_PK": "BYTES",
                "HASHDIFF": "BYTES",
                "DEVICE_USED": "STRING",
                "LAST_LOGIN_DATE": "DATETIME",
                "EFFECTIVE_FROM": "DATETIME",
                "LOAD_DATETIME": "DATETIME",
                "SOURCE": "STRING"
            }
        },
        "AS_OF_DATE": {
            "+column_types": {
                "AS_OF_DATE": "DATETIME"
            }
        },
        "PIT_CUSTOMER": {
            "+column_types": {
                "AS_OF_DATE": "DATETIME",
                "CUSTOMER_PK": "BYTES",
                "SAT_CUSTOMER_DETAILS_PK": "BYTES",
                "SAT_CUSTOMER_DETAILS_LDTS": "DATETIME",
                "SAT_CUSTOMER_LOGIN_PK": "BYTES",
                "SAT_CUSTOMER_LOGIN_LDTS": "DATETIME"
            }
        },
        "PIT_CUSTOMER_TS": {
            "+column_types": {
                "AS_OF_DATE": "DATETIME",
                "CUSTOMER_PK": "BYTES",
                "SAT_CUSTOMER_DETAILS_TS_PK": "BYTES",
                "SAT_CUSTOMER_DETAILS_TS_LDTS": "DATETIME",
                "SAT_CUSTOMER_LOGIN_TS_PK": "BYTES",
                "SAT_CUSTOMER_LOGIN_TS_LDTS": "DATETIME"
            }
        },
        "PIT_CUSTOMER_LG": {
            "+column_types": {
                "AS_OF_DATE": "DATETIME",
                "CUSTOMER_PK": "BYTES",
                "SAT_CUSTOMER_DETAILS_TS_PK": "BYTES",
                "SAT_CUSTOMER_DETAILS_TS_LDTS": "DATETIME",
                "SAT_CUSTOMER_LOGIN_TS_PK": "BYTES",
                "SAT_CUSTOMER_LOGIN_TS_LDTS": "DATETIME"
            }
        },
        "PIT_CUSTOMER_HG": {
            "+column_types": {
                "AS_OF_DATE": "DATETIME",
                "CUSTOMER_PK": "BYTES",
                "SAT_CUSTOMER_DETAILS_PK": "BYTES",
                "SAT_CUSTOMER_DETAILS_LDTS": "DATETIME",
                "SAT_CUSTOMER_LOGIN_PK": "BYTES",
                "SAT_CUSTOMER_LOGIN_LDTS": "DATETIME"
            }
        }
    }


@fixture
def multi_active_satellite_bigquery(context):
    """
    Define the structures and metadata to load multi active satellites
    """
    context.vault_structure_type = "ma_sat"

    context.hashed_columns = {
        "STG_CUSTOMER": {
            "CUSTOMER_PK": "CUSTOMER_ID",
            "HASHDIFF": {"is_hashdiff": True,
                         "columns": ["CUSTOMER_ID", "CUSTOMER_PHONE", "CUSTOMER_NAME"]}
        },
        "STG_CUSTOMER_TS": {
            "CUSTOMER_PK": "CUSTOMER_ID",
            "HASHDIFF": {"is_hashdiff": True,
                         "columns": ["CUSTOMER_ID", "CUSTOMER_PHONE", "CUSTOMER_NAME"]}
        },
        "STG_CUSTOMER_NO_CDK_HASHDIFF": {
            "CUSTOMER_PK": "CUSTOMER_ID",
            "HASHDIFF": {"is_hashdiff": True,
                         "columns": ["CUSTOMER_ID", "CUSTOMER_NAME"]}
        },
        "STG_CUSTOMER_NO_PK_CDK_HASHDIFF": {
            "CUSTOMER_PK": "CUSTOMER_ID",
            "HASHDIFF": {"is_hashdiff": True,
                         "columns": ["CUSTOMER_NAME"]}
        },
        "STG_CUSTOMER_TWO_CDK": {
            "CUSTOMER_PK": "CUSTOMER_ID",
            "HASHDIFF": {"is_hashdiff": True,
                         "columns": ["CUSTOMER_ID", "CUSTOMER_PHONE", "CUSTOMER_NAME", "EXTENSION"]}
        },
        "STG_CUSTOMER_TWO_CDK_TS": {
            "CUSTOMER_PK": "CUSTOMER_ID",
            "HASHDIFF": {"is_hashdiff": True,
                         "columns": ["CUSTOMER_ID", "CUSTOMER_PHONE", "CUSTOMER_NAME", "EXTENSION"]}
        },
        "STG_CUSTOMER_TWO_CDK_NO_CDK_HASHDIFF": {
            "CUSTOMER_PK": "CUSTOMER_ID",
            "HASHDIFF": {"is_hashdiff": True,
                         "columns": ["CUSTOMER_ID", "CUSTOMER_NAME"]}
        },
        "STG_CUSTOMER_TWO_CDK_NO_PK_CDK_HASHDIFF": {
            "CUSTOMER_PK": "CUSTOMER_ID",
            "HASHDIFF": {"is_hashdiff": True,
                         "columns": ["CUSTOMER_NAME"]}
        }
    }

    context.derived_columns = {
        "STG_CUSTOMER": {
            "EFFECTIVE_FROM": "LOAD_DATE"
        },
        "STG_CUSTOMER_TS": {
            "EFFECTIVE_FROM": "LOAD_DATETIME"
        },
        "STG_CUSTOMER_NO_CDK_HASHDIFF": {
            "EFFECTIVE_FROM": "LOAD_DATE"
        },
        "STG_CUSTOMER_NO_PK_CDK_HASHDIFF": {
            "EFFECTIVE_FROM": "LOAD_DATE"
        },
        "STG_CUSTOMER_TWO_CDK": {
            "EFFECTIVE_FROM": "LOAD_DATE"
        },
        "STG_CUSTOMER_TWO_CDK_TS": {
            "EFFECTIVE_FROM": "LOAD_DATETIME"
        },
        "STG_CUSTOMER_TWO_CDK_NO_CDK_HASHDIFF": {
            "EFFECTIVE_FROM": "LOAD_DATE"
        },
        "STG_CUSTOMER_TWO_CDK_NO_PK_CDK_HASHDIFF": {
            "EFFECTIVE_FROM": "LOAD_DATE"
        }
    }

    context.vault_structure_columns = {
        "MULTI_ACTIVE_SATELLITE": {
            "src_pk": "CUSTOMER_PK",
            "src_cdk": ["CUSTOMER_PHONE"],
            "src_payload": ["CUSTOMER_NAME"],
            "src_hashdiff": "HASHDIFF",
            "src_eff": "EFFECTIVE_FROM",
            "src_ldts": "LOAD_DATE",
            "src_source": "SOURCE"
        },
        "MULTI_ACTIVE_SATELLITE_TS": {
            "src_pk": "CUSTOMER_PK",
            "src_cdk": ["CUSTOMER_PHONE"],
            "src_payload": ["CUSTOMER_NAME"],
            "src_hashdiff": "HASHDIFF",
            "src_eff": "EFFECTIVE_FROM",
            "src_ldts": "LOAD_DATETIME",
            "src_source": "SOURCE"
        },
        "MULTI_ACTIVE_SATELLITE_NO_CDK_HASHDIFF": {
            "src_pk": "CUSTOMER_PK",
            "src_cdk": ["CUSTOMER_PHONE"],
            "src_payload": ["CUSTOMER_NAME"],
            "src_hashdiff": "HASHDIFF",
            "src_eff": "EFFECTIVE_FROM",
            "src_ldts": "LOAD_DATE",
            "src_source": "SOURCE"
        },
        "MULTI_ACTIVE_SATELLITE_NO_PK_CDK_HASHDIFF": {
            "src_pk": "CUSTOMER_PK",
            "src_cdk": ["CUSTOMER_PHONE"],
            "src_payload": ["CUSTOMER_NAME"],
            "src_hashdiff": "HASHDIFF",
            "src_eff": "EFFECTIVE_FROM",
            "src_ldts": "LOAD_DATE",
            "src_source": "SOURCE"
        },
        "MULTI_ACTIVE_SATELLITE_TWO_CDK": {
            "src_pk": "CUSTOMER_PK",
            "src_cdk": ["CUSTOMER_PHONE", "EXTENSION"],
            "src_payload": ["CUSTOMER_NAME"],
            "src_hashdiff": "HASHDIFF",
            "src_eff": "EFFECTIVE_FROM",
            "src_ldts": "LOAD_DATE",
            "src_source": "SOURCE"
        },
        "MULTI_ACTIVE_SATELLITE_TWO_CDK_TS": {
            "src_pk": "CUSTOMER_PK",
            "src_cdk": ["CUSTOMER_PHONE", "EXTENSION"],
            "src_payload": ["CUSTOMER_NAME"],
            "src_hashdiff": "HASHDIFF",
            "src_eff": "EFFECTIVE_FROM",
            "src_ldts": "LOAD_DATETIME",
            "src_source": "SOURCE"
        },
        "MULTI_ACTIVE_SATELLITE_TWO_CDK_NO_CDK_HASHDIFF": {
            "src_pk": "CUSTOMER_PK",
            "src_cdk": ["CUSTOMER_PHONE", "EXTENSION"],
            "src_payload": ["CUSTOMER_NAME"],
            "src_hashdiff": "HASHDIFF",
            "src_eff": "EFFECTIVE_FROM",
            "src_ldts": "LOAD_DATE",
            "src_source": "SOURCE"
        },
        "MULTI_ACTIVE_SATELLITE_TWO_CDK_NO_PK_CDK_HASHDIFF": {
            "src_pk": "CUSTOMER_PK",
            "src_cdk": ["CUSTOMER_PHONE", "EXTENSION"],
            "src_payload": ["CUSTOMER_NAME"],
            "src_hashdiff": "HASHDIFF",
            "src_eff": "EFFECTIVE_FROM",
            "src_ldts": "LOAD_DATE",
            "src_source": "SOURCE"
        }
    }

    context.seed_config = {
        "RAW_STAGE": {
            "+column_types": {
                "CUSTOMER_ID": "NUMERIC",
                "CUSTOMER_NAME": "STRING",
                "CUSTOMER_PHONE": "STRING",
                "LOAD_DATE": "DATE",
                "SOURCE": "STRING"
            }
        },
        "RAW_STAGE_TS": {
            "+column_types": {
                "CUSTOMER_ID": "NUMERIC",
                "CUSTOMER_NAME": "STRING",
                "CUSTOMER_PHONE": "STRING",
                "LOAD_DATETIME": "DATETIME",
                "SOURCE": "STRING"
            }
        },
        "RAW_STAGE_TWO_CDK": {
            "+column_types": {
                "CUSTOMER_ID": "NUMERIC",
                "CUSTOMER_NAME": "STRING",
                "CUSTOMER_PHONE": "STRING",
                "EXTENSION": "NUMERIC",
                "LOAD_DATE": "DATE",
                "SOURCE": "STRING"
            }
        },
        "RAW_STAGE_TWO_CDK_TS": {
            "+column_types": {
                "CUSTOMER_ID": "NUMERIC",
                "CUSTOMER_NAME": "STRING",
                "CUSTOMER_PHONE": "STRING",
                "EXTENSION": "NUMERIC",
                "LOAD_DATETIME": "DATETIME",
                "SOURCE": "STRING"
            }
        },
        "MULTI_ACTIVE_SATELLITE": {
            "+column_types": {
                "CUSTOMER_PK": "BYTES",
                "CUSTOMER_NAME": "STRING",
                "CUSTOMER_PHONE": "STRING",
                "HASHDIFF": "BYTES",
                "EFFECTIVE_FROM": "DATE",
                "LOAD_DATE": "DATE",
                "SOURCE": "STRING"
            }
        },
        "MULTI_ACTIVE_SATELLITE_TS": {
            "+column_types": {
                "CUSTOMER_PK": "BYTES",
                "CUSTOMER_NAME": "STRING",
                "CUSTOMER_PHONE": "STRING",
                "HASHDIFF": "BYTES",
                "EFFECTIVE_FROM": "DATETIME",
                "LOAD_DATETIME": "DATETIME",
                "SOURCE": "STRING"
            }
        },
        "MULTI_ACTIVE_SATELLITE_NO_CDK_HASHDIFF": {
            "+column_types": {
                "CUSTOMER_PK": "BYTES",
                "CUSTOMER_NAME": "STRING",
                "CUSTOMER_PHONE": "STRING",
                "HASHDIFF": "BYTES",
                "EFFECTIVE_FROM": "DATE",
                "LOAD_DATE": "DATE",
                "SOURCE": "STRING"
            }
        },
        "MULTI_ACTIVE_SATELLITE_NO_PK_CDK_HASHDIFF": {
            "+column_types": {
                "CUSTOMER_PK": "BYTES",
                "CUSTOMER_NAME": "STRING",
                "CUSTOMER_PHONE": "STRING",
                "HASHDIFF": "BYTES",
                "EFFECTIVE_FROM": "DATE",
                "LOAD_DATE": "DATE",
                "SOURCE": "STRING"
            }
        },
        "MULTI_ACTIVE_SATELLITE_TWO_CDK": {
            "+column_types": {
                "CUSTOMER_PK": "BYTES",
                "CUSTOMER_NAME": "STRING",
                "CUSTOMER_PHONE": "STRING",
                "EXTENSION": "NUMERIC",
                "HASHDIFF": "BYTES",
                "EFFECTIVE_FROM": "DATE",
                "LOAD_DATE": "DATE",
                "SOURCE": "STRING"
            }
        },
        "MULTI_ACTIVE_SATELLITE_TWO_CDK_TS": {
            "+column_types": {
                "CUSTOMER_PK": "BYTES",
                "CUSTOMER_NAME": "STRING",
                "CUSTOMER_PHONE": "STRING",
                "EXTENSION": "NUMERIC",
                "HASHDIFF": "BYTES",
                "EFFECTIVE_FROM": "DATETIME",
                "LOAD_DATETIME": "DATETIME",
                "SOURCE": "STRING"
            }
        },
        "MULTI_ACTIVE_SATELLITE_TWO_CDK_NO_CDK_HASHDIFF": {
            "+column_types": {
                "CUSTOMER_PK": "BYTES",
                "CUSTOMER_NAME": "STRING",
                "CUSTOMER_PHONE": "STRING",
                "EXTENSION": "NUMERIC",
                "HASHDIFF": "BYTES",
                "EFFECTIVE_FROM": "DATE",
                "LOAD_DATE": "DATE",
                "SOURCE": "STRING"
            }
        },
        "MULTI_ACTIVE_SATELLITE_TWO_CDK_NO_PK_CDK_HASHDIFF": {
            "+column_types": {
                "CUSTOMER_PK": "BYTES",
                "CUSTOMER_NAME": "STRING",
                "CUSTOMER_PHONE": "STRING",
                "EXTENSION": "NUMERIC",
                "HASHDIFF": "BYTES",
                "EFFECTIVE_FROM": "DATE",
                "LOAD_DATE": "DATE",
                "SOURCE": "STRING"
            }
        }
    }


@fixture
def multi_active_satellite_cycle_bigquery(context):
    """
    Define the structures and metadata to perform load cycles for multi active satellites
    """
    context.vault_structure_type = "ma_sat"

    context.hashed_columns = {
        "STG_CUSTOMER": {
            "CUSTOMER_PK": "CUSTOMER_ID",
            "HASHDIFF": {"is_hashdiff": True,
                         "columns": ["CUSTOMER_ID", "CUSTOMER_PHONE", "CUSTOMER_NAME"]}
        },
        "STG_CUSTOMER_TS": {
            "CUSTOMER_PK": "CUSTOMER_ID",
            "HASHDIFF": {"is_hashdiff": True,
                         "columns": ["CUSTOMER_ID", "CUSTOMER_PHONE", "CUSTOMER_NAME"]}
        },
        "STG_CUSTOMER_NO_CDK_HASHDIFF": {
            "CUSTOMER_PK": "CUSTOMER_ID",
            "HASHDIFF": {"is_hashdiff": True,
                         "columns": ["CUSTOMER_ID", "CUSTOMER_NAME"]}
        },
        "STG_CUSTOMER_NO_PK_CDK_HASHDIFF": {
            "CUSTOMER_PK": "CUSTOMER_ID",
            "HASHDIFF": {"is_hashdiff": True,
                         "columns": ["CUSTOMER_NAME"]}
        },
        "STG_CUSTOMER_TWO_CDK": {
            "CUSTOMER_PK": "CUSTOMER_ID",
            "HASHDIFF": {"is_hashdiff": True,
                         "columns": ["CUSTOMER_ID", "CUSTOMER_PHONE", "CUSTOMER_NAME", "EXTENSION"]}
        },
        "STG_CUSTOMER_TWO_CDK_TS": {
            "CUSTOMER_PK": "CUSTOMER_ID",
            "HASHDIFF": {"is_hashdiff": True,
                         "columns": ["CUSTOMER_ID", "CUSTOMER_PHONE", "CUSTOMER_NAME", "EXTENSION"]}
        },
        "STG_CUSTOMER_TWO_CDK_NO_CDK_HASHDIFF": {
            "CUSTOMER_PK": "CUSTOMER_ID",
            "HASHDIFF": {"is_hashdiff": True,
                         "columns": ["CUSTOMER_ID", "CUSTOMER_NAME"]}
        },
        "STG_CUSTOMER_TWO_CDK_NO_PK_CDK_HASHDIFF": {
            "CUSTOMER_PK": "CUSTOMER_ID",
            "HASHDIFF": {"is_hashdiff": True,
                         "columns": ["CUSTOMER_NAME"]}
        }
    }

    context.derived_columns = {
        "STG_CUSTOMER": {
            "EFFECTIVE_FROM": "LOAD_DATE"
        },
        "STG_CUSTOMER_TS": {
            "EFFECTIVE_FROM": "LOAD_DATETIME"
        },
        "STG_CUSTOMER_NO_CDK_HASHDIFF": {
            "EFFECTIVE_FROM": "LOAD_DATE"
        },
        "STG_CUSTOMER_NO_PK_CDK_HASHDIFF": {
            "EFFECTIVE_FROM": "LOAD_DATE"
        },
        "STG_CUSTOMER_TWO_CDK": {
            "EFFECTIVE_FROM": "LOAD_DATE"
        },
        "STG_CUSTOMER_TWO_CDK_TS": {
            "EFFECTIVE_FROM": "LOAD_DATETIME"
        },
        "STG_CUSTOMER_TWO_CDK_NO_CDK_HASHDIFF": {
            "EFFECTIVE_FROM": "LOAD_DATE"
        },
        "STG_CUSTOMER_TWO_CDK_NO_PK_CDK_HASHDIFF": {
            "EFFECTIVE_FROM": "LOAD_DATE"
        }
    }

    context.stage_columns = {
        "RAW_STAGE":
            ["CUSTOMER_ID",
             "CUSTOMER_NAME",
             "CUSTOMER_PHONE",
             "EFFECTIVE_FROM",
             "LOAD_DATE",
             "SOURCE"],

        "RAW_STAGE_TS":
            ["CUSTOMER_ID",
             "CUSTOMER_NAME",
             "CUSTOMER_PHONE",
             "EFFECTIVE_FROM",
             "LOAD_DATETIME",
             "SOURCE"],

        "RAW_STAGE_TWO_CDK":
            ["CUSTOMER_ID",
             "CUSTOMER_NAME",
             "CUSTOMER_PHONE",
             "EXTENSION",
             "EFFECTIVE_FROM",
             "LOAD_DATE",
             "SOURCE"],

        "RAW_STAGE_TWO_CDK_TS":
            ["CUSTOMER_ID",
             "CUSTOMER_NAME",
             "CUSTOMER_PHONE",
             "EXTENSION",
             "EFFECTIVE_FROM",
             "LOAD_DATETIME",
             "SOURCE"]
    }

    context.vault_structure_columns = {
        "MULTI_ACTIVE_SATELLITE": {
            "src_pk": "CUSTOMER_PK",
            "src_cdk": ["CUSTOMER_PHONE"],
            "src_payload": ["CUSTOMER_NAME"],
            "src_hashdiff": "HASHDIFF",
            "src_eff": "EFFECTIVE_FROM",
            "src_ldts": "LOAD_DATE",
            "src_source": "SOURCE"
        },
        "MULTI_ACTIVE_SATELLITE_TS": {
            "src_pk": "CUSTOMER_PK",
            "src_cdk": ["CUSTOMER_PHONE"],
            "src_payload": ["CUSTOMER_NAME"],
            "src_hashdiff": "HASHDIFF",
            "src_eff": "EFFECTIVE_FROM",
            "src_ldts": "LOAD_DATETIME",
            "src_source": "SOURCE"
        },
        "MULTI_ACTIVE_SATELLITE_NO_CDK_HASHDIFF": {
            "src_pk": "CUSTOMER_PK",
            "src_cdk": ["CUSTOMER_PHONE"],
            "src_payload": ["CUSTOMER_NAME"],
            "src_hashdiff": "HASHDIFF",
            "src_eff": "EFFECTIVE_FROM",
            "src_ldts": "LOAD_DATE",
            "src_source": "SOURCE"
        },
        "MULTI_ACTIVE_SATELLITE_NO_PK_CDK_HASHDIFF": {
            "src_pk": "CUSTOMER_PK",
            "src_cdk": ["CUSTOMER_PHONE"],
            "src_payload": ["CUSTOMER_NAME"],
            "src_hashdiff": "HASHDIFF",
            "src_eff": "EFFECTIVE_FROM",
            "src_ldts": "LOAD_DATE",
            "src_source": "SOURCE"
        },
        "MULTI_ACTIVE_SATELLITE_TWO_CDK": {
            "src_pk": "CUSTOMER_PK",
            "src_cdk": ["CUSTOMER_PHONE", "EXTENSION"],
            "src_payload": ["CUSTOMER_NAME"],
            "src_hashdiff": "HASHDIFF",
            "src_eff": "EFFECTIVE_FROM",
            "src_ldts": "LOAD_DATE",
            "src_source": "SOURCE"
        },
        "MULTI_ACTIVE_SATELLITE_TWO_CDK_TS": {
            "src_pk": "CUSTOMER_PK",
            "src_cdk": ["CUSTOMER_PHONE", "EXTENSION"],
            "src_payload": ["CUSTOMER_NAME"],
            "src_hashdiff": "HASHDIFF",
            "src_eff": "EFFECTIVE_FROM",
            "src_ldts": "LOAD_DATETIME",
            "src_source": "SOURCE"
        },
        "MULTI_ACTIVE_SATELLITE_TWO_CDK_NO_CDK_HASHDIFF": {
            "src_pk": "CUSTOMER_PK",
            "src_cdk": ["CUSTOMER_PHONE", "EXTENSION"],
            "src_payload": ["CUSTOMER_NAME"],
            "src_hashdiff": "HASHDIFF",
            "src_eff": "EFFECTIVE_FROM",
            "src_ldts": "LOAD_DATE",
            "src_source": "SOURCE"
        },
        "MULTI_ACTIVE_SATELLITE_TWO_CDK_NO_PK_CDK_HASHDIFF": {
            "src_pk": "CUSTOMER_PK",
            "src_cdk": ["CUSTOMER_PHONE", "EXTENSION"],
            "src_payload": ["CUSTOMER_NAME"],
            "src_hashdiff": "HASHDIFF",
            "src_eff": "EFFECTIVE_FROM",
            "src_ldts": "LOAD_DATE",
            "src_source": "SOURCE"
        }
    }

    context.seed_config = {
        "RAW_STAGE": {
            "+column_types": {
                "CUSTOMER_ID": "NUMERIC",
                "CUSTOMER_NAME": "STRING",
                "CUSTOMER_PHONE": "STRING",
                "EFFECTIVE_FROM": "DATE",
                "LOAD_DATE": "DATE",
                "SOURCE": "STRING"
            }
        },
        "RAW_STAGE_TS": {
            "+column_types": {
                "CUSTOMER_ID": "NUMERIC",
                "CUSTOMER_NAME": "STRING",
                "CUSTOMER_PHONE": "STRING",
                "EFFECTIVE_FROM": "DATETIME",
                "LOAD_DATETIME": "DATETIME",
                "SOURCE": "STRING"
            }
        },
        "RAW_STAGE_TWO_CDK": {
            "+column_types": {
                "CUSTOMER_ID": "NUMERIC",
                "CUSTOMER_NAME": "STRING",
                "CUSTOMER_PHONE": "STRING",
                "EXTENSION": "NUMERIC",
                "EFFECTIVE_FROM": "DATE",
                "LOAD_DATE": "DATE",
                "SOURCE": "STRING"
            }
        },
        "RAW_STAGE_TWO_CDK_TS": {
            "+column_types": {
                "CUSTOMER_ID": "NUMERIC",
                "CUSTOMER_NAME": "STRING",
                "CUSTOMER_PHONE": "STRING",
                "EXTENSION": "NUMERIC",
                "EFFECTIVE_FROM": "DATETIME",
                "LOAD_DATETIME": "DATETIME",
                "SOURCE": "STRING"
            }
        },
        "MULTI_ACTIVE_SATELLITE": {
            "+column_types": {
                "CUSTOMER_PK": "BYTES",
                "HASHDIFF": "BYTES",
                "CUSTOMER_PHONE": "STRING",
                "CUSTOMER_NAME": "STRING",
                "EFFECTIVE_FROM": "DATE",
                "LOAD_DATE": "DATE",
                "SOURCE": "STRING"
            }
        },
        "MULTI_ACTIVE_SATELLITE_TS": {
            "+column_types": {
                "CUSTOMER_PK": "BYTES",
                "HASHDIFF": "BYTES",
                "CUSTOMER_PHONE": "STRING",
                "CUSTOMER_NAME": "STRING",
                "EFFECTIVE_FROM": "DATETIME",
                "LOAD_DATETIME": "DATETIME",
                "SOURCE": "STRING"
            }
        },
        "MULTI_ACTIVE_SATELLITE_NO_CDK_HASHDIFF": {
            "+column_types": {
                "CUSTOMER_PK": "BYTES",
                "CUSTOMER_NAME": "STRING",
                "CUSTOMER_PHONE": "STRING",
                "HASHDIFF": "BYTES",
                "EFFECTIVE_FROM": "DATE",
                "LOAD_DATE": "DATE",
                "SOURCE": "STRING"
            }
        },
        "MULTI_ACTIVE_SATELLITE_NO_PK_CDK_HASHDIFF": {
            "+column_types": {
                "CUSTOMER_PK": "BYTES",
                "CUSTOMER_NAME": "STRING",
                "CUSTOMER_PHONE": "STRING",
                "HASHDIFF": "BYTES",
                "EFFECTIVE_FROM": "DATE",
                "LOAD_DATE": "DATE",
                "SOURCE": "STRING"
            }
        },
        "MULTI_ACTIVE_SATELLITE_TWO_CDK": {
            "+column_types": {
                "CUSTOMER_PK": "BYTES",
                "HASHDIFF": "BYTES",
                "CUSTOMER_PHONE": "STRING",
                "CUSTOMER_NAME": "STRING",
                "EXTENSION": "NUMERIC",
                "EFFECTIVE_FROM": "DATE",
                "LOAD_DATE": "DATE",
                "SOURCE": "STRING"
            }
        },
        "MULTI_ACTIVE_SATELLITE_TWO_CDK_TS": {
            "+column_types": {
                "CUSTOMER_PK": "BYTES",
                "HASHDIFF": "BYTES",
                "CUSTOMER_PHONE": "STRING",
                "CUSTOMER_NAME": "STRING",
                "EXTENSION": "NUMERIC",
                "EFFECTIVE_FROM": "DATETIME",
                "LOAD_DATETIME": "DATETIME",
                "SOURCE": "STRING"
            }
        },
        "MULTI_ACTIVE_SATELLITE_TWO_CDK_NO_CDK_HASHDIFF": {
            "+column_types": {
                "CUSTOMER_PK": "BYTES",
                "CUSTOMER_NAME": "STRING",
                "CUSTOMER_PHONE": "STRING",
                "EXTENSION": "NUMERIC",
                "HASHDIFF": "BYTES",
                "EFFECTIVE_FROM": "DATE",
                "LOAD_DATE": "DATE",
                "SOURCE": "STRING"
            }
        },
        "MULTI_ACTIVE_SATELLITE_TWO_CDK_NO_PK_CDK_HASHDIFF": {
            "+column_types": {
                "CUSTOMER_PK": "BYTES",
                "CUSTOMER_NAME": "STRING",
                "CUSTOMER_PHONE": "STRING",
                "EXTENSION": "NUMERIC",
                "HASHDIFF": "BYTES",
                "EFFECTIVE_FROM": "DATE",
                "LOAD_DATE": "DATE",
                "SOURCE": "STRING"
            }
        }
    }


@fixture
def xts_bigquery(context):
    """
    Define the structures and metadata to load xts
    """

    context.vault_structure_type = "xts"

    context.hashed_columns = {
        "STG_CUSTOMER": {
            "CUSTOMER_PK": "CUSTOMER_ID",
            "HASHDIFF": {"is_hashdiff": True,
                         "columns": ["CUSTOMER_ID", "CUSTOMER_FIRSTNAME", "CUSTOMER_LASTNAME"]}
        },
        "STG_CUSTOMER_1": {
            "CUSTOMER_PK": "CUSTOMER_ID",
            "HASHDIFF": {"is_hashdiff": True,
                         "columns": ["CUSTOMER_ID", "CUSTOMER_FIRSTNAME", "CUSTOMER_LASTNAME"]}
        },
        "STG_CUSTOMER_2": {
            "CUSTOMER_PK": "CUSTOMER_ID",
            "HASHDIFF": {"is_hashdiff": True,
                         "columns": ["CUSTOMER_ID", "CUSTOMER_FIRSTNAME", "CUSTOMER_LASTNAME"]}
        },
        "STG_CUSTOMER_2SAT": {
            "CUSTOMER_PK": "CUSTOMER_ID",
            "HASHDIFF_1": {"is_hashdiff": True,
                           "columns": ["CUSTOMER_ID", "CUSTOMER_FIRSTNAME", "CUSTOMER_LASTNAME"]},
            "HASHDIFF_2": {"is_hashdiff": True,
                           "columns": ["CUSTOMER_ID", "CUSTOMER_DOB", "CUSTOMER_PHONE"]}
        },
        "STG_CUSTOMER_2SAT_1": {
            "CUSTOMER_PK": "CUSTOMER_ID",
            "HASHDIFF_1": {"is_hashdiff": True,
                           "columns": ["CUSTOMER_ID", "CUSTOMER_FIRSTNAME", "CUSTOMER_LASTNAME"]},
            "HASHDIFF_2": {"is_hashdiff": True,
                           "columns": ["CUSTOMER_ID", "CUSTOMER_DOB", "CUSTOMER_PHONE"]}
        },
        "STG_CUSTOMER_2SAT_2": {
            "CUSTOMER_PK": "CUSTOMER_ID",
            "HASHDIFF_1": {"is_hashdiff": True,
                           "columns": ["CUSTOMER_ID", "CUSTOMER_FIRSTNAME", "CUSTOMER_LASTNAME"]},
            "HASHDIFF_2": {"is_hashdiff": True,
                           "columns": ["CUSTOMER_ID", "CUSTOMER_DOB", "CUSTOMER_PHONE"]}
        },
        "STG_CUSTOMER_3SAT": {
            "CUSTOMER_PK": "CUSTOMER_ID",
            "HASHDIFF_1": {"is_hashdiff": True,
                           "columns": ["CUSTOMER_ID", "CUSTOMER_FIRSTNAME", "CUSTOMER_LASTNAME"]},
            "HASHDIFF_2": {"is_hashdiff": True,
                           "columns": ["CUSTOMER_ID", "CUSTOMER_DOB", "CUSTOMER_PHONE"]},
            "HASHDIFF_3": {"is_hashdiff": True,
                           "columns": ["CUSTOMER_ID", "CUSTOMER_COUNTY", "CUSTOMER_CITY"]}
        }
    }

    context.derived_columns = {
        "STG_CUSTOMER": {
            "EFFECTIVE_FROM": "LOAD_DATE",
            "SATELLITE_NAME": "!SAT_CUSTOMER"
        },
        "STG_CUSTOMER_1": {
            "EFFECTIVE_FROM": "LOAD_DATE",
            "SATELLITE_NAME": "!SAT_CUSTOMER"
        },
        "STG_CUSTOMER_2": {
            "EFFECTIVE_FROM": "LOAD_DATE",
            "SATELLITE_NAME": "!SAT_CUSTOMER"
        },
        "STG_CUSTOMER_2SAT": {
            "EFFECTIVE_FROM": "LOAD_DATE",
            "SATELLITE_1": "!SAT_CUSTOMER",
            "SATELLITE_2": "!SAT_CUSTOMER_DETAILS",
        },
        "STG_CUSTOMER_2SAT_1": {
            "EFFECTIVE_FROM": "LOAD_DATE",
            "SATELLITE_1": "!SAT_CUSTOMER",
            "SATELLITE_2": "!SAT_CUSTOMER_DETAILS",
        },
        "STG_CUSTOMER_2SAT_2": {
            "EFFECTIVE_FROM": "LOAD_DATE",
            "SATELLITE_1": "!SAT_CUSTOMER",
            "SATELLITE_2": "!SAT_CUSTOMER_DETAILS",
        },
        "STG_CUSTOMER_3SAT": {
            "EFFECTIVE_FROM": "LOAD_DATE",
            "SATELLITE_1": "!SAT_CUSTOMER",
            "SATELLITE_2": "!SAT_CUSTOMER_DETAILS",
            "SATELLITE_3": "!SAT_CUSTOMER_LOCATION",
        }
    }

    context.vault_structure_columns = {
        "XTS": {
            "src_pk": "CUSTOMER_PK",
            "src_ldts": "LOAD_DATE",
            "src_satellite": {
                "SATELLITE_CUSTOMER": {
                    "sat_name": {
                        "SATELLITE_NAME": "SATELLITE_NAME"
                    },
                    "hashdiff": {
                        "HASHDIFF": "HASHDIFF"
                    }
                },
            },
            "src_source": "SOURCE"
        },
        "XTS_2SAT": {
            "src_pk": "CUSTOMER_PK",
            "src_ldts": "LOAD_DATE",
            "src_satellite": {
                "SATELLITE_CUSTOMER": {
                    "sat_name": {
                        "SATELLITE_NAME": "SATELLITE_1"
                    },
                    "hashdiff": {
                        "HASHDIFF": "HASHDIFF_1"
                    }
                },
                "SATELLITE_CUSTOMER_DETAILS": {
                    "sat_name": {
                        "SATELLITE_NAME": "SATELLITE_2"
                    },
                    "hashdiff": {
                        "HASHDIFF": "HASHDIFF_2"
                    }
                }
            },
            "src_source": "SOURCE"
        },
        "XTS_3SAT": {
            "src_pk": "CUSTOMER_PK",
            "src_ldts": "LOAD_DATE",
            "src_satellite": {
                "SATELLITE_CUSTOMER": {
                    "sat_name": {
                        "SATELLITE_NAME": "SATELLITE_1"
                    },
                    "hashdiff": {
                        "HASHDIFF": "HASHDIFF_1"
                    }
                },
                "SATELLITE_CUSTOMER_DETAILS": {
                    "sat_name": {
                        "SATELLITE_NAME": "SATELLITE_2"
                    },
                    "hashdiff": {
                        "HASHDIFF": "HASHDIFF_2"
                    }
                },
                "SATELLITE_CUSTOMER_LOCATION": {
                    "sat_name": {
                        "SATELLITE_NAME": "SATELLITE_3"
                    },
                    "hashdiff": {
                        "HASHDIFF": "HASHDIFF_3"
                    }
                }
            },
            "src_source": "SOURCE"
        }
    }

    context.seed_config = {
        "RAW_STAGE": {
            "+column_types": {
                "CUSTOMER_ID": "STRING",
                "CUSTOMER_FIRSTNAME": "STRING",
                "CUSTOMER_LASTNAME": "STRING",
                "CUSTOMER_DOB": "DATE",
                "CUSTOMER_PHONE": "STRING",
                "CUSTOMER_COUNTY": "STRING",
                "CUSTOMER_CITY": "STRING",
                "LOAD_DATE": "DATE",
                "SOURCE": "STRING",
            }
        },
        "RAW_STAGE_1": {
            "+column_types": {
                "CUSTOMER_ID": "STRING",
                "CUSTOMER_FIRSTNAME": "STRING",
                "CUSTOMER_LASTNAME": "STRING",
                "CUSTOMER_DOB": "DATE",
                "CUSTOMER_PHONE": "STRING",
                "CUSTOMER_COUNTY": "STRING",
                "CUSTOMER_CITY": "STRING",
                "LOAD_DATE": "DATE",
                "SOURCE": "STRING",
            }
        },
        "RAW_STAGE_2": {
            "+column_types": {
                "CUSTOMER_ID": "STRING",
                "CUSTOMER_FIRSTNAME": "STRING",
                "CUSTOMER_LASTNAME": "STRING",
                "CUSTOMER_DOB": "DATE",
                "CUSTOMER_PHONE": "STRING",
                "CUSTOMER_COUNTY": "STRING",
                "CUSTOMER_CITY": "STRING",
                "LOAD_DATE": "DATE",
                "SOURCE": "STRING",
            }
        },
        "RAW_STAGE_2SAT": {
            "+column_types": {
                "CUSTOMER_ID": "STRING",
                "CUSTOMER_FIRSTNAME": "STRING",
                "CUSTOMER_LASTNAME": "STRING",
                "CUSTOMER_DOB": "DATE",
                "CUSTOMER_PHONE": "STRING",
                "CUSTOMER_COUNTY": "STRING",
                "CUSTOMER_CITY": "STRING",
                "LOAD_DATE": "DATE",
                "SOURCE": "STRING",
            }
        },
        "RAW_STAGE_2SAT_1": {
            "+column_types": {
                "CUSTOMER_ID": "STRING",
                "CUSTOMER_FIRSTNAME": "STRING",
                "CUSTOMER_LASTNAME": "STRING",
                "CUSTOMER_DOB": "DATE",
                "CUSTOMER_PHONE": "STRING",
                "CUSTOMER_COUNTY": "STRING",
                "CUSTOMER_CITY": "STRING",
                "LOAD_DATE": "DATE",
                "SOURCE": "STRING",
            }
        },
        "RAW_STAGE_2SAT_2": {
            "+column_types": {
                "CUSTOMER_ID": "STRING",
                "CUSTOMER_FIRSTNAME": "STRING",
                "CUSTOMER_LASTNAME": "STRING",
                "CUSTOMER_DOB": "DATE",
                "CUSTOMER_PHONE": "STRING",
                "CUSTOMER_COUNTY": "STRING",
                "CUSTOMER_CITY": "STRING",
                "LOAD_DATE": "DATE",
                "SOURCE": "STRING",
            }
        },
        "RAW_STAGE_3SAT": {
            "+column_types": {
                "CUSTOMER_ID": "STRING",
                "CUSTOMER_FIRSTNAME": "STRING",
                "CUSTOMER_LASTNAME": "STRING",
                "CUSTOMER_DOB": "DATE",
                "CUSTOMER_PHONE": "STRING",
                "CUSTOMER_COUNTY": "STRING",
                "CUSTOMER_CITY": "STRING",
                "LOAD_DATE": "DATE",
                "SOURCE": "STRING",
            }
        },
        "STG_CUSTOMER": {
            "+column_types": {
                "CUSTOMER_PK": "BYTES",
                "HASHDIFF": "BYTES",
                "EFFECTIVE_FROM": "DATE",
                "SATELLITE_NAME": "STRING",
                "CUSTOMER_ID": "STRING",
                "CUSTOMER_FIRSTNAME": "STRING",
                "CUSTOMER_LASTNAME": "STRING",
                "CUSTOMER_DOB": "DATE",
                "CUSTOMER_PHONE": "STRING",
                "CUSTOMER_COUNTY": "STRING",
                "CUSTOMER_CITY": "STRING",
                "LOAD_DATE": "DATE",
                "SOURCE": "STRING"
            }
        },
        "STG_CUSTOMER_2SAT": {
            "+column_types": {
                "CUSTOMER_PK": "BYTES",
                "HASHDIFF_1": "BYTES",
                "HASHDIFF_2": "BYTES",
                "EFFECTIVE_FROM": "DATE",
                "SATELLITE_1": "STRING",
                "SATELLITE_2": "STRING",
                "CUSTOMER_ID": "STRING",
                "CUSTOMER_FIRSTNAME": "STRING",
                "CUSTOMER_LASTNAME": "STRING",
                "CUSTOMER_DOB": "DATE",
                "CUSTOMER_PHONE": "STRING",
                "CUSTOMER_COUNTY": "STRING",
                "CUSTOMER_CITY": "STRING",
                "LOAD_DATE": "DATE",
                "SOURCE": "STRING"
            }
        },
        "STG_CUSTOMER_3SAT": {
            "+column_types": {
                "CUSTOMER_PK": "BYTES",
                "HASHDIFF_1": "BYTES",
                "HASHDIFF_2": "BYTES",
                "HASHDIFF_3": "BYTES",
                "EFFECTIVE_FROM": "DATE",
                "SATELLITE_1": "STRING",
                "SATELLITE_2": "STRING",
                "SATELLITE_3": "STRING",
                "CUSTOMER_ID": "STRING",
                "CUSTOMER_FIRSTNAME": "STRING",
                "CUSTOMER_LASTNAME": "STRING",
                "CUSTOMER_DOB": "DATE",
                "CUSTOMER_PHONE": "STRING",
                "CUSTOMER_COUNTY": "STRING",
                "CUSTOMER_CITY": "STRING",
                "LOAD_DATE": "DATE",
                "SOURCE": "STRING"
            }
        },
        "XTS": {
            "+column_types": {
                "CUSTOMER_PK": "BYTES",
                "LOAD_DATE": "DATE",
                "SATELLITE_NAME": "STRING",
                "HASHDIFF": "BYTES",
                "SOURCE": "STRING"
            }
        },
        "XTS_2SAT": {
            "+column_types": {
                "CUSTOMER_PK": "BYTES",
                "SATELLITE_NAME": "STRING",
                "HASHDIFF": "BYTES",
                "LOAD_DATE": "DATE",
                "SOURCE": "STRING"
            }
        },
        "XTS_3SAT": {
            "+column_types": {
                "CUSTOMER_PK": "BYTES",
                "SATELLITE_NAME": "STRING",
                "HASHDIFF": "BYTES",
                "LOAD_DATE": "DATE",
                "SOURCE": "STRING"
            }
        }
    }


@fixture
def cycle_bigquery(context):
    """
    Define the structures and metadata to perform vault load cycles
    """

    context.hashed_columns = {
        "STG_CUSTOMER": {
            "CUSTOMER_PK": "CUSTOMER_ID",
            "HASHDIFF": {"is_hashdiff": True,
                         "columns": ["CUSTOMER_DOB", "CUSTOMER_ID", "CUSTOMER_NAME"]
                         }
        },
        "STG_BOOKING": {
            "CUSTOMER_PK": "CUSTOMER_ID",
            "BOOKING_PK": "BOOKING_ID",
            "CUSTOMER_BOOKING_PK": ["CUSTOMER_ID", "BOOKING_ID"],
            "HASHDIFF_BOOK_CUSTOMER_DETAILS": {"is_hashdiff": True,
                                               "columns": ["CUSTOMER_ID",
                                                           "NATIONALITY",
                                                           "PHONE"]
                                               },
            "HASHDIFF_BOOK_BOOKING_DETAILS": {"is_hashdiff": True,
                                              "columns": ["BOOKING_ID",
                                                          "BOOKING_DATE",
                                                          "PRICE",
                                                          "DEPARTURE_DATE",
                                                          "DESTINATION"]
                                              }
        }
    }

    context.derived_columns = {
        "STG_CUSTOMER": {
            "EFFECTIVE_FROM": "LOAD_DATE"
        },
        "STG_BOOKING": {
            "EFFECTIVE_FROM": "BOOKING_DATE"
        }
    }

    context.vault_structure_columns = {
        "HUB_CUSTOMER": {
            "source_model": ["STG_CUSTOMER",
                             "STG_BOOKING"],
            "src_pk": "CUSTOMER_PK",
            "src_nk": "CUSTOMER_ID",
            "src_ldts": "LOAD_DATE",
            "src_source": "SOURCE"
        },
        "HUB_BOOKING": {
            "source_model": "STG_BOOKING",
            "src_pk": "BOOKING_PK",
            "src_nk": "BOOKING_ID",
            "src_ldts": "LOAD_DATE",
            "src_source": "SOURCE"
        },
        "LINK_CUSTOMER_BOOKING": {
            "source_model": "STG_BOOKING",
            "src_pk": "CUSTOMER_BOOKING_PK",
            "src_fk": ["CUSTOMER_PK", "BOOKING_PK"],
            "src_ldts": "LOAD_DATE",
            "src_source": "SOURCE"
        },
        "SAT_CUST_CUSTOMER_DETAILS": {
            "source_model": "STG_CUSTOMER",
            "src_pk": "CUSTOMER_PK",
            "src_hashdiff": "HASHDIFF",
            "src_payload": ["CUSTOMER_NAME", "CUSTOMER_DOB"],
            "src_eff": "EFFECTIVE_FROM",
            "src_ldts": "LOAD_DATE",
            "src_source": "SOURCE"
        },
        "SAT_BOOK_CUSTOMER_DETAILS": {
            "source_model": "STG_BOOKING",
            "src_pk": "CUSTOMER_PK",
            "src_hashdiff": {"source_column": "HASHDIFF_BOOK_CUSTOMER_DETAILS",
                             "alias": "HASHDIFF"},
            "src_payload": ["PHONE", "NATIONALITY"],
            "src_eff": "EFFECTIVE_FROM",
            "src_ldts": "LOAD_DATE",
            "src_source": "SOURCE"
        },
        "SAT_BOOK_BOOKING_DETAILS": {
            "source_model": "STG_BOOKING",
            "src_pk": "BOOKING_PK",
            "src_hashdiff": {"source_column": "HASHDIFF_BOOK_BOOKING_DETAILS",
                             "alias": "HASHDIFF"},
            "src_payload": ["PRICE", "BOOKING_DATE",
                            "DEPARTURE_DATE", "DESTINATION"],
            "src_eff": "EFFECTIVE_FROM",
            "src_ldts": "LOAD_DATE",
            "src_source": "SOURCE"
        },
        "PIT_CUSTOMER": {
            "source_model": "HUB_CUSTOMER",
            "src_pk": "CUSTOMER_PK",
            "as_of_dates_table": "AS_OF_DATE",
            "satellites":
                {
                    "SAT_CUSTOMER_DETAILS": {
                        "pk":
                            {"PK": "CUSTOMER_PK"},
                        "ldts":
                            {"LDTS": "LOAD_DATE"}
                    },
                    "SAT_CUSTOMER_LOGIN": {
                        "pk":
                            {"PK": "CUSTOMER_PK"},
                        "ldts":
                            {"LDTS": "LOAD_DATE"}
                    },
                    "SAT_CUSTOMER_PROFILE": {
                        "pk":
                            {"PK": "CUSTOMER_PK"},
                        "ldts":
                            {"LDTS": "LOAD_DATE"}
                    }
                }
        }
    }

    context.stage_columns = {
        "RAW_STAGE_CUSTOMER":
            ["CUSTOMER_ID",
             "CUSTOMER_NAME",
             "CUSTOMER_DOB",
             "EFFECTIVE_FROM",
             "LOAD_DATE",
             "SOURCE"],

        "RAW_STAGE_BOOKING":
            ["BOOKING_ID",
             "CUSTOMER_ID",
             "BOOKING_DATE",
             "PRICE",
             "DEPARTURE_DATE",
             "DESTINATION",
             "PHONE",
             "NATIONALITY",
             "LOAD_DATE",
             "SOURCE"]
    }

    context.seed_config = {
        "RAW_STAGE_CUSTOMER": {
            "+column_types": {
                "CUSTOMER_ID": "STRING",
                "CUSTOMER_NAME": "STRING",
                "CUSTOMER_DOB": "DATE",
                "EFFECTIVE_FROM": "DATE",
                "LOAD_DATE": "DATE",
                "SOURCE": "STRING"
            }
        },
        "RAW_STAGE_BOOKING": {
            "+column_types": {
                "BOOKING_ID": "STRING",
                "CUSTOMER_ID": "STRING",
                "PRICE": "NUMERIC",
                "DEPARTURE_DATE": "DATE",
                "BOOKING_DATE": "DATE",
                "PHONE": "STRING",
                "DESTINATION": "STRING",
                "NATIONALITY": "STRING",
                "LOAD_DATE": "DATE",
                "SOURCE": "STRING"
            }
        },
        "HUB_CUSTOMER": {
            "+column_types": {
                "CUSTOMER_PK": "BYTES",
                "CUSTOMER_ID": "STRING",
                "LOAD_DATE": "DATE",
                "SOURCE": "STRING"
            }
        },
        "HUB_BOOKING": {
            "+column_types": {
                "BOOKING_PK": "BYTES",
                "BOOKING_ID": "STRING",
                "LOAD_DATE": "DATE",
                "SOURCE": "STRING"
            }
        },
        "LINK_CUSTOMER_BOOKING": {
            "+column_types": {
                "CUSTOMER_BOOKING_PK": "BYTES",
                "CUSTOMER_PK": "BYTES",
                "BOOKING_PK": "BYTES",
                "LOAD_DATE": "DATE",
                "SOURCE": "STRING"
            }
        },
        "SAT_CUST_CUSTOMER_DETAILS": {
            "+column_types": {
                "CUSTOMER_PK": "BYTES",
                "HASHDIFF": "BYTES",
                "CUSTOMER_NAME": "STRING",
                "CUSTOMER_DOB": "DATE",
                "EFFECTIVE_FROM": "DATE",
                "LOAD_DATE": "DATE",
                "SOURCE": "STRING"
            }
        },
        "SAT_BOOK_CUSTOMER_DETAILS": {
            "+column_types": {
                "CUSTOMER_PK": "BYTES",
                "HASHDIFF": "BYTES",
                "PHONE": "STRING",
                "NATIONALITY": "STRING",
                "EFFECTIVE_FROM": "DATE",
                "LOAD_DATE": "DATE",
                "SOURCE": "STRING"
            }
        },
        "SAT_BOOK_BOOKING_DETAILS": {
            "+column_types": {
                "BOOKING_PK": "BYTES",
                "HASHDIFF": "BYTES",
                "PRICE": "NUMERIC",
                "BOOKING_DATE": "DATE",
                "DEPARTURE_DATE": "DATE",
                "DESTINATION": "STRING",
                "EFFECTIVE_FROM": "DATE",
                "LOAD_DATE": "DATE",
                "SOURCE": "STRING"
            }
        }
    }


@fixture
def enable_auto_end_date(context):
    """
    Indicate that auto end-dating on effectivity satellites should be enabled
    """
    context.auto_end_date = True


@fixture
def enable_full_refresh(context):
    """
    Indicate that a full refresh for a dbt run should be executed
    """
    context.full_refresh = True


@fixture
def disable_union(context):
    """
    Indicate that a list should not be created if multiple stages are specified in a scenario
    """
    context.disable_union = True


@fixture
def disable_payload(context):
    """
    Indicate that a src_payload key should be removed from the provided metadata
    """
    context.disable_payload = True