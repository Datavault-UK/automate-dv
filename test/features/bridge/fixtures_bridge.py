from behave import fixture


def set_vault_structure_definition(context):
    context.vault_structure_type = "bridge"

    context.vault_structure_columns = {
        "HUB_CUSTOMER": {
            "source_model": "STG_CUSTOMER_ORDER",
            "src_pk": "CUSTOMER_PK",
            "src_nk": "CUSTOMER_ID",
            "src_ldts": "LOAD_DATETIME",
            "src_source": "SOURCE"
        },
        "HUB_CUSTOMER_M_AC": {
            "source_model": "STG_CUSTOMER_ORDER",
            "src_pk": "CUSTOMER_PK",
            "src_nk": ["CUSTOMER_ID", "TEST_COLUMN"],
            "src_ldts": "LOAD_DATETIME",
            "src_source": "SOURCE"
        },
        "LINK_CUSTOMER_ORDER": {
            "source_model": "STG_CUSTOMER_ORDER",
            "src_pk": "CUSTOMER_ORDER_PK",
            "src_fk": ["CUSTOMER_PK", "ORDER_PK"],
            "src_ldts": "LOAD_DATETIME",
            "src_source": "SOURCE"
        },
        "LINK_ORDER_PRODUCT": {
            "source_model": "STG_ORDER_PRODUCT",
            "src_pk": "ORDER_PRODUCT_PK",
            "src_fk": ["ORDER_PK", "PRODUCT_PK"],
            "src_ldts": "LOAD_DATETIME",
            "src_source": "SOURCE"
        },
        "LINK_PRODUCT_COMPONENT": {
            "source_model": "STG_PRODUCT_COMPONENT",
            "src_pk": "PRODUCT_COMPONENT_PK",
            "src_fk": ["PRODUCT_PK", "COMPONENT_PK"],
            "src_ldts": "LOAD_DATETIME",
            "src_source": "SOURCE"
        },
        "EFF_SAT_CUSTOMER_ORDER": {
            "source_model": "STG_CUSTOMER_ORDER",
            "src_pk": "CUSTOMER_ORDER_PK",
            "src_dfk": ["ORDER_PK"],
            "src_sfk": ["CUSTOMER_PK"],
            "src_start_date": "START_DATE",
            "src_end_date": "END_DATE",
            "src_eff": "EFFECTIVE_FROM",
            "src_ldts": "LOAD_DATETIME",
            "src_source": "SOURCE"
        },
        "EFF_SAT_ORDER_PRODUCT": {
            "source_model": "STG_ORDER_PRODUCT",
            "src_pk": "ORDER_PRODUCT_PK",
            "src_dfk": ["ORDER_PK"],
            "src_sfk": ["PRODUCT_PK"],
            "src_start_date": "START_DATE",
            "src_end_date": "END_DATE",
            "src_eff": "EFFECTIVE_FROM",
            "src_ldts": "LOAD_DATETIME",
            "src_source": "SOURCE"
        },
        "EFF_SAT_PRODUCT_COMPONENT": {
            "source_model": "STG_PRODUCT_COMPONENT",
            "src_pk": "PRODUCT_COMPONENT_PK",
            "src_dfk": ["COMPONENT_PK"],
            "src_sfk": ["PRODUCT_PK"],
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
                    "link_fk1": "CUSTOMER_PK",
                    "link_fk2": "ORDER_PK",
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
        "BRIDGE_CUSTOMER_ORDER_AC": {
            "source_model": "HUB_CUSTOMER",
            "src_pk": "CUSTOMER_PK",
            "src_ldts": "LOAD_DATETIME",
            "as_of_dates_table": "AS_OF_DATE",
            "src_extra_columns": "CUSTOMER_ID",
            "bridge_walk": {
                "CUSTOMER_ORDER": {
                    "bridge_link_pk": "LINK_CUSTOMER_ORDER_PK",
                    "bridge_end_date": "EFF_SAT_CUSTOMER_ORDER_ENDDATE",
                    "bridge_load_date": "EFF_SAT_CUSTOMER_ORDER_LOADDATE",
                    "link_table": "LINK_CUSTOMER_ORDER",
                    "link_pk": "CUSTOMER_ORDER_PK",
                    "link_fk1": "CUSTOMER_PK",
                    "link_fk2": "ORDER_PK",
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
        "BRIDGE_CUSTOMER_ORDER_M_AC": {
            "source_model": "HUB_CUSTOMER_M_AC",
            "src_pk": "CUSTOMER_PK",
            "src_ldts": "LOAD_DATETIME",
            "as_of_dates_table": "AS_OF_DATE",
            "src_extra_columns": ["CUSTOMER_ID", "TEST_COLUMN"],
            "bridge_walk": {
                "CUSTOMER_ORDER": {
                    "bridge_link_pk": "LINK_CUSTOMER_ORDER_PK",
                    "bridge_end_date": "EFF_SAT_CUSTOMER_ORDER_ENDDATE",
                    "bridge_load_date": "EFF_SAT_CUSTOMER_ORDER_LOADDATE",
                    "link_table": "LINK_CUSTOMER_ORDER",
                    "link_pk": "CUSTOMER_ORDER_PK",
                    "link_fk1": "CUSTOMER_PK",
                    "link_fk2": "ORDER_PK",
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
                    "link_fk1": "CUSTOMER_PK",
                    "link_fk2": "ORDER_PK",
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
                    "link_fk1": "ORDER_PK",
                    "link_fk2": "PRODUCT_PK",
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
        "BRIDGE_CUSTOMER_ORDER_PRODUCT_AC": {
            "source_model": "HUB_CUSTOMER",
            "src_pk": "CUSTOMER_PK",
            "src_ldts": "LOAD_DATETIME",
            "as_of_dates_table": "AS_OF_DATE",
            "src_extra_columns": "CUSTOMER_ID",
            "bridge_walk": {
                "CUSTOMER_ORDER": {
                    "bridge_link_pk": "LINK_CUSTOMER_ORDER_PK",
                    "bridge_end_date": "EFF_SAT_CUSTOMER_ORDER_ENDDATE",
                    "bridge_load_date": "EFF_SAT_CUSTOMER_ORDER_LOADDATE",
                    "link_table": "LINK_CUSTOMER_ORDER",
                    "link_pk": "CUSTOMER_ORDER_PK",
                    "link_fk1": "CUSTOMER_PK",
                    "link_fk2": "ORDER_PK",
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
                    "link_fk1": "ORDER_PK",
                    "link_fk2": "PRODUCT_PK",
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
                    "link_fk1": "CUSTOMER_PK",
                    "link_fk2": "ORDER_PK",
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
                    "link_fk1": "ORDER_PK",
                    "link_fk2": "PRODUCT_PK",
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
                    "link_fk1": "PRODUCT_PK",
                    "link_fk2": "COMPONENT_PK",
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
        },
        "BRIDGE_CUSTOMER_ORDER_PRODUCT_COMPONENT_AC": {
            "source_model": "HUB_CUSTOMER",
            "src_pk": "CUSTOMER_PK",
            "src_ldts": "LOAD_DATETIME",
            "as_of_dates_table": "AS_OF_DATE",
            "src_extra_columns": "CUSTOMER_ID",
            "bridge_walk": {
                "CUSTOMER_ORDER": {
                    "bridge_link_pk": "LINK_CUSTOMER_ORDER_PK",
                    "bridge_end_date": "EFF_SAT_CUSTOMER_ORDER_ENDDATE",
                    "bridge_load_date": "EFF_SAT_CUSTOMER_ORDER_LOADDATE",
                    "link_table": "LINK_CUSTOMER_ORDER",
                    "link_pk": "CUSTOMER_ORDER_PK",
                    "link_fk1": "CUSTOMER_PK",
                    "link_fk2": "ORDER_PK",
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
                    "link_fk1": "ORDER_PK",
                    "link_fk2": "PRODUCT_PK",
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
                    "link_fk1": "PRODUCT_PK",
                    "link_fk2": "COMPONENT_PK",
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


def set_staging_definition(context):
    context.hashed_columns = {
        "STG_CUSTOMER_ORDER": {
            "CUSTOMER_PK": "CUSTOMER_ID",
            "ORDER_PK": "ORDER_ID",
            "CUSTOMER_ORDER_PK": {"is_hashdiff": True,
                                  "columns": ["CUSTOMER_ID", "ORDER_ID"]},
        },
        "STG_ORDER_PRODUCT": {
            "ORDER_PK": "ORDER_ID",
            "PRODUCT_PK": "PRODUCT_ID",
            "ORDER_PRODUCT_PK": {"is_hashdiff": True,
                                 "columns": ["ORDER_ID", "PRODUCT_ID"]}
        },
        "STG_PRODUCT_COMPONENT": {
            "PRODUCT_PK": "PRODUCT_ID",
            "COMPONENT_PK": "COMPONENT_ID",
            "PRODUCT_COMPONENT_PK": {"is_hashdiff": True,
                                     "columns": ["COMPONENT_ID", "PRODUCT_ID"]}
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


def set_metadata(context):
    set_vault_structure_definition(context)

    set_staging_definition(context)


@fixture
def bridge_snowflake(context):
    """
    Define the structures and metadata to perform bridge load
    """

    set_metadata(context)

    context.seed_config = {
        "RAW_CUSTOMER_ORDER": {
            "column_types": {
                "CUSTOMER_ID": "VARCHAR",
                "ORDER_ID": "VARCHAR",
                "CUSTOMER_MT_ID": "VARCHAR",
                "LOAD_DATETIME": "DATETIME",
                "END_DATE": "DATETIME",
                "SOURCE": "VARCHAR"
            }
        },
        "RAW_ORDER_PRODUCT": {
            "column_types": {
                "ORDER_ID": "VARCHAR",
                "PRODUCT_ID": "VARCHAR",
                "LOAD_DATETIME": "DATETIME",
                "END_DATE": "DATETIME",
                "SOURCE": "VARCHAR"
            }
        },
        "RAW_PRODUCT_COMPONENT": {
            "column_types": {
                "PRODUCT_ID": "VARCHAR",
                "COMPONENT_ID": "VARCHAR",
                "LOAD_DATETIME": "DATETIME",
                "END_DATE": "DATETIME",
                "SOURCE": "VARCHAR"
            }
        },
        "HUB_CUSTOMER": {
            "column_types": {
                "CUSTOMER_PK": "BINARY(16)",
                "CUSTOMER_ID": "VARCHAR",
                "LOAD_DATETIME": "DATETIME",
                "SOURCE": "VARCHAR"
            }
        },
        "HUB_CUSTOMER_M_AC": {
            "column_types": {
                "CUSTOMER_PK": "BINARY(16)",
                "CUSTOMER_ID": "VARCHAR",
                "TEST_COLUMN": "VARCHAR",
                "LOAD_DATETIME": "DATETIME",
                "SOURCE": "VARCHAR"
            }
        },
        "LINK_CUSTOMER_ORDER": {
            "column_types": {
                "CUSTOMER_ORDER_PK": "BINARY(16)",
                "CUSTOMER_PK": "BINARY(16)",
                "ORDER_K": "BINARY(16)",
                "LOAD_DATETIME": "DATETIME",
                "SOURCE": "VARCHAR"
            }
        },
        "LINK_ORDER_PRODUCT": {
            "column_types": {
                "ORDER_PRODUCT_PK": "BINARY(16)",
                "ORDER_PK": "BINARY(16)",
                "PRODUCT_PK": "BINARY(16)",
                "LOAD_DATETIME": "DATETIME",
                "SOURCE": "VARCHAR"
            }
        },
        "LINK_PRODUCT_COMPONENT": {
            "column_types": {
                "PRODUCT_COMPONENT_PK": "BINARY(16)",
                "PRODUCT_PK": "BINARY(16)",
                "COMPONENT_PK": "BINARY(16)",
                "LOAD_DATETIME": "DATETIME",
                "SOURCE": "VARCHAR"
            }
        },
        "EFF_SAT_CUSTOMER_ORDER": {
            "column_types": {
                "CUSTOMER_ORDER_PK": "BINARY(16)",
                "CUSTOMER_PK": "BINARY(16)",
                "ORDER_PK": "BINARY(16)",
                "START_DATE": "DATETIME",
                "END_DATE": "DATETIME",
                "EFFECTIVE_FROM": "DATETIME",
                "LOAD_DATETIME": "DATETIME",
                "SOURCE": "VARCHAR"
            }
        },
        "EFF_SAT_ORDER_PRODUCT": {
            "column_types": {
                "ORDER_PRODUCT_PK": "BINARY(16)",
                "ORDER_PK": "BINARY(16)",
                "PRODUCT_PK": "BINARY(16)",
                "START_DATE": "DATETIME",
                "END_DATE": "DATETIME",
                "EFFECTIVE_FROM": "DATETIME",
                "LOAD_DATETIME": "DATETIME",
                "SOURCE": "VARCHAR"
            }
        },
        "EFF_SAT_PRODUCT_COMPONENT": {
            "column_types": {
                "PRODUCT_COMPONENT_PK": "BINARY(16)",
                "PRODUCT_PK": "BINARY(16)",
                "COMPONENT_PK": "BINARY(16)",
                "START_DATE": "DATETIME",
                "END_DATE": "DATETIME",
                "EFFECTIVE_FROM": "DATETIME",
                "LOAD_DATETIME": "DATETIME",
                "SOURCE": "VARCHAR"
            }
        },
        "AS_OF_DATE": {
            "column_types": {
                "AS_OF_DATE": "DATETIME"
            }
        },
        "BRIDGE_CUSTOMER_ORDER": {
            "column_types": {
                "CUSTOMER_PK": "BINARY(16)",
                "AS_OF_DATE": "DATETIME",
                "LINK_CUSTOMER_ORDER_PK": "BINARY(16)",
            }
        },
        "BRIDGE_CUSTOMER_ORDER_AC": {
            "column_types": {
                "CUSTOMER_PK": "BINARY(16)",
                "AS_OF_DATE": "DATETIME",
                "LINK_CUSTOMER_ORDER_PK": "BINARY(16)",
                "CUSTOMER_ID": "VARCHAR"
            }
        },
        "BRIDGE_CUSTOMER_ORDER_M_AC": {
            "column_types": {
                "CUSTOMER_PK": "BINARY(16)",
                "AS_OF_DATE": "DATETIME",
                "CUSTOMER_ID": "VARCHAR",
                "TEST_COLUMN": "VARCHAR",
                "LINK_CUSTOMER_ORDER_PK": "BINARY(16)"
            }
        },
        "BRIDGE_CUSTOMER_ORDER_PRODUCT": {
            "column_types": {
                "CUSTOMER_PK": "BINARY(16)",
                "AS_OF_DATE": "DATETIME",
                "LINK_CUSTOMER_ORDER_PK": "BINARY(16)",
                "LINK_ORDER_PRODUCT_PK": "BINARY(16)",
            }
        },
        "BRIDGE_CUSTOMER_ORDER_PRODUCT_AC": {
            "column_types": {
                "CUSTOMER_PK": "BINARY(16)",
                "AS_OF_DATE": "DATETIME",
                "CUSTOMER_ID": "VARCHAR",
                "LINK_CUSTOMER_ORDER_PK": "BINARY(16)",
                "LINK_ORDER_PRODUCT_PK": "BINARY(16)",
            }
        },
        "BRIDGE_CUSTOMER_ORDER_PRODUCT_COMPONENT": {
            "column_types": {
                "CUSTOMER_PK": "BINARY(16)",
                "AS_OF_DATE": "DATETIME",
                "LINK_CUSTOMER_ORDER_PK": "BINARY(16)",
                "LINK_ORDER_PRODUCT_PK": "BINARY(16)",
                "LINK_PRODUCT_COMPONENT_PK": "BINARY(16)",
            }
        },
        "BRIDGE_CUSTOMER_ORDER_PRODUCT_COMPONENT_AC": {
            "column_types": {
                "CUSTOMER_PK": "BINARY(16)",
                "AS_OF_DATE": "DATETIME",
                "CUSTOMER_ID": "VARCHAR",
                "LINK_CUSTOMER_ORDER_PK": "BINARY(16)",
                "LINK_ORDER_PRODUCT_PK": "BINARY(16)",
                "LINK_PRODUCT_COMPONENT_PK": "BINARY(16)",
            }
        }
    }


@fixture
def bridge_bigquery(context):
    """
    Define the structures and metadata to perform bridge load
    """

    set_metadata(context)

    context.seed_config = {
        "RAW_CUSTOMER_ORDER": {
            "column_types": {
                "CUSTOMER_ID": "STRING",
                "ORDER_ID": "STRING",
                "TEST_COLUMN": "STRING",
                "LOAD_DATETIME": "DATETIME",
                "END_DATE": "DATETIME",
                "SOURCE": "STRING"
            }
        },
        "RAW_ORDER_PRODUCT": {
            "column_types": {
                "ORDER_ID": "STRING",
                "PRODUCT_ID": "STRING",
                "LOAD_DATETIME": "DATETIME",
                "END_DATE": "DATETIME",
                "SOURCE": "STRING"
            }
        },
        "RAW_PRODUCT_COMPONENT": {
            "column_types": {
                "PRODUCT_ID": "STRING",
                "COMPONENT_ID": "STRING",
                "LOAD_DATETIME": "DATETIME",
                "END_DATE": "DATETIME",
                "SOURCE": "STRING"
            }
        },
        "HUB_CUSTOMER": {
            "column_types": {
                "CUSTOMER_PK": "STRING",
                "CUSTOMER_ID": "STRING",
                "LOAD_DATETIME": "DATETIME",
                "SOURCE": "STRING"
            }
        },
        "HUB_CUSTOMER_M_AC": {
            "column_types": {
                "CUSTOMER_PK": "STRING",
                "CUSTOMER_ID": "STRING",
                "TEST_COLUMN": "STRING",
                "LOAD_DATETIME": "DATETIME",
                "SOURCE": "STRING"
            }
        },
        "LINK_CUSTOMER_ORDER": {
            "column_types": {
                "CUSTOMER_ORDER_PK": "STRING",
                "CUSTOMER_PK": "STRING",
                "ORDER_PK": "STRING",
                "LOAD_DATETIME": "DATETIME",
                "SOURCE": "STRING"
            }
        },
        "LINK_ORDER_PRODUCT": {
            "column_types": {
                "ORDER_PRODUCT_PK": "STRING",
                "ORDER_PK": "STRING",
                "PRODUCT_PK": "STRING",
                "LOAD_DATETIME": "DATETIME",
                "SOURCE": "STRING"
            }
        },
        "LINK_PRODUCT_COMPONENT": {
            "column_types": {
                "PRODUCT_COMPONENT_PK": "STRING",
                "PRODUCT_PK": "STRING",
                "COMPONENT_PK": "STRING",
                "LOAD_DATETIME": "DATETIME",
                "SOURCE": "STRING"
            }
        },
        "EFF_SAT_CUSTOMER_ORDER": {
            "column_types": {
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
        "EFF_SAT_ORDER_PRODUCT": {
            "column_types": {
                "ORDER_PRODUCT_PK": "STRING",
                "ORDER_PK": "STRING",
                "PRODUCT_PK": "STRING",
                "START_DATE": "DATETIME",
                "END_DATE": "DATETIME",
                "EFFECTIVE_FROM": "DATETIME",
                "LOAD_DATETIME": "DATETIME",
                "SOURCE": "STRING"
            }
        },
        "EFF_SAT_PRODUCT_COMPONENT": {
            "column_types": {
                "PRODUCT_COMPONENT_PK": "STRING",
                "PRODUCT_PK": "STRING",
                "COMPONENT_PK": "STRING",
                "START_DATE": "DATETIME",
                "END_DATE": "DATETIME",
                "EFFECTIVE_FROM": "DATETIME",
                "LOAD_DATETIME": "DATETIME",
                "SOURCE": "STRING"
            }
        },
        "AS_OF_DATE": {
            "column_types": {
                "AS_OF_DATE": "DATETIME"
            }
        },
        "BRIDGE_CUSTOMER_ORDER": {
            "column_types": {
                "CUSTOMER_PK": "STRING",
                "AS_OF_DATE": "DATETIME",
                "LINK_CUSTOMER_ORDER_PK": "STRING",
            }
        },
        "BRIDGE_CUSTOMER_ORDER_PRODUCT": {
            "column_types": {
                "CUSTOMER_PK": "STRING",
                "AS_OF_DATE": "DATETIME",
                "LINK_CUSTOMER_ORDER_PK": "STRING",
                "LINK_ORDER_PRODUCT_PK": "STRING",
            }
        },
        "BRIDGE_CUSTOMER_ORDER_PRODUCT_AC": {
            "column_types": {
                "CUSTOMER_PK": "STRING",
                "AS_OF_DATE": "DATETIME",
                "CUSTOMER_ID": "STRING",
                "LINK_CUSTOMER_ORDER_PK": "STRING",
                "LINK_ORDER_PRODUCT_PK": "STRING",
            }
        },
        "BRIDGE_CUSTOMER_ORDER_PRODUCT_COMPONENT": {
            "column_types": {
                "CUSTOMER_PK": "STRING",
                "AS_OF_DATE": "DATETIME",
                "LINK_CUSTOMER_ORDER_PK": "STRING",
                "LINK_ORDER_PRODUCT_PK": "STRING",
                "LINK_PRODUCT_COMPONENT_PK": "STRING",
            }
        },
        "BRIDGE_CUSTOMER_ORDER_PRODUCT_COMPONENT_AC": {
            "column_types": {
                "CUSTOMER_PK": "STRING",
                "CUSTOMER_ID": "STRING",
                "AS_OF_DATE": "DATETIME",
                "LINK_CUSTOMER_ORDER_PK": "STRING",
                "LINK_ORDER_PRODUCT_PK": "STRING",
                "LINK_PRODUCT_COMPONENT_PK": "STRING",
            }
        },
        "BRIDGE_CUSTOMER_ORDER_AC": {
            "column_types": {
                "CUSTOMER_PK": "STRING",
                "AS_OF_DATE": "DATETIME",
                "CUSTOMER_ID": "STRING",
                "LINK_CUSTOMER_ORDER_PK": "STRING",
            }
        },
        "BRIDGE_CUSTOMER_ORDER_M_AC": {
            "column_types": {
                "CUSTOMER_PK": "STRING",
                "AS_OF_DATE": "DATETIME",
                "CUSTOMER_ID": "STRING",
                "TEST_COLUMN": "STRING",
                "LINK_CUSTOMER_ORDER_PK": "STRING",
            }
        }
    }


@fixture
def bridge_sqlserver(context):
    """
    Define the structures and metadata to perform bridge load
    """

    set_metadata(context)

    context.seed_config = {
        "RAW_CUSTOMER_ORDER": {
            "column_types": {
                "CUSTOMER_ID": "VARCHAR(50)",
                "ORDER_ID": "VARCHAR(50)",
                "TEST_COLUMN": "VARCHAR(50)",
                "LOAD_DATETIME": "DATETIME2",
                "END_DATE": "DATETIME2",
                "SOURCE": "VARCHAR(50)"
            }
        },
        "RAW_ORDER_PRODUCT": {
            "column_types": {
                "ORDER_ID": "VARCHAR(50)",
                "PRODUCT_ID": "VARCHAR(50)",
                "LOAD_DATETIME": "DATETIME2",
                "END_DATE": "DATETIME2",
                "SOURCE": "VARCHAR(50)"
            }
        },
        "RAW_PRODUCT_COMPONENT": {
            "column_types": {
                "PRODUCT_ID": "VARCHAR(50)",
                "COMPONENT_ID": "VARCHAR(50)",
                "LOAD_DATETIME": "DATETIME2",
                "END_DATE": "DATETIME2",
                "SOURCE": "VARCHAR(50)"
            }
        },
        "HUB_CUSTOMER": {
            "column_types": {
                "CUSTOMER_PK": "BINARY(16)",
                "CUSTOMER_ID": "VARCHAR(50)",
                "LOAD_DATETIME": "DATETIME2",
                "SOURCE": "VARCHAR(50)"
            }
        },
        "HUB_CUSTOMER_M_AC": {
            "column_types": {
                "CUSTOMER_PK": "BINARY(16)",
                "CUSTOMER_ID": "VARCHAR(50)",
                "TEST_COLUMN": "VARCHAR(50)",
                "LOAD_DATETIME": "DATETIME2",
                "SOURCE": "VARCHAR(50)"
            }
        },
        "LINK_CUSTOMER_ORDER": {
            "column_types": {
                "CUSTOMER_ORDER_PK": "BINARY(16)",
                "CUSTOMER_PK": "BINARY(16)",
                "ORDER_PK": "BINARY(16)",
                "LOAD_DATETIME": "DATETIME2",
                "SOURCE": "VARCHAR(50)"
            }
        },
        "LINK_ORDER_PRODUCT": {
            "column_types": {
                "ORDER_PRODUCT_PK": "BINARY(16)",
                "ORDER_PK": "BINARY(16)",
                "PRODUCT_PK": "BINARY(16)",
                "LOAD_DATETIME": "DATETIME2",
                "SOURCE": "VARCHAR(50)"
            }
        },
        "LINK_PRODUCT_COMPONENT": {
            "column_types": {
                "PRODUCT_COMPONENT_PK": "BINARY(16)",
                "PRODUCT_PK": "BINARY(16)",
                "COMPONENT_PK": "BINARY(16)",
                "LOAD_DATETIME": "DATETIME2",
                "SOURCE": "VARCHAR(50)"
            }
        },
        "EFF_SAT_CUSTOMER_ORDER": {
            "column_types": {
                "CUSTOMER_ORDER_PK": "BINARY(16)",
                "CUSTOMER_PK": "BINARY(16)",
                "ORDER_PK": "BINARY(16)",
                "START_DATE": "DATETIME2",
                "END_DATE": "DATETIME2",
                "EFFECTIVE_FROM": "DATETIME2",
                "LOAD_DATETIME": "DATETIME2",
                "SOURCE": "VARCHAR(50)"
            }
        },
        "EFF_SAT_ORDER_PRODUCT": {
            "column_types": {
                "ORDER_PRODUCT_PK": "BINARY(16)",
                "ORDER_PK": "BINARY(16)",
                "PRODUCT_PK": "BINARY(16)",
                "START_DATE": "DATETIME2",
                "END_DATE": "DATETIME2",
                "EFFECTIVE_FROM": "DATETIME2",
                "LOAD_DATETIME": "DATETIME2",
                "SOURCE": "VARCHAR(50)"
            }
        },
        "EFF_SAT_PRODUCT_COMPONENT": {
            "column_types": {
                "PRODUCT_COMPONENT_PK": "BINARY(16)",
                "PRODUCT_PK": "BINARY(16)",
                "COMPONENT_PK": "BINARY(16)",
                "START_DATE": "DATETIME2",
                "END_DATE": "DATETIME2",
                "EFFECTIVE_FROM": "DATETIME2",
                "LOAD_DATETIME": "DATETIME2",
                "SOURCE": "VARCHAR(50)"
            }
        },
        "AS_OF_DATE": {
            "column_types": {
                "AS_OF_DATE": "DATETIME2"
            }
        },
        "BRIDGE_CUSTOMER_ORDER": {
            "column_types": {
                "CUSTOMER_PK": "BINARY(16)",
                "AS_OF_DATE": "DATETIME2",
                "LINK_CUSTOMER_ORDER_PK": "BINARY(16)",
            }
        },
        "BRIDGE_CUSTOMER_ORDER_PRODUCT": {
            "column_types": {
                "CUSTOMER_PK": "BINARY(16)",
                "AS_OF_DATE": "DATETIME2",
                "LINK_CUSTOMER_ORDER_PK": "BINARY(16)",
                "LINK_ORDER_PRODUCT_PK": "BINARY(16)",
            }
        },
        "BRIDGE_CUSTOMER_ORDER_PRODUCT_AC": {
            "column_types": {
                "CUSTOMER_PK": "BINARY(16)",
                "AS_OF_DATE": "DATETIME2",
                "CUSTOMER_ID": "VARCHAR(4)",
                "LINK_CUSTOMER_ORDER_PK": "BINARY(16)",
                "LINK_ORDER_PRODUCT_PK": "BINARY(16)",
            }
        },
        "BRIDGE_CUSTOMER_ORDER_PRODUCT_COMPONENT": {
            "column_types": {
                "CUSTOMER_PK": "BINARY(16)",
                "AS_OF_DATE": "DATETIME2",
                "LINK_CUSTOMER_ORDER_PK": "BINARY(16)",
                "LINK_ORDER_PRODUCT_PK": "BINARY(16)",
                "LINK_PRODUCT_COMPONENT_PK": "BINARY(16)",
            }
        },
        "BRIDGE_CUSTOMER_ORDER_PRODUCT_COMPONENT_AC": {
            "column_types": {
                "CUSTOMER_PK": "BINARY(16)",
                "CUSTOMER_ID": "VARCHAR(4)",
                "AS_OF_DATE": "DATETIME2",
                "LINK_CUSTOMER_ORDER_PK": "BINARY(16)",
                "LINK_ORDER_PRODUCT_PK": "BINARY(16)",
                "LINK_PRODUCT_COMPONENT_PK": "BINARY(16)",
            }
        },
        "BRIDGE_CUSTOMER_ORDER_AC": {
            "column_types": {
                "CUSTOMER_PK": "BINARY(16)",
                "AS_OF_DATE": "DATETIME2",
                "CUSTOMER_ID": "VARCHAR(4)",
                "LINK_CUSTOMER_ORDER_PK": "BINARY(16)",
            }
        },
        "BRIDGE_CUSTOMER_ORDER_M_AC": {
            "column_types": {
                "CUSTOMER_PK": "BINARY(16)",
                "AS_OF_DATE": "DATETIME2",
                "CUSTOMER_ID": "VARCHAR(4)",
                "TEST_COLUMN": "VARCHAR(50)",
                "LINK_CUSTOMER_ORDER_PK": "BINARY(16)",
            }
        }
    }
