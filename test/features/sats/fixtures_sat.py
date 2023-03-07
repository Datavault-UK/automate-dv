from behave import fixture


def set_vault_structure_definition(context):
    context.vault_structure_type = 'sat'

    context.vault_structure_columns = {
        "SATELLITE": {
            "src_pk": "CUSTOMER_PK",
            "src_payload": ["CUSTOMER_NAME", "CUSTOMER_DOB", "CUSTOMER_PHONE"],
            "src_hashdiff": "HASHDIFF",
            "src_eff": "EFFECTIVE_FROM",
            "src_ldts": "LOAD_DATE",
            "src_source": "SOURCE"
        },
        "SATELLITE_TZ": {
            "src_pk": "CUSTOMER_PK",
            "src_payload": ["CUSTOMER_NAME", "CUSTOMER_DOB", "CUSTOMER_PHONE"],
            "src_hashdiff": "HASHDIFF",
            "src_eff": "EFFECTIVE_FROM_TZ",
            "src_ldts": "LOAD_DATE_TZ",
            "src_source": "SOURCE"
        },
        "SATELLITE_PL_EXCLUDE": {
            "src_pk": "CUSTOMER_PK",
            "src_payload": ['CUSTOMER_NAME', 'CUSTOMER_DOB', 'CUSTOMER_PHONE', 'CUSTOMER_ID'],
            "src_hashdiff": "HASHDIFF",
            "src_eff": "EFFECTIVE_FROM",
            "src_ldts": "LOAD_DATE",
            "src_source": "SOURCE"
        },
        "SATELLITE_HD_ALIAS": {
            "src_pk": "CUSTOMER_PK",
            "src_payload": ["CUSTOMER_NAME", "CUSTOMER_PHONE", "CUSTOMER_DOB"],
            "src_hashdiff": {"source_column": "HASHDIFF", "alias": "CUSTOMER_HASHDIFF"},
            "src_eff": "EFFECTIVE_FROM",
            "src_ldts": "LOAD_DATE",
            "src_source": "SOURCE"
        },
        "SATELLITE_PL_EXCLUDE_HD_ALIAS": {
            "src_pk": "CUSTOMER_PK",
            "src_payload": ['CUSTOMER_NAME', 'CUSTOMER_DOB', 'CUSTOMER_PHONE', 'CUSTOMER_ID'],
            "src_hashdiff": {"source_column": "HASHDIFF", "alias": "CUSTOMER_HASHDIFF"},
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
        },
        "SATELLITE_AC": {
            "src_pk": "CUSTOMER_PK",
            "src_payload": ["CUSTOMER_NAME", "CUSTOMER_PHONE", "CUSTOMER_DOB"],
            "src_hashdiff": "HASHDIFF",
            "src_extra_columns": "CUSTOMER_MT_ID",
            "src_eff": "EFFECTIVE_FROM",
            "src_ldts": "LOAD_DATE",
            "src_source": "SOURCE"
        },
        "SATELLITE_AC_TZ": {
            "src_pk": "CUSTOMER_PK",
            "src_payload": ["CUSTOMER_NAME", "CUSTOMER_PHONE", "CUSTOMER_DOB"],
            "src_hashdiff": "HASHDIFF",
            "src_extra_columns": "CUSTOMER_MT_ID",
            "src_eff": "EFFECTIVE_FROM_TZ",
            "src_ldts": "LOAD_DATE_TZ",
            "src_source": "SOURCE"
        }
    }


def set_staging_definition(context):
    context.stage_columns = {
        "RAW_STAGE":
            ["CUSTOMER_ID",
             "CUSTOMER_NAME",
             "CUSTOMER_DOB",
             "CUSTOMER_PHONE",
             "EFFECTIVE_FROM",
             "LOAD_DATE",
             "SOURCE"],
        "RAW_STAGE_TZ":
            ["CUSTOMER_ID",
             "CUSTOMER_NAME",
             "CUSTOMER_DOB",
             "CUSTOMER_PHONE",
             "CUSTOMER_MT_ID",
              "LOAD_DATE_TZ",
             "SOURCE"],
        "RAW_STAGE_TS":
            ["CUSTOMER_ID",
             "CUSTOMER_NAME",
             "CUSTOMER_DOB",
             "CUSTOMER_PHONE",
             "LOAD_DATE_TZ",
             "SOURCE"]
    }

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
        "STG_CUSTOMER_TZ": {
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
        "STG_CUSTOMER_TZ": {
            "EFFECTIVE_FROM_TZ": "LOAD_DATE_TZ"
        },
        "STG_CUSTOMER_TS": {
            "EFFECTIVE_FROM": "LOAD_DATETIME"
        },
        "STG_CUSTOMER_NO_PK_HASHDIFF": {
            "EFFECTIVE_FROM": "LOAD_DATE"
        }
    }


def set_metadata(context):
    set_vault_structure_definition(context)

    set_staging_definition(context)


# Snowflake

@fixture
def satellite_snowflake(context):
    """
    Define the structures and metadata to load satellites
    """

    set_metadata(context)

    context.seed_config = {
        "RAW_STAGE": {
            "column_types": {
                "CUSTOMER_ID": "NUMBER(38, 0)",
                "CUSTOMER_NAME": "VARCHAR",
                "CUSTOMER_PHONE": "VARCHAR",
                "CUSTOMER_DOB": "DATE",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR"
            }
        },
        "RAW_STAGE_TZ": {
            "column_types": {
                "CUSTOMER_ID": "NUMBER(38, 0)",
                "CUSTOMER_NAME": "VARCHAR",
                "CUSTOMER_PHONE": "VARCHAR",
                "CUSTOMER_DOB": "DATE",
                "CUSTOMER_MT_ID": "VARCHAR",
                "LOAD_DATE_TZ": "TIMESTAMP_TZ",
                "SOURCE": "VARCHAR"
            }
        },
        "RAW_STAGE_TS": {
            "column_types": {
                "CUSTOMER_ID": "NUMBER(38, 0)",
                "CUSTOMER_NAME": "VARCHAR",
                "CUSTOMER_PHONE": "VARCHAR",
                "CUSTOMER_DOB": "DATE",
                "LOAD_DATETIME": "DATETIME",
                "SOURCE": "VARCHAR"
            }
        },
        "SATELLITE": {
            "column_types": {
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
        "SATELLITE_TZ": {
            "column_types": {
                "CUSTOMER_PK": "BINARY(16)",
                "CUSTOMER_NAME": "VARCHAR",
                "CUSTOMER_PHONE": "VARCHAR",
                "CUSTOMER_DOB": "DATE",
                "HASHDIFF": "BINARY(16)",
                "EFFECTIVE_FROM_TZ": "TIMESTAMP_TZ",
                "LOAD_DATE_TZ": "TIMESTAMP_TZ",
                "SOURCE": "VARCHAR"
            }
        },
        "SATELLITE_HD_ALIAS": {
            "column_types": {
                "CUSTOMER_PK": "BINARY(16)",
                "CUSTOMER_NAME": "VARCHAR",
                "CUSTOMER_PHONE": "VARCHAR",
                "CUSTOMER_DOB": "DATE",
                "CUSTOMER_HASHDIFF": "BINARY(16)",
                "EFFECTIVE_FROM": "DATE",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR"
            }
        },
        "SATELLITE_PL_EXCLUDE": {
            "column_types": {
                "CUSTOMER_PK": "BINARY(16)",
                "CUSTOMER_NAME": "VARCHAR",
                "CUSTOMER_PHONE": "VARCHAR",
                "CUSTOMER_ID": "VARCHAR",
                "CUSTOMER_DOB": "DATE",
                "HASHDIFF": "BINARY(16)",
                "EFFECTIVE_FROM": "DATE",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR"
            }
        },
        "SATELLITE_PL_EXCLUDE_HD_ALIAS": {
            "column_types": {
                "CUSTOMER_PK": "BINARY(16)",
                "CUSTOMER_NAME": "VARCHAR",
                "CUSTOMER_PHONE": "VARCHAR",
                "CUSTOMER_DOB": "DATE",
                "CUSTOMER_ID": "VARCHAR",
                "CUSTOMER_HASHDIFF": "BINARY(16)",
                "EFFECTIVE_FROM": "DATE",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR"
            }
        },
        "SATELLITE_TS": {
            "column_types": {
                "CUSTOMER_PK": "BINARY(16)",
                "CUSTOMER_NAME": "VARCHAR",
                "CUSTOMER_PHONE": "VARCHAR",
                "CUSTOMER_DOB": "DATE",
                "HASHDIFF": "BINARY(16)",
                "EFFECTIVE_FROM": "DATETIME",
                "LOAD_DATETIME": "DATETIME",
                "SOURCE": "VARCHAR"
            }
        },
        "SATELLITE_AC": {
            "column_types": {
                "CUSTOMER_PK": "BINARY(16)",
                "CUSTOMER_NAME": "VARCHAR",
                "CUSTOMER_PHONE": "VARCHAR",
                "CUSTOMER_DOB": "DATE",
                "HASHDIFF": "BINARY(16)",
                "CUSTOMER_MT_ID": "VARCHAR",
                "EFFECTIVE_FROM": "DATE",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR"
            }
        },
        "SATELLITE_AC_TZ": {
            "column_types": {
                "CUSTOMER_PK": "BINARY(16)",
                "CUSTOMER_NAME": "VARCHAR",
                "CUSTOMER_PHONE": "VARCHAR",
                "CUSTOMER_DOB": "DATE",
                "HASHDIFF": "BINARY(16)",
                "CUSTOMER_MT_ID": "VARCHAR",
                "EFFECTIVE_FROM_TZ": "TIMESTAMP_TZ",
                "LOAD_DATE_TZ": "TIMESTAMP_TZ",
                "SOURCE": "VARCHAR"
            }
        }
    }


@fixture
def satellite_cycle_snowflake(context):
    """
    Define the structures and metadata to perform load cycles for satellites
    """

    set_metadata(context)

    context.seed_config = {
        "RAW_STAGE": {
            "column_types": {
                "CUSTOMER_ID": "VARCHAR",
                "CUSTOMER_NAME": "VARCHAR",
                "CUSTOMER_DOB": "DATE",
                "CUSTOMER_PHONE": "VARCHAR",
                "EFFECTIVE_FROM": "DATE",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR"
            }
        },
        "RAW_STAGE_TZ": {
            "column_types": {
                "CUSTOMER_ID": "VARCHAR",
                "CUSTOMER_NAME": "VARCHAR",
                "CUSTOMER_DOB": "DATE",
                "CUSTOMER_PHONE": "VARCHAR",
                "EFFECTIVE_FROM_TZ": "TIMESTAMP_TZ",
                "CUSTOMER_MT_ID": "VARCHAR",
                "LOAD_DATE_TZ": "TIMESTAMP_TZ",
                "SOURCE": "VARCHAR"
            }
        },
        "SATELLITE": {
            "column_types": {
                "CUSTOMER_PK": "BINARY(16)",
                "CUSTOMER_NAME": "VARCHAR",
                "CUSTOMER_DOB": "DATE",
                "CUSTOMER_PHONE": "VARCHAR",
                "HASHDIFF": "BINARY(16)",
                "EFFECTIVE_FROM": "DATE",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR"
            }
        },
        "SATELLITE_TZ": {
            "column_types": {
                "CUSTOMER_PK": "BINARY(16)",
                "CUSTOMER_NAME": "VARCHAR",
                "CUSTOMER_DOB": "DATE",
                "CUSTOMER_PHONE": "VARCHAR",
                "HASHDIFF": "BINARY(16)",
                "EFFECTIVE_FROM_TZ": "TIMESTAMP_TZ",
                "LOAD_DATE_TZ": "TIMESTAMP_TZ",
                "SOURCE": "VARCHAR"
            }
        }
    }


# BigQuery


@fixture
def satellite_bigquery(context):
    """
    Define the structures and metadata to load satellites
    """

    set_metadata(context)

    context.seed_config = {
        "RAW_STAGE": {
            "column_types": {
                "CUSTOMER_ID": "STRING",
                "CUSTOMER_NAME": "STRING",
                "CUSTOMER_PHONE": "STRING",
                "CUSTOMER_DOB": "DATE",
                "LOAD_DATE": "DATE",
                "SOURCE": "STRING"
            }
        },
        "RAW_STAGE_TZ": {
            "column_types": {
                "CUSTOMER_ID": "STRING",
                "CUSTOMER_NAME": "STRING",
                "CUSTOMER_PHONE": "STRING",
                "CUSTOMER_DOB": "DATE",
                "CUSTOMER_MT_ID": "STRING",
                "LOAD_DATE_TZ": "TIMESTAMP",
                "SOURCE": "STRING"
            }
        },
        "RAW_STAGE_TS": {
            "column_types": {
                "CUSTOMER_ID": "STRING",
                "CUSTOMER_NAME": "STRING",
                "CUSTOMER_PHONE": "STRING",
                "CUSTOMER_DOB": "DATE",
                "LOAD_DATETIME": "DATETIME",
                "SOURCE": "STRING"
            }
        },
        "SATELLITE": {
            "column_types": {
                "CUSTOMER_PK": "STRING",
                "CUSTOMER_NAME": "STRING",
                "CUSTOMER_PHONE": "STRING",
                "CUSTOMER_DOB": "DATE",
                "HASHDIFF": "STRING",
                "EFFECTIVE_FROM": "DATE",
                "LOAD_DATE": "DATE",
                "SOURCE": "STRING"
            }
        },
        "SATELLITE_HD_ALIAS": {
            "column_types": {
                "CUSTOMER_PK": "STRING",
                "CUSTOMER_NAME": "STRING",
                "CUSTOMER_PHONE": "STRING",
                "CUSTOMER_DOB": "DATE",
                "CUSTOMER_HASHDIFF": "STRING",
                "EFFECTIVE_FROM": "DATE",
                "LOAD_DATE": "DATE",
                "SOURCE": "STRING"
            }
        },
        "SATELLITE_TZ": {
            "column_types": {
                "CUSTOMER_PK": "STRING",
                "CUSTOMER_NAME": "STRING",
                "CUSTOMER_PHONE": "STRING",
                "CUSTOMER_DOB": "DATE",
                "HASHDIFF": "STRING",
                "EFFECTIVE_FROM_TZ": "TIMESTAMP",
                "LOAD_DATE_TZ": "TIMESTAMP",
                "SOURCE": "STRING"
            }
        },
        "SATELLITE_PL_EXCLUDE": {
            "column_types": {
                "CUSTOMER_PK": "STRING",
                "CUSTOMER_NAME": "STRING",
                "CUSTOMER_PHONE": "STRING",
                "CUSTOMER_ID": "STRING",
                "CUSTOMER_DOB": "DATE",
                "HASHDIFF": "STRING",
                "EFFECTIVE_FROM": "DATE",
                "LOAD_DATE": "DATE",
                "SOURCE": "STRING"
            }
        },
        "SATELLITE_PL_EXCLUDE_HD_ALIAS": {
            "column_types": {
                "CUSTOMER_PK": "STRING",
                "CUSTOMER_NAME": "STRING",
                "CUSTOMER_PHONE": "STRING",
                "CUSTOMER_DOB": "DATE",
                "CUSTOMER_ID": "STRING",
                "CUSTOMER_HASHDIFF": "STRING",
                "EFFECTIVE_FROM": "DATE",
                "LOAD_DATE": "DATE",
                "SOURCE": "STRING"
            }
        },
        "SATELLITE_TS": {
            "column_types": {
                "CUSTOMER_PK": "STRING",
                "CUSTOMER_NAME": "STRING",
                "CUSTOMER_PHONE": "STRING",
                "CUSTOMER_DOB": "DATE",
                "HASHDIFF": "STRING",
                "EFFECTIVE_FROM": "DATETIME",
                "LOAD_DATETIME": "DATETIME",
                "SOURCE": "STRING"
            }
        },
        "SATELLITE_AC": {
            "column_types": {
                "CUSTOMER_PK": "STRING",
                "CUSTOMER_NAME": "STRING",
                "CUSTOMER_PHONE": "STRING",
                "CUSTOMER_DOB": "DATE",
                "HASHDIFF": "STRING",
                "CUSTOMER_MT_ID": "STRING",
                "EFFECTIVE_FROM": "DATE",
                "LOAD_DATE": "DATE",
                "SOURCE": "STRING"
            }
        },
        "SATELLITE_AC_TZ": {
            "column_types": {
                "CUSTOMER_PK": "STRING",
                "CUSTOMER_NAME": "STRING",
                "CUSTOMER_PHONE": "STRING",
                "CUSTOMER_DOB": "DATE",
                "HASHDIFF": "STRING",
                "CUSTOMER_MT_ID": "STRING",
                "EFFECTIVE_FROM_TZ": "TIMESTAMP",
                "LOAD_DATE_TZ": "TIMESTAMP",
                "SOURCE": "STRING"
            }
        }
    }


@fixture
def satellite_cycle_bigquery(context):
    """
    Define the structures and metadata to perform load cycles for satellites
    """

    set_metadata(context)

    context.seed_config = {
        "RAW_STAGE": {
            "column_types": {
                "CUSTOMER_ID": "STRING",
                "CUSTOMER_NAME": "STRING",
                "CUSTOMER_DOB": "DATE",
                "CUSTOMER_PHONE": "STRING",
                "EFFECTIVE_FROM": "DATE",
                "LOAD_DATE": "DATE",
                "SOURCE": "STRING"
            }
        },
        "RAW_STAGE_TZ": {
            "column_types": {
                "CUSTOMER_ID": "STRING",
                "CUSTOMER_NAME": "STRING",
                "CUSTOMER_DOB": "DATE",
                "CUSTOMER_PHONE": "STRING",
                "CUSTOMER_MT_ID": "STRING",
                "LOAD_DATE_TZ": "TIMESTAMP",
                "SOURCE": "STRING"
            }
        },
        "SATELLITE": {
            "column_types": {
                "CUSTOMER_PK": "STRING",
                "CUSTOMER_NAME": "STRING",
                "CUSTOMER_DOB": "DATE",
                "CUSTOMER_PHONE": "STRING",
                "HASHDIFF": "STRING",
                "EFFECTIVE_FROM": "DATE",
                "LOAD_DATE": "DATE",
                "SOURCE": "STRING"
            }
        },
        "SATELLITE_TZ": {
            "column_types": {
                "CUSTOMER_PK": "STRING",
                "CUSTOMER_NAME": "STRING",
                "CUSTOMER_DOB": "DATE",
                "CUSTOMER_PHONE": "STRING",
                "HASHDIFF": "STRING",
                "EFFECTIVE_FROM_TZ": "TIMESTAMP",
                "LOAD_DATE_TZ": "TIMESTAMP",
                "SOURCE": "STRING"
            }
        }
    }


# SQLServer


@fixture
def satellite_sqlserver(context):
    """
    Define the structures and metadata to load satellites
    """

    set_metadata(context)

    context.seed_config = {
        "RAW_STAGE": {
            "column_types": {
                "CUSTOMER_ID": "DECIMAL(38,0)",
                "CUSTOMER_NAME": "VARCHAR(50)",
                "CUSTOMER_PHONE": "VARCHAR(50)",
                "CUSTOMER_DOB": "DATE",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR(50)"
            }
        },
        "RAW_STAGE_TS": {
            "column_types": {
                "CUSTOMER_ID": "DECIMAL(38,0)",
                "CUSTOMER_NAME": "VARCHAR(50)",
                "CUSTOMER_PHONE": "VARCHAR(50)",
                "CUSTOMER_DOB": "DATE",
                "LOAD_DATETIME": "DATETIME2",
                "SOURCE": "VARCHAR(50)"
            }
        },
        "RAW_STAGE_TZ": {
            "column_types": {
                "CUSTOMER_ID": "DECIMAL(38, 0)",
                "CUSTOMER_NAME": "VARCHAR(50)",
                "CUSTOMER_PHONE": "VARCHAR(50)",
                "CUSTOMER_DOB": "DATE",
                "CUSTOMER_MT_ID": "VARCHAR(13)",
                "LOAD_DATE_TZ": "DATETIME2",
                "SOURCE": "VARCHAR(50)"
            }
        },
        "SATELLITE": {
            "column_types": {
                "CUSTOMER_PK": "BINARY(16)",
                "CUSTOMER_NAME": "VARCHAR(50)",
                "CUSTOMER_PHONE": "VARCHAR(50)",
                "CUSTOMER_ID": "VARCHAR(50)",
                "CUSTOMER_DOB": "DATE",
                "HASHDIFF": "BINARY(16)",
                "EFFECTIVE_FROM": "DATE",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR(50)"
            }
        },
        "SATELLITE_TZ": {
            "column_types": {
                "CUSTOMER_PK": "BINARY(16)",
                "CUSTOMER_NAME": "VARCHAR(50)",
                "CUSTOMER_PHONE": "VARCHAR(50)",
                "CUSTOMER_DOB": "DATE",
                "HASHDIFF": "BINARY(16)",
                "EFFECTIVE_FROM_TZ": "DATETIME2",
                "LOAD_DATE_TZ": "DATETIME2",
                "SOURCE": "VARCHAR(50)"
            }
        },
        "SATELLITE_HD_ALIAS": {
            "column_types": {
                "CUSTOMER_PK": "BINARY(16)",
                "CUSTOMER_NAME": "VARCHAR(50)",
                "CUSTOMER_PHONE": "VARCHAR(50)",
                "CUSTOMER_ID": "VARCHAR(50)",
                "CUSTOMER_DOB": "DATE",
                "CUSTOMER_HASHDIFF": "BINARY(16)",
                "EFFECTIVE_FROM": "DATE",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR(50)"
            }
        },
        "SATELLITE_PL_EXCLUDE": {
            "column_types": {
                "CUSTOMER_PK": "BINARY(16)",
                "CUSTOMER_NAME": "VARCHAR(50)",
                "CUSTOMER_PHONE": "VARCHAR(50)",
                "CUSTOMER_ID": "VARCHAR(50)",
                "CUSTOMER_DOB": "DATE",
                "HASHDIFF": "BINARY(16)",
                "EFFECTIVE_FROM": "DATE",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR(50)"
            }
        },
        "SATELLITE_PL_EXCLUDE_HD_ALIAS": {
            "column_types": {
                "CUSTOMER_PK": "BINARY(16)",
                "CUSTOMER_NAME": "VARCHAR(50)",
                "CUSTOMER_PHONE": "VARCHAR(50)",
                "CUSTOMER_DOB": "DATE",
                "CUSTOMER_ID": "VARCHAR(50)",
                "CUSTOMER_HASHDIFF": "BINARY(16)",
                "EFFECTIVE_FROM": "DATE",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR(50)"
            }
        },
        "SATELLITE_TS": {
            "column_types": {
                "CUSTOMER_PK": "BINARY(16)",
                "CUSTOMER_NAME": "VARCHAR(50)",
                "CUSTOMER_PHONE": "VARCHAR(50)",
                "CUSTOMER_DOB": "DATE",
                "HASHDIFF": "BINARY(16)",
                "EFFECTIVE_FROM": "DATETIME2",
                "LOAD_DATETIME": "DATETIME2",
                "SOURCE": "VARCHAR(50)"
            }
        },
        "SATELLITE_AC": {
            "column_types": {
                "CUSTOMER_PK": "BINARY(16)",
                "CUSTOMER_NAME": "VARCHAR(50)",
                "CUSTOMER_PHONE": "VARCHAR(50)",
                "CUSTOMER_DOB": "DATE",
                "HASHDIFF": "BINARY(16)",
                "CUSTOMER_MT_ID": "VARCHAR(13)",
                "EFFECTIVE_FROM": "DATE",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR(50)"
            }
        },
        "SATELLITE_AC_TZ": {
            "column_types": {
                "CUSTOMER_PK": "BINARY(16)",
                "CUSTOMER_NAME": "VARCHAR(50)",
                "CUSTOMER_PHONE": "VARCHAR(50)",
                "CUSTOMER_DOB": "DATE",
                "HASHDIFF": "BINARY(16)",
                "CUSTOMER_MT_ID": "VARCHAR(13)",
                "EFFECTIVE_FROM_TZ": "DATETIME2",
                "LOAD_DATE_TZ": "DATETIME2",
                "SOURCE": "VARCHAR(50)"
            }
        }
    }


@fixture
def satellite_cycle_sqlserver(context):
    """
    Define the structures and metadata to perform load cycles for satellites
    """

    set_metadata(context)

    context.seed_config = {
        "RAW_STAGE": {
            "column_types": {
                "CUSTOMER_ID": "VARCHAR(50)",
                "CUSTOMER_NAME": "VARCHAR(50)",
                "CUSTOMER_DOB": "DATE",
                "CUSTOMER_PHONE": "VARCHAR(15)",
                "EFFECTIVE_FROM": "DATE",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR(50)"
            }
        },
        "RAW_STAGE_TZ": {
            "column_types": {
                "CUSTOMER_ID": "VARCHAR(50)",
                "CUSTOMER_NAME": "VARCHAR(50)",
                "CUSTOMER_DOB": "DATE",
                "CUSTOMER_PHONE": "VARCHAR(15)",
                "EFFECTIVE_FROM_TZ": "DATETIME2",
                "CUSTOMER_MT_ID": "VARCHAR(13)",
                "LOAD_DATE_TZ": "DATETIME2",
                "SOURCE": "VARCHAR(50)"
            }
        },
        "SATELLITE": {
            "column_types": {
                "CUSTOMER_PK": "BINARY(16)",
                "CUSTOMER_NAME": "VARCHAR(50)",
                "CUSTOMER_DOB": "DATE",
                "CUSTOMER_PHONE": "VARCHAR(15)",
                "HASHDIFF": "BINARY(16)",
                "EFFECTIVE_FROM": "DATE",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR(50)"
            }
        },
        "SATELLITE_TZ": {
            "column_types": {
                "CUSTOMER_PK": "BINARY(16)",
                "CUSTOMER_NAME": "VARCHAR(50)",
                "CUSTOMER_DOB": "DATE",
                "CUSTOMER_PHONE": "VARCHAR(15)",
                "HASHDIFF": "BINARY(16)",
                "EFFECTIVE_FROM_TZ": "DATETIME2",
                "LOAD_DATE_TZ": "DATETIME2",
                "SOURCE": "VARCHAR(50)"
            }
        }
    }


# Databricks

@fixture
def satellite_databricks(context):
    """
    Define the structures and metadata to load satellites
    """

    set_metadata(context)

    context.seed_config = {
        "RAW_STAGE": {
            "column_types": {
                "CUSTOMER_ID": "DECIMAL(38,0)",
                "CUSTOMER_NAME": "VARCHAR(100)",
                "CUSTOMER_PHONE": "VARCHAR(100)",
                "CUSTOMER_DOB": "DATE",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR(100)"
            }
        },
        "RAW_STAGE_TZ": {
            "column_types": {
                "CUSTOMER_ID": "DECIMAL(38, 0)",
                "CUSTOMER_NAME": "VARCHAR(100)",
                "CUSTOMER_PHONE": "VARCHAR(100)",
                "CUSTOMER_DOB": "DATE",
                "CUSTOMER_MT_ID": "VARCHAR(100)",
                "LOAD_DATE_TZ": "TIMESTAMP",
                "SOURCE": "VARCHAR(100)"
            }
        },
        "RAW_STAGE_TS": {
            "column_types": {
                "CUSTOMER_ID": "DECIMAL(38,0)",
                "CUSTOMER_NAME": "VARCHAR(100)",
                "CUSTOMER_PHONE": "VARCHAR(100)",
                "CUSTOMER_DOB": "DATE",
                "LOAD_DATETIME": "TIMESTAMP",
                "SOURCE": "VARCHAR(100)"
            }
        },
        "SATELLITE": {
            "column_types": {
                "CUSTOMER_PK": "STRING",
                "CUSTOMER_NAME": "VARCHAR(100)",
                "CUSTOMER_PHONE": "VARCHAR(100)",
                "CUSTOMER_DOB": "DATE",
                "HASHDIFF": "STRING",
                "EFFECTIVE_FROM": "DATE",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR(100)"
            }
        },
        "SATELLITE_TZ": {
            "column_types": {
                "CUSTOMER_PK": "STRING",
                "CUSTOMER_NAME": "VARCHAR(100)",
                "CUSTOMER_PHONE": "VARCHAR(100)",
                "CUSTOMER_DOB": "DATE",
                "HASHDIFF": "STRING",
                "EFFECTIVE_FROM_TZ": "TIMESTAMP",
                "LOAD_DATE_TZ": "TIMESTAMP",
                "SOURCE": "VARCHAR(100)"
            }
        },
        "SATELLITE_HD_ALIAS": {
            "column_types": {
                "CUSTOMER_PK": "STRING",
                "CUSTOMER_NAME": "VARCHAR(100)",
                "CUSTOMER_PHONE": "VARCHAR(100)",
                "CUSTOMER_DOB": "DATE",
                "CUSTOMER_HASHDIFF": "STRING",
                "EFFECTIVE_FROM": "DATE",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR(100)"
            }
        },
        "SATELLITE_PL_EXCLUDE": {
            "column_types": {
                "CUSTOMER_PK": "STRING",
                "CUSTOMER_NAME": "VARCHAR(100)",
                "CUSTOMER_PHONE": "VARCHAR(100)",
                "CUSTOMER_ID": "VARCHAR(100)",
                "CUSTOMER_DOB": "DATE",
                "HASHDIFF": "STRING",
                "EFFECTIVE_FROM": "DATE",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR(100)"
            }
        },
        "SATELLITE_PL_EXCLUDE_HD_ALIAS": {
            "column_types": {
                "CUSTOMER_PK": "STRING",
                "CUSTOMER_NAME": "VARCHAR(100)",
                "CUSTOMER_PHONE": "VARCHAR(100)",
                "CUSTOMER_DOB": "DATE",
                "CUSTOMER_ID": "VARCHAR(100)",
                "CUSTOMER_HASHDIFF": "STRING",
                "EFFECTIVE_FROM": "DATE",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR(100)"
            }
        },
        "SATELLITE_TS": {
            "column_types": {
                "CUSTOMER_PK": "STRING",
                "CUSTOMER_NAME": "VARCHAR(100)",
                "CUSTOMER_PHONE": "VARCHAR(100)",
                "CUSTOMER_DOB": "DATE",
                "HASHDIFF": "STRING",
                "EFFECTIVE_FROM": "TIMESTAMP",
                "LOAD_DATETIME": "TIMESTAMP",
                "SOURCE": "VARCHAR(100)"
            }
        },
        "SATELLITE_AC": {
            "column_types": {
                "CUSTOMER_PK": "STRING",
                "CUSTOMER_NAME": "VARCHAR(100)",
                "CUSTOMER_PHONE": "VARCHAR(100)",
                "CUSTOMER_DOB": "DATE",
                "HASHDIFF": "STRING",
                "CUSTOMER_MT_ID": "VARCHAR(100)",
                "EFFECTIVE_FROM": "DATE",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR(100)"
            }
        },
        "SATELLITE_AC_TZ": {
            "column_types": {
                "CUSTOMER_PK": "STRING",
                "CUSTOMER_NAME": "VARCHAR(100)",
                "CUSTOMER_PHONE": "VARCHAR(100)",
                "CUSTOMER_DOB": "DATE",
                "HASHDIFF": "STRING",
                "CUSTOMER_MT_ID": "VARCHAR(100)",
                "EFFECTIVE_FROM_TZ": "TIMESTAMP",
                "LOAD_DATE_TZ": "TIMESTAMP",
                "SOURCE": "VARCHAR(100)"
            }
        }
    }


@fixture
def satellite_cycle_databricks(context):
    """
    Define the structures and metadata to perform load cycles for satellites
    """

    set_metadata(context)

    context.seed_config = {
        "RAW_STAGE": {
            "column_types": {
                "CUSTOMER_ID": "VARCHAR(100)",
                "CUSTOMER_NAME": "VARCHAR(100)",
                "CUSTOMER_DOB": "DATE",
                "CUSTOMER_PHONE": "VARCHAR(100)",
                "EFFECTIVE_FROM": "DATE",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR(100)"
            }
        },
        "RAW_STAGE_TZ": {
            "column_types": {
                "CUSTOMER_ID": "VARCHAR(100)",
                "CUSTOMER_NAME": "VARCHAR(100)",
                "CUSTOMER_DOB": "DATE",
                "CUSTOMER_PHONE": "VARCHAR(100)",
                "EFFECTIVE_FROM_TZ": "TIMESTAMP",
                "CUSTOMER_MT_ID": "VARCHAR(100)",
                "LOAD_DATE_TZ": "TIMESTAMP",
                "SOURCE": "VARCHAR(100)"
            }
        },
        "SATELLITE": {
            "column_types": {
                "CUSTOMER_PK": "STRING",
                "CUSTOMER_NAME": "VARCHAR(100)",
                "CUSTOMER_DOB": "DATE",
                "CUSTOMER_PHONE": "VARCHAR(100)",
                "HASHDIFF": "STRING",
                "EFFECTIVE_FROM": "DATE",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR(100)"
            }
        },
        "SATELLITE_TZ": {
            "column_types": {
                "CUSTOMER_PK": "STRING",
                "CUSTOMER_NAME": "VARCHAR(100)",
                "CUSTOMER_DOB": "DATE",
                "CUSTOMER_PHONE": "VARCHAR(100)",
                "HASHDIFF": "STRING",
                "EFFECTIVE_FROM_TZ": "TIMESTAMP",
                "LOAD_DATE_TZ": "TIMESTAMP",
                "SOURCE": "VARCHAR(100)"
            }
        }
    }


# Postgres

@fixture
def satellite_postgres(context):
    """
    Define the structures and metadata to load satellites
    """

    set_metadata(context)

    context.seed_config = {
        "RAW_STAGE": {
            "column_types": {
                "CUSTOMER_ID": "NUMERIC(38, 0)",
                "CUSTOMER_NAME": "VARCHAR",
                "CUSTOMER_PHONE": "VARCHAR",
                "CUSTOMER_DOB": "DATE",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR"
            }
        },
        "RAW_STAGE_TZ": {
            "column_types": {
                "CUSTOMER_ID": "NUMERIC(38, 0)",
                "CUSTOMER_NAME": "VARCHAR",
                "CUSTOMER_PHONE": "VARCHAR",
                "CUSTOMER_DOB": "DATE",
                "CUSTOMER_MT_ID": "VARCHAR",
                "LOAD_DATE_TZ": "TIMESTAMPTZ",
                "SOURCE": "VARCHAR"
            }
        },
        "RAW_STAGE_TS": {
            "column_types": {
                "CUSTOMER_ID": "NUMERIC(38, 0)",
                "CUSTOMER_NAME": "VARCHAR",
                "CUSTOMER_PHONE": "VARCHAR",
                "CUSTOMER_DOB": "DATE",
                "LOAD_DATETIME": "DATETIME",
                "SOURCE": "VARCHAR"
            }
        },
        "SATELLITE": {
            "column_types": {
                "CUSTOMER_PK": "BYTEA",
                "CUSTOMER_NAME": "VARCHAR",
                "CUSTOMER_PHONE": "VARCHAR",
                "CUSTOMER_DOB": "DATE",
                "HASHDIFF": "BYTEA",
                "EFFECTIVE_FROM": "DATE",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR"
            }
        },
        "SATELLITE_TZ": {
            "column_types": {
                "CUSTOMER_PK": "BYTEA",
                "CUSTOMER_NAME": "VARCHAR",
                "CUSTOMER_PHONE": "VARCHAR",
                "CUSTOMER_DOB": "DATE",
                "HASHDIFF": "BYTEA",
                "EFFECTIVE_FROM_TZ": "TIMESTAMPTZ",
                "LOAD_DATE_TZ": "TIMESTAMPTZ",
                "SOURCE": "VARCHAR"
            }
        },
        "SATELLITE_HD_ALIAS": {
            "column_types": {
                "CUSTOMER_PK": "BYTEA",
                "CUSTOMER_NAME": "VARCHAR",
                "CUSTOMER_PHONE": "VARCHAR",
                "CUSTOMER_DOB": "DATE",
                "CUSTOMER_HASHDIFF": "BYTEA",
                "EFFECTIVE_FROM": "DATE",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR"
            }
        },
        "SATELLITE_PL_EXCLUDE": {
            "column_types": {
                "CUSTOMER_PK": "BYTEA",
                "CUSTOMER_NAME": "VARCHAR",
                "CUSTOMER_PHONE": "VARCHAR",
                "CUSTOMER_ID": "VARCHAR",
                "CUSTOMER_DOB": "DATE",
                "HASHDIFF": "BYTEA",
                "EFFECTIVE_FROM": "DATE",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR"
            }
        },
        "SATELLITE_PL_EXCLUDE_HD_ALIAS": {
            "column_types": {
                "CUSTOMER_PK": "BYTEA",
                "CUSTOMER_NAME": "VARCHAR",
                "CUSTOMER_PHONE": "VARCHAR",
                "CUSTOMER_DOB": "DATE",
                "CUSTOMER_ID": "VARCHAR",
                "CUSTOMER_HASHDIFF": "BYTEA",
                "EFFECTIVE_FROM": "DATE",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR`"
            }
        },
        "SATELLITE_TS": {
            "column_types": {
                "CUSTOMER_PK": "BYTEA",
                "CUSTOMER_NAME": "VARCHAR",
                "CUSTOMER_PHONE": "VARCHAR",
                "CUSTOMER_DOB": "DATE",
                "HASHDIFF": "BYTEA",
                "EFFECTIVE_FROM": "DATETIME",
                "LOAD_DATETIME": "DATETIME",
                "SOURCE": "VARCHAR"
            }
        },
        "SATELLITE_AC": {
            "column_types": {
                "CUSTOMER_PK": "BYTEA",
                "CUSTOMER_NAME": "VARCHAR",
                "CUSTOMER_PHONE": "VARCHAR",
                "CUSTOMER_DOB": "DATE",
                "HASHDIFF": "BYTEA",
                "CUSTOMER_MT_ID": "VARCHAR",
                "EFFECTIVE_FROM": "DATE",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR"
            }
        },
        "SATELLITE_AC_TZ": {
            "column_types": {
                "CUSTOMER_PK": "BYTEA",
                "CUSTOMER_NAME": "VARCHAR",
                "CUSTOMER_PHONE": "VARCHAR",
                "CUSTOMER_DOB": "DATE",
                "HASHDIFF": "BYTEA",
                "CUSTOMER_MT_ID": "VARCHAR",
                "EFFECTIVE_FROM_TZ": "DATETIME",
                "LOAD_DATE_TZ": "DATETIME",
                "SOURCE": "VARCHAR"
            }
        }
    }


@fixture
def satellite_cycle_postgres(context):
    """
    Define the structures and metadata to perform load cycles for satellites
    """

    set_metadata(context)

    context.seed_config = {
        "RAW_STAGE": {
            "column_types": {
                "CUSTOMER_ID": "VARCHAR",
                "CUSTOMER_NAME": "VARCHAR",
                "CUSTOMER_DOB": "DATE",
                "CUSTOMER_PHONE": "VARCHAR",
                "EFFECTIVE_FROM": "DATE",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR"
            }
        },
        "SATELLITE": {
            "column_types": {
                "CUSTOMER_PK": "BYTEA",
                "CUSTOMER_NAME": "VARCHAR",
                "CUSTOMER_DOB": "DATE",
                "CUSTOMER_PHONE": "VARCHAR",
                "HASHDIFF": "BYTEA",
                "EFFECTIVE_FROM": "DATE",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR"
            }
        }
    }
