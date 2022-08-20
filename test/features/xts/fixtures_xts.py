from behave import fixture

from test.fixture_helpers import compile_aliased_metadata


def set_vault_structure_definition(context):
    context.vault_structure_type = "xts"

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
        "XTS_AC": {
            "src_pk": "CUSTOMER_PK",
            "src_ldts": "LOAD_DATE",
            "src_extra_columns": "CUSTOMER_MT_ID",
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
        "XTS_AC_M": {
            "src_pk": "CUSTOMER_PK",
            "src_ldts": "LOAD_DATE",
            "src_extra_columns": [
                "CUSTOMER_MT_ID",
                "CUSTOMER_MT_ID_2",
            ],
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
        "XTS_COMP_PK": {
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
        "XTS_2SAT_AC": {
            "src_pk": "CUSTOMER_PK",
            "src_ldts": "LOAD_DATE",
            "src_extra_columns": "CUSTOMER_MT_ID",
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


def set_staging_definition(context):
    context.hashed_columns = {
        "STG_CUSTOMER": {
            "CUSTOMER_PK": "CUSTOMER_ID",
            "HASHDIFF": {"is_hashdiff": True,
                         "columns": ["CUSTOMER_ID", "CUSTOMER_FIRSTNAME", "CUSTOMER_LASTNAME"]}
        },
        "STG_CUSTOMER_CRM": {
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
        "STG_CUSTOMER_CRM_2SAT": {
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
        "STG_CUSTOMER_CRM": {
            "EFFECTIVE_FROM": "LOAD_DATE",
            "SATELLITE_NAME": "!SAT_CUSTOMER"
        },
        "STG_CUSTOMER_2SAT": {
            "EFFECTIVE_FROM": "LOAD_DATE",
            "SATELLITE_1": "!SAT_CUSTOMER",
            "SATELLITE_2": "!SAT_CUSTOMER_DETAILS",
        },
        "STG_CUSTOMER_CRM_2SAT": {
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


def set_metadata(context):
    set_vault_structure_definition(context)

    set_staging_definition(context)


@fixture
def xts_snowflake(context):
    """
    Define the structures and metadata to load xts
    """

    set_metadata(context)

    seed_aliases = [
        {
            "aliases": [
                "RAW_STAGE_CUSTOMER",
                "RAW_STAGE_CUSTOMER_CRM",
                "RAW_STAGE_CUSTOMER_CRM_2SAT",
                "RAW_STAGE_CUSTOMER_2SAT",
                "RAW_STAGE_3SAT"
            ],
            "column_types": {
                "CUSTOMER_ID": "VARCHAR",
                "CUSTOMER_FIRSTNAME": "VARCHAR",
                "CUSTOMER_LASTNAME": "VARCHAR",
                "CUSTOMER_DOB": "DATE",
                "CUSTOMER_PHONE": "VARCHAR",
                "CUSTOMER_MT_ID": "VARCHAR",
                "CUSTOMER_MT_ID_2": "VARCHAR",
                "CUSTOMER_COUNTY": "VARCHAR",
                "CUSTOMER_CITY": "VARCHAR",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR",
            }
        },
        {
            "aliases": [
                "XTS_2SAT",
                "XTS_2SAT_AC",
                "XTS_3SAT",
                "XTS_AC",
                "XTS_AC_M"
            ],
            "column_types": {
                "CUSTOMER_PK": "BINARY(16)",
                "SATELLITE_NAME": "VARCHAR",
                "CUSTOMER_MT_ID": "VARCHAR",
                "CUSTOMER_MT_ID_2": "VARCHAR",
                "HASHDIFF": "BINARY(16)",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR"
            }
        }
    ]

    seed_metadata = {
        "RAW_STAGE_CUSTOMER_2SAT_AC": {
            "column_types": {
                "CUSTOMER_ID": "VARCHAR",
                "CUSTOMER_FIRSTNAME": "VARCHAR",
                "CUSTOMER_LASTNAME": "VARCHAR",
                "CUSTOMER_MT_ID": "VARCHAR",
                "CUSTOMER_DOB": "DATE",
                "CUSTOMER_PHONE": "VARCHAR",
                "CUSTOMER_COUNTY": "VARCHAR",
                "CUSTOMER_CITY": "VARCHAR",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR",
            }
        },
        "STG_CUSTOMER": {
            "column_types": {
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
            "column_types": {
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
                "CUSTOMER_MT_ID": "VARCHAR",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR"
            }
        },
        "STG_CUSTOMER_3SAT": {
            "column_types": {
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
            "column_types": {
                "CUSTOMER_PK": "BINARY(16)",
                "LOAD_DATE": "DATE",
                "SATELLITE_NAME": "VARCHAR",
                "HASHDIFF": "BINARY(16)",
                "SOURCE": "VARCHAR"
            }
        },
        "XTS_COMP_PK": {
            "column_types": {
                "CUSTOMER_PK": "BINARY(16)",
                "CUSTOMER_PHONE": "VARCHAR",
                "LOAD_DATE": "DATE",
                "SATELLITE_NAME": "VARCHAR",
                "HASHDIFF": "BINARY(16)",
                "SOURCE": "VARCHAR"
            }
        }
    }

    context.seed_config = compile_aliased_metadata(seed_aliases, seed_metadata)


@fixture
def xts_bigquery(context):
    """
    Define the structures and metadata to load xts
    """

    set_metadata(context)

    seed_aliases = [
        {
            "aliases": [
                "RAW_STAGE_CUSTOMER",
                "RAW_STAGE_CUSTOMER_CRM",
                "RAW_STAGE_CUSTOMER_CRM_2SAT",
                "RAW_STAGE_CUSTOMER_2SAT",
                "RAW_STAGE_3SAT"
            ],
            "column_types": {
                "CUSTOMER_ID": "STRING",
                "CUSTOMER_FIRSTNAME": "STRING",
                "CUSTOMER_LASTNAME": "STRING",
                "CUSTOMER_DOB": "DATE",
                "CUSTOMER_PHONE": "STRING",
                "CUSTOMER_MT_ID": "STRING",
                "CUSTOMER_MT_ID_2": "STRING",
                "CUSTOMER_COUNTY": "STRING",
                "CUSTOMER_CITY": "STRING",
                "LOAD_DATE": "DATE",
                "SOURCE": "STRING",
            }
        },
        {
            "aliases": [
                "XTS_2SAT",
                "XTS_2SAT_AC",
                "XTS_3SAT",
                "XTS_AC",
                "XTS_AC_M"
            ],
            "column_types": {
                "CUSTOMER_PK": "STRING",
                "SATELLITE_NAME": "STRING",
                "CUSTOMER_MT_ID": "STRING",
                "CUSTOMER_MT_ID_2": "STRING",
                "HASHDIFF": "STRING",
                "LOAD_DATE": "DATE",
                "SOURCE": "STRING"
            }
        }
    ]

    seed_metadata = {
        "RAW_STAGE_CUSTOMER_2SAT_AC": {
            "column_types": {
                "CUSTOMER_ID": "STRING",
                "CUSTOMER_FIRSTNAME": "STRING",
                "CUSTOMER_LASTNAME": "STRING",
                "CUSTOMER_MT_ID": "STRING",
                "CUSTOMER_DOB": "DATE",
                "CUSTOMER_PHONE": "STRING",
                "CUSTOMER_COUNTY": "STRING",
                "CUSTOMER_CITY": "STRING",
                "LOAD_DATE": "DATE",
                "SOURCE": "STRING",
            }
        },
        "STG_CUSTOMER": {
            "column_types": {
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
            "column_types": {
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
                "CUSTOMER_MT_ID": "STRING",
                "LOAD_DATE": "DATE",
                "SOURCE": "STRING"
            }
        },
        "STG_CUSTOMER_3SAT": {
            "column_types": {
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
            "column_types": {
                "CUSTOMER_PK": "STRING",
                "LOAD_DATE": "DATE",
                "SATELLITE_NAME": "STRING",
                "HASHDIFF": "STRING",
                "SOURCE": "STRING"
            }
        },
        "XTS_COMP_PK": {
            "column_types": {
                "CUSTOMER_PK": "STRING",
                "CUSTOMER_PHONE": "STRING",
                "LOAD_DATE": "DATE",
                "SATELLITE_NAME": "STRING",
                "HASHDIFF": "STRING",
                "SOURCE": "STRING"
            }
        }
    }

    context.seed_config = compile_aliased_metadata(seed_aliases, seed_metadata)


@fixture
def xts_sqlserver(context):
    """
    Define the structures and metadata to load xts
    """

    set_metadata(context)

    seed_aliases = [
        {
            "aliases": [
                "RAW_STAGE_CUSTOMER",
                "RAW_STAGE_CUSTOMER_CRM",
                "RAW_STAGE_CUSTOMER_CRM_2SAT",
                "RAW_STAGE_CUSTOMER_2SAT",
                "RAW_STAGE_3SAT"
            ],
            "column_types": {
                "CUSTOMER_ID": "VARCHAR(50)",
                "CUSTOMER_FIRSTNAME": "VARCHAR(50)",
                "CUSTOMER_LASTNAME": "VARCHAR(50)",
                "CUSTOMER_DOB": "DATE",
                "CUSTOMER_PHONE": "VARCHAR(50)",
                "CUSTOMER_MT_ID": "VARCHAR(50)",
                "CUSTOMER_MT_ID_2": "VARCHAR(50)",
                "CUSTOMER_COUNTY": "VARCHAR(50)",
                "CUSTOMER_CITY": "VARCHAR(50)",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR(50)",
            }
        },
        {
            "aliases": [
                "XTS_2SAT",
                "XTS_2SAT_AC",
                "XTS_3SAT",
                "XTS_AC",
                "XTS_AC_M"
            ],
            "column_types": {
                "CUSTOMER_PK": "BINARY(16)",
                "SATELLITE_NAME": "VARCHAR(50)",
                "CUSTOMER_MT_ID": "VARCHAR(50)",
                "CUSTOMER_MT_ID_2": "VARCHAR(50)",
                "HASHDIFF": "BINARY(16)",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR(50)"
            }
        }
    ]

    seed_metadata = {
        "RAW_STAGE_CUSTOMER_2SAT_AC": {
            "column_types": {
                "CUSTOMER_ID": "VARCHAR(50)",
                "CUSTOMER_FIRSTNAME": "VARCHAR(50)",
                "CUSTOMER_LASTNAME": "VARCHAR(50)",
                "CUSTOMER_MT_ID": "VARCHAR(50)",
                "CUSTOMER_DOB": "DATE",
                "CUSTOMER_PHONE": "VARCHAR(50)",
                "CUSTOMER_COUNTY": "VARCHAR(50)",
                "CUSTOMER_CITY": "VARCHAR(50)",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR(50)",
            }
        },
        "STG_CUSTOMER": {
            "column_types": {
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
            "column_types": {
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
                "CUSTOMER_MT_ID": "VARCHAR(50)",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR(50)"
            }
        },
        "STG_CUSTOMER_3SAT": {
            "column_types": {
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
            "column_types": {
                "CUSTOMER_PK": "BINARY(16)",
                "LOAD_DATE": "DATE",
                "SATELLITE_NAME": "VARCHAR(50)",
                "HASHDIFF": "BINARY(16)",
                "SOURCE": "VARCHAR(50)"
            }
        },
        "XTS_COMP_PK": {
            "column_types": {
                "CUSTOMER_PK": "BINARY(16)",
                "CUSTOMER_PHONE": "VARCHAR(50)",
                "LOAD_DATE": "DATE",
                "SATELLITE_NAME": "VARCHAR",
                "HASHDIFF": "BINARY(16)",
                "SOURCE": "VARCHAR(50)"
            }
        }
    }

    context.seed_config = compile_aliased_metadata(seed_aliases, seed_metadata)
