from behave import fixture


# Snowflake

@fixture
def eff_satellite_2_snowflake(context):
    """
    Define the structures and metadata to load effectivity satellites (eff sat 2)
    """

    context.hashed_columns = {
        "STG_CUSTOMER": {
            "CUSTOMER_ORDER_PK": ["CUSTOMER_ID", "ORDER_ID"],
            "CUSTOMER_PK": "CUSTOMER_ID",
            "ORDER_PK": "ORDER_ID",
            "HASHDIFF": {"is_hashdiff": True,
                           "columns": "STATUS::INT"}
        }
    }

    context.vault_structure_columns = {
        "EFF_SAT_2": {
            "src_pk": "CUSTOMER_ORDER_PK",
            "src_dfk": ["ORDER_PK"],
            "src_sfk": "CUSTOMER_PK",
            "src_status": "STATUS",
            "src_hashdiff": "HASHDIFF",
            "src_eff": "EFFECTIVE_FROM",
            "src_ldts": "LOAD_DATE",
            "src_source": "SOURCE"
        }
    }

    context.seed_config = {
        "RAW_STAGE": {
            "column_types": {
                "CUSTOMER_ID": "NUMBER(38, 0)",
                "ORDER_ID": "VARCHAR",
                "EFFECTIVE_FROM": "DATE",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR",
                "STATUS": "BOOLEAN"

            }
        },

        "EFF_SAT_2": {
            "column_types": {
                "CUSTOMER_ORDER_PK": "BINARY(16)",
                "CUSTOMER_PK": "BINARY(16)",
                "ORDER_PK": "BINARY(16)",
                "EFFECTIVE_FROM": "DATE",
                "STATUS": "BOOLEAN",
                "HASHDIFF": "BINARY(16)",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR"
            }
        }
    }

@fixture
def eff_satellite_2_multipart_snowflake(context):
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
            "ORGANISATION_PK": "ORGANISATION_ID",
            "HASHDIFF": {"is_hashdiff": True,
                         "columns": "STATUS::INT"}
        }
    }

    context.vault_structure_columns = {
        "EFF_SAT_2": {
            "src_pk": "CUSTOMER_ORDER_PK",
            "src_dfk": ["ORDER_PK", "PLATFORM_PK", "ORGANISATION_PK"],
            "src_sfk": ["CUSTOMER_PK", "NATION_PK"],
            "src_eff": "EFFECTIVE_FROM",
            "src_status": "STATUS",
            "src_hashdiff": "HASHDIFF",
            "src_ldts": "LOAD_DATE",
            "src_source": "SOURCE"
        }
    }

    context.seed_config = {
        "RAW_STAGE": {
            "column_types": {
                "CUSTOMER_ID": "NUMBER(38, 0)",
                "NATION_ID": "VARCHAR",
                "ORDER_ID": "VARCHAR",
                "PLATFORM_ID": "VARCHAR",
                "ORGANISATION_ID": "VARCHAR",
                "EFFECTIVE_FROM": "DATE",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR",
                "STATUS": "BOOLEAN"
            }
        },
        "EFF_SAT_2": {
            "column_types": {
                "CUSTOMER_ORDER_PK": "BINARY(16)",
                "ORDER_PK": "BINARY(16)",
                "PLATFORM_PK": "BINARY(16)",
                "ORGANISATION_PK": "BINARY(16)",
                "CUSTOMER_PK": "BINARY(16)",
                "NATION_PK": "BINARY(16)",
                "EFFECTIVE_FROM": "DATE",
                "STATUS": "BOOLEAN",
                "HASHDIFF": "BINARY(16)",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR",
            }
        }
    }

@fixture
def eff_satellite_2_testing_auto_end_dating_snowflake(context):
    """
    Define the structures and metadata to load effectivity satellites
    """

    context.hashed_columns = {
        "STG_CUSTOMER_ORDER": {
            "CUSTOMER_ORDER_PK": ["CUSTOMER_ID", "ORDER_ID"],
            "CUSTOMER_PK": "CUSTOMER_ID",
            "ORDER_PK": "ORDER_ID",
            "HASHDIFF": {"is_hashdiff": True,
                         "columns": "STATUS::INT"}
        },
        "STG_ORDER_CUSTOMER": {
            "ORDER_CUSTOMER_PK": ["CUSTOMER_ID", "ORDER_ID"],
            "CUSTOMER_PK": "CUSTOMER_ID",
            "ORDER_PK": "ORDER_ID",
            "HASHDIFF": {"is_hashdiff": True,
                         "columns": "STATUS::INT"}
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
        "EFF_SAT_2_CUSTOMER_ORDER": {
            "source_model": "STG_CUSTOMER_ORDER",
            "src_pk": "CUSTOMER_ORDER_PK",
            "src_dfk": ["CUSTOMER_PK"],
            "src_sfk": "ORDER_PK",
            "src_status": "STATUS",
            "src_hashdiff": "HASHDIFF",
            "src_eff": "EFFECTIVE_FROM",
            "src_ldts": "LOAD_DATETIME",
            "src_source": "SOURCE"
        },
        "EFF_SAT_2_ORDER_CUSTOMER": {
            "src_pk": "ORDER_CUSTOMER_PK",
            "src_dfk": ["ORDER_PK"],
            "src_sfk": "CUSTOMER_PK",
            "src_status": "STATUS",
            "src_hashdiff": "HASHDIFF",
            "src_eff": "EFFECTIVE_FROM",
            "src_ldts": "LOAD_DATETIME",
            "src_source": "SOURCE"
        }
    }

    context.seed_config = {
        "RAW_STAGE_CUSTOMER_ORDER": {
            "column_types": {
                "CUSTOMER_ID": "VARCHAR",
                "ORDER_ID": "VARCHAR",
                "EFFECTIVE_FROM": "DATETIME",
                "LOAD_DATETIME": "DATETIME",
                "SOURCE": "VARCHAR",
                "STATUS": "BOOLEAN"
            }
        },
        "RAW_STAGE_ORDER_CUSTOMER": {
            "column_types": {
                "CUSTOMER_ID": "VARCHAR",
                "ORDER_ID": "VARCHAR",
                "EFFECTIVE_FROM": "DATETIME",
                "LOAD_DATETIME": "DATETIME",
                "SOURCE": "VARCHAR",
                "STATUS": "BOOLEAN"
            }
        },
        "LINK_CUSTOMER_ORDER": {
            "column_types": {
                "CUSTOMER_ORDER_PK": "BINARY(16)",
                "CUSTOMER_PK": "BINARY(16)",
                "ORDER_PK": "BINARY(16)",
                "LOAD_DATETIME": "DATETIME",
                "SOURCE": "VARCHAR"
            }
        },
        "LINK_ORDER_CUSTOMER": {
            "column_types": {
                "ORDER_CUSTOMER_PK": "BINARY(16)",
                "CUSTOMER_PK": "BINARY(16)",
                "ORDER_PK": "BINARY(16)",
                "LOAD_DATETIME": "DATETIME",
                "SOURCE": "VARCHAR"
            }
        },
        "EFF_SAT_2_CUSTOMER_ORDER": {
            "column_types": {
                "CUSTOMER_ORDER_PK": "BINARY(16)",
                "CUSTOMER_PK": "BINARY(16)",
                "ORDER_PK": "BINARY(16)",
                "STATUS": "BOOLEAN",
                "HASHDIFF": "BINARY(16)",
                "EFFECTIVE_FROM": "DATETIME",
                "LOAD_DATETIME": "DATETIME",
                "SOURCE": "VARCHAR"
            }
        },
        "EFF_SAT_2_ORDER_CUSTOMER": {
            "column_types": {
                "ORDER_CUSTOMER_PK": "BINARY(16)",
                "CUSTOMER_PK": "BINARY(16)",
                "ORDER_PK": "BINARY(16)",
                "STATUS": "BOOLEAN",
                "HASHDIFF": "BINARY(16)",
                "EFFECTIVE_FROM": "DATETIME",
                "LOAD_DATETIME": "DATETIME",
                "SOURCE": "VARCHAR"
            }
        }
    }


@fixture
def eff_satellite_2_datetime_snowflake(context):
    """
    Define the structures and metadata to load effectivity satellites
    """

    context.hashed_columns = {
        "STG_CUSTOMER": {
            "CUSTOMER_ORDER_PK": ["CUSTOMER_ID", "ORDER_ID"],
            "CUSTOMER_PK": "CUSTOMER_ID",
            "ORDER_PK": "ORDER_ID",
            "HASHDIFF": {"is_hashdiff": True,
                         "columns": "STATUS::INT"}
    }
    }

    context.vault_structure_columns = {
        "EFF_SAT_2": {
            "src_pk": "CUSTOMER_ORDER_PK",
            "src_dfk": ["ORDER_PK"],
            "src_sfk": "CUSTOMER_PK",
            "src_status": "STATUS",
            "src_hashdiff": "HASHDIFF",
            "src_eff": "EFFECTIVE_FROM",
            "src_ldts": "LOAD_DATETIME",
            "src_source": "SOURCE"
        }
    }

    context.seed_config = {
        "RAW_STAGE": {
            "column_types": {
                "CUSTOMER_ID": "VARCHAR",
                "ORDER_ID": "VARCHAR",
                "STATUS": "BOOLEAN",
                "EFFECTIVE_FROM": "DATETIME",
                "LOAD_DATETIME": "DATETIME",
                "SOURCE": "VARCHAR"
            }
        },
        "EFF_SAT_2": {
            "column_types": {
                "CUSTOMER_ORDER_PK": "BINARY(16)",
                "CUSTOMER_PK": "BINARY(16)",
                "ORDER_PK": "BINARY(16)",
                "STATUS": "BOOLEAN",
                "HASHDIFF": "BINARY(16)",
                "EFFECTIVE_FROM": "DATETIME",
                "LOAD_DATETIME": "DATETIME",
                "SOURCE": "VARCHAR"
            }
        }
    }


# MS SQL Server

@fixture
def eff_satellite_2_sqlserver(context):
    """
    Define the structures and metadata to load effectivity satellites (eff sat 2)
    """

    context.hashed_columns = {
        "STG_CUSTOMER": {
            "CUSTOMER_ORDER_PK": ["CUSTOMER_ID", "ORDER_ID"],
            "CUSTOMER_PK": "CUSTOMER_ID",
            "ORDER_PK": "ORDER_ID",
            "HASHDIFF": {"is_hashdiff": True,
                           "columns": "CAST(STATUS AS BIT)"}
        }
    }

    context.vault_structure_columns = {
        "EFF_SAT_2": {
            "src_pk": "CUSTOMER_ORDER_PK",
            "src_dfk": ["ORDER_PK"],
            "src_sfk": "CUSTOMER_PK",
            "src_status": "STATUS",
            "src_hashdiff": "HASHDIFF",
            "src_eff": "EFFECTIVE_FROM",
            "src_ldts": "LOAD_DATE",
            "src_source": "SOURCE"
        }
    }

    context.seed_config = {
        "RAW_STAGE": {
            "column_types": {
                "CUSTOMER_ID": "DECIMAL(18, 0)",
                "ORDER_ID": "VARCHAR(10)",
                "EFFECTIVE_FROM": "DATETIME2",
                "LOAD_DATE": "DATETIME2",
                "SOURCE": "VARCHAR(10)",
                "STATUS": "BIT"

            }
        },

        "EFF_SAT_2": {
            "column_types": {
                "CUSTOMER_ORDER_PK": "BINARY(16)",
                "CUSTOMER_PK": "BINARY(16)",
                "ORDER_PK": "BINARY(16)",
                "EFFECTIVE_FROM": "DATETIME2",
                "STATUS": "BIT",
                "HASHDIFF": "BINARY(16)",
                "LOAD_DATE": "DATETIME2",
                "SOURCE": "VARCHAR(10)"
            }
        }
    }

@fixture
def eff_satellite_2_multipart_sqlserver(context):
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
            "ORGANISATION_PK": "ORGANISATION_ID",
            "HASHDIFF": {"is_hashdiff": True,
                         "columns": "CAST(STATUS AS BIT)"}
        }
    }

    context.vault_structure_columns = {
        "EFF_SAT_2": {
            "src_pk": "CUSTOMER_ORDER_PK",
            "src_dfk": ["ORDER_PK", "PLATFORM_PK", "ORGANISATION_PK"],
            "src_sfk": ["CUSTOMER_PK", "NATION_PK"],
            "src_eff": "EFFECTIVE_FROM",
            "src_status": "STATUS",
            "src_hashdiff": "HASHDIFF",
            "src_ldts": "LOAD_DATE",
            "src_source": "SOURCE"
        }
    }

    context.seed_config = {
        "RAW_STAGE": {
            "column_types": {
                "CUSTOMER_ID": "DECIMAL(18, 0)",
                "NATION_ID": "VARCHAR(10)",
                "ORDER_ID": "VARCHAR(10)",
                "PLATFORM_ID": "VARCHAR(10)",
                "ORGANISATION_ID": "VARCHAR(10)",
                "EFFECTIVE_FROM": "DATETIME2",
                "LOAD_DATE": "DATETIME2",
                "SOURCE": "VARCHAR(10)",
                "STATUS": "BIT"
            }
        },
        "EFF_SAT_2": {
            "column_types": {
                "CUSTOMER_ORDER_PK": "BINARY(16)",
                "ORDER_PK": "BINARY(16)",
                "PLATFORM_PK": "BINARY(16)",
                "ORGANISATION_PK": "BINARY(16)",
                "CUSTOMER_PK": "BINARY(16)",
                "NATION_PK": "BINARY(16)",
                "EFFECTIVE_FROM": "DATETIME2",
                "STATUS": "BIT",
                "HASHDIFF": "BINARY(16)",
                "LOAD_DATE": "DATETIME2",
                "SOURCE": "VARCHAR(10)",
            }
        }
    }

@fixture
def eff_satellite_2_testing_auto_end_dating_sqlserver(context):
    """
    Define the structures and metadata to load effectivity satellites
    """

    context.hashed_columns = {
        "STG_CUSTOMER_ORDER": {
            "CUSTOMER_ORDER_PK": ["CUSTOMER_ID", "ORDER_ID"],
            "CUSTOMER_PK": "CUSTOMER_ID",
            "ORDER_PK": "ORDER_ID",
            "HASHDIFF": {"is_hashdiff": True,
                         "columns": "CAST(STATUS AS BIT)"}
        },
        "STG_ORDER_CUSTOMER": {
            "ORDER_CUSTOMER_PK": ["CUSTOMER_ID", "ORDER_ID"],
            "CUSTOMER_PK": "CUSTOMER_ID",
            "ORDER_PK": "ORDER_ID",
            "HASHDIFF": {"is_hashdiff": True,
                         "columns": "CAST(STATUS AS BIT)"}
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
        "EFF_SAT_2_CUSTOMER_ORDER": {
            "source_model": "STG_CUSTOMER_ORDER",
            "src_pk": "CUSTOMER_ORDER_PK",
            "src_dfk": ["CUSTOMER_PK"],
            "src_sfk": "ORDER_PK",
            "src_status": "STATUS",
            "src_hashdiff": "HASHDIFF",
            "src_eff": "EFFECTIVE_FROM",
            "src_ldts": "LOAD_DATETIME",
            "src_source": "SOURCE"
        },
        "EFF_SAT_2_ORDER_CUSTOMER": {
            "src_pk": "ORDER_CUSTOMER_PK",
            "src_dfk": ["ORDER_PK"],
            "src_sfk": "CUSTOMER_PK",
            "src_status": "STATUS",
            "src_hashdiff": "HASHDIFF",
            "src_eff": "EFFECTIVE_FROM",
            "src_ldts": "LOAD_DATETIME",
            "src_source": "SOURCE"
        }
    }

    context.seed_config = {
        "RAW_STAGE_CUSTOMER_ORDER": {
            "column_types": {
                "CUSTOMER_ID": "VARCHAR(10)",
                "ORDER_ID": "VARCHAR(10)",
                "EFFECTIVE_FROM": "DATETIME2",
                "LOAD_DATETIME": "DATETIME2",
                "SOURCE": "VARCHAR(10)",
                "STATUS": "BIT"
            }
        },
        "RAW_STAGE_ORDER_CUSTOMER": {
            "column_types": {
                "CUSTOMER_ID": "VARCHAR(10)",
                "ORDER_ID": "VARCHAR(10)",
                "EFFECTIVE_FROM": "DATETIME2",
                "LOAD_DATETIME": "DATETIME2",
                "SOURCE": "VARCHAR(10)",
                "STATUS": "BIT"
            }
        },
        "LINK_CUSTOMER_ORDER": {
            "column_types": {
                "CUSTOMER_ORDER_PK": "BINARY(16)",
                "CUSTOMER_PK": "BINARY(16)",
                "ORDER_PK": "BINARY(16)",
                "LOAD_DATETIME": "DATETIME2",
                "SOURCE": "VARCHAR(10)"
            }
        },
        "LINK_ORDER_CUSTOMER": {
            "column_types": {
                "ORDER_CUSTOMER_PK": "BINARY(16)",
                "CUSTOMER_PK": "BINARY(16)",
                "ORDER_PK": "BINARY(16)",
                "LOAD_DATETIME": "DATETIME2",
                "SOURCE": "VARCHAR(10)"
            }
        },
        "EFF_SAT_2_CUSTOMER_ORDER": {
            "column_types": {
                "CUSTOMER_ORDER_PK": "BINARY(16)",
                "CUSTOMER_PK": "BINARY(16)",
                "ORDER_PK": "BINARY(16)",
                "STATUS": "BIT",
                "HASHDIFF": "BINARY(16)",
                "EFFECTIVE_FROM": "DATETIME2",
                "LOAD_DATETIME": "DATETIME2",
                "SOURCE": "VARCHAR(10)"
            }
        },
        "EFF_SAT_2_ORDER_CUSTOMER": {
            "column_types": {
                "ORDER_CUSTOMER_PK": "BINARY(16)",
                "CUSTOMER_PK": "BINARY(16)",
                "ORDER_PK": "BINARY(16)",
                "STATUS": "BIT",
                "HASHDIFF": "BINARY(16)",
                "EFFECTIVE_FROM": "DATETIME2",
                "LOAD_DATETIME": "DATETIME2",
                "SOURCE": "VARCHAR(10)"
            }
        }
    }


@fixture
def eff_satellite_2_datetime_sqlserver(context):
    """
    Define the structures and metadata to load effectivity satellites
    """

    context.hashed_columns = {
        "STG_CUSTOMER": {
            "CUSTOMER_ORDER_PK": ["CUSTOMER_ID", "ORDER_ID"],
            "CUSTOMER_PK": "CUSTOMER_ID",
            "ORDER_PK": "ORDER_ID",
            "HASHDIFF": {"is_hashdiff": True,
                         "columns": "CAST(STATUS AS BIT)"}
    }
    }

    context.vault_structure_columns = {
        "EFF_SAT_2": {
            "src_pk": "CUSTOMER_ORDER_PK",
            "src_dfk": ["ORDER_PK"],
            "src_sfk": "CUSTOMER_PK",
            "src_status": "STATUS",
            "src_hashdiff": "HASHDIFF",
            "src_eff": "EFFECTIVE_FROM",
            "src_ldts": "LOAD_DATETIME",
            "src_source": "SOURCE"
        }
    }

    context.seed_config = {
        "RAW_STAGE": {
            "column_types": {
                "CUSTOMER_ID": "VARCHAR",
                "ORDER_ID": "VARCHAR",
                "STATUS": "BIT",
                "EFFECTIVE_FROM": "DATETIME2",
                "LOAD_DATETIME": "DATETIME2",
                "SOURCE": "VARCHAR"
            }
        },
        "EFF_SAT_2": {
            "column_types": {
                "CUSTOMER_ORDER_PK": "BINARY(16)",
                "CUSTOMER_PK": "BINARY(16)",
                "ORDER_PK": "BINARY(16)",
                "STATUS": "BIT",
                "HASHDIFF": "BINARY(16)",
                "EFFECTIVE_FROM": "DATETIME2",
                "LOAD_DATETIME": "DATETIME2",
                "SOURCE": "VARCHAR"
            }
        }
    }
