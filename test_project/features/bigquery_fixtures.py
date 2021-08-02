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

                if t == "STRING":
                    config[k]["+column_types"][c] = "STRING"

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
                    "link_table": "LINK_LINKPRODUCT_COMPONENT",
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
                "CUSTOMER_PK": "STRING",
                "CUSTOMER_ID": "STRING",
                "LOAD_DATETIME": "DATETIME",
                "SOURCE": "STRING"
            }
        },
        "LINK_CUSTOMER_ORDER": {
            "+column_types": {
                "CUSTOMER_ORDER_PK": "STRING",
                "CUSTOMER_FK": "STRING",
                "ORDER_FK": "STRING",
                "LOAD_DATETIME": "DATETIME",
                "SOURCE": "STRING"
            }
        },
        "LINK_ORDER_PRODUCT": {
            "+column_types": {
                "ORDER_PRODUCT_PK": "STRING",
                "ORDER_FK": "STRING",
                "PRODUCT_FK": "STRING",
                "LOAD_DATETIME": "DATETIME",
                "SOURCE": "STRING"
            }
        },
        "LINK_PRODUCT_COMPONENT": {
            "+column_types": {
                "PRODUCT_COMPONENT_PK": "STRING",
                "PRODUCT_FK": "STRING",
                "COMPONENT_FK": "STRING",
                "LOAD_DATETIME": "DATETIME",
                "SOURCE": "STRING"
            }
        },
        "EFF_SAT_CUSTOMER_ORDER": {
            "+column_types": {
                "CUSTOMER_ORDER_PK": "STRING",
                "CUSTOMER_FK": "STRING",
                "ORDER_FK": "STRING",
                "START_DATE": "DATETIME",
                "END_DATE": "DATETIME",
                "EFFECTIVE_FROM": "DATETIME",
                "LOAD_DATETIME": "DATETIME",
                "SOURCE": "STRING"
            }
        },
        "EFF_SAT_ORDER_PRODUCT": {
            "+column_types": {
                "ORDER_PRODUCT_PK": "STRING",
                "ORDER_FK": "STRING",
                "PRODUCT_FK": "STRING",
                "START_DATE": "DATETIME",
                "END_DATE": "DATETIME",
                "EFFECTIVE_FROM": "DATETIME",
                "LOAD_DATETIME": "DATETIME",
                "SOURCE": "STRING"
            }
        },
        "EFF_SAT_PRODUCT_COMPONENT": {
            "+column_types": {
                "PRODUCT_COMPONENT_PK": "STRING",
                "PRODUCT_FK": "STRING",
                "COMPONENT_FK": "STRING",
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
                "CUSTOMER_PK": "STRING",
                "AS_OF_DATE": "DATETIME",
                "LINK_CUSTOMER_ORDER_PK": "STRING",
            }
        },
        "BRIDGE_CUSTOMER_ORDER_PRODUCT": {
            "+column_types": {
                "CUSTOMER_PK": "STRING",
                "AS_OF_DATE": "DATETIME",
                "LINK_CUSTOMER_ORDER_PK": "STRING",
                "LINK_ORDER_PRODUCT_PK": "STRING",
            }
        },
        "BRIDGE_CUSTOMER_ORDER_PRODUCT_COMPONENT": {
            "+column_types": {
                "CUSTOMER_PK": "STRING",
                "AS_OF_DATE": "DATETIME",
                "LINK_CUSTOMER_ORDER_PK": "STRING",
                "LINK_ORDER_PRODUCT_PK": "STRING",
                "LINK_PRODUCT_COMPONENT_PK": "STRING",
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
                "CUSTOMER_ID": "STRING",
                "CUSTOMER_NAME": "STRING",
                "CUSTOMER_PHONE": "STRING",
                "CUSTOMER_DOB": "DATE",
                "LOAD_DATE": "DATE",
                "SOURCE": "STRING"
            }
        },
        "RAW_STAGE_TS": {
            "+column_types": {
                "CUSTOMER_ID": "STRING",
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
                "HASHDIFF": "BYTES",
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
                "CUSTOMER_PK": "STRING",
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
                "CUSTOMER_ORDER_PK": "STRING",
                "CUSTOMER_PK": "STRING",
                "ORDER_PK": "STRING",
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
                "CUSTOMER_ORDER_PK": "STRING",
                "CUSTOMER_PK": "STRING",
                "ORDER_PK": "STRING",
                "LOAD_DATETIME": "DATETIME",
                "SOURCE": "STRING"
            }
        },
        "LINK_ORDER_CUSTOMER": {
            "+column_types": {
                "ORDER_CUSTOMER_PK": "STRING",
                "CUSTOMER_PK": "STRING",
                "ORDER_PK": "STRING",
                "LOAD_DATETIME": "DATETIME",
                "SOURCE": "STRING"
            }
        },
        "EFF_SAT_CUSTOMER_ORDER": {
            "+column_types": {
                "CUSTOMER_ORDER_PK": "STRING",
                "CUSTOMER_PK": "STRING",
                "ORDER_PK": "STRING",
                "START_DATE": "DATETIME",
                "END_DATE": "DATETIME",
                "EFFECTIVE_FROM": "DATETIME",
                "LOAD_DATETIME": "DATETIME",
                "SOURCE": "STRING"
            }
        },
        "EFF_SAT_ORDER_CUSTOMER": {
            "+column_types": {
                "ORDER_CUSTOMER_PK": "STRING",
                "CUSTOMER_PK": "STRING",
                "ORDER_PK": "STRING",
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
                "CUSTOMER_ID": "STRING",
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
                "CUSTOMER_ORDER_PK": "STRING",
                "ORDER_PK": "STRING",
                "PLATFORM_PK": "STRING",
                "ORGANISATION_PK": "STRING",
                "CUSTOMER_PK": "STRING",
                "NATION_PK": "STRING",
                "START_DATE": "DATE",
                "END_DATE": "DATE",
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