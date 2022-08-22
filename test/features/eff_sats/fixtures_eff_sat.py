from behave import fixture


def set_vault_structure_definition(context):
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
        },
        "EFF_SAT_AC": {
            "src_pk": "CUSTOMER_ORDER_PK",
            "src_dfk": ["ORDER_PK"],
            "src_sfk": "CUSTOMER_PK",
            "src_extra_columns": "CUSTOMER_MT_ID",
            "src_start_date": "START_DATE",
            "src_end_date": "END_DATE",
            "src_eff": "EFFECTIVE_FROM",
            "src_ldts": "LOAD_DATE",
            "src_source": "SOURCE"
        },
        "EFF_SAT_AC_MULTI": {
            "src_pk": "CUSTOMER_ORDER_PK",
            "src_dfk": ["ORDER_PK"],
            "src_sfk": "CUSTOMER_PK",
            "src_extra_columns": [
                "CUSTOMER_MT_ID",
                "CUSTOMER_CK"
            ],
            "src_start_date": "START_DATE",
            "src_end_date": "END_DATE",
            "src_eff": "EFFECTIVE_FROM",
            "src_ldts": "LOAD_DATE",
            "src_source": "SOURCE"
        },
        "EFF_SAT_ORDER_CUSTOMER": {
            "src_pk": "ORDER_CUSTOMER_PK",
            "src_dfk": ["ORDER_PK"],
            "src_sfk": "CUSTOMER_PK",
            "src_start_date": "START_DATE",
            "src_end_date": "END_DATE",
            "src_eff": "EFFECTIVE_FROM",
            "src_ldts": "LOAD_DATETIME",
            "src_source": "SOURCE"
        },
        "EFF_SAT_CUSTOMER_ORDER": {
            "src_pk": "CUSTOMER_ORDER_PK",
            "src_dfk": ["CUSTOMER_PK"],
            "src_sfk": "ORDER_PK",
            "src_start_date": "START_DATE",
            "src_end_date": "END_DATE",
            "src_eff": "EFFECTIVE_FROM",
            "src_ldts": "LOAD_DATETIME",
            "src_source": "SOURCE"
        },
        "EFF_SAT_ORDER_CUSTOMER_AC": {
            "src_pk": "ORDER_CUSTOMER_PK",
            "src_dfk": ["ORDER_PK"],
            "src_sfk": "CUSTOMER_PK",
            "src_start_date": "START_DATE",
            "src_end_date": "END_DATE",
            "src_extra_columns": "CUSTOMER_MT_ID",
            "src_eff": "EFFECTIVE_FROM",
            "src_ldts": "LOAD_DATETIME",
            "src_source": "SOURCE"
        }
    }


def set_staging_definition(context):
    context.hashed_columns = {
        "STG_CUSTOMER": {
            "ORDER_CUSTOMER_PK": ["CUSTOMER_ID", "ORDER_ID"],
            "CUSTOMER_ORDER_PK": ["CUSTOMER_ID", "ORDER_ID"],
            "CUSTOMER_PK": "CUSTOMER_ID",
            "ORDER_PK": "ORDER_ID"
        }
    }


def set_metadata(context):
    set_vault_structure_definition(context)

    set_staging_definition(context)


# Snowflake


@fixture
def eff_satellite_snowflake(context):
    """
    Define the structures and metadata to load effectivity satellites
    """

    set_metadata(context)

    context.seed_config = {
        "RAW_STAGE": {
            "column_types": {
                "CUSTOMER_ID": "VARCHAR",
                "ORDER_ID": "VARCHAR",
                "CUSTOMER_MT_ID": "VARCHAR",
                "CUSTOMER_CK": "VARCHAR",
                "START_DATE": "DATE",
                "END_DATE": "DATE",
                "EFFECTIVE_FROM": "DATE",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR"
            }
        },
        "EFF_SAT": {
            "column_types": {
                "CUSTOMER_ORDER_PK": "BINARY(16)",
                "CUSTOMER_PK": "BINARY(16)",
                "ORDER_PK": "BINARY(16)",
                "START_DATE": "DATE",
                "END_DATE": "DATE",
                "EFFECTIVE_FROM": "DATE",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR"
            }
        },
        "EFF_SAT_AC": {
            "column_types": {
                "CUSTOMER_ORDER_PK": "BINARY(16)",
                "CUSTOMER_PK": "BINARY(16)",
                "ORDER_PK": "BINARY(16)",
                "CUSTOMER_MT_ID": "VARCHAR",
                "START_DATE": "DATE",
                "END_DATE": "DATE",
                "EFFECTIVE_FROM": "DATE",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR"
            }
        },
        "EFF_SAT_AC_MULTI": {
            "column_types": {
                "CUSTOMER_ORDER_PK": "BINARY(16)",
                "CUSTOMER_PK": "BINARY(16)",
                "ORDER_PK": "BINARY(16)",
                "CUSTOMER_MT_ID": "VARCHAR",
                "CUSTOMER_CK": "VARCHAR",
                "START_DATE": "DATE",
                "END_DATE": "DATE",
                "EFFECTIVE_FROM": "DATE",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR"
            }
        }
    }


@fixture
def eff_satellite_datetime_snowflake(context):
    """
    Define the structures and metadata to load effectivity satellites
    """

    set_metadata(context)

    context.hashed_columns = {
        "STG_CUSTOMER": {
            "CUSTOMER_ORDER_PK": ["CUSTOMER_ID", "ORDER_ID"],
            "CUSTOMER_PK": "CUSTOMER_ID",
            "ORDER_PK": "ORDER_ID"
        }
    }

    context.vault_structure_columns['EFF_SAT'] = {
        "src_pk": "CUSTOMER_ORDER_PK",
        "src_dfk": ["ORDER_PK"],
        "src_sfk": "CUSTOMER_PK",
        "src_start_date": "START_DATE",
        "src_end_date": "END_DATE",
        "src_eff": "EFFECTIVE_FROM",
        "src_ldts": "LOAD_DATETIME",
        "src_source": "SOURCE"
    }

    context.seed_config = {
        "RAW_STAGE": {
            "column_types": {
                "CUSTOMER_ID": "VARCHAR",
                "ORDER_ID": "VARCHAR",
                "START_DATE": "DATETIME",
                "END_DATE": "DATETIME",
                "EFFECTIVE_FROM": "DATETIME",
                "LOAD_DATETIME": "DATETIME",
                "SOURCE": "VARCHAR"
            }
        },
        "EFF_SAT": {
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
        }
    }


@fixture
def eff_satellite_auto_end_dating_snowflake(context):
    """
    Define the structures and metadata to load effectivity satellites
    """

    set_metadata(context)

    context.seed_config = {
        "RAW_STAGE": {
            "column_types": {
                "CUSTOMER_ID": "VARCHAR",
                "ORDER_ID": "VARCHAR",
                "START_DATE": "DATETIME",
                "CUSTOMER_MT_ID": "VARCHAR",
                "END_DATE": "DATETIME",
                "EFFECTIVE_FROM": "DATETIME",
                "LOAD_DATETIME": "DATETIME",
                "SOURCE": "VARCHAR"
            }
        },
        "RAW_STAGE_CUSTOMER_ORDER": {
            "column_types": {
                "CUSTOMER_ID": "VARCHAR",
                "ORDER_ID": "VARCHAR",
                "START_DATE": "DATETIME",
                "CUSTOMER_MT_ID": "VARCHAR",
                "END_DATE": "DATETIME",
                "EFFECTIVE_FROM": "DATETIME",
                "LOAD_DATETIME": "DATETIME",
                "SOURCE": "VARCHAR"
            }
        },
        "RAW_STAGE_ORDER_CUSTOMER": {
            "column_types": {
                "CUSTOMER_ID": "VARCHAR",
                "ORDER_ID": "VARCHAR",
                "START_DATE": "DATETIME",
                "CUSTOMER_MT_ID": "VARCHAR",
                "END_DATE": "DATETIME",
                "EFFECTIVE_FROM": "DATETIME",
                "LOAD_DATETIME": "DATETIME",
                "SOURCE": "VARCHAR"
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
        "EFF_SAT_ORDER_CUSTOMER": {
            "column_types": {
                "ORDER_CUSTOMER_PK": "BINARY(16)",
                "CUSTOMER_PK": "BINARY(16)",
                "ORDER_PK": "BINARY(16)",
                "START_DATE": "DATETIME",
                "END_DATE": "DATETIME",
                "EFFECTIVE_FROM": "DATETIME",
                "LOAD_DATETIME": "DATETIME",
                "SOURCE": "VARCHAR"
            }
        },
        "EFF_SAT_ORDER_CUSTOMER_AC": {
            "column_types": {
                "ORDER_CUSTOMER_PK": "BINARY(16)",
                "CUSTOMER_PK": "BINARY(16)",
                "ORDER_PK": "BINARY(16)",
                "START_DATE": "DATETIME",
                "END_DATE": "DATETIME",
                "CUSTOMER_MT_ID": "VARCHAR",
                "EFFECTIVE_FROM": "DATETIME",
                "LOAD_DATETIME": "DATETIME",
                "SOURCE": "VARCHAR"
            }
        }
    }


@fixture
def eff_satellite_multipart_snowflake(context):
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
            "column_types": {
                "CUSTOMER_ID": "VARCHAR",
                "NATION_ID": "VARCHAR",
                "ORDER_ID": "VARCHAR",
                "PLATFORM_ID": "VARCHAR",
                "ORGANISATION_ID": "VARCHAR",
                "START_DATE": "DATE",
                "END_DATE": "DATE",
                "EFFECTIVE_FROM": "DATE",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR"
            }
        },
        "EFF_SAT": {
            "column_types": {
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
                "SOURCE": "VARCHAR"
            }
        }
    }


# BigQuery


@fixture
def eff_satellite_bigquery(context):
    """
    Define the structures and metadata to load effectivity satellites
    """

    set_metadata(context)

    context.seed_config = {
        "RAW_STAGE": {
            "column_types": {
                "CUSTOMER_ID": "STRING",
                "ORDER_ID": "STRING",
                "CUSTOMER_MT_ID": "STRING",
                "CUSTOMER_CK": "STRING",
                "START_DATE": "DATE",
                "END_DATE": "DATE",
                "EFFECTIVE_FROM": "DATE",
                "LOAD_DATE": "DATE",
                "SOURCE": "STRING"
            }
        },
        "EFF_SAT": {
            "column_types": {
                "CUSTOMER_ORDER_PK": "STRING",
                "CUSTOMER_PK": "STRING",
                "ORDER_PK": "STRING",
                "START_DATE": "DATE",
                "END_DATE": "DATE",
                "EFFECTIVE_FROM": "DATE",
                "LOAD_DATE": "DATE",
                "SOURCE": "STRING"
            }
        },
        "EFF_SAT_AC": {
            "column_types": {
                "CUSTOMER_ORDER_PK": "STRING",
                "CUSTOMER_PK": "STRING",
                "ORDER_PK": "STRING",
                "CUSTOMER_MT_ID": "STRING",
                "START_DATE": "DATE",
                "END_DATE": "DATE",
                "EFFECTIVE_FROM": "DATE",
                "LOAD_DATE": "DATE",
                "SOURCE": "STRING"
            }
        },
        "EFF_SAT_AC_MULTI": {
            "column_types": {
                "CUSTOMER_ORDER_PK": "STRING",
                "CUSTOMER_PK": "STRING",
                "ORDER_PK": "STRING",
                "CUSTOMER_MT_ID": "STRING",
                "CUSTOMER_CK": "STRING",
                "START_DATE": "DATE",
                "END_DATE": "DATE",
                "EFFECTIVE_FROM": "DATE",
                "LOAD_DATE": "DATE",
                "SOURCE": "STRING"
            }
        }
    }


@fixture
def eff_satellite_datetime_bigquery(context):
    """
    Define the structures and metadata to load effectivity satellites
    """

    set_metadata(context)

    context.hashed_columns = {
        "STG_CUSTOMER": {
            "CUSTOMER_ORDER_PK": ["CUSTOMER_ID", "ORDER_ID"],
            "CUSTOMER_PK": "CUSTOMER_ID",
            "ORDER_PK": "ORDER_ID"
        }
    }

    context.vault_structure_columns['EFF_SAT'] = {
        "src_pk": "CUSTOMER_ORDER_PK",
        "src_dfk": ["ORDER_PK"],
        "src_sfk": "CUSTOMER_PK",
        "src_start_date": "START_DATE",
        "src_end_date": "END_DATE",
        "src_eff": "EFFECTIVE_FROM",
        "src_ldts": "LOAD_DATETIME",
        "src_source": "SOURCE"
    }

    context.seed_config = {
        "RAW_STAGE": {
            "column_types": {
                "CUSTOMER_ID": "STRING",
                "ORDER_ID": "STRING",
                "START_DATE": "DATETIME",
                "END_DATE": "DATETIME",
                "EFFECTIVE_FROM": "DATETIME",
                "LOAD_DATETIME": "DATETIME",
                "SOURCE": "STRING"
            }
        },
        "EFF_SAT": {
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
        }
    }


@fixture
def eff_satellite_auto_end_dating_bigquery(context):
    """
    Define the structures and metadata to load effectivity satellites
    """

    set_metadata(context)

    context.seed_config = {
        "RAW_STAGE": {
            "column_types": {
                "CUSTOMER_ID": "STRING",
                "ORDER_ID": "STRING",
                "START_DATE": "DATETIME",
                "CUSTOMER_MT_ID": "STRING",
                "END_DATE": "DATETIME",
                "EFFECTIVE_FROM": "DATETIME",
                "LOAD_DATETIME": "DATETIME",
                "SOURCE": "STRING"
            }
        },
        "RAW_STAGE_CUSTOMER_ORDER": {
            "column_types": {
                "CUSTOMER_ID": "STRING",
                "ORDER_ID": "STRING",
                "START_DATE": "DATETIME",
                "CUSTOMER_MT_ID": "STRING",
                "END_DATE": "DATETIME",
                "EFFECTIVE_FROM": "DATETIME",
                "LOAD_DATETIME": "DATETIME",
                "SOURCE": "STRING"
            }
        },
        "RAW_STAGE_ORDER_CUSTOMER": {
            "column_types": {
                "CUSTOMER_ID": "STRING",
                "ORDER_ID": "STRING",
                "START_DATE": "DATETIME",
                "CUSTOMER_MT_ID": "STRING",
                "END_DATE": "DATETIME",
                "EFFECTIVE_FROM": "DATETIME",
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
        "LINK_ORDER_CUSTOMER": {
            "column_types": {
                "ORDER_CUSTOMER_PK": "STRING",
                "CUSTOMER_PK": "STRING",
                "ORDER_PK": "STRING",
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
        "EFF_SAT_ORDER_CUSTOMER": {
            "column_types": {
                "ORDER_CUSTOMER_PK": "STRING",
                "CUSTOMER_PK": "STRING",
                "ORDER_PK": "STRING",
                "START_DATE": "DATETIME",
                "END_DATE": "DATETIME",
                "EFFECTIVE_FROM": "DATETIME",
                "LOAD_DATETIME": "DATETIME",
                "SOURCE": "STRING"
            }
        },
        "EFF_SAT_ORDER_CUSTOMER_AC": {
            "column_types": {
                "ORDER_CUSTOMER_PK": "STRING",
                "CUSTOMER_PK": "STRING",
                "ORDER_PK": "STRING",
                "START_DATE": "DATETIME",
                "END_DATE": "DATETIME",
                "CUSTOMER_MT_ID": "STRING",
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
            "column_types": {
                "CUSTOMER_ID": "NUMERIC",
                "NATION_ID": "STRING",
                "ORDER_ID": "STRING",
                "PLATFORM_ID": "STRING",
                "ORGANISATION_ID": "STRING",
                "START_DATE": "DATE",
                "END_DATE": "DATE",
                "EFFECTIVE_FROM": "DATE",
                "LOAD_DATE": "DATE",
                "SOURCE": "STRING"
            }
        },
        "EFF_SAT": {
            "column_types": {
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


# SQLServer


@fixture
def eff_satellite_sqlserver(context):
    """
    Define the structures and metadata to load effectivity satellites
    """

    set_metadata(context)

    context.seed_config = {
        "RAW_STAGE": {
            "column_types": {
                "CUSTOMER_ID": "VARCHAR(4)",
                "ORDER_ID": "VARCHAR(50)",
                "CUSTOMER_MT_ID": "VARCHAR(13)",
                "CUSTOMER_CK": "VARCHAR(11)",
                "START_DATE": "DATE",
                "END_DATE": "DATE",
                "EFFECTIVE_FROM": "DATE",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR(50)"
            }
        },
        "EFF_SAT": {
            "column_types": {
                "CUSTOMER_ORDER_PK": "BINARY(16)",
                "CUSTOMER_PK": "BINARY(16)",
                "ORDER_PK": "BINARY(16)",
                "START_DATE": "DATE",
                "END_DATE": "DATE",
                "EFFECTIVE_FROM": "DATE",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR(50)"
            }
        },
        "EFF_SAT_AC": {
            "column_types": {
                "CUSTOMER_ORDER_PK": "BINARY(16)",
                "CUSTOMER_PK": "BINARY(16)",
                "ORDER_PK": "BINARY(16)",
                "CUSTOMER_MT_ID": "VARCHAR(13)",
                "START_DATE": "DATE",
                "END_DATE": "DATE",
                "EFFECTIVE_FROM": "DATE",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR(50)"
            }
        },
        "EFF_SAT_AC_MULTI": {
            "column_types": {
                "CUSTOMER_ORDER_PK": "BINARY(16)",
                "CUSTOMER_PK": "BINARY(16)",
                "ORDER_PK": "BINARY(16)",
                "CUSTOMER_MT_ID": "VARCHAR(13)",
                "CUSTOMER_CK": "VARCHAR(11)",
                "START_DATE": "DATE",
                "END_DATE": "DATE",
                "EFFECTIVE_FROM": "DATE",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR(50)"
            }
        }
    }


@fixture
def eff_satellite_datetime_sqlserver(context):
    """
    Define the structures and metadata to load effectivity satellites
    """

    set_metadata(context)

    context.hashed_columns = {
        "STG_CUSTOMER": {
            "CUSTOMER_ORDER_PK": ["CUSTOMER_ID", "ORDER_ID"],
            "CUSTOMER_PK": "CUSTOMER_ID",
            "ORDER_PK": "ORDER_ID"
        }
    }

    context.vault_structure_columns['EFF_SAT'] = {
        "src_pk": "CUSTOMER_ORDER_PK",
        "src_dfk": ["ORDER_PK"],
        "src_sfk": "CUSTOMER_PK",
        "src_start_date": "START_DATE",
        "src_end_date": "END_DATE",
        "src_eff": "EFFECTIVE_FROM",
        "src_ldts": "LOAD_DATETIME",
        "src_source": "SOURCE"
    }

    context.seed_config = {
        "RAW_STAGE": {
            "column_types": {
                "CUSTOMER_ID": "VARCHAR(10)",
                "ORDER_ID": "VARCHAR(50)",
                "START_DATE": "DATETIME2",
                "END_DATE": "DATETIME2",
                "EFFECTIVE_FROM": "DATETIME2",
                "LOAD_DATETIME": "DATETIME2",
                "SOURCE": "VARCHAR(50)"
            }
        },
        "EFF_SAT": {
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
        }
    }


@fixture
def eff_satellite_auto_end_dating_sqlserver(context):
    """
    Define the structures and metadata to load effectivity satellites
    """

    set_metadata(context)

    context.seed_config = {
        "RAW_STAGE": {
            "column_types": {
                "CUSTOMER_ID": "VARCHAR(50)",
                "ORDER_ID": "VARCHAR(50)",
                "START_DATE": "DATETIME2",
                "CUSTOMER_MT_ID": "VARCHAR(50)",
                "END_DATE": "DATETIME2",
                "EFFECTIVE_FROM": "DATETIME2",
                "LOAD_DATETIME": "DATETIME2",
                "SOURCE": "VARCHAR(50)"
            }
        },
        "RAW_STAGE_CUSTOMER_ORDER": {
            "column_types": {
                "CUSTOMER_ID": "VARCHAR(50)",
                "ORDER_ID": "VARCHAR(50)",
                "START_DATE": "DATETIME2",
                "CUSTOMER_MT_ID": "VARCHAR(50)",
                "END_DATE": "DATETIME2",
                "EFFECTIVE_FROM": "DATETIME2",
                "LOAD_DATETIME": "DATETIME2",
                "SOURCE": "VARCHAR(50)"
            }
        },
        "RAW_STAGE_ORDER_CUSTOMER": {
            "column_types": {
                "CUSTOMER_ID": "VARCHAR(50)",
                "ORDER_ID": "VARCHAR(50)",
                "START_DATE": "DATETIME2",
                "CUSTOMER_MT_ID": "VARCHAR(50)",
                "END_DATE": "DATETIME2",
                "EFFECTIVE_FROM": "DATETIME2",
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
        "LINK_ORDER_CUSTOMER": {
            "column_types": {
                "ORDER_CUSTOMER_PK": "BINARY(16)",
                "CUSTOMER_PK": "BINARY(16)",
                "ORDER_PK": "BINARY(16)",
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
        "EFF_SAT_ORDER_CUSTOMER": {
            "column_types": {
                "ORDER_CUSTOMER_PK": "BINARY(16)",
                "CUSTOMER_PK": "BINARY(16)",
                "ORDER_PK": "BINARY(16)",
                "START_DATE": "DATETIME2",
                "END_DATE": "DATETIME2",
                "EFFECTIVE_FROM": "DATETIME2",
                "LOAD_DATETIME": "DATETIME2",
                "SOURCE": "VARCHAR(50)"
            }
        },
        "EFF_SAT_ORDER_CUSTOMER_AC": {
            "column_types": {
                "ORDER_CUSTOMER_PK": "BINARY(16)",
                "CUSTOMER_PK": "BINARY(16)",
                "ORDER_PK": "BINARY(16)",
                "START_DATE": "DATETIME2",
                "END_DATE": "DATETIME2",
                "CUSTOMER_MT_ID": "VARCHAR(50)",
                "EFFECTIVE_FROM": "DATETIME2",
                "LOAD_DATETIME": "DATETIME2",
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
            "column_types": {
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
            "column_types": {
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
