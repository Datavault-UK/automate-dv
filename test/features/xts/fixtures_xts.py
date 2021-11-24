from behave import fixture


@fixture
def xts(context):
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
        "XTS_COMPPK": {
            "src_pk": ["CUSTOMER_PK", "CUSTOMER_PHONE"],
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
                "CUSTOMER_ID": "VARCHAR",
                "CUSTOMER_FIRSTNAME": "VARCHAR",
                "CUSTOMER_LASTNAME": "VARCHAR",
                "CUSTOMER_DOB": "DATE",
                "CUSTOMER_PHONE": "VARCHAR",
                "CUSTOMER_COUNTY": "VARCHAR",
                "CUSTOMER_CITY": "VARCHAR",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR",
            }
        },
        "RAW_STAGE_1": {
            "+column_types": {
                "CUSTOMER_ID": "VARCHAR",
                "CUSTOMER_FIRSTNAME": "VARCHAR",
                "CUSTOMER_LASTNAME": "VARCHAR",
                "CUSTOMER_DOB": "DATE",
                "CUSTOMER_PHONE": "VARCHAR",
                "CUSTOMER_COUNTY": "VARCHAR",
                "CUSTOMER_CITY": "VARCHAR",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR",
            }
        },
        "RAW_STAGE_2": {
            "+column_types": {
                "CUSTOMER_ID": "VARCHAR",
                "CUSTOMER_FIRSTNAME": "VARCHAR",
                "CUSTOMER_LASTNAME": "VARCHAR",
                "CUSTOMER_DOB": "DATE",
                "CUSTOMER_PHONE": "VARCHAR",
                "CUSTOMER_COUNTY": "VARCHAR",
                "CUSTOMER_CITY": "VARCHAR",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR",
            }
        },
        "RAW_STAGE_2SAT": {
            "+column_types": {
                "CUSTOMER_ID": "VARCHAR",
                "CUSTOMER_FIRSTNAME": "VARCHAR",
                "CUSTOMER_LASTNAME": "VARCHAR",
                "CUSTOMER_DOB": "DATE",
                "CUSTOMER_PHONE": "VARCHAR",
                "CUSTOMER_COUNTY": "VARCHAR",
                "CUSTOMER_CITY": "VARCHAR",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR",
            }
        },
        "RAW_STAGE_2SAT_1": {
            "+column_types": {
                "CUSTOMER_ID": "VARCHAR",
                "CUSTOMER_FIRSTNAME": "VARCHAR",
                "CUSTOMER_LASTNAME": "VARCHAR",
                "CUSTOMER_DOB": "DATE",
                "CUSTOMER_PHONE": "VARCHAR",
                "CUSTOMER_COUNTY": "VARCHAR",
                "CUSTOMER_CITY": "VARCHAR",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR",
            }
        },
        "RAW_STAGE_2SAT_2": {
            "+column_types": {
                "CUSTOMER_ID": "VARCHAR",
                "CUSTOMER_FIRSTNAME": "VARCHAR",
                "CUSTOMER_LASTNAME": "VARCHAR",
                "CUSTOMER_DOB": "DATE",
                "CUSTOMER_PHONE": "VARCHAR",
                "CUSTOMER_COUNTY": "VARCHAR",
                "CUSTOMER_CITY": "VARCHAR",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR",
            }
        },
        "RAW_STAGE_3SAT": {
            "+column_types": {
                "CUSTOMER_ID": "VARCHAR",
                "CUSTOMER_FIRSTNAME": "VARCHAR",
                "CUSTOMER_LASTNAME": "VARCHAR",
                "CUSTOMER_DOB": "DATE",
                "CUSTOMER_PHONE": "VARCHAR",
                "CUSTOMER_COUNTY": "VARCHAR",
                "CUSTOMER_CITY": "VARCHAR",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR",
            }
        },
        "STG_CUSTOMER": {
            "+column_types": {
                "CUSTOMER_PK": "BINARY(16)",
                "HASHDIFF": "BINARY(16)",
                "EFFECTIVE_FROM": "DATE",
                "SATELLITE_NAME": "VARCHAR",
                "CUSTOMER_ID": "VARCHAR",
                "CUSTOMER_FIRSTNAME": "VARCHAR",
                "CUSTOMER_LASTNAME": "VARCHAR",
                "CUSTOMER_DOB": "DATE",
                "CUSTOMER_PHONE": "VARCHAR",
                "CUSTOMER_COUNTY": "VARCHAR",
                "CUSTOMER_CITY": "VARCHAR",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR"
            }
        },
        "STG_CUSTOMER_2SAT": {
            "+column_types": {
                "CUSTOMER_PK": "BINARY(16)",
                "HASHDIFF_1": "BINARY(16)",
                "HASHDIFF_2": "BINARY(16)",
                "EFFECTIVE_FROM": "DATE",
                "SATELLITE_1": "VARCHAR",
                "SATELLITE_2": "VARCHAR",
                "CUSTOMER_ID": "VARCHAR",
                "CUSTOMER_FIRSTNAME": "VARCHAR",
                "CUSTOMER_LASTNAME": "VARCHAR",
                "CUSTOMER_DOB": "DATE",
                "CUSTOMER_PHONE": "VARCHAR",
                "CUSTOMER_COUNTY": "VARCHAR",
                "CUSTOMER_CITY": "VARCHAR",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR"
            }
        },
        "STG_CUSTOMER_3SAT": {
            "+column_types": {
                "CUSTOMER_PK": "BINARY(16)",
                "HASHDIFF_1": "BINARY(16)",
                "HASHDIFF_2": "BINARY(16)",
                "HASHDIFF_3": "BINARY(16)",
                "EFFECTIVE_FROM": "DATE",
                "SATELLITE_1": "VARCHAR",
                "SATELLITE_2": "VARCHAR",
                "SATELLITE_3": "VARCHAR",
                "CUSTOMER_ID": "VARCHAR",
                "CUSTOMER_FIRSTNAME": "VARCHAR",
                "CUSTOMER_LASTNAME": "VARCHAR",
                "CUSTOMER_DOB": "DATE",
                "CUSTOMER_PHONE": "VARCHAR",
                "CUSTOMER_COUNTY": "VARCHAR",
                "CUSTOMER_CITY": "VARCHAR",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR"
            }
        },
        "XTS": {
            "+column_types": {
                "CUSTOMER_PK": "BINARY(16)",
                "LOAD_DATE": "DATE",
                "SATELLITE_NAME": "VARCHAR",
                "HASHDIFF": "BINARY(16)",
                "SOURCE": "VARCHAR"
            }
        },
        "XTS_COMPPK": {
            "+column_types": {
                "CUSTOMER_PK": "BINARY(16)",
                "CUSTOMER_PHONE": "VARCHAR",
                "LOAD_DATE": "DATE",
                "SATELLITE_NAME": "VARCHAR",
                "HASHDIFF": "BINARY(16)",
                "SOURCE": "VARCHAR"
            }
        },
        "XTS_2SAT": {
            "+column_types": {
                "CUSTOMER_PK": "BINARY(16)",
                "SATELLITE_NAME": "VARCHAR",
                "HASHDIFF": "BINARY(16)",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR"
            }
        },
        "XTS_3SAT": {
            "+column_types": {
                "CUSTOMER_PK": "BINARY(16)",
                "SATELLITE_NAME": "VARCHAR",
                "HASHDIFF": "BINARY(16)",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR"
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
        "XTS_COMPPK": {
            "src_pk": ["CUSTOMER_PK", "CUSTOMER_PHONE"],
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
                "CUSTOMER_PK": "STRING",
                "HASHDIFF": "STRING",
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
                "CUSTOMER_PK": "STRING",
                "HASHDIFF_1": "STRING",
                "HASHDIFF_2": "STRING",
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
                "CUSTOMER_PK": "STRING",
                "HASHDIFF_1": "STRING",
                "HASHDIFF_2": "STRING",
                "HASHDIFF_3": "STRING",
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
                "CUSTOMER_PK": "STRING",
                "LOAD_DATE": "DATE",
                "SATELLITE_NAME": "STRING",
                "HASHDIFF": "STRING",
                "SOURCE": "STRING"
            }
        },
        "XTS_COMPPK": {
            "+column_types": {
                "CUSTOMER_PK": "STRING",
                "CUSTOMER_PHONE": "STRING",
                "LOAD_DATE": "DATE",
                "SATELLITE_NAME": "STRING",
                "HASHDIFF": "STRING",
                "SOURCE": "STRING"
            }
        },
        "XTS_2SAT": {
            "+column_types": {
                "CUSTOMER_PK": "STRING",
                "SATELLITE_NAME": "STRING",
                "HASHDIFF": "STRING",
                "LOAD_DATE": "DATE",
                "SOURCE": "STRING"
            }
        },
        "XTS_3SAT": {
            "+column_types": {
                "CUSTOMER_PK": "STRING",
                "SATELLITE_NAME": "STRING",
                "HASHDIFF": "STRING",
                "LOAD_DATE": "DATE",
                "SOURCE": "STRING"
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
        "XTS_COMPPK": {
            "src_pk": ["CUSTOMER_PK", "CUSTOMER_PHONE"],
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
        "XTS_COMPPK": {
            "+column_types": {
                "CUSTOMER_PK": "BINARY(16)",
                "CUSTOMER_PHONE": "VARCHAR(50)",
                "LOAD_DATE": "DATE",
                "SATELLITE_NAME": "VARCHAR",
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
