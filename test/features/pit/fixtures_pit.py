from behave import fixture


def set_vault_structure_definition(context):
    context.vault_structure_type = "pit"

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
        "HUB_CUSTOMER_TS": {
            "source_model": ["STG_CUSTOMER_DETAILS_TS",
                             "STG_CUSTOMER_LOGIN_TS"],
            "src_pk": "CUSTOMER_PK",
            "src_nk": "CUSTOMER_ID",
            "src_ldts": "LOAD_DATETIME",
            "src_source": "SOURCE"
        },
        "HUB_CUSTOMER_2S": {
            "source_model": ["STG_CUSTOMER_DETAILS",
                             "STG_CUSTOMER_LOGIN"],
            "src_pk": "CUSTOMER_PK",
            "src_nk": "CUSTOMER_ID",
            "src_ldts": "LOAD_DATE",
            "src_source": "SOURCE"
        },
        "HUB_CUSTOMER_1S": {
            "source_model": "STG_CUSTOMER_DETAILS",
            "src_pk": "CUSTOMER_PK",
            "src_nk": "CUSTOMER_ID",
            "src_ldts": "LOAD_DATE",
            "src_source": "SOURCE"
        },
        "HUB_CUSTOMER_1S_TS": {
            "source_model": "STG_CUSTOMER_DETAILS_TS",
            "src_pk": "CUSTOMER_PK",
            "src_nk": "CUSTOMER_ID",
            "src_ldts": "LOAD_DATETIME",
            "src_source": "SOURCE"
        },
        "HUB_CUSTOMER_AC": {
            "source_model": ["STG_CUSTOMER_DETAILS",
                             "STG_CUSTOMER_LOGIN",
                             "STG_CUSTOMER_PROFILE"],
            "src_pk": "CUSTOMER_PK",
            "src_nk": ["CUSTOMER_ID", "DASHBOARD_COLOUR"],
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
            "src_payload": ["LAST_LOGIN_DATE", "DEVICE_USED"],
            "src_eff": "EFFECTIVE_FROM",
            "src_ldts": "LOAD_DATE",
            "src_source": "SOURCE"
        },
        "SAT_CUSTOMER_LOGIN_TS": {
            "source_model": "STG_CUSTOMER_LOGIN_TS",
            "src_pk": "CUSTOMER_PK",
            "src_hashdiff": "HASHDIFF",
            "src_payload": ["LAST_LOGIN_DATE", "DEVICE_USED"],
            "src_eff": "EFFECTIVE_FROM",
            "src_ldts": "LOAD_DATETIME",
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
            "stage_tables_ldts":
                {
                    "STG_CUSTOMER_DETAILS": "LOAD_DATE",
                    "STG_CUSTOMER_LOGIN": "LOAD_DATE",
                    "STG_CUSTOMER_PROFILE": "LOAD_DATE"
                },
            "src_ldts": "LOAD_DATE"
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
            "stage_tables_ldts":
                {
                    "STG_CUSTOMER_DETAILS_TS": "LOAD_DATETIME",
                    "STG_CUSTOMER_LOGIN_TS": "LOAD_DATETIME"
                },
            "src_ldts": "LOAD_DATETIME"
        },
        "PIT_CUSTOMER_HG": {
            "source_model": "HUB_CUSTOMER_2S",
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
            "stage_tables_ldts":
                {
                    "STG_CUSTOMER_DETAILS": "LOAD_DATE",
                    "STG_CUSTOMER_LOGIN": "LOAD_DATE"
                },
            "src_ldts": "LOAD_DATE"
        },
        "PIT_CUSTOMER_2S": {
            "source_model": "HUB_CUSTOMER_2S",
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
                },
            "stage_tables_ldts":
                {
                    "STG_CUSTOMER_DETAILS": "LOAD_DATE",
                    "STG_CUSTOMER_LOGIN": "LOAD_DATE",
                },
            "src_ldts": "LOAD_DATE"
        },
        "PIT_CUSTOMER_1S": {
            "source_model": "HUB_CUSTOMER_1S",
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
            "stage_tables_ldts":
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
                    },
                    "SAT_CUSTOMER_LOGIN_TS": {
                        "pk":
                            {"PK": "CUSTOMER_PK"},
                        "ldts":
                            {"LDTS": "LOAD_DATETIME"}
                    }
                },
            "stage_tables_ldts":
                {
                    "SAT_CUSTOMER_DETAILS_TS": "LOAD_DATETIME",
                    "STG_CUSTOMER_LOGIN_TS": "LOAD_DATETIME",
                },
            "src_ldts": "LOAD_DATETIME"
        },
        "PIT_CUSTOMER_1S_TS": {
            "source_model": "HUB_CUSTOMER_1S_TS",
            "src_pk": "CUSTOMER_PK",
            "as_of_dates_table": "AS_OF_DATE",
            "satellites": {
                "SAT_CUSTOMER_DETAILS_TS": {
                    "pk":
                        {"PK": "CUSTOMER_PK"},
                    "ldts":
                        {"LDTS": "LOAD_DATETIME"}
                }
            },
            "stage_tables_ldts": {
                "SAT_CUSTOMER_DETAILS_TS": "LOAD_DATETIME",
            },
            "src_ldts": "LOAD_DATETIME"
        },
        "PIT_CUSTOMER_AC": {
            "source_model": "HUB_CUSTOMER",
            "src_pk": "CUSTOMER_PK",
            "src_extra_columns": "CUSTOMER_ID",
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
            "stage_tables_ldts":
                {
                    "STG_CUSTOMER_DETAILS": "LOAD_DATE",
                    "STG_CUSTOMER_LOGIN": "LOAD_DATE",
                    "STG_CUSTOMER_PROFILE": "LOAD_DATE"
                },
            "src_ldts": "LOAD_DATE"
        },
        "PIT_CUSTOMER_M_AC": {
            "source_model": "HUB_CUSTOMER_AC",
            "src_pk": "CUSTOMER_PK",
            "src_extra_columns": ["CUSTOMER_ID", "DASHBOARD_COLOUR"],
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
            "stage_tables_ldts":
                {
                    "STG_CUSTOMER_DETAILS": "LOAD_DATE",
                    "STG_CUSTOMER_LOGIN": "LOAD_DATE",
                    "STG_CUSTOMER_PROFILE": "LOAD_DATE"
                },
            "src_ldts": "LOAD_DATE"
        }
    }


def set_staging_definition(context):
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
        },
        "STG_CUSTOMER_DETAILS_TS": {
            "CUSTOMER_PK": "CUSTOMER_ID",
            "HASHDIFF": {"is_hashdiff": True,
                         "columns": ["CUSTOMER_ADDRESS", "CUSTOMER_DOB", "CUSTOMER_NAME"]
                         }
        },
        "STG_CUSTOMER_LOGIN_TS": {
            "CUSTOMER_PK": "CUSTOMER_ID",
            "HASHDIFF": {"is_hashdiff": True,
                         "columns": ["DEVICE_USED", "LAST_LOGIN_DATE"]
                         }
        },
        "STG_CUSTOMER_PROFILE_TS": {
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
        },
        "STG_CUSTOMER_DETAILS_TS": {
            "EFFECTIVE_FROM": "LOAD_DATETIME"
        },
        "STG_CUSTOMER_LOGIN_TS": {
            "EFFECTIVE_FROM": "LOAD_DATETIME"
        },
        "STG_CUSTOMER_PROFILE_TS": {
            "EFFECTIVE_FROM": "LOAD_DATETIME"
        }
    }


def set_metadata(context):
    set_vault_structure_definition(context)

    set_staging_definition(context)


# Snowflake


@fixture
def pit_snowflake(context):
    """
    Define the structures and metadata to perform PIT load
    """

    set_metadata(context)

    context.stage_columns = {
        "RAW_STAGE_DETAILS":
            ["CUSTOMER_ID",
             "CUSTOMER_NAME",
             "CUSTOMER_ADDRESS",
             "CUSTOMER_DOB",
             "LOAD_DATE",
             "SOURCE"],
        "RAW_STAGE_LOGIN":
            ["CUSTOMER_ID",
             "LAST_LOGIN_DATE",
             "DEVICE_USED",
             "LOAD_DATE",
             "SOURCE"],
        "RAW_STAGE_PROFILE":
            ["CUSTOMER_ID",
             "DASHBOARD_COLOUR",
             "DISPLAY_NAME",
             "LOAD_DATE",
             "SOURCE"]
    }

    context.seed_config = {
        "RAW_STAGE_DETAILS": {
            "column_types": {
                "CUSTOMER_ID": "VARCHAR",
                "DASHBOARD_COLOUR": "VARCHAR",
                "CUSTOMER_NAME": "VARCHAR",
                "CUSTOMER_ADDRESS": "VARCHAR",
                "CUSTOMER_DOB": "DATE",
                "LOAD_DATE": "DATETIME",
                "SOURCE": "VARCHAR"
            }
        },
        "RAW_STAGE_LOGIN": {
            "column_types": {
                "CUSTOMER_ID": "VARCHAR",
                "DASHBOARD_COLOUR": "VARCHAR",
                "LAST_LOGIN_DATE": "DATETIME",
                "DEVICE_USED": "VARCHAR",
                "LOAD_DATE": "DATETIME",
                "SOURCE": "VARCHAR"
            }
        },
        "RAW_STAGE_PROFILE": {
            "column_types": {
                "CUSTOMER_ID": "VARCHAR",
                "DASHBOARD_COLOUR": "VARCHAR",
                "DISPLAY_NAME": "VARCHAR",
                "LOAD_DATE": "DATETIME",
                "SOURCE": "VARCHAR"
            }
        },
        "HUB_CUSTOMER": {
            "column_types": {
                "CUSTOMER_PK": "BINARY(16)",
                "CUSTOMER_ID": "VARCHAR",
                "LOAD_DATE": "DATETIME",
                "SOURCE": "VARCHAR"
            }
        },
        "HUB_CUSTOMER_AC": {
            "column_types": {
                "CUSTOMER_PK": "BINARY(16)",
                "CUSTOMER_ID": "VARCHAR",
                "DASHBOARD_COLOUR": "VARCHAR",
                "LOAD_DATE": "DATETIME",
                "SOURCE": "VARCHAR"
            }
        },
        "SAT_CUSTOMER_DETAILS": {
            "column_types": {
                "CUSTOMER_PK": "BINARY(16)",
                "HASHDIFF": "BINARY(16)",
                "CUSTOMER_NAME": "VARCHAR",
                "CUSTOMER_ADDRESS": "VARCHAR",
                "CUSTOMER_DOB": "DATE",
                "EFFECTIVE_FROM": "DATETIME",
                "LOAD_DATE": "DATETIME",
                "SOURCE": "VARCHAR"
            }
        },
        "SAT_CUSTOMER_LOGIN": {
            "column_types": {
                "CUSTOMER_PK": "BINARY(16)",
                "HASHDIFF": "BINARY(16)",
                "DEVICE_USED": "VARCHAR",
                "LAST_LOGIN_DATE": "DATETIME",
                "EFFECTIVE_FROM": "DATETIME",
                "LOAD_DATE": "DATETIME",
                "SOURCE": "VARCHAR"
            }
        },
        "SAT_CUSTOMER_PROFILE": {
            "column_types": {
                "CUSTOMER_PK": "BINARY(16)",
                "HASHDIFF": "BINARY(16)",
                "DASHBOARD_COLOUR": "VARCHAR",
                "DISPLAY_NAME": "VARCHAR",
                "EFFECTIVE_FROM": "DATETIME",
                "LOAD_DATE": "DATETIME",
                "SOURCE": "VARCHAR"
            }
        },
        "AS_OF_DATE": {
            "column_types": {
                "AS_OF_DATE": "DATETIME"
            }
        },
        "PIT_CUSTOMER": {
            "column_types": {
                "AS_OF_DATE": "DATETIME",
                "CUSTOMER_PK": "BINARY(16)",
                "SAT_CUSTOMER_DETAILS_PK": "BINARY(16)",
                "SAT_CUSTOMER_DETAILS_LDTS": "DATETIME",
                "SAT_CUSTOMER_LOGIN_PK": "BINARY(16)",
                "SAT_CUSTOMER_LOGIN_LDTS": "DATETIME",
                "SAT_CUSTOMER_PROFILE_PK": "BINARY(16)",
                "SAT_CUSTOMER_PROFILE_LDTS": "DATETIME"
            }
        },
        "PIT_CUSTOMER_AC": {
            "column_types": {
                "AS_OF_DATE": "DATETIME",
                "CUSTOMER_PK": "BINARY(16)",
                "CUSTOMER_ID": "VARCHAR",
                "SAT_CUSTOMER_DETAILS_PK": "BINARY(16)",
                "SAT_CUSTOMER_DETAILS_LDTS": "DATETIME",
                "SAT_CUSTOMER_LOGIN_PK": "BINARY(16)",
                "SAT_CUSTOMER_LOGIN_LDTS": "DATETIME",
                "SAT_CUSTOMER_PROFILE_PK": "BINARY(16)",
                "SAT_CUSTOMER_PROFILE_LDTS": "DATETIME"
            }
        },
        "PIT_CUSTOMER_M_AC": {
            "column_types": {
                "AS_OF_DATE": "DATETIME",
                "CUSTOMER_PK": "BINARY(16)",
                "CUSTOMER_ID": "VARCHAR",
                "DASHBOARD_COLOUR": "VARCHAR",
                "SAT_CUSTOMER_DETAILS_PK": "BINARY(16)",
                "SAT_CUSTOMER_DETAILS_LDTS": "DATETIME",
                "SAT_CUSTOMER_LOGIN_PK": "BINARY(16)",
                "SAT_CUSTOMER_LOGIN_LDTS": "DATETIME",
                "SAT_CUSTOMER_PROFILE_PK": "BINARY(16)",
                "SAT_CUSTOMER_PROFILE_LDTS": "DATETIME"
            }
        }
    }


@fixture
def pit_one_sat_snowflake(context):
    """
    Define the structures and metadata to perform PIT load
    """

    set_metadata(context)

    context.seed_config = {
        "RAW_STAGE_DETAILS": {
            "column_types": {
                "CUSTOMER_ID": "VARCHAR",
                "CUSTOMER_NAME": "VARCHAR",
                "CUSTOMER_ADDRESS": "VARCHAR",
                "CUSTOMER_DOB": "DATE",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR"
            }
        },
        "RAW_STAGE_DETAILS_TS": {
            "column_types": {
                "CUSTOMER_ID": "VARCHAR",
                "CUSTOMER_NAME": "VARCHAR",
                "CUSTOMER_ADDRESS": "VARCHAR",
                "CUSTOMER_DOB": "DATE",
                "LOAD_DATETIME": "DATETIME",
                "SOURCE": "VARCHAR"
            }
        },
        "HUB_CUSTOMER": {
            "column_types": {
                "CUSTOMER_PK": "BINARY(16)",
                "CUSTOMER_ID": "VARCHAR",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR"
            }
        },
        "HUB_CUSTOMER_1S": {
            "column_types": {
                "CUSTOMER_PK": "BINARY(16)",
                "CUSTOMER_ID": "VARCHAR",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR"
            }
        },
        "HUB_CUSTOMER_1S_TS": {
            "column_types": {
                "CUSTOMER_PK": "BINARY(16)",
                "CUSTOMER_ID": "VARCHAR",
                "LOAD_DATETIME": "DATETIME",
                "SOURCE": "VARCHAR"
            }
        },
        "HUB_CUSTOMER_TS": {
            "column_types": {
                "CUSTOMER_PK": "BINARY(16)",
                "CUSTOMER_ID": "VARCHAR",
                "LOAD_DATETIME": "DATETIME",
                "SOURCE": "VARCHAR"
            }
        },
        "SAT_CUSTOMER_DETAILS": {
            "column_types": {
                "CUSTOMER_PK": "BINARY(16)",
                "HASHDIFF": "BINARY(16)",
                "CUSTOMER_NAME": "VARCHAR",
                "CUSTOMER_ADDRESS": "VARCHAR",
                "CUSTOMER_DOB": "DATE",
                "EFFECTIVE_FROM": "DATE",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR"
            }
        },
        "SAT_CUSTOMER_DETAILS_TS": {
            "column_types": {
                "CUSTOMER_PK": "BINARY(16)",
                "HASHDIFF": "BINARY(16)",
                "CUSTOMER_NAME": "VARCHAR",
                "CUSTOMER_ADDRESS": "VARCHAR",
                "CUSTOMER_DOB": "DATE",
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
        "PIT_CUSTOMER": {
            "column_types": {
                "AS_OF_DATE": "DATETIME",
                "CUSTOMER_PK": "BINARY(16)",
                "SAT_CUSTOMER_DETAILS_PK": "BINARY(16)",
                "SAT_CUSTOMER_DETAILS_LDTS": "DATETIME"
            }
        },
        "PIT_CUSTOMER_1S": {
            "column_types": {
                "CUSTOMER_PK": "BINARY(16)",
                "AS_OF_DATE": "DATETIME",
                "SAT_CUSTOMER_DETAILS_PK": "BINARY(16)",
                "SAT_CUSTOMER_DETAILS_LDTS": "DATETIME"
            }
        },
        "PIT_CUSTOMER_1S_TS": {
            "column_types": {
                "CUSTOMER_PK": "BINARY(16)",
                "AS_OF_DATE": "DATETIME",
                "SAT_CUSTOMER_DETAILS_TS_PK": "BINARY(16)",
                "SAT_CUSTOMER_DETAILS_TS_LDTS": "DATETIME"
            }
        },
        "PIT_CUSTOMER_TS": {
            "column_types": {
                "AS_OF_DATE": "DATETIME",
                "CUSTOMER_PK": "BINARY(16)",
                "SAT_CUSTOMER_DETAILS_TS_PK": "BINARY(16)",
                "SAT_CUSTOMER_DETAILS_TS_LDTS": "DATETIME"
            }
        },
        "PIT_CUSTOMER_LG": {
            "column_types": {
                "AS_OF_DATE": "DATETIME",
                "CUSTOMER_PK": "BINARY(16)",
                "SAT_CUSTOMER_DETAILS_TS_PK": "BINARY(16)",
                "SAT_CUSTOMER_DETAILS_TS_LDTS": "DATETIME"
            }
        },
        "PIT_CUSTOMER_HG": {
            "column_types": {
                "AS_OF_DATE": "DATETIME",
                "CUSTOMER_PK": "BINARY(16)",
                "SAT_CUSTOMER_DETAILS_PK": "BINARY(16)",
                "SAT_CUSTOMER_DETAILS_LDTS": "DATETIME"
            }
        }
    }


@fixture
def pit_two_sats_snowflake(context):
    """
    Define the structures and metadata to perform PIT load
    """

    set_metadata(context)

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
            "column_types": {
                "CUSTOMER_ID": "VARCHAR",
                "CUSTOMER_NAME": "VARCHAR",
                "CUSTOMER_ADDRESS": "VARCHAR",
                "CUSTOMER_DOB": "DATE",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR"
            }
        },
        "RAW_STAGE_DETAILS_TS": {
            "column_types": {
                "CUSTOMER_ID": "VARCHAR",
                "CUSTOMER_NAME": "VARCHAR",
                "CUSTOMER_ADDRESS": "VARCHAR",
                "CUSTOMER_DOB": "DATE",
                "LOAD_DATETIME": "DATETIME",
                "SOURCE": "VARCHAR"
            }
        },
        "RAW_STAGE_LOGIN": {
            "column_types": {
                "CUSTOMER_ID": "VARCHAR",
                "LAST_LOGIN_DATE": "DATETIME",
                "DEVICE_USED": "VARCHAR",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR"
            }
        },
        "RAW_STAGE_LOGIN_TS": {
            "column_types": {
                "CUSTOMER_ID": "VARCHAR",
                "LAST_LOGIN_DATE": "DATETIME",
                "DEVICE_USED": "VARCHAR",
                "LOAD_DATETIME": "DATETIME",
                "SOURCE": "VARCHAR"
            }
        },
        "HUB_CUSTOMER": {
            "column_types": {
                "CUSTOMER_PK": "BINARY(16)",
                "CUSTOMER_ID": "VARCHAR",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR"
            }
        },
        "HUB_CUSTOMER_2S": {
            "column_types": {
                "CUSTOMER_PK": "BINARY(16)",
                "CUSTOMER_ID": "VARCHAR",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR"
            }
        },
        "HUB_CUSTOMER_TS": {
            "column_types": {
                "CUSTOMER_PK": "BINARY(16)",
                "CUSTOMER_ID": "VARCHAR",
                "LOAD_DATETIME": "DATETIME",
                "SOURCE": "VARCHAR"
            }
        },
        "SAT_CUSTOMER_DETAILS": {
            "column_types": {
                "CUSTOMER_PK": "BINARY(16)",
                "HASHDIFF": "BINARY(16)",
                "CUSTOMER_NAME": "VARCHAR",
                "CUSTOMER_ADDRESS": "VARCHAR",
                "CUSTOMER_DOB": "DATE",
                "EFFECTIVE_FROM": "DATE",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR"
            }
        },
        "SAT_CUSTOMER_DETAILS_TS": {
            "column_types": {
                "CUSTOMER_PK": "BINARY(16)",
                "HASHDIFF": "BINARY(16)",
                "CUSTOMER_NAME": "VARCHAR",
                "CUSTOMER_ADDRESS": "VARCHAR",
                "CUSTOMER_DOB": "DATE",
                "EFFECTIVE_FROM": "DATETIME",
                "LOAD_DATETIME": "DATETIME",
                "SOURCE": "VARCHAR"
            }
        },
        "SAT_CUSTOMER_LOGIN": {
            "column_types": {
                "CUSTOMER_PK": "BINARY(16)",
                "HASHDIFF": "BINARY(16)",
                "DEVICE_USED": "VARCHAR",
                "LAST_LOGIN_DATE": "DATETIME",
                "EFFECTIVE_FROM": "DATE",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR"
            }
        },
        "SAT_CUSTOMER_LOGIN_TS": {
            "column_types": {
                "CUSTOMER_PK": "BINARY(16)",
                "HASHDIFF": "BINARY(16)",
                "DEVICE_USED": "VARCHAR",
                "LAST_LOGIN_DATE": "DATETIME",
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
        "PIT_CUSTOMER": {
            "column_types": {
                "AS_OF_DATE": "DATETIME",
                "CUSTOMER_PK": "BINARY(16)",
                "SAT_CUSTOMER_DETAILS_PK": "BINARY(16)",
                "SAT_CUSTOMER_DETAILS_LDTS": "DATETIME",
                "SAT_CUSTOMER_LOGIN_PK": "BINARY(16)",
                "SAT_CUSTOMER_LOGIN_LDTS": "DATETIME"
            }
        },
        "PIT_CUSTOMER_2S": {
            "column_types": {
                "AS_OF_DATE": "DATETIME",
                "CUSTOMER_PK": "BINARY(16)",
                "SAT_CUSTOMER_DETAILS_PK": "BINARY(16)",
                "SAT_CUSTOMER_DETAILS_LDTS": "DATETIME",
                "SAT_CUSTOMER_LOGIN_PK": "BINARY(16)",
                "SAT_CUSTOMER_LOGIN_LDTS": "DATETIME"
            }
        },
        "PIT_CUSTOMER_TS": {
            "column_types": {
                "AS_OF_DATE": "DATETIME",
                "CUSTOMER_PK": "BINARY(16)",
                "SAT_CUSTOMER_DETAILS_TS_PK": "BINARY(16)",
                "SAT_CUSTOMER_DETAILS_TS_LDTS": "DATETIME",
                "SAT_CUSTOMER_LOGIN_TS_PK": "BINARY(16)",
                "SAT_CUSTOMER_LOGIN_TS_LDTS": "DATETIME"
            }
        },
        "PIT_CUSTOMER_LG": {
            "column_types": {
                "AS_OF_DATE": "DATETIME",
                "CUSTOMER_PK": "BINARY(16)",
                "SAT_CUSTOMER_DETAILS_TS_PK": "BINARY(16)",
                "SAT_CUSTOMER_DETAILS_TS_LDTS": "DATETIME",
                "SAT_CUSTOMER_LOGIN_TS_PK": "BINARY(16)",
                "SAT_CUSTOMER_LOGIN_TS_LDTS": "DATETIME"
            }
        },
        "PIT_CUSTOMER_HG": {
            "column_types": {
                "AS_OF_DATE": "DATETIME",
                "CUSTOMER_PK": "BINARY(16)",
                "SAT_CUSTOMER_DETAILS_PK": "BINARY(16)",
                "SAT_CUSTOMER_DETAILS_LDTS": "DATETIME",
                "SAT_CUSTOMER_LOGIN_PK": "BINARY(16)",
                "SAT_CUSTOMER_LOGIN_LDTS": "DATETIME"
            }
        }
    }


# BigQuery


@fixture
def pit_bigquery(context):
    """
    Define the structures and metadata to perform PIT load
    """

    set_metadata(context)

    context.stage_columns = {
        "RAW_STAGE_DETAILS":
            ["CUSTOMER_ID",
             "CUSTOMER_NAME",
             "CUSTOMER_ADDRESS",
             "CUSTOMER_DOB",
             "LOAD_DATE",
             "SOURCE"],
        "RAW_STAGE_LOGIN":
            ["CUSTOMER_ID",
             "LAST_LOGIN_DATE",
             "DEVICE_USED",
             "LOAD_DATE",
             "SOURCE"],
        "RAW_STAGE_PROFILE":
            ["CUSTOMER_ID",
             "DASHBOARD_COLOUR",
             "DISPLAY_NAME",
             "LOAD_DATE",
             "SOURCE"]
    }

    context.seed_config = {
        "RAW_STAGE_DETAILS": {
            "column_types": {
                "CUSTOMER_ID": "STRING",
                "DASHBOARD_COLOUR": "STRING",
                "CUSTOMER_NAME": "STRING",
                "CUSTOMER_ADDRESS": "STRING",
                "CUSTOMER_DOB": "DATE",
                "LOAD_DATE": "DATETIME",
                "SOURCE": "STRING"
            }
        },
        "RAW_STAGE_LOGIN": {
            "column_types": {
                "CUSTOMER_ID": "STRING",
                "DASHBOARD_COLOUR": "STRING",
                "LAST_LOGIN_DATE": "DATETIME",
                "DEVICE_USED": "STRING",
                "LOAD_DATE": "DATETIME",
                "SOURCE": "STRING"
            }
        },
        "RAW_STAGE_PROFILE": {
            "column_types": {
                "CUSTOMER_ID": "STRING",
                "DASHBOARD_COLOUR": "STRING",
                "DISPLAY_NAME": "STRING",
                "LOAD_DATE": "DATETIME",
                "SOURCE": "STRING"
            }
        },
        "HUB_CUSTOMER": {
            "column_types": {
                "CUSTOMER_PK": "STRING",
                "CUSTOMER_ID": "STRING",
                "LOAD_DATE": "DATETIME",
                "SOURCE": "STRING"
            }
        },
        "HUB_CUSTOMER_AC": {
            "column_types": {
                "CUSTOMER_PK": "STRING",
                "CUSTOMER_ID": "STRING",
                "DASHBOARD_COLOUR": "STRING",
                "LOAD_DATE": "DATETIME",
                "SOURCE": "STRING"
            }
        },
        "SAT_CUSTOMER_DETAILS": {
            "column_types": {
                "CUSTOMER_PK": "STRING",
                "HASHDIFF": "STRING",
                "CUSTOMER_NAME": "STRING",
                "CUSTOMER_ADDRESS": "STRING",
                "CUSTOMER_DOB": "DATE",
                "EFFECTIVE_FROM": "DATETIME",
                "LOAD_DATE": "DATETIME",
                "SOURCE": "STRING"
            }
        },
        "SAT_CUSTOMER_LOGIN": {
            "column_types": {
                "CUSTOMER_PK": "STRING",
                "HASHDIFF": "STRING",
                "DEVICE_USED": "STRING",
                "LAST_LOGIN_DATE": "DATETIME",
                "EFFECTIVE_FROM": "DATETIME",
                "LOAD_DATE": "DATETIME",
                "SOURCE": "STRING"
            }
        },
        "SAT_CUSTOMER_PROFILE": {
            "column_types": {
                "CUSTOMER_PK": "STRING",
                "HASHDIFF": "STRING",
                "DASHBOARD_COLOUR": "STRING",
                "DISPLAY_NAME": "STRING",
                "EFFECTIVE_FROM": "DATETIME",
                "LOAD_DATE": "DATETIME",
                "SOURCE": "STRING"
            }
        },
        "AS_OF_DATE": {
            "column_types": {
                "AS_OF_DATE": "DATETIME"
            }
        },
        "PIT_CUSTOMER": {
            "column_types": {
                "AS_OF_DATE": "DATETIME",
                "CUSTOMER_PK": "STRING",
                "SAT_CUSTOMER_DETAILS_PK": "STRING",
                "SAT_CUSTOMER_DETAILS_LDTS": "DATETIME",
                "SAT_CUSTOMER_LOGIN_PK": "STRING",
                "SAT_CUSTOMER_LOGIN_LDTS": "DATETIME",
                "SAT_CUSTOMER_PROFILE_PK": "STRING",
                "SAT_CUSTOMER_PROFILE_LDTS": "DATETIME"
            }
        },
        "PIT_CUSTOMER_AC": {
            "column_types": {
                "AS_OF_DATE": "DATETIME",
                "CUSTOMER_PK": "STRING",
                "CUSTOMER_ID": "STRING",
                "SAT_CUSTOMER_DETAILS_PK": "STRING",
                "SAT_CUSTOMER_DETAILS_LDTS": "DATETIME",
                "SAT_CUSTOMER_LOGIN_PK": "STRING",
                "SAT_CUSTOMER_LOGIN_LDTS": "DATETIME",
                "SAT_CUSTOMER_PROFILE_PK": "STRING",
                "SAT_CUSTOMER_PROFILE_LDTS": "DATETIME"
            }
        },
        "PIT_CUSTOMER_M_AC": {
            "column_types": {
                "AS_OF_DATE": "DATETIME",
                "CUSTOMER_PK": "STRING",
                "CUSTOMER_ID": "STRING",
                "DASHBOARD_COLOUR": "STRING",
                "SAT_CUSTOMER_DETAILS_PK": "STRING",
                "SAT_CUSTOMER_DETAILS_LDTS": "DATETIME",
                "SAT_CUSTOMER_LOGIN_PK": "STRING",
                "SAT_CUSTOMER_LOGIN_LDTS": "DATETIME",
                "SAT_CUSTOMER_PROFILE_PK": "STRING",
                "SAT_CUSTOMER_PROFILE_LDTS": "DATETIME"
            }
        }
    }


@fixture
def pit_one_sat_bigquery(context):
    """
    Define the structures and metadata to perform PIT load
    """

    set_metadata(context)

    context.seed_config = {
        "RAW_STAGE_DETAILS": {
            "column_types": {
                "CUSTOMER_ID": "STRING",
                "CUSTOMER_NAME": "STRING",
                "CUSTOMER_ADDRESS": "STRING",
                "CUSTOMER_DOB": "DATE",
                "LOAD_DATE": "DATE",
                "SOURCE": "STRING"
            }
        },
        "RAW_STAGE_DETAILS_TS": {
            "column_types": {
                "CUSTOMER_ID": "STRING",
                "CUSTOMER_NAME": "STRING",
                "CUSTOMER_ADDRESS": "STRING",
                "CUSTOMER_DOB": "DATE",
                "LOAD_DATETIME": "DATETIME",
                "SOURCE": "STRING"
            }
        },
        "HUB_CUSTOMER": {
            "column_types": {
                "CUSTOMER_PK": "STRING",
                "CUSTOMER_ID": "STRING",
                "LOAD_DATE": "DATE",
                "SOURCE": "STRING"
            }
        },
        "HUB_CUSTOMER_1S": {
            "column_types": {
                "CUSTOMER_PK": "STRING",
                "CUSTOMER_ID": "STRING",
                "LOAD_DATE": "DATE",
                "SOURCE": "STRING"
            }
        },
        "HUB_CUSTOMER_1S_TS": {
            "column_types": {
                "CUSTOMER_PK": "STRING",
                "CUSTOMER_ID": "STRING",
                "LOAD_DATETIME": "DATETIME",
                "SOURCE": "STRING"
            }
        },
        "HUB_CUSTOMER_TS": {
            "column_types": {
                "CUSTOMER_PK": "STRING",
                "CUSTOMER_ID": "STRING",
                "LOAD_DATETIME": "DATETIME",
                "SOURCE": "STRING"
            }
        },
        "SAT_CUSTOMER_DETAILS": {
            "column_types": {
                "CUSTOMER_PK": "STRING",
                "HASHDIFF": "STRING",
                "CUSTOMER_NAME": "STRING",
                "CUSTOMER_ADDRESS": "STRING",
                "CUSTOMER_DOB": "DATE",
                "EFFECTIVE_FROM": "DATE",
                "LOAD_DATE": "DATE",
                "SOURCE": "STRING"
            }
        },
        "SAT_CUSTOMER_DETAILS_TS": {
            "column_types": {
                "CUSTOMER_PK": "STRING",
                "HASHDIFF": "STRING",
                "CUSTOMER_NAME": "STRING",
                "CUSTOMER_ADDRESS": "STRING",
                "CUSTOMER_DOB": "DATE",
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
        "PIT_CUSTOMER": {
            "column_types": {
                "AS_OF_DATE": "DATETIME",
                "CUSTOMER_PK": "STRING",
                "SAT_CUSTOMER_DETAILS_PK": "STRING",
                "SAT_CUSTOMER_DETAILS_LDTS": "DATETIME"
            }
        },
        "PIT_CUSTOMER_1S": {
            "column_types": {
                "CUSTOMER_PK": "STRING",
                "AS_OF_DATE": "DATETIME",
                "SAT_CUSTOMER_DETAILS_PK": "STRING",
                "SAT_CUSTOMER_DETAILS_LDTS": "DATETIME"
            }
        },
        "PIT_CUSTOMER_1S_TS": {
            "column_types": {
                "CUSTOMER_PK": "STRING",
                "AS_OF_DATE": "DATETIME",
                "SAT_CUSTOMER_DETAILS_TS_PK": "STRING",
                "SAT_CUSTOMER_DETAILS_TS_LDTS": "DATETIME"
            }
        },
        "PIT_CUSTOMER_TS": {
            "column_types": {
                "AS_OF_DATE": "DATETIME",
                "CUSTOMER_PK": "STRING",
                "SAT_CUSTOMER_DETAILS_TS_PK": "STRING",
                "SAT_CUSTOMER_DETAILS_TS_LDTS": "DATETIME"
            }
        },
        "PIT_CUSTOMER_LG": {
            "column_types": {
                "AS_OF_DATE": "DATETIME",
                "CUSTOMER_PK": "STRING",
                "SAT_CUSTOMER_DETAILS_TS_PK": "STRING",
                "SAT_CUSTOMER_DETAILS_TS_LDTS": "DATETIME"
            }
        },
        "PIT_CUSTOMER_HG": {
            "column_types": {
                "AS_OF_DATE": "DATETIME",
                "CUSTOMER_PK": "STRING",
                "SAT_CUSTOMER_DETAILS_PK": "STRING",
                "SAT_CUSTOMER_DETAILS_LDTS": "DATETIME"
            }
        }
    }


@fixture
def pit_two_sats_bigquery(context):
    """
    Define the structures and metadata to perform PIT load
    """

    set_metadata(context)

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
            "column_types": {
                "CUSTOMER_ID": "STRING",
                "CUSTOMER_NAME": "STRING",
                "CUSTOMER_ADDRESS": "STRING",
                "CUSTOMER_DOB": "DATE",
                "LOAD_DATE": "DATE",
                "SOURCE": "STRING"
            }
        },
        "RAW_STAGE_DETAILS_TS": {
            "column_types": {
                "CUSTOMER_ID": "STRING",
                "CUSTOMER_NAME": "STRING",
                "CUSTOMER_ADDRESS": "STRING",
                "CUSTOMER_DOB": "DATE",
                "LOAD_DATETIME": "DATETIME",
                "SOURCE": "STRING"
            }
        },
        "RAW_STAGE_LOGIN": {
            "column_types": {
                "CUSTOMER_ID": "STRING",
                "LAST_LOGIN_DATE": "DATETIME",
                "DEVICE_USED": "STRING",
                "LOAD_DATE": "DATE",
                "SOURCE": "STRING"
            }
        },
        "RAW_STAGE_LOGIN_TS": {
            "column_types": {
                "CUSTOMER_ID": "STRING",
                "LAST_LOGIN_DATE": "DATETIME",
                "DEVICE_USED": "STRING",
                "LOAD_DATETIME": "DATETIME",
                "SOURCE": "STRING"
            }
        },
        "HUB_CUSTOMER": {
            "column_types": {
                "CUSTOMER_PK": "STRING",
                "CUSTOMER_ID": "STRING",
                "LOAD_DATE": "DATE",
                "SOURCE": "STRING"
            }
        },
        "HUB_CUSTOMER_2S": {
            "column_types": {
                "CUSTOMER_PK": "STRING",
                "CUSTOMER_ID": "STRING",
                "LOAD_DATE": "DATE",
                "SOURCE": "STRING"
            }
        },
        "HUB_CUSTOMER_TS": {
            "column_types": {
                "CUSTOMER_PK": "STRING",
                "CUSTOMER_ID": "STRING",
                "LOAD_DATETIME": "DATETIME",
                "SOURCE": "STRING"
            }
        },
        "SAT_CUSTOMER_DETAILS": {
            "column_types": {
                "CUSTOMER_PK": "STRING",
                "HASHDIFF": "STRING",
                "CUSTOMER_NAME": "STRING",
                "CUSTOMER_ADDRESS": "STRING",
                "CUSTOMER_DOB": "DATE",
                "EFFECTIVE_FROM": "DATE",
                "LOAD_DATE": "DATE",
                "SOURCE": "STRING"
            }
        },
        "SAT_CUSTOMER_DETAILS_TS": {
            "column_types": {
                "CUSTOMER_PK": "STRING",
                "HASHDIFF": "STRING",
                "CUSTOMER_NAME": "STRING",
                "CUSTOMER_ADDRESS": "STRING",
                "CUSTOMER_DOB": "DATE",
                "EFFECTIVE_FROM": "DATETIME",
                "LOAD_DATETIME": "DATETIME",
                "SOURCE": "STRING"
            }
        },
        "SAT_CUSTOMER_LOGIN": {
            "column_types": {
                "CUSTOMER_PK": "STRING",
                "HASHDIFF": "STRING",
                "DEVICE_USED": "STRING",
                "LAST_LOGIN_DATE": "DATETIME",
                "EFFECTIVE_FROM": "DATE",
                "LOAD_DATE": "DATE",
                "SOURCE": "STRING"
            }
        },
        "SAT_CUSTOMER_LOGIN_TS": {
            "column_types": {
                "CUSTOMER_PK": "STRING",
                "HASHDIFF": "STRING",
                "DEVICE_USED": "STRING",
                "LAST_LOGIN_DATE": "DATETIME",
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
        "PIT_CUSTOMER": {
            "column_types": {
                "AS_OF_DATE": "DATETIME",
                "CUSTOMER_PK": "STRING",
                "SAT_CUSTOMER_DETAILS_PK": "STRING",
                "SAT_CUSTOMER_DETAILS_LDTS": "DATETIME",
                "SAT_CUSTOMER_LOGIN_PK": "STRING",
                "SAT_CUSTOMER_LOGIN_LDTS": "DATETIME"
            }
        },
        "PIT_CUSTOMER_2S": {
            "column_types": {
                "AS_OF_DATE": "DATETIME",
                "CUSTOMER_PK": "STRING",
                "SAT_CUSTOMER_DETAILS_PK": "STRING",
                "SAT_CUSTOMER_DETAILS_LDTS": "DATETIME",
                "SAT_CUSTOMER_LOGIN_PK": "STRING",
                "SAT_CUSTOMER_LOGIN_LDTS": "DATETIME"
            }
        },
        "PIT_CUSTOMER_TS": {
            "column_types": {
                "AS_OF_DATE": "DATETIME",
                "CUSTOMER_PK": "STRING",
                "SAT_CUSTOMER_DETAILS_TS_PK": "STRING",
                "SAT_CUSTOMER_DETAILS_TS_LDTS": "DATETIME",
                "SAT_CUSTOMER_LOGIN_TS_PK": "STRING",
                "SAT_CUSTOMER_LOGIN_TS_LDTS": "DATETIME"
            }
        },
        "PIT_CUSTOMER_LG": {
            "column_types": {
                "AS_OF_DATE": "DATETIME",
                "CUSTOMER_PK": "STRING",
                "SAT_CUSTOMER_DETAILS_TS_PK": "STRING",
                "SAT_CUSTOMER_DETAILS_TS_LDTS": "DATETIME",
                "SAT_CUSTOMER_LOGIN_TS_PK": "STRING",
                "SAT_CUSTOMER_LOGIN_TS_LDTS": "DATETIME"
            }
        },
        "PIT_CUSTOMER_HG": {
            "column_types": {
                "AS_OF_DATE": "DATETIME",
                "CUSTOMER_PK": "STRING",
                "SAT_CUSTOMER_DETAILS_PK": "STRING",
                "SAT_CUSTOMER_DETAILS_LDTS": "DATETIME",
                "SAT_CUSTOMER_LOGIN_PK": "STRING",
                "SAT_CUSTOMER_LOGIN_LDTS": "DATETIME"
            }
        }
    }


# SQLServer


@fixture
def pit_sqlserver(context):
    """
    Define the structures and metadata to perform PIT load
    """

    set_metadata(context)

    context.stage_columns = {
        "RAW_STAGE_DETAILS":
            ["CUSTOMER_ID",
             "CUSTOMER_NAME",
             "CUSTOMER_ADDRESS",
             "CUSTOMER_DOB",
             "LOAD_DATE",
             "SOURCE"],
        "RAW_STAGE_LOGIN":
            ["CUSTOMER_ID",
             "LAST_LOGIN_DATE",
             "DEVICE_USED",
             "LOAD_DATE",
             "SOURCE"],
        "RAW_STAGE_PROFILE":
            ["CUSTOMER_ID",
             "DASHBOARD_COLOUR",
             "DISPLAY_NAME",
             "LOAD_DATE",
             "SOURCE"]
    }

    context.seed_config = {
        "RAW_STAGE_DETAILS": {
            "column_types": {
                "CUSTOMER_ID": "VARCHAR(5)",
                "DASHBOARD_COLOUR": "VARCHAR(10)",
                "CUSTOMER_NAME": "VARCHAR(10)",
                "CUSTOMER_ADDRESS": "VARCHAR(30)",
                "CUSTOMER_DOB": "DATE",
                "LOAD_DATE": "DATETIME2",
                "SOURCE": "VARCHAR(10)"
            }
        },
        "RAW_STAGE_LOGIN": {
            "column_types": {
                "CUSTOMER_ID": "VARCHAR(5)",
                "DASHBOARD_COLOUR": "VARCHAR(10)",
                "LAST_LOGIN_DATE": "DATETIME2",
                "DEVICE_USED": "VARCHAR(10)",
                "LOAD_DATE": "DATETIME2",
                "SOURCE": "VARCHAR(10)"
            }
        },
        "RAW_STAGE_PROFILE": {
            "column_types": {
                "CUSTOMER_ID": "VARCHAR(5)",
                "DASHBOARD_COLOUR": "VARCHAR(10)",
                "DISPLAY_NAME": "VARCHAR(10)",
                "LOAD_DATE": "DATETIME2",
                "SOURCE": "VARCHAR(10)"
            }
        },
        "HUB_CUSTOMER": {
            "column_types": {
                "CUSTOMER_PK": "BINARY(16)",
                "CUSTOMER_ID": "VARCHAR(5)",
                "LOAD_DATE": "DATETIME2",
                "SOURCE": "VARCHAR(10)"
            }
        },
        "HUB_CUSTOMER_AC": {
            "column_types": {
                "CUSTOMER_PK": "BINARY(16)",
                "CUSTOMER_ID": "VARCHAR(5)",
                "DASHBOARD_COLOUR": "VARCHAR(10)",
                "LOAD_DATE": "DATETIME2",
                "SOURCE": "VARCHAR(10)"
            }
        },
        "SAT_CUSTOMER_DETAILS": {
            "column_types": {
                "CUSTOMER_PK": "BINARY(16)",
                "HASHDIFF": "BINARY(16)",
                "CUSTOMER_NAME": "VARCHAR(10)",
                "CUSTOMER_ADDRESS": "VARCHAR(30)",
                "CUSTOMER_DOB": "DATE",
                "EFFECTIVE_FROM": "DATETIME2",
                "LOAD_DATE": "DATETIME2",
                "SOURCE": "VARCHAR(10)"
            }
        },
        "SAT_CUSTOMER_LOGIN": {
            "column_types": {
                "CUSTOMER_PK": "BINARY(16)",
                "HASHDIFF": "BINARY(16)",
                "DEVICE_USED": "VARCHAR(10)",
                "LAST_LOGIN_DATE": "DATETIME2",
                "EFFECTIVE_FROM": "DATETIME2",
                "LOAD_DATE": "DATETIME2",
                "SOURCE": "VARCHAR(10)"
            }
        },
        "SAT_CUSTOMER_PROFILE": {
            "column_types": {
                "CUSTOMER_PK": "BINARY(16)",
                "HASHDIFF": "BINARY(16)",
                "DASHBOARD_COLOUR": "VARCHAR(10)",
                "DISPLAY_NAME": "VARCHAR(10)",
                "EFFECTIVE_FROM": "DATETIME2",
                "LOAD_DATE": "DATETIME2",
                "SOURCE": "VARCHAR(10)"
            }
        },
        "AS_OF_DATE": {
            "column_types": {
                "AS_OF_DATE": "DATETIME2"
            }
        },
        "PIT_CUSTOMER": {
            "column_types": {
                "AS_OF_DATE": "DATETIME2",
                "CUSTOMER_PK": "BINARY(16)",
                "SAT_CUSTOMER_DETAILS_PK": "BINARY(16)",
                "SAT_CUSTOMER_DETAILS_LDTS": "DATETIME2",
                "SAT_CUSTOMER_LOGIN_PK": "BINARY(16)",
                "SAT_CUSTOMER_LOGIN_LDTS": "DATETIME2",
                "SAT_CUSTOMER_PROFILE_PK": "BINARY(16)",
                "SAT_CUSTOMER_PROFILE_LDTS": "DATETIME2"
            }
        },
        "PIT_CUSTOMER_AC": {
            "column_types": {
                "AS_OF_DATE": "DATETIME2",
                "CUSTOMER_PK": "BINARY(16)",
                "CUSTOMER_ID": "VARCHAR(4)",
                "SAT_CUSTOMER_DETAILS_PK": "BINARY(16)",
                "SAT_CUSTOMER_DETAILS_LDTS": "DATETIME2",
                "SAT_CUSTOMER_LOGIN_PK": "BINARY(16)",
                "SAT_CUSTOMER_LOGIN_LDTS": "DATETIME2",
                "SAT_CUSTOMER_PROFILE_PK": "BINARY(16)",
                "SAT_CUSTOMER_PROFILE_LDTS": "DATETIME2"
            }
        },
        "PIT_CUSTOMER_M_AC": {
            "column_types": {
                "AS_OF_DATE": "DATETIME2",
                "CUSTOMER_PK": "BINARY(16)",
                "CUSTOMER_ID": "VARCHAR(4)",
                "DASHBOARD_COLOUR": "VARCHAR(10)",
                "SAT_CUSTOMER_DETAILS_PK": "BINARY(16)",
                "SAT_CUSTOMER_DETAILS_LDTS": "DATETIME2",
                "SAT_CUSTOMER_LOGIN_PK": "BINARY(16)",
                "SAT_CUSTOMER_LOGIN_LDTS": "DATETIME2",
                "SAT_CUSTOMER_PROFILE_PK": "BINARY(16)",
                "SAT_CUSTOMER_PROFILE_LDTS": "DATETIME2"
            }
        },
    }


@fixture
def pit_one_sat_sqlserver(context):
    """
    Define the structures and metadata to perform PIT load
    """

    set_metadata(context)

    context.seed_config = {
        "RAW_STAGE_DETAILS": {
            "column_types": {
                "CUSTOMER_ID": "VARCHAR(50)",
                "CUSTOMER_NAME": "VARCHAR(50)",
                "CUSTOMER_ADDRESS": "VARCHAR(50)",
                "CUSTOMER_DOB": "DATE",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR(50)"
            }
        },
        "RAW_STAGE_DETAILS_TS": {
            "column_types": {
                "CUSTOMER_ID": "VARCHAR(50)",
                "CUSTOMER_NAME": "VARCHAR(50)",
                "CUSTOMER_ADDRESS": "VARCHAR(50)",
                "CUSTOMER_DOB": "DATE",
                "LOAD_DATETIME": "DATETIME2",
                "SOURCE": "VARCHAR(50)"
            }
        },
        "HUB_CUSTOMER": {
            "column_types": {
                "CUSTOMER_PK": "BINARY(16)",
                "CUSTOMER_ID": "VARCHAR(50)",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR(50)"
            }
        },
        "HUB_CUSTOMER_1S": {
            "column_types": {
                "CUSTOMER_PK": "BINARY(16)",
                "CUSTOMER_ID": "VARCHAR(50)",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR(50)"
            }
        },
        "HUB_CUSTOMER_1S_TS": {
            "column_types": {
                "CUSTOMER_PK": "BINARY(16)",
                "CUSTOMER_ID": "VARCHAR(50)",
                "LOAD_DATETIME": "DATETIME2",
                "SOURCE": "VARCHAR(50)"
            }
        },
        "HUB_CUSTOMER_TS": {
            "column_types": {
                "CUSTOMER_PK": "BINARY(16)",
                "CUSTOMER_ID": "VARCHAR(50)",
                "LOAD_DATETIME": "DATETIME2",
                "SOURCE": "VARCHAR(50)"
            }
        },
        "SAT_CUSTOMER_DETAILS": {
            "column_types": {
                "CUSTOMER_PK": "BINARY(16)",
                "HASHDIFF": "BINARY(16)",
                "CUSTOMER_NAME": "VARCHAR(50)",
                "CUSTOMER_ADDRESS": "VARCHAR(50)",
                "CUSTOMER_DOB": "DATE",
                "EFFECTIVE_FROM": "DATE",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR(50)"
            }
        },
        "SAT_CUSTOMER_DETAILS_TS": {
            "column_types": {
                "CUSTOMER_PK": "BINARY(16)",
                "HASHDIFF": "BINARY(16)",
                "CUSTOMER_NAME": "VARCHAR(50)",
                "CUSTOMER_ADDRESS": "VARCHAR(50)",
                "CUSTOMER_DOB": "DATE",
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
        "PIT_CUSTOMER": {
            "column_types": {
                "AS_OF_DATE": "DATETIME2",
                "CUSTOMER_PK": "BINARY(16)",
                "SAT_CUSTOMER_DETAILS_PK": "BINARY(16)",
                "SAT_CUSTOMER_DETAILS_LDTS": "DATETIME2"
            }
        },
        "PIT_CUSTOMER_1S": {
            "column_types": {
                "CUSTOMER_PK": "BINARY(16)",
                "AS_OF_DATE": "DATETIME2",
                "SAT_CUSTOMER_DETAILS_PK": "BINARY(16)",
                "SAT_CUSTOMER_DETAILS_LDTS": "DATETIME2"
            }
        },
        "PIT_CUSTOMER_1S_TS": {
            "column_types": {
                "CUSTOMER_PK": "BINARY(16)",
                "AS_OF_DATE": "DATETIME2",
                "SAT_CUSTOMER_DETAILS_TS_PK": "BINARY(16)",
                "SAT_CUSTOMER_DETAILS_TS_LDTS": "DATETIME2"
            }
        },
        "PIT_CUSTOMER_TS": {
            "column_types": {
                "AS_OF_DATE": "DATETIME2",
                "CUSTOMER_PK": "BINARY(16)",
                "SAT_CUSTOMER_DETAILS_TS_PK": "BINARY(16)",
                "SAT_CUSTOMER_DETAILS_TS_LDTS": "DATETIME2"
            }
        },
        "PIT_CUSTOMER_LG": {
            "column_types": {
                "AS_OF_DATE": "DATETIME2",
                "CUSTOMER_PK": "BINARY(16)",
                "SAT_CUSTOMER_DETAILS_TS_PK": "BINARY(16)",
                "SAT_CUSTOMER_DETAILS_TS_LDTS": "DATETIME2"
            }
        },
        "PIT_CUSTOMER_HG": {
            "column_types": {
                "AS_OF_DATE": "DATETIME2",
                "CUSTOMER_PK": "BINARY(16)",
                "SAT_CUSTOMER_DETAILS_PK": "BINARY(16)",
                "SAT_CUSTOMER_DETAILS_LDTS": "DATETIME2"
            }
        }
    }


@fixture
def pit_two_sats_sqlserver(context):
    """
    Define the structures and metadata to perform PIT load
    """

    set_metadata(context)

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
            "column_types": {
                "CUSTOMER_ID": "VARCHAR(50)",
                "CUSTOMER_NAME": "VARCHAR(50)",
                "CUSTOMER_ADDRESS": "VARCHAR(50)",
                "CUSTOMER_DOB": "DATE",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR(50)"
            }
        },
        "RAW_STAGE_DETAILS_TS": {
            "column_types": {
                "CUSTOMER_ID": "VARCHAR(50)",
                "CUSTOMER_NAME": "VARCHAR(50)",
                "CUSTOMER_ADDRESS": "VARCHAR(50)",
                "CUSTOMER_DOB": "DATE",
                "LOAD_DATETIME": "DATETIME2",
                "SOURCE": "VARCHAR(50)"
            }
        },
        "RAW_STAGE_LOGIN": {
            "column_types": {
                "CUSTOMER_ID": "VARCHAR(50)",
                "LAST_LOGIN_DATE": "DATETIME2",
                "DEVICE_USED": "VARCHAR(50)",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR(50)"
            }
        },
        "RAW_STAGE_LOGIN_TS": {
            "column_types": {
                "CUSTOMER_ID": "VARCHAR(50)",
                "LAST_LOGIN_DATE": "DATETIME2",
                "DEVICE_USED": "VARCHAR(50)",
                "LOAD_DATETIME": "DATETIME2",
                "SOURCE": "VARCHAR(50)"
            }
        },
        "HUB_CUSTOMER": {
            "column_types": {
                "CUSTOMER_PK": "BINARY(16)",
                "CUSTOMER_ID": "VARCHAR(50)",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR(50)"
            }
        },
        "HUB_CUSTOMER_2S": {
            "column_types": {
                "CUSTOMER_PK": "BINARY(16)",
                "CUSTOMER_ID": "VARCHAR(50)",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR(50)"
            }
        },
        "HUB_CUSTOMER_TS": {
            "column_types": {
                "CUSTOMER_PK": "BINARY(16)",
                "CUSTOMER_ID": "VARCHAR(50)",
                "LOAD_DATETIME": "DATETIME2",
                "SOURCE": "VARCHAR(50)"
            }
        },
        "SAT_CUSTOMER_DETAILS": {
            "column_types": {
                "CUSTOMER_PK": "BINARY(16)",
                "HASHDIFF": "BINARY(16)",
                "CUSTOMER_NAME": "VARCHAR(50)",
                "CUSTOMER_ADDRESS": "VARCHAR(50)",
                "CUSTOMER_DOB": "DATE",
                "EFFECTIVE_FROM": "DATE",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR(50)"
            }
        },
        "SAT_CUSTOMER_DETAILS_TS": {
            "column_types": {
                "CUSTOMER_PK": "BINARY(16)",
                "HASHDIFF": "BINARY(16)",
                "CUSTOMER_NAME": "VARCHAR(50)",
                "CUSTOMER_ADDRESS": "VARCHAR(50)",
                "CUSTOMER_DOB": "DATE",
                "EFFECTIVE_FROM": "DATETIME2",
                "LOAD_DATETIME": "DATETIME2",
                "SOURCE": "VARCHAR(50)"
            }
        },
        "SAT_CUSTOMER_LOGIN": {
            "column_types": {
                "CUSTOMER_PK": "BINARY(16)",
                "HASHDIFF": "BINARY(16)",
                "DEVICE_USED": "VARCHAR(50)",
                "LAST_LOGIN_DATE": "DATETIME2",
                "EFFECTIVE_FROM": "DATE",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR(50)"
            }
        },
        "SAT_CUSTOMER_LOGIN_TS": {
            "column_types": {
                "CUSTOMER_PK": "BINARY(16)",
                "HASHDIFF": "BINARY(16)",
                "DEVICE_USED": "VARCHAR(50)",
                "LAST_LOGIN_DATE": "DATETIME2",
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
        "PIT_CUSTOMER": {
            "column_types": {
                "AS_OF_DATE": "DATETIME2",
                "CUSTOMER_PK": "BINARY(16)",
                "SAT_CUSTOMER_DETAILS_PK": "BINARY(16)",
                "SAT_CUSTOMER_DETAILS_LDTS": "DATETIME2",
                "SAT_CUSTOMER_LOGIN_PK": "BINARY(16)",
                "SAT_CUSTOMER_LOGIN_LDTS": "DATETIME2"
            }
        },
        "PIT_CUSTOMER_2S": {
            "column_types": {
                "AS_OF_DATE": "DATETIME2",
                "CUSTOMER_PK": "BINARY(16)",
                "SAT_CUSTOMER_DETAILS_PK": "BINARY(16)",
                "SAT_CUSTOMER_DETAILS_LDTS": "DATETIME2",
                "SAT_CUSTOMER_LOGIN_PK": "BINARY(16)",
                "SAT_CUSTOMER_LOGIN_LDTS": "DATETIME2"
            }
        },
        "PIT_CUSTOMER_TS": {
            "column_types": {
                "AS_OF_DATE": "DATETIME2",
                "CUSTOMER_PK": "BINARY(16)",
                "SAT_CUSTOMER_DETAILS_TS_PK": "BINARY(16)",
                "SAT_CUSTOMER_DETAILS_TS_LDTS": "DATETIME2",
                "SAT_CUSTOMER_LOGIN_TS_PK": "BINARY(16)",
                "SAT_CUSTOMER_LOGIN_TS_LDTS": "DATETIME2"
            }
        },
        "PIT_CUSTOMER_LG": {
            "column_types": {
                "AS_OF_DATE": "DATETIME2",
                "CUSTOMER_PK": "BINARY(16)",
                "SAT_CUSTOMER_DETAILS_TS_PK": "BINARY(16)",
                "SAT_CUSTOMER_DETAILS_TS_LDTS": "DATETIME2",
                "SAT_CUSTOMER_LOGIN_TS_PK": "BINARY(16)",
                "SAT_CUSTOMER_LOGIN_TS_LDTS": "DATETIME2"
            }
        },
        "PIT_CUSTOMER_HG": {
            "column_types": {
                "AS_OF_DATE": "DATETIME2",
                "CUSTOMER_PK": "BINARY(16)",
                "SAT_CUSTOMER_DETAILS_PK": "BINARY(16)",
                "SAT_CUSTOMER_DETAILS_LDTS": "DATETIME2",
                "SAT_CUSTOMER_LOGIN_PK": "BINARY(16)",
                "SAT_CUSTOMER_LOGIN_LDTS": "DATETIME2"
            }
        }
    }
