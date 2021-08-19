from behave import fixture

"""
MSSQL specific fixtures for use with dbt-sqlserver adapter
The fixtures here are used to supply runtime metadata to MSSQL specific tests, which are provided to the model generator.
"""










@fixture
def t_link_sqlserver(context):
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
                "CUSTOMER_ID": "VARCHAR(50)",
                "ORDER_ID": "VARCHAR(50)",
                "TRANSACTION_NUMBER": "DECIMAL(38,0)",
                "TRANSACTION_DATE": "DATE",
                "TYPE": "VARCHAR(50)",
                "AMOUNT": "DECIMAL(38,2)",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR(50)"
            }
        },
        "T_LINK": {
            "+column_types": {
                "TRANSACTION_PK": "BINARY(16)",
                "CUSTOMER_FK": "BINARY(16)",
                "ORDER_FK": "BINARY(16)",
                "TRANSACTION_NUMBER": "DECIMAL(38,0)",
                "TRANSACTION_DATE": "DATE",
                "TYPE": "VARCHAR(50)",
                "AMOUNT": "DECIMAL(38,2)",
                "EFFECTIVE_FROM": "DATE",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR(50)"
            }
        }
    }


@fixture
def pit_sqlserver(context):
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
                "CUSTOMER_ID": "VARCHAR(5)",
                "CUSTOMER_NAME": "VARCHAR(10)",
                "CUSTOMER_ADDRESS": "VARCHAR(30)",
                "CUSTOMER_DOB": "DATE",
                "LOAD_DATE": "DATETIME",
                "SOURCE": "VARCHAR(10)"
            }
        },
        "RAW_STAGE_LOGIN": {
            "+column_types": {
                "CUSTOMER_ID": "VARCHAR(5)",
                "LAST_LOGIN_DATE": "DATETIME",
                "DEVICE_USED": "VARCHAR(10)",
                "LOAD_DATE": "DATETIME",
                "SOURCE": "VARCHAR(10)"
            }
        },
        "RAW_STAGE_PROFILE": {
            "+column_types": {
                "CUSTOMER_ID": "VARCHAR(5)",
                "DASHBOARD_COLOUR": "VARCHAR(10)",
                "DISPLAY_NAME": "VARCHAR(10)",
                "LOAD_DATE": "DATETIME",
                "SOURCE": "VARCHAR(10)"
            }
        },
        "HUB_CUSTOMER": {
            "+column_types": {
                "CUSTOMER_PK": "BINARY(16)",
                "CUSTOMER_ID": "VARCHAR(5)",
                "LOAD_DATE": "DATETIME",
                "SOURCE": "VARCHAR(10)"
            }
        },
        "SAT_CUSTOMER_DETAILS": {
            "+column_types": {
                "CUSTOMER_PK": "BINARY(16)",
                "HASHDIFF": "BINARY(16)",
                "CUSTOMER_NAME": "VARCHAR(10)",
                "CUSTOMER_ADDRESS": "VARCHAR(30)",
                "CUSTOMER_DOB": "DATE",
                "EFFECTIVE_FROM": "DATETIME",
                "LOAD_DATE": "DATETIME",
                "SOURCE": "VARCHAR(10)"
            }
        },
        "SAT_CUSTOMER_LOGIN": {
            "+column_types": {
                "CUSTOMER_PK": "BINARY(16)",
                "HASHDIFF": "BINARY(16)",
                "DEVICE_USED": "VARCHAR(10)",
                "LAST_LOGIN_DATE": "DATETIME",
                "EFFECTIVE_FROM": "DATETIME",
                "LOAD_DATE": "DATETIME",
                "SOURCE": "VARCHAR(10)"
            }
        },
        "SAT_CUSTOMER_PROFILE": {
            "+column_types": {
                "CUSTOMER_PK": "BINARY(16)",
                "HASHDIFF": "BINARY(16)",
                "DASHBOARD_COLOUR": "VARCHAR(10)",
                "DISPLAY_NAME": "VARCHAR(10)",
                "EFFECTIVE_FROM": "DATETIME",
                "LOAD_DATE": "DATETIME",
                "SOURCE": "VARCHAR(10)"
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
                "CUSTOMER_PK": "BINARY(16)",
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
def pit_one_sat_sqlserver(context):
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
                "CUSTOMER_ID": "VARCHAR(50)",
                "CUSTOMER_NAME": "VARCHAR(50)",
                "CUSTOMER_ADDRESS": "VARCHAR(50)",
                "CUSTOMER_DOB": "DATE",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR(50)"
            }
        },
        "RAW_STAGE_DETAILS_TS": {
            "+column_types": {
                "CUSTOMER_ID": "VARCHAR(50)",
                "CUSTOMER_NAME": "VARCHAR(50)",
                "CUSTOMER_ADDRESS": "VARCHAR(50)",
                "CUSTOMER_DOB": "DATE",
                "LOAD_DATETIME": "DATETIME",
                "SOURCE": "VARCHAR(50)"
            }
        },
        "HUB_CUSTOMER": {
            "+column_types": {
                "CUSTOMER_PK": "BINARY(16)",
                "CUSTOMER_ID": "VARCHAR(50)",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR(50)"
            }
        },
        "HUB_CUSTOMER_TS": {
            "+column_types": {
                "CUSTOMER_PK": "BINARY(16)",
                "CUSTOMER_ID": "VARCHAR(50)",
                "LOAD_DATETIME": "DATETIME",
                "SOURCE": "VARCHAR(50)"
            }
        },
        "SAT_CUSTOMER_DETAILS": {
            "+column_types": {
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
            "+column_types": {
                "CUSTOMER_PK": "BINARY(16)",
                "HASHDIFF": "BINARY(16)",
                "CUSTOMER_NAME": "VARCHAR(50)",
                "CUSTOMER_ADDRESS": "VARCHAR(50)",
                "CUSTOMER_DOB": "DATE",
                "EFFECTIVE_FROM": "DATETIME",
                "LOAD_DATETIME": "DATETIME",
                "SOURCE": "VARCHAR(50)"
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
                "CUSTOMER_PK": "BINARY(16)",
                "SAT_CUSTOMER_DETAILS_PK": "BINARY(16)",
                "SAT_CUSTOMER_DETAILS_LDTS": "DATETIME"
            }
        },
        "PIT_CUSTOMER_TS": {
            "+column_types": {
                "AS_OF_DATE": "DATETIME",
                "CUSTOMER_PK": "BINARY(16)",
                "SAT_CUSTOMER_DETAILS_TS_PK": "BINARY(16)",
                "SAT_CUSTOMER_DETAILS_TS_LDTS": "DATETIME"
            }
        },
        "PIT_CUSTOMER_LG": {
            "+column_types": {
                "AS_OF_DATE": "DATETIME",
                "CUSTOMER_PK": "BINARY(16)",
                "SAT_CUSTOMER_DETAILS_TS_PK": "BINARY(16)",
                "SAT_CUSTOMER_DETAILS_TS_LDTS": "DATETIME"
            }
        },
        "PIT_CUSTOMER_HG": {
            "+column_types": {
                "AS_OF_DATE": "DATETIME",
                "CUSTOMER_PK": "BINARY(16)",
                "SAT_CUSTOMER_DETAILS_PK": "BINARY(16)",
                "SAT_CUSTOMER_DETAILS_LDTS": "DATETIME"
            }
        }
    }


@fixture
def pit_two_sats_sqlserver(context):
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
                "CUSTOMER_ID": "VARCHAR(50)",
                "CUSTOMER_NAME": "VARCHAR(50)",
                "CUSTOMER_ADDRESS": "VARCHAR(50)",
                "CUSTOMER_DOB": "DATE",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR(50)"
            }
        },
        "RAW_STAGE_DETAILS_TS": {
            "+column_types": {
                "CUSTOMER_ID": "VARCHAR(50)",
                "CUSTOMER_NAME": "VARCHAR(50)",
                "CUSTOMER_ADDRESS": "VARCHAR(50)",
                "CUSTOMER_DOB": "DATE",
                "LOAD_DATETIME": "DATETIME",
                "SOURCE": "VARCHAR(50)"
            }
        },
        "RAW_STAGE_LOGIN": {
            "+column_types": {
                "CUSTOMER_ID": "VARCHAR(50)",
                "LAST_LOGIN_DATE": "DATETIME",
                "DEVICE_USED": "VARCHAR(50)",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR(50)"
            }
        },
        "RAW_STAGE_LOGIN_TS": {
            "+column_types": {
                "CUSTOMER_ID": "VARCHAR(50)",
                "LAST_LOGIN_DATE": "DATETIME",
                "DEVICE_USED": "VARCHAR(50)",
                "LOAD_DATETIME": "DATETIME",
                "SOURCE": "VARCHAR(50)"
            }
        },
        "HUB_CUSTOMER": {
            "+column_types": {
                "CUSTOMER_PK": "BINARY(16)",
                "CUSTOMER_ID": "VARCHAR(50)",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR(50)"
            }
        },
        "HUB_CUSTOMER_TS": {
            "+column_types": {
                "CUSTOMER_PK": "BINARY(16)",
                "CUSTOMER_ID": "VARCHAR(50)",
                "LOAD_DATETIME": "DATETIME",
                "SOURCE": "VARCHAR(50)"
            }
        },
        "SAT_CUSTOMER_DETAILS": {
            "+column_types": {
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
            "+column_types": {
                "CUSTOMER_PK": "BINARY(16)",
                "HASHDIFF": "BINARY(16)",
                "CUSTOMER_NAME": "VARCHAR(50)",
                "CUSTOMER_ADDRESS": "VARCHAR(50)",
                "CUSTOMER_DOB": "DATE",
                "EFFECTIVE_FROM": "DATETIME",
                "LOAD_DATETIME": "DATETIME",
                "SOURCE": "VARCHAR(50)"
            }
        },
        "SAT_CUSTOMER_LOGIN": {
            "+column_types": {
                "CUSTOMER_PK": "BINARY(16)",
                "HASHDIFF": "BINARY(16)",
                "DEVICE_USED": "VARCHAR(50)",
                "LAST_LOGIN_DATE": "DATETIME",
                "EFFECTIVE_FROM": "DATE",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR(50)"
            }
        },
        "SAT_CUSTOMER_LOGIN_TS": {
            "+column_types": {
                "CUSTOMER_PK": "BINARY(16)",
                "HASHDIFF": "BINARY(16)",
                "DEVICE_USED": "VARCHAR(50)",
                "LAST_LOGIN_DATE": "DATETIME",
                "EFFECTIVE_FROM": "DATETIME",
                "LOAD_DATETIME": "DATETIME",
                "SOURCE": "VARCHAR(50)"
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
                "CUSTOMER_PK": "BINARY(16)",
                "SAT_CUSTOMER_DETAILS_PK": "BINARY(16)",
                "SAT_CUSTOMER_DETAILS_LDTS": "DATETIME",
                "SAT_CUSTOMER_LOGIN_PK": "BINARY(16)",
                "SAT_CUSTOMER_LOGIN_LDTS": "DATETIME"
            }
        },
        "PIT_CUSTOMER_TS": {
            "+column_types": {
                "AS_OF_DATE": "DATETIME",
                "CUSTOMER_PK": "BINARY(16)",
                "SAT_CUSTOMER_DETAILS_TS_PK": "BINARY(16)",
                "SAT_CUSTOMER_DETAILS_TS_LDTS": "DATETIME",
                "SAT_CUSTOMER_LOGIN_TS_PK": "BINARY(16)",
                "SAT_CUSTOMER_LOGIN_TS_LDTS": "DATETIME"
            }
        },
        "PIT_CUSTOMER_LG": {
            "+column_types": {
                "AS_OF_DATE": "DATETIME",
                "CUSTOMER_PK": "BINARY(16)",
                "SAT_CUSTOMER_DETAILS_TS_PK": "BINARY(16)",
                "SAT_CUSTOMER_DETAILS_TS_LDTS": "DATETIME",
                "SAT_CUSTOMER_LOGIN_TS_PK": "BINARY(16)",
                "SAT_CUSTOMER_LOGIN_TS_LDTS": "DATETIME"
            }
        },
        "PIT_CUSTOMER_HG": {
            "+column_types": {
                "AS_OF_DATE": "DATETIME",
                "CUSTOMER_PK": "BINARY(16)",
                "SAT_CUSTOMER_DETAILS_PK": "BINARY(16)",
                "SAT_CUSTOMER_DETAILS_LDTS": "DATETIME",
                "SAT_CUSTOMER_LOGIN_PK": "BINARY(16)",
                "SAT_CUSTOMER_LOGIN_LDTS": "DATETIME"
            }
        }
    }


def bridge_sqlserver(context):
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
                "CUSTOMER_ID": "VARCHAR(50)",
                "ORDER_ID": "VARCHAR(50)",
                "LOAD_DATETIME": "DATETIME",
                "END_DATE": "DATETIME",
                "SOURCE": "VARCHAR(50)"
            }
        },
        "RAW_ORDER_PRODUCT": {
            "+column_types": {
                "ORDER_ID": "VARCHAR(50)",
                "PRODUCT_ID": "VARCHAR(50)",
                "LOAD_DATETIME": "DATETIME",
                "END_DATE": "DATETIME",
                "SOURCE": "VARCHAR(50)"
            }
        },
        "RAW_PRODUCT_COMPONENT": {
            "+column_types": {
                "PRODUCT_ID": "VARCHAR(50)",
                "COMPONENT_ID": "VARCHAR(50)",
                "LOAD_DATETIME": "DATETIME",
                "END_DATE": "DATETIME",
                "SOURCE": "VARCHAR(50)"
            }
        },
        "HUB_CUSTOMER": {
            "+column_types": {
                "CUSTOMER_PK": "BINARY(16)",
                "CUSTOMER_ID": "VARCHAR(50)",
                "LOAD_DATETIME": "DATETIME",
                "SOURCE": "VARCHAR(50)"
            }
        },
        "LINK_CUSTOMER_ORDER": {
            "+column_types": {
                "CUSTOMER_ORDER_PK": "BINARY(16)",
                "CUSTOMER_FK": "BINARY(16)",
                "ORDER_FK": "BINARY(16)",
                "LOAD_DATETIME": "DATETIME",
                "SOURCE": "VARCHAR(50)"
            }
        },
        "LINK_ORDER_PRODUCT": {
            "+column_types": {
                "ORDER_PRODUCT_PK": "BINARY(16)",
                "ORDER_FK": "BINARY(16)",
                "PRODUCT_FK": "BINARY(16)",
                "LOAD_DATETIME": "DATETIME",
                "SOURCE": "VARCHAR(50)"
            }
        },
        "LINK_PRODUCT_COMPONENT": {
            "+column_types": {
                "PRODUCT_COMPONENT_PK": "BINARY(16)",
                "PRODUCT_FK": "BINARY(16)",
                "COMPONENT_FK": "BINARY(16)",
                "LOAD_DATETIME": "DATETIME",
                "SOURCE": "VARCHAR(50)"
            }
        },
        "EFF_SAT_CUSTOMER_ORDER": {
            "+column_types": {
                "CUSTOMER_ORDER_PK": "BINARY(16)",
                "CUSTOMER_FK": "BINARY(16)",
                "ORDER_FK": "BINARY(16)",
                "START_DATE": "DATETIME",
                "END_DATE": "DATETIME",
                "EFFECTIVE_FROM": "DATETIME",
                "LOAD_DATETIME": "DATETIME",
                "SOURCE": "VARCHAR(50)"
            }
        },
        "EFF_SAT_ORDER_PRODUCT": {
            "+column_types": {
                "ORDER_PRODUCT_PK": "BINARY(16)",
                "ORDER_FK": "BINARY(16)",
                "PRODUCT_FK": "BINARY(16)",
                "START_DATE": "DATETIME",
                "END_DATE": "DATETIME",
                "EFFECTIVE_FROM": "DATETIME",
                "LOAD_DATETIME": "DATETIME",
                "SOURCE": "VARCHAR(50)"
            }
        },
        "EFF_SAT_PRODUCT_COMPONENT": {
            "+column_types": {
                "PRODUCT_COMPONENT_PK": "BINARY(16)",
                "PRODUCT_FK": "BINARY(16)",
                "COMPONENT_FK": "BINARY(16)",
                "START_DATE": "DATETIME",
                "END_DATE": "DATETIME",
                "EFFECTIVE_FROM": "DATETIME",
                "LOAD_DATETIME": "DATETIME",
                "SOURCE": "VARCHAR(50)"
            }
        },
        "AS_OF_DATE": {
            "+column_types": {
                "AS_OF_DATE": "DATETIME"
            }
        },
        "BRIDGE_CUSTOMER_ORDER": {
            "+column_types": {
                "CUSTOMER_PK": "BINARY(16)",
                "AS_OF_DATE": "DATETIME",
                "LINK_CUSTOMER_ORDER_PK": "BINARY(16)",
            }
        },
        "BRIDGE_CUSTOMER_ORDER_PRODUCT": {
            "+column_types": {
                "CUSTOMER_PK": "BINARY(16)",
                "AS_OF_DATE": "DATETIME",
                "LINK_CUSTOMER_ORDER_PK": "BINARY(16)",
                "LINK_ORDER_PRODUCT_PK": "BINARY(16)",
            }
        },
        "BRIDGE_CUSTOMER_ORDER_PRODUCT_COMPONENT": {
            "+column_types": {
                "CUSTOMER_PK": "BINARY(16)",
                "AS_OF_DATE": "DATETIME",
                "LINK_CUSTOMER_ORDER_PK": "BINARY(16)",
                "LINK_ORDER_PRODUCT_PK": "BINARY(16)",
                "LINK_PRODUCT_COMPONENT_PK": "BINARY(16)",
            }
        }
    }


@fixture
def eff_satellite_sqlserver(context):
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
                "CUSTOMER_ID": "DECIMAL(38, 0)",
                "ORDER_ID": "VARCHAR(50)",
                "START_DATE": "DATE",
                "END_DATE": "DATE",
                "EFFECTIVE_FROM": "DATE",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR(50)"
            }
        },
        "EFF_SAT": {
            "+column_types": {
                "CUSTOMER_ORDER_PK": "BINARY(16)",
                "CUSTOMER_PK": "BINARY(16)",
                "ORDER_PK": "BINARY(16)",
                "START_DATE": "DATE",
                "END_DATE": "DATE",
                "EFFECTIVE_FROM": "DATE",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR(50)"
            }
        }
    }


@fixture
def eff_satellite_testing_auto_end_dating_sqlserver(context):
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
                "CUSTOMER_ID": "VARCHAR(50)",
                "ORDER_ID": "VARCHAR(50)",
                "START_DATE": "DATETIME",
                "END_DATE": "DATETIME",
                "EFFECTIVE_FROM": "DATETIME",
                "LOAD_DATETIME": "DATETIME",
                "SOURCE": "VARCHAR(50)"
            }
        },
        "RAW_STAGE_ORDER_CUSTOMER": {
            "+column_types": {
                "CUSTOMER_ID": "VARCHAR(50)",
                "ORDER_ID": "VARCHAR(50)",
                "START_DATE": "DATETIME",
                "END_DATE": "DATETIME",
                "EFFECTIVE_FROM": "DATETIME",
                "LOAD_DATETIME": "DATETIME",
                "SOURCE": "VARCHAR(50)"
            }
        },
        "LINK_CUSTOMER_ORDER": {
            "+column_types": {
                "CUSTOMER_ORDER_PK": "BINARY(16)",
                "CUSTOMER_PK": "BINARY(16)",
                "ORDER_PK": "BINARY(16)",
                "LOAD_DATETIME": "DATETIME",
                "SOURCE": "VARCHAR(50)"
            }
        },
        "LINK_ORDER_CUSTOMER": {
            "+column_types": {
                "ORDER_CUSTOMER_PK": "BINARY(16)",
                "CUSTOMER_PK": "BINARY(16)",
                "ORDER_PK": "BINARY(16)",
                "LOAD_DATETIME": "DATETIME",
                "SOURCE": "VARCHAR(50)"
            }
        },
        "EFF_SAT_CUSTOMER_ORDER": {
            "+column_types": {
                "CUSTOMER_ORDER_PK": "BINARY(16)",
                "CUSTOMER_PK": "BINARY(16)",
                "ORDER_PK": "BINARY(16)",
                "START_DATE": "DATETIME",
                "END_DATE": "DATETIME",
                "EFFECTIVE_FROM": "DATETIME",
                "LOAD_DATETIME": "DATETIME",
                "SOURCE": "VARCHAR(50)"
            }
        },
        "EFF_SAT_ORDER_CUSTOMER": {
            "+column_types": {
                "ORDER_CUSTOMER_PK": "BINARY(16)",
                "CUSTOMER_PK": "BINARY(16)",
                "ORDER_PK": "BINARY(16)",
                "START_DATE": "DATETIME",
                "END_DATE": "DATETIME",
                "EFFECTIVE_FROM": "DATETIME",
                "LOAD_DATETIME": "DATETIME",
                "SOURCE": "VARCHAR(50)"
            }
        }
    }


@fixture
def eff_satellite_multipart_sqlserver(context):
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
                "CUSTOMER_ID": "DECIMAL(38, 0)",
                "NATION_ID": "VARCHAR(50)",
                "ORDER_ID": "VARCHAR(50)",
                "PLATFORM_ID": "VARCHAR(50)",
                "ORGANISATION_ID": "VARCHAR(50)",
                "START_DATE": "DATE",
                "END_DATE": "DATE",
                "EFFECTIVE_FROM": "DATE",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR(50)"
            }
        },
        "EFF_SAT": {
            "+column_types": {
                "CUSTOMER_ORDER_PK": "BINARY(16)",
                "ORDER_PK": "BINARY(16)",
                "PLATFORM_PK": "BINARY(16)",
                "ORGANISATION_PK": "BINARY(16)",
                "CUSTOMER_PK": "BINARY(16)",
                "NATION_PK": "BINARY(16)",
                "START_DATE": "DATE",
                "END_DATE": "DATE",
                "EFFECTIVE_FROM": "DATE",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR(50)"
            }
        }
    }

@fixture
def multi_active_satellite_sqlserver(context):
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
                         "columns": "CUSTOMER_NAME"}
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
                         "columns": "CUSTOMER_NAME"}
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
                "CUSTOMER_ID": "DECIMAL(38, 0)",
                "CUSTOMER_NAME": "VARCHAR(50)",
                "CUSTOMER_PHONE": "VARCHAR(50)",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR(50)"
            }
        },
        "RAW_STAGE_TS": {
            "+column_types": {
                "CUSTOMER_ID": "DECIMAL(38, 0)",
                "CUSTOMER_NAME": "VARCHAR(50)",
                "CUSTOMER_PHONE": "VARCHAR(50)",
                "LOAD_DATETIME": "DATETIME",
                "SOURCE": "VARCHAR(50)"
            }
        },
        "RAW_STAGE_TWO_CDK": {
            "+column_types": {
                "CUSTOMER_ID": "DECIMAL(38, 0)",
                "CUSTOMER_NAME": "VARCHAR(50)",
                "CUSTOMER_PHONE": "VARCHAR(50)",
                "EXTENSION": "DECIMAL(38, 0)",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR(50)"
            }
        },
        "RAW_STAGE_TWO_CDK_TS": {
            "+column_types": {
                "CUSTOMER_ID": "DECIMAL(38, 0)",
                "CUSTOMER_NAME": "VARCHAR(50)",
                "CUSTOMER_PHONE": "VARCHAR(50)",
                "EXTENSION": "DECIMAL(38, 0)",
                "LOAD_DATETIME": "DATETIME",
                "SOURCE": "VARCHAR(50)"
            }
        },
        "MULTI_ACTIVE_SATELLITE": {
            "+column_types": {
                "CUSTOMER_PK": "BINARY(16)",
                "CUSTOMER_NAME": "VARCHAR(50)",
                "CUSTOMER_PHONE": "VARCHAR(50)",
                "HASHDIFF": "BINARY(16)",
                "EFFECTIVE_FROM": "DATE",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR(50)"
            }
        },
        "MULTI_ACTIVE_SATELLITE_TS": {
            "+column_types": {
                "CUSTOMER_PK": "BINARY(16)",
                "CUSTOMER_NAME": "VARCHAR(50)",
                "CUSTOMER_PHONE": "VARCHAR(50)",
                "HASHDIFF": "BINARY(16)",
                "EFFECTIVE_FROM": "DATETIME",
                "LOAD_DATETIME": "DATETIME",
                "SOURCE": "VARCHAR(50)"
            }
        },
        "MULTI_ACTIVE_SATELLITE_NO_CDK_HASHDIFF": {
            "+column_types": {
                "CUSTOMER_PK": "BINARY(16)",
                "CUSTOMER_NAME": "VARCHAR(50)",
                "CUSTOMER_PHONE": "VARCHAR(50)",
                "HASHDIFF": "BINARY(16)",
                "EFFECTIVE_FROM": "DATE",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR(50)"
            }
        },
        "MULTI_ACTIVE_SATELLITE_NO_PK_CDK_HASHDIFF": {
            "+column_types": {
                "CUSTOMER_PK": "BINARY(16)",
                "CUSTOMER_NAME": "VARCHAR(50)",
                "CUSTOMER_PHONE": "VARCHAR(50)",
                "HASHDIFF": "BINARY(16)",
                "EFFECTIVE_FROM": "DATE",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR(50)"
            }
        },
        "MULTI_ACTIVE_SATELLITE_TWO_CDK": {
            "+column_types": {
                "CUSTOMER_PK": "BINARY(16)",
                "CUSTOMER_NAME": "VARCHAR(50)",
                "CUSTOMER_PHONE": "VARCHAR(50)",
                "EXTENSION": "DECIMAL(38, 0)",
                "HASHDIFF": "BINARY(16)",
                "EFFECTIVE_FROM": "DATE",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR(50)"
            }
        },
        "MULTI_ACTIVE_SATELLITE_TWO_CDK_TS": {
            "+column_types": {
                "CUSTOMER_PK": "BINARY(16)",
                "CUSTOMER_NAME": "VARCHAR(50)",
                "CUSTOMER_PHONE": "VARCHAR(50)",
                "EXTENSION": "DECIMAL(38, 0)",
                "HASHDIFF": "BINARY(16)",
                "EFFECTIVE_FROM": "DATETIME",
                "LOAD_DATETIME": "DATETIME",
                "SOURCE": "VARCHAR(50)"
            }
        },
        "MULTI_ACTIVE_SATELLITE_TWO_CDK_NO_CDK_HASHDIFF": {
            "+column_types": {
                "CUSTOMER_PK": "BINARY(16)",
                "CUSTOMER_NAME": "VARCHAR(50)",
                "CUSTOMER_PHONE": "VARCHAR(50)",
                "EXTENSION": "DECIMAL(38, 0)",
                "HASHDIFF": "BINARY(16)",
                "EFFECTIVE_FROM": "DATE",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR(50)"
            }
        },
        "MULTI_ACTIVE_SATELLITE_TWO_CDK_NO_PK_CDK_HASHDIFF": {
            "+column_types": {
                "CUSTOMER_PK": "BINARY(16)",
                "CUSTOMER_NAME": "VARCHAR(50)",
                "CUSTOMER_PHONE": "VARCHAR(50)",
                "EXTENSION": "DECIMAL(38, 0)",
                "HASHDIFF": "BINARY(16)",
                "EFFECTIVE_FROM": "DATE",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR(50)"
            }
        }
    }


@fixture
def multi_active_satellite_cycle_sqlserver(context):
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
                         "columns": "CUSTOMER_NAME"}
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
                         "columns": "CUSTOMER_NAME"}
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
                "CUSTOMER_ID": "DECIMAL(38, 0)",
                "CUSTOMER_NAME": "VARCHAR(50)",
                "CUSTOMER_PHONE": "VARCHAR(50)",
                "EFFECTIVE_FROM": "DATE",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR(50)"
            }
        },
        "RAW_STAGE_TS": {
            "+column_types": {
                "CUSTOMER_ID": "DECIMAL(38, 0)",
                "CUSTOMER_NAME": "VARCHAR(50)",
                "CUSTOMER_PHONE": "VARCHAR(50)",
                "EFFECTIVE_FROM": "DATETIME",
                "LOAD_DATETIME": "DATETIME",
                "SOURCE": "VARCHAR(50)"
            }
        },
        "RAW_STAGE_TWO_CDK": {
            "+column_types": {
                "CUSTOMER_ID": "DECIMAL(38, 0)",
                "CUSTOMER_NAME": "VARCHAR(50)",
                "CUSTOMER_PHONE": "VARCHAR(50)",
                "EXTENSION": "DECIMAL(38, 0)",
                "EFFECTIVE_FROM": "DATE",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR(50)"
            }
        },
        "RAW_STAGE_TWO_CDK_TS": {
            "+column_types": {
                "CUSTOMER_ID": "DECIMAL(38, 0)",
                "CUSTOMER_NAME": "VARCHAR(50)",
                "CUSTOMER_PHONE": "VARCHAR(50)",
                "EXTENSION": "DECIMAL(38, 0)",
                "EFFECTIVE_FROM": "DATETIME",
                "LOAD_DATETIME": "DATETIME",
                "SOURCE": "VARCHAR(50)"
            }
        },
        "MULTI_ACTIVE_SATELLITE": {
            "+column_types": {
                "CUSTOMER_PK": "BINARY(16)",
                "HASHDIFF": "BINARY(16)",
                "CUSTOMER_PHONE": "VARCHAR(50)",
                "CUSTOMER_NAME": "VARCHAR(50)",
                "EFFECTIVE_FROM": "DATE",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR(50)"
            }
        },
        "MULTI_ACTIVE_SATELLITE_TS": {
            "+column_types": {
                "CUSTOMER_PK": "BINARY(16)",
                "HASHDIFF": "BINARY(16)",
                "CUSTOMER_PHONE": "VARCHAR(50)",
                "CUSTOMER_NAME": "VARCHAR(50)",
                "EFFECTIVE_FROM": "DATETIME",
                "LOAD_DATETIME": "DATETIME",
                "SOURCE": "VARCHAR(50)"
            }
        },
        "MULTI_ACTIVE_SATELLITE_NO_CDK_HASHDIFF": {
            "+column_types": {
                "CUSTOMER_PK": "BINARY(16)",
                "CUSTOMER_NAME": "VARCHAR(50)",
                "CUSTOMER_PHONE": "VARCHAR(50)",
                "HASHDIFF": "BINARY(16)",
                "EFFECTIVE_FROM": "DATE",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR(50)"
            }
        },
        "MULTI_ACTIVE_SATELLITE_NO_PK_CDK_HASHDIFF": {
            "+column_types": {
                "CUSTOMER_PK": "BINARY(16)",
                "CUSTOMER_NAME": "VARCHAR(50)",
                "CUSTOMER_PHONE": "VARCHAR(50)",
                "HASHDIFF": "BINARY(16)",
                "EFFECTIVE_FROM": "DATE",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR(50)"
            }
        },
        "MULTI_ACTIVE_SATELLITE_TWO_CDK": {
            "+column_types": {
                "CUSTOMER_PK": "BINARY(16)",
                "HASHDIFF": "BINARY(16)",
                "CUSTOMER_PHONE": "VARCHAR(50)",
                "CUSTOMER_NAME": "VARCHAR(50)",
                "EXTENSION": "DECIMAL(38, 0)",
                "EFFECTIVE_FROM": "DATE",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR(50)"
            }
        },
        "MULTI_ACTIVE_SATELLITE_TWO_CDK_TS": {
            "+column_types": {
                "CUSTOMER_PK": "BINARY(16)",
                "HASHDIFF": "BINARY(16)",
                "CUSTOMER_PHONE": "VARCHAR(50)",
                "CUSTOMER_NAME": "VARCHAR(50)",
                "EXTENSION": "DECIMAL(38, 0)",
                "EFFECTIVE_FROM": "DATETIME",
                "LOAD_DATETIME": "DATETIME",
                "SOURCE": "VARCHAR(50)"
            }
        },
        "MULTI_ACTIVE_SATELLITE_TWO_CDK_NO_CDK_HASHDIFF": {
            "+column_types": {
                "CUSTOMER_PK": "BINARY(16)",
                "CUSTOMER_NAME": "VARCHAR(50)",
                "CUSTOMER_PHONE": "VARCHAR(50)",
                "EXTENSION": "DECIMAL(38, 0)",
                "HASHDIFF": "BINARY(16)",
                "EFFECTIVE_FROM": "DATE",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR(50)"
            }
        },
        "MULTI_ACTIVE_SATELLITE_TWO_CDK_NO_PK_CDK_HASHDIFF": {
            "+column_types": {
                "CUSTOMER_PK": "BINARY(16)",
                "CUSTOMER_NAME": "VARCHAR(50)",
                "CUSTOMER_PHONE": "VARCHAR(50)",
                "EXTENSION": "DECIMAL(38, 0)",
                "HASHDIFF": "BINARY(16)",
                "EFFECTIVE_FROM": "DATE",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR(50)"
            }
        }
    }


@fixture
def satellite_sqlserver(context):
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
                "CUSTOMER_ID": "DECIMAL(38, 0)",
                "CUSTOMER_NAME": "VARCHAR(50)",
                "CUSTOMER_PHONE": "VARCHAR(50)",
                "CUSTOMER_DOB": "DATE",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR(50)"
            }
        },
        "RAW_STAGE_TS": {
            "+column_types": {
                "CUSTOMER_ID": "DECIMAL(38, 0)",
                "CUSTOMER_NAME": "VARCHAR(50)",
                "CUSTOMER_PHONE": "VARCHAR(50)",
                "CUSTOMER_DOB": "DATE",
                "LOAD_DATETIME": "DATETIME",
                "SOURCE": "VARCHAR(50)"
            }
        },
        "SATELLITE": {
            "+column_types": {
                "CUSTOMER_PK": "BINARY(16)",
                "CUSTOMER_NAME": "VARCHAR(50)",
                "CUSTOMER_PHONE": "VARCHAR(50)",
                "CUSTOMER_DOB": "DATE",
                "HASHDIFF": "BINARY(16)",
                "EFFECTIVE_FROM": "DATE",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR(50)"
            }
        },
        "SATELLITE_TS": {
            "+column_types": {
                "CUSTOMER_PK": "BINARY(16)",
                "CUSTOMER_NAME": "VARCHAR(50)",
                "CUSTOMER_PHONE": "VARCHAR(50)",
                "CUSTOMER_DOB": "DATE",
                "HASHDIFF": "BINARY(16)",
                "EFFECTIVE_FROM": "DATETIME",
                "LOAD_DATETIME": "DATETIME",
                "SOURCE": "VARCHAR(50)"
            }
        }
    }


@fixture
def satellite_cycle_sqlserver(context):
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
                "CUSTOMER_ID": "VARCHAR(50)",
                "CUSTOMER_NAME": "VARCHAR(50)",
                "CUSTOMER_DOB": "DATE",
                "EFFECTIVE_FROM": "DATE",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR(50)"
            }
        },
        "SATELLITE": {
            "+column_types": {
                "CUSTOMER_PK": "BINARY(16)",
                "CUSTOMER_NAME": "VARCHAR(50)",
                "CUSTOMER_DOB": "DATE",
                "HASHDIFF": "BINARY(16)",
                "EFFECTIVE_FROM": "DATE",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR(50)"
            }
        }
    }


@fixture
def xts_sqlserver(context):
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
                "CUSTOMER_ID": "VARCHAR(50)",
                "CUSTOMER_FIRSTNAME": "VARCHAR(50)",
                "CUSTOMER_LASTNAME": "VARCHAR(50)",
                "CUSTOMER_DOB": "DATE",
                "CUSTOMER_PHONE": "VARCHAR(50)",
                "CUSTOMER_COUNTY": "VARCHAR(50)",
                "CUSTOMER_CITY": "VARCHAR(50)",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR(50)",
            }
        },
        "RAW_STAGE_1": {
            "+column_types": {
                "CUSTOMER_ID": "VARCHAR(50)",
                "CUSTOMER_FIRSTNAME": "VARCHAR(50)",
                "CUSTOMER_LASTNAME": "VARCHAR(50)",
                "CUSTOMER_DOB": "DATE",
                "CUSTOMER_PHONE": "VARCHAR(50)",
                "CUSTOMER_COUNTY": "VARCHAR(50)",
                "CUSTOMER_CITY": "VARCHAR(50)",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR(50)",
            }
        },
        "RAW_STAGE_2": {
            "+column_types": {
                "CUSTOMER_ID": "VARCHAR(50)",
                "CUSTOMER_FIRSTNAME": "VARCHAR(50)",
                "CUSTOMER_LASTNAME": "VARCHAR(50)",
                "CUSTOMER_DOB": "DATE",
                "CUSTOMER_PHONE": "VARCHAR(50)",
                "CUSTOMER_COUNTY": "VARCHAR(50)",
                "CUSTOMER_CITY": "VARCHAR(50)",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR(50)",
            }
        },
        "RAW_STAGE_2SAT": {
            "+column_types": {
                "CUSTOMER_ID": "VARCHAR(50)",
                "CUSTOMER_FIRSTNAME": "VARCHAR(50)",
                "CUSTOMER_LASTNAME": "VARCHAR(50)",
                "CUSTOMER_DOB": "DATE",
                "CUSTOMER_PHONE": "VARCHAR(50)",
                "CUSTOMER_COUNTY": "VARCHAR(50)",
                "CUSTOMER_CITY": "VARCHAR(50)",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR(50)",
            }
        },
        "RAW_STAGE_2SAT_1": {
            "+column_types": {
                "CUSTOMER_ID": "VARCHAR(50)",
                "CUSTOMER_FIRSTNAME": "VARCHAR(50)",
                "CUSTOMER_LASTNAME": "VARCHAR(50)",
                "CUSTOMER_DOB": "DATE",
                "CUSTOMER_PHONE": "VARCHAR(50)",
                "CUSTOMER_COUNTY": "VARCHAR(50)",
                "CUSTOMER_CITY": "VARCHAR(50)",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR(50)",
            }
        },
        "RAW_STAGE_2SAT_2": {
            "+column_types": {
                "CUSTOMER_ID": "VARCHAR(50)",
                "CUSTOMER_FIRSTNAME": "VARCHAR(50)",
                "CUSTOMER_LASTNAME": "VARCHAR(50)",
                "CUSTOMER_DOB": "DATE",
                "CUSTOMER_PHONE": "VARCHAR(50)",
                "CUSTOMER_COUNTY": "VARCHAR(50)",
                "CUSTOMER_CITY": "VARCHAR(50)",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR(50)",
            }
        },
        "RAW_STAGE_3SAT": {
            "+column_types": {
                "CUSTOMER_ID": "VARCHAR(50)",
                "CUSTOMER_FIRSTNAME": "VARCHAR(50)",
                "CUSTOMER_LASTNAME": "VARCHAR(50)",
                "CUSTOMER_DOB": "DATE",
                "CUSTOMER_PHONE": "VARCHAR(50)",
                "CUSTOMER_COUNTY": "VARCHAR(50)",
                "CUSTOMER_CITY": "VARCHAR(50)",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR(50)",
            }
        },
        "STG_CUSTOMER": {
            "+column_types": {
                "CUSTOMER_PK": "BINARY(16)",
                "HASHDIFF": "BINARY(16)",
                "EFFECTIVE_FROM": "DATE",
                "SATELLITE_NAME": "VARCHAR(50)",
                "CUSTOMER_ID": "VARCHAR(50)",
                "CUSTOMER_FIRSTNAME": "VARCHAR(50)",
                "CUSTOMER_LASTNAME": "VARCHAR(50)",
                "CUSTOMER_DOB": "DATE",
                "CUSTOMER_PHONE": "VARCHAR(50)",
                "CUSTOMER_COUNTY": "VARCHAR(50)",
                "CUSTOMER_CITY": "VARCHAR(50)",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR(50)"
            }
        },
        "STG_CUSTOMER_2SAT": {
            "+column_types": {
                "CUSTOMER_PK": "BINARY(16)",
                "HASHDIFF_1": "BINARY(16)",
                "HASHDIFF_2": "BINARY(16)",
                "EFFECTIVE_FROM": "DATE",
                "SATELLITE_1": "VARCHAR(50)",
                "SATELLITE_2": "VARCHAR(50)",
                "CUSTOMER_ID": "VARCHAR(50)",
                "CUSTOMER_FIRSTNAME": "VARCHAR(50)",
                "CUSTOMER_LASTNAME": "VARCHAR(50)",
                "CUSTOMER_DOB": "DATE",
                "CUSTOMER_PHONE": "VARCHAR(50)",
                "CUSTOMER_COUNTY": "VARCHAR(50)",
                "CUSTOMER_CITY": "VARCHAR(50)",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR(50)"
            }
        },
        "STG_CUSTOMER_3SAT": {
            "+column_types": {
                "CUSTOMER_PK": "BINARY(16)",
                "HASHDIFF_1": "BINARY(16)",
                "HASHDIFF_2": "BINARY(16)",
                "HASHDIFF_3": "BINARY(16)",
                "EFFECTIVE_FROM": "DATE",
                "SATELLITE_1": "VARCHAR(50)",
                "SATELLITE_2": "VARCHAR(50)",
                "SATELLITE_3": "VARCHAR(50)",
                "CUSTOMER_ID": "VARCHAR(50)",
                "CUSTOMER_FIRSTNAME": "VARCHAR(50)",
                "CUSTOMER_LASTNAME": "VARCHAR(50)",
                "CUSTOMER_DOB": "DATE",
                "CUSTOMER_PHONE": "VARCHAR(50)",
                "CUSTOMER_COUNTY": "VARCHAR(50)",
                "CUSTOMER_CITY": "VARCHAR(50)",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR(50)"
            }
        },
        "XTS": {
            "+column_types": {
                "CUSTOMER_PK": "BINARY(16)",
                "LOAD_DATE": "DATE",
                "SATELLITE_NAME": "VARCHAR(50)",
                "HASHDIFF": "BINARY(16)",
                "SOURCE": "VARCHAR(50)"
            }
        },
        "XTS_2SAT": {
            "+column_types": {
                "CUSTOMER_PK": "BINARY(16)",
                "SATELLITE_NAME": "VARCHAR(50)",
                "HASHDIFF": "BINARY(16)",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR(50)"
            }
        },
        "XTS_3SAT": {
            "+column_types": {
                "CUSTOMER_PK": "BINARY(16)",
                "SATELLITE_NAME": "VARCHAR(50)",
                "HASHDIFF": "BINARY(16)",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR(50)"
            }
        }
    }

@fixture
def out_of_sequence_satellite_sqlserver(context):
    context.vault_structure_type = "xts"

    context.hashed_columns = {
        "STG_CUSTOMER": {
            "CUSTOMER_PK": "CUSTOMER_ID",
            "HASHDIFF": {"is_hashdiff": True,
                         "columns": ["CUSTOMER_ID", "CUSTOMER_DOB", "CUSTOMER_PHONE", "CUSTOMER_NAME"]}
        },
        "STG_CUSTOMER_TIMESTAMP": {
            "CUSTOMER_PK": "CUSTOMER_ID",
            "HASHDIFF": {"is_hashdiff": True,
                         "columns": ["CUSTOMER_ID", "CUSTOMER_DOB", "CUSTOMER_PHONE", "CUSTOMER_NAME"]}
        }
    }

    context.derived_columns = {
        "STG_CUSTOMER": {
            "EFFECTIVE_FROM": "LOAD_DATE",
            "SATELLITE_NAME": "!SAT_CUSTOMER_OOS"
        },
        "STG_CUSTOMER_TIMESTAMP": {
            "EFFECTIVE_FROM": "LOAD_DATETIME",
            "SATELLITE_NAME": "!SAT_CUSTOMER_OOS_TIMESTAMP"
        }
    }

    context.vault_structure_columns = {
        "SAT_CUSTOMER_OOS": {
            "src_pk": "CUSTOMER_PK",
            "src_payload": ["CUSTOMER_NAME", "CUSTOMER_PHONE", "CUSTOMER_DOB"],
            "src_hashdiff": "HASHDIFF",
            "src_eff": "EFFECTIVE_FROM",
            "src_ldts": "LOAD_DATE",
            "src_source": "SOURCE",
            "out_of_sequence": {
                "source_xts": "XTS",
                "sat_name_col": "SATELLITE_NAME",
                "insert_date": "1993-01-03"
            }
        },
        "SAT_CUSTOMER_OOS_EARLY": {
            "src_pk": "CUSTOMER_PK",
            "src_payload": ["CUSTOMER_NAME", "CUSTOMER_PHONE", "CUSTOMER_DOB"],
            "src_hashdiff": "HASHDIFF",
            "src_eff": "EFFECTIVE_FROM",
            "src_ldts": "LOAD_DATE",
            "src_source": "SOURCE",
            "out_of_sequence": {
                "source_xts": "XTS",
                "sat_name_col": "SATELLITE_NAME",
                "insert_date": "1992-12-31"
            }
        },
        "SAT_CUSTOMER_OOS_LATE": {
            "src_pk": "CUSTOMER_PK",
            "src_payload": ["CUSTOMER_NAME", "CUSTOMER_PHONE", "CUSTOMER_DOB"],
            "src_hashdiff": "HASHDIFF",
            "src_eff": "EFFECTIVE_FROM",
            "src_ldts": "LOAD_DATE",
            "src_source": "SOURCE",
            "out_of_sequence": {
                "source_xts": "XTS",
                "sat_name_col": "SATELLITE_NAME",
                "insert_date": "1993-01-09"
            }
        },
        "SATELLITE": {
            "src_pk": "CUSTOMER_PK",
            "src_payload": ["CUSTOMER_NAME", "CUSTOMER_PHONE", "CUSTOMER_DOB"],
            "src_hashdiff": "HASHDIFF",
            "src_eff": "EFFECTIVE_FROM",
            "src_ldts": "LOAD_DATE",
            "src_source": "SOURCE"
        },
        "SAT_CUSTOMER_OOS_TIMESTAMP": {
            "src_pk": "CUSTOMER_PK",
            "src_payload": ["CUSTOMER_NAME", "CUSTOMER_PHONE", "CUSTOMER_DOB"],
            "src_hashdiff": "HASHDIFF",
            "src_eff": "EFFECTIVE_FROM",
            "src_ldts": "LOAD_DATETIME",
            "src_source": "SOURCE",
            "out_of_sequence": {
                "source_xts": "XTS_TIMESTAMP",
                "sat_name_col": "SATELLITE_NAME",
                "insert_timestamp": "1993-01-01 01:01:03"
            }
        },
        "XTS": {
            "src_pk": "CUSTOMER_PK",
            "src_ldts": "LOAD_DATE",
            "src_satellite": {
                "SAT_CUSTOMER_OOS": {
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
        "XTS_TIMESTAMP": {
            "src_pk": "CUSTOMER_PK",
            "src_ldts": "LOAD_DATETIME",
            "src_satellite": {
                "SAT_CUSTOMER_OOS_TIMESTAMP": {
                    "sat_name": {
                        "SATELLITE_NAME": "SATELLITE_NAME"
                    },
                    "hashdiff": {
                        "HASHDIFF": "HASHDIFF"
                    }
                },
            },
            "src_source": "SOURCE"
        }
    }

    context.seed_config = {
        "RAW_STAGE": {
            "+column_types": {
                "CUSTOMER_ID": "DECIMAL(38, 0)",
                "CUSTOMER_NAME": "VARCHAR(50)",
                "CUSTOMER_PHONE": "VARCHAR(50)",
                "CUSTOMER_DOB": "DATE",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR(50)",
                "EFFECTIVE_FROM": "DATE"
            }
        },
        "RAW_STAGE_TIMESTAMP": {
            "+column_types": {
                "CUSTOMER_ID": "DECIMAL(38, 0)",
                "CUSTOMER_NAME": "VARCHAR(50)",
                "CUSTOMER_PHONE": "VARCHAR(50)",
                "CUSTOMER_DOB": "DATE",
                "LOAD_DATETIME": "DATETIME",
                "SOURCE": "VARCHAR(50)",
                "EFFECTIVE_FROM": "DATE"
    }
        },
        "SAT_CUSTOMER_OOS": {
            "+column_types": {
                "CUSTOMER_PK": "BINARY(16)",
                "CUSTOMER_NAME": "VARCHAR(50)",
                "CUSTOMER_PHONE": "VARCHAR(50)",
                "CUSTOMER_DOB": "DATE",
                "HASHDIFF": "BINARY(16)",
                "EFFECTIVE_FROM": "DATE",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR(50)"
            }
        },
        "SAT_CUSTOMER_OOS_EARLY": {
            "+column_types": {
                "CUSTOMER_PK": "BINARY(16)",
                "CUSTOMER_NAME": "VARCHAR(50)",
                "CUSTOMER_PHONE": "VARCHAR(50)",
                "CUSTOMER_DOB": "DATE",
                "HASHDIFF": "BINARY(16)",
                "EFFECTIVE_FROM": "DATE",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR(50)"
            }
        },
        "SAT_CUSTOMER_OOS_LATE": {
            "+column_types": {
                "CUSTOMER_PK": "BINARY(16)",
                "CUSTOMER_NAME": "VARCHAR(50)",
                "CUSTOMER_PHONE": "VARCHAR(50)",
                "CUSTOMER_DOB": "DATE",
                "HASHDIFF": "BINARY(16)",
                "EFFECTIVE_FROM": "DATE",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR(50)"
            }
        },
        "SATELLITE": {
            "+column_types": {
                "CUSTOMER_PK": "BINARY(16)",
                "CUSTOMER_NAME": "VARCHAR(50)",
                "CUSTOMER_PHONE": "VARCHAR(50)",
                "CUSTOMER_DOB": "DATE",
                "HASHDIFF": "BINARY(16)",
                "EFFECTIVE_FROM": "DATE",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR(50)"
            }
        },
        "SAT_CUSTOMER_OOS_TIMESTAMP": {
            "+column_types": {
                "CUSTOMER_PK": "BINARY(16)",
                "CUSTOMER_NAME": "VARCHAR(50)",
                "CUSTOMER_PHONE": "VARCHAR(50)",
                "CUSTOMER_DOB": "DATE",
                "HASHDIFF": "BINARY(16)",
                "EFFECTIVE_FROM": "DATETIME",
                "LOAD_DATETIME": "DATETIME",
                "SOURCE": "VARCHAR(50)"
            }
        },
        "XTS": {
            "+column_types": {
                "CUSTOMER_PK": "BINARY(16)",
                "LOAD_DATE": "DATE",
                "SATELLITE_NAME": "VARCHAR(50)",
                "HASHDIFF": "BINARY(16)",
                "SOURCE": "VARCHAR(50)"
            }
        },
        "XTS_TIMESTAMP": {
            "+column_types": {
                "CUSTOMER_PK": "BINARY(16)",
                "LOAD_DATETIME": "DATETIME",
                "SATELLITE_NAME": "VARCHAR(50)",
                "HASHDIFF": "BINARY(16)",
                "SOURCE": "VARCHAR(50)"
            }
        }
    }


@fixture
def cycle_sqlserver(context):
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
                "CUSTOMER_ID": "VARCHAR(50)",
                "CUSTOMER_NAME": "VARCHAR(50)",
                "CUSTOMER_DOB": "DATE",
                "EFFECTIVE_FROM": "DATE",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR(50)"
            }
        },
        "RAW_STAGE_BOOKING": {
            "+column_types": {
                "BOOKING_ID": "VARCHAR(50)",
                "CUSTOMER_ID": "VARCHAR(50)",
                "PRICE": "DECIMAL(38,2)",
                "DEPARTURE_DATE": "DATE",
                "BOOKING_DATE": "DATE",
                "PHONE": "VARCHAR(50)",
                "DESTINATION": "VARCHAR(50)",
                "NATIONALITY": "VARCHAR(50)",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR(50)"
            }
        },
        "HUB_CUSTOMER": {
            "+column_types": {
                "CUSTOMER_PK": "BINARY(16)",
                "CUSTOMER_ID": "VARCHAR(50)",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR(50)"
            }
        },
        "HUB_BOOKING": {
            "+column_types": {
                "BOOKING_PK": "BINARY(16)",
                "BOOKING_ID": "VARCHAR(50)",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR(50)"
            }
        },
        "LINK_CUSTOMER_BOOKING": {
            "+column_types": {
                "CUSTOMER_BOOKING_PK": "BINARY(16)",
                "CUSTOMER_PK": "BINARY(16)",
                "BOOKING_PK": "BINARY(16)",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR(50)"
            }
        },
        "SAT_CUST_CUSTOMER_DETAILS": {
            "+column_types": {
                "CUSTOMER_PK": "BINARY(16)",
                "HASHDIFF": "BINARY(16)",
                "CUSTOMER_NAME": "VARCHAR(50)",
                "CUSTOMER_DOB": "DATE",
                "EFFECTIVE_FROM": "DATE",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR(50)"
            }
        },
        "SAT_BOOK_CUSTOMER_DETAILS": {
            "+column_types": {
                "CUSTOMER_PK": "BINARY(16)",
                "HASHDIFF": "BINARY(16)",
                "PHONE": "VARCHAR(50)",
                "NATIONALITY": "VARCHAR(50)",
                "EFFECTIVE_FROM": "DATE",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR(50)"
            }
        },
        "SAT_BOOK_BOOKING_DETAILS": {
            "+column_types": {
                "BOOKING_PK": "BINARY(16)",
                "HASHDIFF": "BINARY(16)",
                "PRICE": "DECIMAL(38,2)",
                "BOOKING_DATE": "DATE",
                "DEPARTURE_DATE": "DATE",
                "DESTINATION": "VARCHAR(50)",
                "EFFECTIVE_FROM": "DATE",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR(50)"
            }
        }
    }
