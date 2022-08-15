from behave import fixture


@fixture
def cycle_snowflake(context):
    """
    Define the structures and metadata to perform vault load cycles
    """

    context.null_columns = {
        "STG_CUSTOMER": {
            "required": "CUSTOMER_ID"
        },
        "STG_BOOKING": {
            "required": ["BOOKING_ID", "CUSTOMER_ID"],
            "optional": "PHONE"
        }
    }

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
            "column_types": {
                "CUSTOMER_ID": "VARCHAR",
                "CUSTOMER_NAME": "VARCHAR",
                "CUSTOMER_DOB": "DATE",
                "EFFECTIVE_FROM": "DATE",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR"
            }
        },
        "RAW_STAGE_BOOKING": {
            "column_types": {
                "BOOKING_ID": "VARCHAR",
                "CUSTOMER_ID": "VARCHAR",
                "PRICE": "NUMBER(38,2)",
                "DEPARTURE_DATE": "DATE",
                "BOOKING_DATE": "DATE",
                "PHONE": "VARCHAR",
                "DESTINATION": "VARCHAR",
                "NATIONALITY": "VARCHAR",
                "LOAD_DATE": "DATE",
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
        "HUB_BOOKING": {
            "column_types": {
                "BOOKING_PK": "BINARY(16)",
                "BOOKING_ID": "VARCHAR",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR"
            }
        },
        "LINK_CUSTOMER_BOOKING": {
            "column_types": {
                "CUSTOMER_BOOKING_PK": "BINARY(16)",
                "CUSTOMER_PK": "BINARY(16)",
                "BOOKING_PK": "BINARY(16)",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR"
            }
        },
        "SAT_CUST_CUSTOMER_DETAILS": {
            "column_types": {
                "CUSTOMER_PK": "BINARY(16)",
                "HASHDIFF": "BINARY(16)",
                "CUSTOMER_NAME": "VARCHAR",
                "CUSTOMER_DOB": "DATE",
                "EFFECTIVE_FROM": "DATE",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR"
            }
        },
        "SAT_BOOK_CUSTOMER_DETAILS": {
            "column_types": {
                "CUSTOMER_PK": "BINARY(16)",
                "HASHDIFF": "BINARY(16)",
                "PHONE": "VARCHAR",
                "NATIONALITY": "VARCHAR",
                "EFFECTIVE_FROM": "DATE",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR"
            }
        },
        "SAT_BOOK_BOOKING_DETAILS": {
            "column_types": {
                "BOOKING_PK": "BINARY(16)",
                "HASHDIFF": "BINARY(16)",
                "PRICE": "NUMBER(38,2)",
                "BOOKING_DATE": "DATE",
                "DEPARTURE_DATE": "DATE",
                "DESTINATION": "VARCHAR",
                "EFFECTIVE_FROM": "DATE",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR"
            }
        }
    }


@fixture
def cycle_custom_null_key_snowflake(context):
    """
    Define the structures and metadata to perform vault load cycles
    """

    context.null_columns = {
        "STG_CUSTOMER": {
            "required": "CUSTOMER_ID"
        },
        "STG_BOOKING": {
            "required": ["BOOKING_ID", "CUSTOMER_ID"],
            "optional": "PHONE"
        }
    }

    context.null_key_required = "-6"

    context.null_key_optional = "-9"

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
            "column_types": {
                "CUSTOMER_ID": "VARCHAR",
                "CUSTOMER_NAME": "VARCHAR",
                "CUSTOMER_DOB": "DATE",
                "EFFECTIVE_FROM": "DATE",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR"
            }
        },
        "RAW_STAGE_BOOKING": {
            "column_types": {
                "BOOKING_ID": "VARCHAR",
                "CUSTOMER_ID": "VARCHAR",
                "PRICE": "NUMBER(38,2)",
                "DEPARTURE_DATE": "DATE",
                "BOOKING_DATE": "DATE",
                "PHONE": "VARCHAR",
                "DESTINATION": "VARCHAR",
                "NATIONALITY": "VARCHAR",
                "LOAD_DATE": "DATE",
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
        "HUB_BOOKING": {
            "column_types": {
                "BOOKING_PK": "BINARY(16)",
                "BOOKING_ID": "VARCHAR",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR"
            }
        },
        "LINK_CUSTOMER_BOOKING": {
            "column_types": {
                "CUSTOMER_BOOKING_PK": "BINARY(16)",
                "CUSTOMER_PK": "BINARY(16)",
                "BOOKING_PK": "BINARY(16)",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR"
            }
        },
        "SAT_CUST_CUSTOMER_DETAILS": {
            "column_types": {
                "CUSTOMER_PK": "BINARY(16)",
                "HASHDIFF": "BINARY(16)",
                "CUSTOMER_NAME": "VARCHAR",
                "CUSTOMER_DOB": "DATE",
                "EFFECTIVE_FROM": "DATE",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR"
            }
        },
        "SAT_BOOK_CUSTOMER_DETAILS": {
            "column_types": {
                "CUSTOMER_PK": "BINARY(16)",
                "HASHDIFF": "BINARY(16)",
                "PHONE": "VARCHAR",
                "NATIONALITY": "VARCHAR",
                "EFFECTIVE_FROM": "DATE",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR"
            }
        },
        "SAT_BOOK_BOOKING_DETAILS": {
            "column_types": {
                "BOOKING_PK": "BINARY(16)",
                "HASHDIFF": "BINARY(16)",
                "PRICE": "NUMBER(38,2)",
                "BOOKING_DATE": "DATE",
                "DEPARTURE_DATE": "DATE",
                "DESTINATION": "VARCHAR",
                "EFFECTIVE_FROM": "DATE",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR"
            }
        }
    }


@fixture
def cycle_bigquery(context):
    """
    Define the structures and metadata to perform vault load cycles
    """

    context.null_columns = {
        "STG_CUSTOMER": {
            "required": "CUSTOMER_ID"
        },
        "STG_BOOKING": {
            "required": ["BOOKING_ID", "CUSTOMER_ID"],
            "optional": "PHONE"
        }
    }

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
            "column_types": {
                "CUSTOMER_ID": "STRING",
                "CUSTOMER_NAME": "STRING",
                "CUSTOMER_DOB": "DATE",
                "EFFECTIVE_FROM": "DATE",
                "LOAD_DATE": "DATE",
                "SOURCE": "STRING"
            }
        },
        "RAW_STAGE_BOOKING": {
            "column_types": {
                "BOOKING_ID": "STRING",
                "CUSTOMER_ID": "STRING",
                "PRICE": "STRING",
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
            "column_types": {
                "CUSTOMER_PK": "STRING",
                "CUSTOMER_ID": "STRING",
                "LOAD_DATE": "DATE",
                "SOURCE": "STRING"
            }
        },
        "HUB_BOOKING": {
            "column_types": {
                "BOOKING_PK": "STRING",
                "BOOKING_ID": "STRING",
                "LOAD_DATE": "DATE",
                "SOURCE": "STRING"
            }
        },
        "LINK_CUSTOMER_BOOKING": {
            "column_types": {
                "CUSTOMER_BOOKING_PK": "STRING",
                "CUSTOMER_PK": "STRING",
                "BOOKING_PK": "STRING",
                "LOAD_DATE": "DATE",
                "SOURCE": "STRING"
            }
        },
        "SAT_CUST_CUSTOMER_DETAILS": {
            "column_types": {
                "CUSTOMER_PK": "STRING",
                "HASHDIFF": "STRING",
                "CUSTOMER_NAME": "STRING",
                "CUSTOMER_DOB": "DATE",
                "EFFECTIVE_FROM": "DATE",
                "LOAD_DATE": "DATE",
                "SOURCE": "STRING"
            }
        },
        "SAT_BOOK_CUSTOMER_DETAILS": {
            "column_types": {
                "CUSTOMER_PK": "STRING",
                "HASHDIFF": "STRING",
                "PHONE": "STRING",
                "NATIONALITY": "STRING",
                "EFFECTIVE_FROM": "DATE",
                "LOAD_DATE": "DATE",
                "SOURCE": "STRING"
            }
        },
        "SAT_BOOK_BOOKING_DETAILS": {
            "column_types": {
                "BOOKING_PK": "STRING",
                "HASHDIFF": "STRING",
                "PRICE": "STRING",
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
def cycle_custom_null_key_bigquery(context):
    """
    Define the structures and metadata to perform vault load cycles
    """

    context.null_columns = {
        "STG_CUSTOMER": {
            "required": "CUSTOMER_ID"
        },
        "STG_BOOKING": {
            "required": ["BOOKING_ID", "CUSTOMER_ID"],
            "optional": "PHONE"
        }
    }

    context.null_key_required = "-6"

    context.null_key_optional = "-9"

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
            "column_types": {
                "CUSTOMER_ID": "STRING",
                "CUSTOMER_NAME": "STRING",
                "CUSTOMER_DOB": "DATE",
                "EFFECTIVE_FROM": "DATE",
                "LOAD_DATE": "DATE",
                "SOURCE": "STRING"
            }
        },
        "RAW_STAGE_BOOKING": {
            "column_types": {
                "BOOKING_ID": "STRING",
                "CUSTOMER_ID": "STRING",
                "PRICE": "STRING",
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
            "column_types": {
                "CUSTOMER_PK": "STRING",
                "CUSTOMER_ID": "STRING",
                "LOAD_DATE": "DATE",
                "SOURCE": "STRING"
            }
        },
        "HUB_BOOKING": {
            "column_types": {
                "BOOKING_PK": "STRING",
                "BOOKING_ID": "STRING",
                "LOAD_DATE": "DATE",
                "SOURCE": "STRING"
            }
        },
        "LINK_CUSTOMER_BOOKING": {
            "column_types": {
                "CUSTOMER_BOOKING_PK": "STRING",
                "CUSTOMER_PK": "STRING",
                "BOOKING_PK": "STRING",
                "LOAD_DATE": "DATE",
                "SOURCE": "STRING"
            }
        },
        "SAT_CUST_CUSTOMER_DETAILS": {
            "column_types": {
                "CUSTOMER_PK": "STRING",
                "HASHDIFF": "STRING",
                "CUSTOMER_NAME": "STRING",
                "CUSTOMER_DOB": "DATE",
                "EFFECTIVE_FROM": "DATE",
                "LOAD_DATE": "DATE",
                "SOURCE": "STRING"
            }
        },
        "SAT_BOOK_CUSTOMER_DETAILS": {
            "column_types": {
                "CUSTOMER_PK": "STRING",
                "HASHDIFF": "STRING",
                "PHONE": "STRING",
                "NATIONALITY": "STRING",
                "EFFECTIVE_FROM": "DATE",
                "LOAD_DATE": "DATE",
                "SOURCE": "STRING"
            }
        },
        "SAT_BOOK_BOOKING_DETAILS": {
            "column_types": {
                "BOOKING_PK": "STRING",
                "HASHDIFF": "STRING",
                "PRICE": "STRING",
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
def cycle_sqlserver(context):
    """
    Define the structures and metadata to perform vault load cycles
    """

    context.null_columns = {
        "STG_CUSTOMER": {
            "required": "CUSTOMER_ID"
        },
        "STG_BOOKING": {
            "required": ["BOOKING_ID", "CUSTOMER_ID"],
            "optional": "PHONE"
        }
    }

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
            "column_types": {
                "CUSTOMER_ID": "VARCHAR(50)",
                "CUSTOMER_NAME": "VARCHAR(50)",
                "CUSTOMER_DOB": "DATE",
                "EFFECTIVE_FROM": "DATE",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR(50)"
            }
        },
        "RAW_STAGE_BOOKING": {
            "column_types": {
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
            "column_types": {
                "CUSTOMER_PK": "BINARY(16)",
                "CUSTOMER_ID": "VARCHAR(50)",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR(50)"
            }
        },
        "HUB_BOOKING": {
            "column_types": {
                "BOOKING_PK": "BINARY(16)",
                "BOOKING_ID": "VARCHAR(50)",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR(50)"
            }
        },
        "LINK_CUSTOMER_BOOKING": {
            "column_types": {
                "CUSTOMER_BOOKING_PK": "BINARY(16)",
                "CUSTOMER_PK": "BINARY(16)",
                "BOOKING_PK": "BINARY(16)",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR(50)"
            }
        },
        "SAT_CUST_CUSTOMER_DETAILS": {
            "column_types": {
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
            "column_types": {
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
            "column_types": {
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


@fixture
def cycle_custom_null_key_sqlserver(context):
    """
    Define the structures and metadata to perform vault load cycles
    """

    context.null_columns = {
        "STG_CUSTOMER": {
            "required": "CUSTOMER_ID"
        },
        "STG_BOOKING": {
            "required": ["BOOKING_ID", "CUSTOMER_ID"],
            "optional": "PHONE"
        }
    }

    context.null_key_required = "-6"

    context.null_key_optional = "-9"

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
            "column_types": {
                "CUSTOMER_ID": "VARCHAR(50)",
                "CUSTOMER_NAME": "VARCHAR(50)",
                "CUSTOMER_DOB": "DATE",
                "EFFECTIVE_FROM": "DATE",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR(50)"
            }
        },
        "RAW_STAGE_BOOKING": {
            "column_types": {
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
            "column_types": {
                "CUSTOMER_PK": "BINARY(16)",
                "CUSTOMER_ID": "VARCHAR(50)",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR(50)"
            }
        },
        "HUB_BOOKING": {
            "column_types": {
                "BOOKING_PK": "BINARY(16)",
                "BOOKING_ID": "VARCHAR(50)",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR(50)"
            }
        },
        "LINK_CUSTOMER_BOOKING": {
            "column_types": {
                "CUSTOMER_BOOKING_PK": "BINARY(16)",
                "CUSTOMER_PK": "BINARY(16)",
                "BOOKING_PK": "BINARY(16)",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR(50)"
            }
        },
        "SAT_CUST_CUSTOMER_DETAILS": {
            "column_types": {
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
            "column_types": {
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
            "column_types": {
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
