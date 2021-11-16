from behave import fixture


@fixture
def out_of_sequence_satellite(context):
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
                "CUSTOMER_ID": "NUMBER(38, 0)",
                "CUSTOMER_NAME": "VARCHAR",
                "CUSTOMER_PHONE": "VARCHAR",
                "CUSTOMER_DOB": "DATE",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR"
            }
        },
        "RAW_STAGE_TIMESTAMP": {
            "+column_types": {
                "CUSTOMER_ID": "NUMBER(38, 0)",
                "CUSTOMER_NAME": "VARCHAR",
                "CUSTOMER_PHONE": "VARCHAR",
                "CUSTOMER_DOB": "DATE",
                "LOAD_DATETIME": "TIMESTAMP",
                "SOURCE": "VARCHAR"
            }
        },
        "SAT_CUSTOMER_OOS": {
            "+column_types": {
                "CUSTOMER_PK": "BINARY(16)",
                "CUSTOMER_NAME": "VARCHAR",
                "CUSTOMER_PHONE": "VARCHAR",
                "CUSTOMER_DOB": "DATE",
                "HASHDIFF": "BINARY(16)",
                "EFFECTIVE_FROM": "DATE",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR"
            }
        },
        "SAT_CUSTOMER_OOS_EARLY": {
            "+column_types": {
                "CUSTOMER_PK": "BINARY(16)",
                "CUSTOMER_NAME": "VARCHAR",
                "CUSTOMER_PHONE": "VARCHAR",
                "CUSTOMER_DOB": "DATE",
                "HASHDIFF": "BINARY(16)",
                "EFFECTIVE_FROM": "DATE",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR"
            }
        },
        "SAT_CUSTOMER_OOS_LATE": {
            "+column_types": {
                "CUSTOMER_PK": "BINARY(16)",
                "CUSTOMER_NAME": "VARCHAR",
                "CUSTOMER_PHONE": "VARCHAR",
                "CUSTOMER_DOB": "DATE",
                "HASHDIFF": "BINARY(16)",
                "EFFECTIVE_FROM": "DATE",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR"
            }
        },
        "SATELLITE": {
            "+column_types": {
                "CUSTOMER_PK": "BINARY(16)",
                "CUSTOMER_NAME": "VARCHAR",
                "CUSTOMER_PHONE": "VARCHAR",
                "CUSTOMER_DOB": "DATE",
                "HASHDIFF": "BINARY(16)",
                "EFFECTIVE_FROM": "DATE",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR"
            }
        },
        "SAT_CUSTOMER_OOS_TIMESTAMP": {
            "+column_types": {
                "CUSTOMER_PK": "BINARY(16)",
                "CUSTOMER_NAME": "VARCHAR",
                "CUSTOMER_PHONE": "VARCHAR",
                "CUSTOMER_DOB": "DATE",
                "HASHDIFF": "BINARY(16)",
                "EFFECTIVE_FROM": "TIMESTAMP",
                "LOAD_DATETIME": "TIMESTAMP",
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
        "XTS_TIMESTAMP": {
            "+column_types": {
                "CUSTOMER_PK": "BINARY(16)",
                "LOAD_DATETIME": "TIMESTAMP",
                "SATELLITE_NAME": "VARCHAR",
                "HASHDIFF": "BINARY(16)",
                "SOURCE": "VARCHAR"
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
