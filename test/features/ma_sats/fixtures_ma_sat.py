from behave import fixture


def set_vault_structure_definition(context):
    context.vault_structure_type = "ma_sat"

    context.vault_structure_columns = {
        "MAS": {
            "src_pk": "CUSTOMER_PK",
            "src_cdk": ["CUSTOMER_PHONE"],
            "src_payload": ["CUSTOMER_NAME"],
            "src_hashdiff": "HASHDIFF",
            "src_eff": "EFFECTIVE_FROM",
            "src_ldts": "LOAD_DATE",
            "src_source": "SOURCE"
        },
        "MAS_TZ": {
            "src_pk": "CUSTOMER_PK",
            "src_cdk": ["CUSTOMER_PHONE"],
            "src_payload": ["CUSTOMER_NAME"],
            "src_hashdiff": "HASHDIFF",
            "src_eff": "EFFECTIVE_FROM",
            "src_ldts": "LOAD_DATE",
            "src_source": "SOURCE"
        },
        "MAS_HD_ALIAS": {
            "src_pk": "CUSTOMER_PK",
            "src_cdk": ["CUSTOMER_PHONE"],
            "src_payload": ["CUSTOMER_NAME"],
            "src_hashdiff": {"source_column": "CUSTOMER_HASHDIFF", "alias": "HASHDIFF"},
            "src_eff": "EFFECTIVE_FROM",
            "src_ldts": "LOAD_DATE",
            "src_source": "SOURCE"
        },
        "MAS_TS": {
            "src_pk": "CUSTOMER_PK",
            "src_cdk": ["CUSTOMER_PHONE"],
            "src_payload": ["CUSTOMER_NAME"],
            "src_hashdiff": "HASHDIFF",
            "src_eff": "EFFECTIVE_FROM",
            "src_ldts": "LOAD_DATETIME",
            "src_source": "SOURCE"
        },
        "MAS_NO_CDK_HASHDIFF": {
            "src_pk": "CUSTOMER_PK",
            "src_cdk": ["CUSTOMER_PHONE"],
            "src_payload": ["CUSTOMER_NAME"],
            "src_hashdiff": "HASHDIFF",
            "src_eff": "EFFECTIVE_FROM",
            "src_ldts": "LOAD_DATE",
            "src_source": "SOURCE"
        },
        "MAS_NO_PK_CDK_HASHDIFF": {
            "src_pk": "CUSTOMER_PK",
            "src_cdk": ["CUSTOMER_PHONE"],
            "src_payload": ["CUSTOMER_NAME"],
            "src_hashdiff": "HASHDIFF",
            "src_eff": "EFFECTIVE_FROM",
            "src_ldts": "LOAD_DATE",
            "src_source": "SOURCE"
        },
        "MAS_TWO_CDK": {
            "src_pk": "CUSTOMER_PK",
            "src_cdk": ["CUSTOMER_PHONE", "EXTENSION"],
            "src_payload": ["CUSTOMER_NAME"],
            "src_hashdiff": "HASHDIFF",
            "src_eff": "EFFECTIVE_FROM",
            "src_ldts": "LOAD_DATE",
            "src_source": "SOURCE"
        },
        "MAS_TWO_CDK_TS": {
            "src_pk": "CUSTOMER_PK",
            "src_cdk": ["CUSTOMER_PHONE", "EXTENSION"],
            "src_payload": ["CUSTOMER_NAME"],
            "src_hashdiff": "HASHDIFF",
            "src_eff": "EFFECTIVE_FROM",
            "src_ldts": "LOAD_DATETIME",
            "src_source": "SOURCE"
        },
        "MAS_TWO_CDK_NO_CDK_HASHDIFF": {
            "src_pk": "CUSTOMER_PK",
            "src_cdk": ["CUSTOMER_PHONE", "EXTENSION"],
            "src_payload": ["CUSTOMER_NAME"],
            "src_hashdiff": "HASHDIFF",
            "src_eff": "EFFECTIVE_FROM",
            "src_ldts": "LOAD_DATE",
            "src_source": "SOURCE"
        },
        "MAS_TWO_CDK_NO_PK_CDK_HASHDIFF": {
            "src_pk": "CUSTOMER_PK",
            "src_cdk": ["CUSTOMER_PHONE", "EXTENSION"],
            "src_payload": ["CUSTOMER_NAME"],
            "src_hashdiff": "HASHDIFF",
            "src_eff": "EFFECTIVE_FROM",
            "src_ldts": "LOAD_DATE",
            "src_source": "SOURCE"
        },
        "MAS_AC": {
            "src_pk": "CUSTOMER_PK",
            "src_cdk": ["CUSTOMER_PHONE"],
            "src_payload": ["CUSTOMER_NAME"],
            "src_hashdiff": "HASHDIFF",
            "src_extra_columns": "CUSTOMER_MT_ID",
            "src_eff": "EFFECTIVE_FROM",
            "src_ldts": "LOAD_DATE",
            "src_source": "SOURCE"
        },
        "MAS_COMP": {
            "src_pk": ["CUSTOMER_PK", "ORDER_PK"],
            "src_cdk": ["CUSTOMER_PHONE"],
            "src_payload": ["CUSTOMER_NAME"],
            "src_hashdiff": "HASHDIFF",
            "src_eff": "EFFECTIVE_FROM",
            "src_ldts": "LOAD_DATE",
            "src_source": "SOURCE"
        },
        "MAS_TWO_CDK_COMP": {
            "src_pk": ["CUSTOMER_PK", "ORDER_PK"],
            "src_cdk": ["CUSTOMER_PHONE", "EXTENSION"],
            "src_payload": ["CUSTOMER_NAME"],
            "src_hashdiff": "HASHDIFF",
            "src_eff": "EFFECTIVE_FROM",
            "src_ldts": "LOAD_DATE",
            "src_source": "SOURCE"
        }
    }


def set_staging_definition(context):
    context.hashed_columns = {
        "STG_CUSTOMER": {
            "CUSTOMER_PK": "CUSTOMER_ID",
            "HASHDIFF": {"is_hashdiff": True,
                         "columns": ["CUSTOMER_ID", "CUSTOMER_PHONE", "CUSTOMER_NAME"]}
        },
        "STG_CUSTOMER_HD_ALIAS": {
            "CUSTOMER_PK": "CUSTOMER_ID",
            "CUSTOMER_HASHDIFF": {"is_hashdiff": True,
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
                         "columns": ["CUSTOMER_NAME"]}
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
                         "columns": ["CUSTOMER_NAME"]}
        },
        "STG_CUSTOMER_COMP": {
            "CUSTOMER_PK": "CUSTOMER_ID",
            "ORDER_PK": "ORDER_ID",
            "HASHDIFF": {"is_hashdiff": True,
                         "columns": ["CUSTOMER_ID", "ORDER_ID", "CUSTOMER_PHONE", "CUSTOMER_NAME"]}
        },
        "STG_CUSTOMER_TWO_CDK_COMP": {
            "CUSTOMER_PK": "CUSTOMER_ID",
            "ORDER_PK": "ORDER_ID",
            "HASHDIFF": {"is_hashdiff": True,
                         "columns": ["CUSTOMER_ID", "ORDER_ID", "CUSTOMER_PHONE", "CUSTOMER_NAME", "EXTENSION"]}
        },
    }

    context.derived_columns = {
        "STG_CUSTOMER": {
            "EFFECTIVE_FROM": "LOAD_DATE"
        },
        "STG_CUSTOMER_HD_ALIAS": {
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
        },
        "STG_CUSTOMER_COMP": {
            "EFFECTIVE_FROM": "LOAD_DATE"
        },
        "STG_CUSTOMER_TWO_CDK_COMP": {
            "EFFECTIVE_FROM": "LOAD_DATE"
        }
    }

    context.stage_columns = {
        "RAW_STAGE":
            [
                "CUSTOMER_ID",
                "CUSTOMER_NAME",
                "CUSTOMER_PHONE",
                "EFFECTIVE_FROM",
                "LOAD_DATE",
                "SOURCE"
            ],
        "RAW_STAGE_TS":
            [
                "CUSTOMER_ID",
                "CUSTOMER_NAME",
                "CUSTOMER_PHONE",
                "EFFECTIVE_FROM",
                "LOAD_DATETIME",
                "SOURCE"
            ],
        "RAW_STAGE_TWO_CDK":
            [
                "CUSTOMER_ID",
                "CUSTOMER_NAME",
                "CUSTOMER_PHONE",
                "EXTENSION",
                "EFFECTIVE_FROM",
                "LOAD_DATE",
                "SOURCE"
            ],
        "RAW_STAGE_TWO_CDK_TS":
            [
                "CUSTOMER_ID",
                "CUSTOMER_NAME",
                "CUSTOMER_PHONE",
                "EXTENSION",
                "EFFECTIVE_FROM",
                "LOAD_DATETIME",
                "SOURCE"
            ],
        "RAW_STAGE_COMP":
            [
                "CUSTOMER_ID",
                "ORDER_ID",
                "CUSTOMER_NAME",
                "CUSTOMER_PHONE",
                "EFFECTIVE_FROM",
                "LOAD_DATE",
                "SOURCE"
            ],
        "RAW_STAGE_TWO_CDK_COMP":
            [
                "CUSTOMER_ID",
                "ORDER_ID",
                "CUSTOMER_NAME",
                "CUSTOMER_PHONE",
                "EXTENSION",
                "EFFECTIVE_FROM",
                "LOAD_DATE",
                "SOURCE"
            ]
    }


def set_metadata(context):
    set_vault_structure_definition(context)

    set_staging_definition(context)


# Snowflake


@fixture
def multi_active_satellite_snowflake(context):
    """
    Define the structures and metadata to load multi active satellites
    """

    set_metadata(context)

    context.seed_config = {
        "RAW_STAGE": {
            "column_types": {
                "CUSTOMER_ID": "NUMBER(38, 0)",
                "CUSTOMER_NAME": "VARCHAR",
                "CUSTOMER_PHONE": "VARCHAR",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR"
            }
        },
        "RAW_STAGE_TZ": {
            "column_types": {
                "CUSTOMER_ID": "NUMBER(38, 0)",
                "CUSTOMER_NAME": "VARCHAR",
                "CUSTOMER_PHONE": "VARCHAR",
                "LOAD_DATE": "TIMESTAMP_TZ",
                "SOURCE": "VARCHAR"
            }
        },
        "RAW_STAGE_TS": {
            "column_types": {
                "CUSTOMER_ID": "NUMBER(38, 0)",
                "CUSTOMER_NAME": "VARCHAR",
                "CUSTOMER_PHONE": "VARCHAR",
                "LOAD_DATETIME": "DATETIME",
                "SOURCE": "VARCHAR"
            }
        },
        "RAW_STAGE_TWO_CDK": {
            "column_types": {
                "CUSTOMER_ID": "NUMBER(38, 0)",
                "CUSTOMER_NAME": "VARCHAR",
                "CUSTOMER_PHONE": "VARCHAR",
                "EXTENSION": "NUMBER(38, 0)",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR"
            }
        },
        "RAW_STAGE_TWO_CDK_TS": {
            "column_types": {
                "CUSTOMER_ID": "NUMBER(38, 0)",
                "CUSTOMER_NAME": "VARCHAR",
                "CUSTOMER_PHONE": "VARCHAR",
                "EXTENSION": "NUMBER(38, 0)",
                "LOAD_DATETIME": "DATETIME",
                "SOURCE": "VARCHAR"
            }
        },
        "RAW_STAGE_COMP": {
            "column_types": {
                "CUSTOMER_ID": "NUMBER(38, 0)",
                "ORDER_ID": "VARCHAR",
                "CUSTOMER_NAME": "VARCHAR",
                "CUSTOMER_PHONE": "VARCHAR",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR"
            }
        },
        "RAW_STAGE_TWO_CDK_COMP": {
            "column_types": {
                "CUSTOMER_ID": "NUMBER(38, 0)",
                "ORDER_ID": "VARCHAR",
                "CUSTOMER_NAME": "VARCHAR",
                "CUSTOMER_PHONE": "VARCHAR",
                "EXTENSION": "NUMBER(38, 0)",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR"
            }
        },
        "MAS": {
            "column_types": {
                "CUSTOMER_PK": "BINARY(16)",
                "CUSTOMER_NAME": "VARCHAR",
                "CUSTOMER_PHONE": "VARCHAR",
                "HASHDIFF": "BINARY(16)",
                "EFFECTIVE_FROM": "DATE",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR"
            }
        },
        "MAS_TZ": {
            "column_types": {
                "CUSTOMER_PK": "BINARY(16)",
                "CUSTOMER_NAME": "VARCHAR",
                "CUSTOMER_PHONE": "VARCHAR",
                "HASHDIFF": "BINARY(16)",
                "EFFECTIVE_FROM": "TIMESTAMP_TZ",
                "LOAD_DATE": "TIMESTAMP_TZ",
                "SOURCE": "VARCHAR"
            }
        },
        "MAS_TS": {
            "column_types": {
                "CUSTOMER_PK": "BINARY(16)",
                "CUSTOMER_NAME": "VARCHAR",
                "CUSTOMER_PHONE": "VARCHAR",
                "HASHDIFF": "BINARY(16)",
                "EFFECTIVE_FROM": "DATETIME",
                "LOAD_DATETIME": "DATETIME",
                "SOURCE": "VARCHAR"
            }
        },
        "MAS_HD_ALIAS": {
            "column_types": {
                "CUSTOMER_PK": "BINARY(16)",
                "CUSTOMER_NAME": "VARCHAR",
                "CUSTOMER_PHONE": "VARCHAR",
                "HASHDIFF": "BINARY(16)",
                "EFFECTIVE_FROM": "DATETIME",
                "LOAD_DATE": "DATETIME",
                "SOURCE": "VARCHAR"
            }
        },
        "MAS_NO_CDK_HASHDIFF": {
            "column_types": {
                "CUSTOMER_PK": "BINARY(16)",
                "CUSTOMER_NAME": "VARCHAR",
                "CUSTOMER_PHONE": "VARCHAR",
                "HASHDIFF": "BINARY(16)",
                "EFFECTIVE_FROM": "DATE",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR"
            }
        },
        "MAS_NO_PK_CDK_HASHDIFF": {
            "column_types": {
                "CUSTOMER_PK": "BINARY(16)",
                "CUSTOMER_NAME": "VARCHAR",
                "CUSTOMER_PHONE": "VARCHAR",
                "HASHDIFF": "BINARY(16)",
                "EFFECTIVE_FROM": "DATE",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR"
            }
        },
        "MAS_TWO_CDK": {
            "column_types": {
                "CUSTOMER_PK": "BINARY(16)",
                "CUSTOMER_NAME": "VARCHAR",
                "CUSTOMER_PHONE": "VARCHAR",
                "EXTENSION": "NUMBER(38, 0)",
                "HASHDIFF": "BINARY(16)",
                "EFFECTIVE_FROM": "DATE",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR"
            }
        },
        "MAS_TWO_CDK_TS": {
            "column_types": {
                "CUSTOMER_PK": "BINARY(16)",
                "CUSTOMER_NAME": "VARCHAR",
                "CUSTOMER_PHONE": "VARCHAR",
                "EXTENSION": "NUMBER(38, 0)",
                "HASHDIFF": "BINARY(16)",
                "EFFECTIVE_FROM": "DATETIME",
                "LOAD_DATETIME": "DATETIME",
                "SOURCE": "VARCHAR"
            }
        },
        "MAS_TWO_CDK_NO_CDK_HASHDIFF": {
            "column_types": {
                "CUSTOMER_PK": "BINARY(16)",
                "CUSTOMER_NAME": "VARCHAR",
                "CUSTOMER_PHONE": "VARCHAR",
                "EXTENSION": "NUMBER(38, 0)",
                "HASHDIFF": "BINARY(16)",
                "EFFECTIVE_FROM": "DATE",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR"
            }
        },
        "MAS_TWO_CDK_NO_PK_CDK_HASHDIFF": {
            "column_types": {
                "CUSTOMER_PK": "BINARY(16)",
                "CUSTOMER_NAME": "VARCHAR",
                "CUSTOMER_PHONE": "VARCHAR",
                "EXTENSION": "NUMBER(38, 0)",
                "HASHDIFF": "BINARY(16)",
                "EFFECTIVE_FROM": "DATE",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR"
            }
        },
        "MAS_AC": {
            "column_types": {
                "CUSTOMER_PK": "BINARY(16)",
                "HASHDIFF": "BINARY(16)",
                "CUSTOMER_NAME": "VARCHAR",
                "CUSTOMER_PHONE": "VARCHAR",
                "CUSTOMER_MT_ID": "VARCHAR",
                "EFFECTIVE_FROM": "DATE",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR"
            }
        },
        "MAS_COMP": {
            "column_types": {
                "CUSTOMER_PK": "BINARY(16)",
                "ORDER_PK": "BINARY(16)",
                "CUSTOMER_NAME": "VARCHAR",
                "CUSTOMER_PHONE": "VARCHAR",
                "HASHDIFF": "BINARY(16)",
                "EFFECTIVE_FROM": "DATE",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR"
            }
        },
        "MAS_TWO_CDK_COMP": {
            "column_types": {
                "CUSTOMER_PK": "BINARY(16)",
                "ORDER_PK": "BINARY(16)",
                "CUSTOMER_NAME": "VARCHAR",
                "CUSTOMER_PHONE": "VARCHAR",
                "EXTENSION": "NUMBER(38, 0)",
                "HASHDIFF": "BINARY(16)",
                "EFFECTIVE_FROM": "DATE",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR"
            }
        }
    }


@fixture
def multi_active_satellite_cycle_snowflake(context):
    """
    Define the structures and metadata to perform load cycles for multi active satellites
    """

    set_metadata(context)

    context.seed_config = {
        "RAW_STAGE": {
            "column_types": {
                "CUSTOMER_ID": "NUMBER(38, 0)",
                "CUSTOMER_NAME": "VARCHAR",
                "CUSTOMER_PHONE": "VARCHAR",
                "EFFECTIVE_FROM": "DATE",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR"
            }
        },
        "RAW_STAGE_TS": {
            "column_types": {
                "CUSTOMER_ID": "NUMBER(38, 0)",
                "CUSTOMER_NAME": "VARCHAR",
                "CUSTOMER_PHONE": "VARCHAR",
                "EFFECTIVE_FROM": "DATETIME",
                "LOAD_DATETIME": "DATETIME",
                "SOURCE": "VARCHAR"
            }
        },
        "RAW_STAGE_TWO_CDK": {
            "column_types": {
                "CUSTOMER_ID": "NUMBER(38, 0)",
                "CUSTOMER_NAME": "VARCHAR",
                "CUSTOMER_PHONE": "VARCHAR",
                "EXTENSION": "NUMBER(38, 0)",
                "EFFECTIVE_FROM": "DATE",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR"
            }
        },
        "RAW_STAGE_TWO_CDK_TS": {
            "column_types": {
                "CUSTOMER_ID": "NUMBER(38, 0)",
                "CUSTOMER_NAME": "VARCHAR",
                "CUSTOMER_PHONE": "VARCHAR",
                "EXTENSION": "NUMBER(38, 0)",
                "EFFECTIVE_FROM": "DATETIME",
                "LOAD_DATETIME": "DATETIME",
                "SOURCE": "VARCHAR"
            }
        },
        "MAS": {
            "column_types": {
                "CUSTOMER_PK": "BINARY(16)",
                "HASHDIFF": "BINARY(16)",
                "CUSTOMER_PHONE": "VARCHAR",
                "CUSTOMER_NAME": "VARCHAR",
                "EFFECTIVE_FROM": "DATE",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR"
            }
        },
        "MAS_TS": {
            "column_types": {
                "CUSTOMER_PK": "BINARY(16)",
                "HASHDIFF": "BINARY(16)",
                "CUSTOMER_PHONE": "VARCHAR",
                "CUSTOMER_NAME": "VARCHAR",
                "EFFECTIVE_FROM": "DATETIME",
                "LOAD_DATETIME": "DATETIME",
                "SOURCE": "VARCHAR"
            }
        },
        "MAS_NO_CDK_HASHDIFF": {
            "column_types": {
                "CUSTOMER_PK": "BINARY(16)",
                "CUSTOMER_NAME": "VARCHAR",
                "CUSTOMER_PHONE": "VARCHAR",
                "HASHDIFF": "BINARY(16)",
                "EFFECTIVE_FROM": "DATE",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR"
            }
        },
        "MAS_NO_PK_CDK_HASHDIFF": {
            "column_types": {
                "CUSTOMER_PK": "BINARY(16)",
                "CUSTOMER_NAME": "VARCHAR",
                "CUSTOMER_PHONE": "VARCHAR",
                "HASHDIFF": "BINARY(16)",
                "EFFECTIVE_FROM": "DATE",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR"
            }
        },
        "MAS_TWO_CDK": {
            "column_types": {
                "CUSTOMER_PK": "BINARY(16)",
                "HASHDIFF": "BINARY(16)",
                "CUSTOMER_PHONE": "VARCHAR",
                "CUSTOMER_NAME": "VARCHAR",
                "EXTENSION": "NUMBER(38, 0)",
                "EFFECTIVE_FROM": "DATE",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR"
            }
        },
        "MAS_TWO_CDK_TS": {
            "column_types": {
                "CUSTOMER_PK": "BINARY(16)",
                "HASHDIFF": "BINARY(16)",
                "CUSTOMER_PHONE": "VARCHAR",
                "CUSTOMER_NAME": "VARCHAR",
                "EXTENSION": "NUMBER(38, 0)",
                "EFFECTIVE_FROM": "DATETIME",
                "LOAD_DATETIME": "DATETIME",
                "SOURCE": "VARCHAR"
            }
        },
        "MAS_TWO_CDK_NO_CDK_HASHDIFF": {
            "column_types": {
                "CUSTOMER_PK": "BINARY(16)",
                "CUSTOMER_NAME": "VARCHAR",
                "CUSTOMER_PHONE": "VARCHAR",
                "EXTENSION": "NUMBER(38, 0)",
                "HASHDIFF": "BINARY(16)",
                "EFFECTIVE_FROM": "DATE",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR"
            }
        },
        "MAS_TWO_CDK_NO_PK_CDK_HASHDIFF": {
            "column_types": {
                "CUSTOMER_PK": "BINARY(16)",
                "CUSTOMER_NAME": "VARCHAR",
                "CUSTOMER_PHONE": "VARCHAR",
                "EXTENSION": "NUMBER(38, 0)",
                "HASHDIFF": "BINARY(16)",
                "EFFECTIVE_FROM": "DATE",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR"
            }
        }
    }


# BigQuery


@fixture
def multi_active_satellite_bigquery(context):
    """
    Define the structures and metadata to load multi active satellites
    """

    set_metadata(context)

    context.seed_config = {
        "RAW_STAGE": {
            "column_types": {
                "CUSTOMER_ID": "STRING",
                "CUSTOMER_NAME": "STRING",
                "CUSTOMER_PHONE": "STRING",
                "CUSTOMER_MT_ID": "STRING",
                "EFFECTIVE_FROM": "DATE",
                "LOAD_DATE": "DATE",
                "SOURCE": "STRING"
            }
        },
        "RAW_STAGE_TZ": {
            "column_types": {
                "CUSTOMER_ID": "STRING",
                "CUSTOMER_NAME": "STRING",
                "CUSTOMER_PHONE": "STRING",
                "CUSTOMER_MT_ID": "STRING",
                "EFFECTIVE_FROM": "TIMESTAMP",
                "LOAD_DATE": "TIMESTAMP",
                "SOURCE": "STRING"
            }
        },
        "RAW_STAGE_TS": {
            "column_types": {
                "CUSTOMER_ID": "STRING",
                "CUSTOMER_NAME": "STRING",
                "CUSTOMER_PHONE": "STRING",
                "LOAD_DATETIME": "DATETIME",
                "SOURCE": "STRING"
            }
        },
        "RAW_STAGE_TWO_CDK": {
            "column_types": {
                "CUSTOMER_ID": "STRING",
                "CUSTOMER_NAME": "STRING",
                "CUSTOMER_PHONE": "STRING",
                "EXTENSION": "STRING",
                "EFFECTIVE_FROM": "DATE",
                "LOAD_DATE": "DATE",
                "SOURCE": "STRING"
            }
        },
        "RAW_STAGE_TWO_CDK_TS": {
            "column_types": {
                "CUSTOMER_ID": "STRING",
                "CUSTOMER_NAME": "STRING",
                "CUSTOMER_PHONE": "STRING",
                "EXTENSION": "STRING",
                "LOAD_DATETIME": "DATETIME",
                "SOURCE": "STRING"
            }
        },
        "RAW_STAGE_COMP": {
            "column_types": {
                "CUSTOMER_ID": "STRING",
                "ORDER_ID": "STRING",
                "CUSTOMER_NAME": "STRING",
                "CUSTOMER_PHONE": "STRING",
                "CUSTOMER_MT_ID": "STRING",
                "EFFECTIVE_FROM": "DATE",
                "LOAD_DATE": "DATE",
                "SOURCE": "STRING"
            }
        },
        "RAW_STAGE_TWO_CDK_COMP": {
            "column_types": {
                "CUSTOMER_ID": "STRING",
                "ORDER_ID": "STRING",
                "CUSTOMER_NAME": "STRING",
                "CUSTOMER_PHONE": "STRING",
                "EXTENSION": "STRING",
                "EFFECTIVE_FROM": "DATE",
                "LOAD_DATE": "DATE",
                "SOURCE": "STRING"
            }
        },
        "MAS": {
            "column_types": {
                "CUSTOMER_PK": "STRING",
                "CUSTOMER_NAME": "STRING",
                "CUSTOMER_PHONE": "STRING",
                "HASHDIFF": "STRING",
                "EFFECTIVE_FROM": "DATE",
                "LOAD_DATE": "DATE",
                "SOURCE": "STRING"
            }
        },
        "MAS_TZ": {
            "column_types": {
                "CUSTOMER_PK": "STRING",
                "CUSTOMER_NAME": "STRING",
                "CUSTOMER_PHONE": "STRING",
                "HASHDIFF": "STRING",
                "EFFECTIVE_FROM": "TIMESTAMP",
                "LOAD_DATE": "TIMESTAMP",
                "SOURCE": "STRING"
            }
        },
        "MAS_TS": {
            "column_types": {
                "CUSTOMER_PK": "STRING",
                "CUSTOMER_NAME": "STRING",
                "CUSTOMER_PHONE": "STRING",
                "HASHDIFF": "STRING",
                "EFFECTIVE_FROM": "DATETIME",
                "LOAD_DATETIME": "DATETIME",
                "SOURCE": "STRING"
            }
        },
        "MAS_HD_ALIAS": {
            "column_types": {
                "CUSTOMER_PK": "STRING",
                "CUSTOMER_NAME": "STRING",
                "CUSTOMER_PHONE": "STRING",
                "HASHDIFF": "STRING",
                "EFFECTIVE_FROM": "DATETIME",
                "LOAD_DATE": "DATETIME",
                "SOURCE": "STRING"
            }
        },
        "MAS_NO_CDK_HASHDIFF": {
            "column_types": {
                "CUSTOMER_PK": "STRING",
                "CUSTOMER_NAME": "STRING",
                "CUSTOMER_PHONE": "STRING",
                "HASHDIFF": "STRING",
                "EFFECTIVE_FROM": "DATE",
                "LOAD_DATE": "DATE",
                "SOURCE": "STRING"
            }
        },
        "MAS_NO_PK_CDK_HASHDIFF": {
            "column_types": {
                "CUSTOMER_PK": "STRING",
                "CUSTOMER_NAME": "STRING",
                "CUSTOMER_PHONE": "STRING",
                "HASHDIFF": "STRING",
                "EFFECTIVE_FROM": "DATE",
                "LOAD_DATE": "DATE",
                "SOURCE": "STRING"
            }
        },
        "MAS_TWO_CDK": {
            "column_types": {
                "CUSTOMER_PK": "STRING",
                "CUSTOMER_NAME": "STRING",
                "CUSTOMER_PHONE": "STRING",
                "EXTENSION": "STRING",
                "HASHDIFF": "STRING",
                "EFFECTIVE_FROM": "DATE",
                "LOAD_DATE": "DATE",
                "SOURCE": "STRING"
            }
        },
        "MAS_TWO_CDK_TS": {
            "column_types": {
                "CUSTOMER_PK": "STRING",
                "CUSTOMER_NAME": "STRING",
                "CUSTOMER_PHONE": "STRING",
                "EXTENSION": "STRING",
                "HASHDIFF": "STRING",
                "EFFECTIVE_FROM": "DATETIME",
                "LOAD_DATETIME": "DATETIME",
                "SOURCE": "STRING"
            }
        },
        "MAS_TWO_CDK_NO_CDK_HASHDIFF": {
            "column_types": {
                "CUSTOMER_PK": "STRING",
                "CUSTOMER_NAME": "STRING",
                "CUSTOMER_PHONE": "STRING",
                "EXTENSION": "STRING",
                "HASHDIFF": "STRING",
                "EFFECTIVE_FROM": "DATE",
                "LOAD_DATE": "DATE",
                "SOURCE": "STRING"
            }
        },
        "MAS_TWO_CDK_NO_PK_CDK_HASHDIFF": {
            "column_types": {
                "CUSTOMER_PK": "STRING",
                "CUSTOMER_NAME": "STRING",
                "CUSTOMER_PHONE": "STRING",
                "EXTENSION": "STRING",
                "HASHDIFF": "STRING",
                "EFFECTIVE_FROM": "DATE",
                "LOAD_DATE": "DATE",
                "SOURCE": "STRING"
            }
        },
        "MAS_AC": {
            "column_types": {
                "CUSTOMER_PK": "STRING",
                "HASHDIFF": "STRING",
                "CUSTOMER_NAME": "STRING",
                "CUSTOMER_PHONE": "STRING",
                "CUSTOMER_MT_ID": "STRING",
                "EFFECTIVE_FROM": "DATE",
                "LOAD_DATE": "DATE",
                "SOURCE": "STRING"
            }
        },
        "MAS_COMP": {
            "column_types": {
                "CUSTOMER_PK": "STRING",
                "ORDER_PK": "STRING",
                "CUSTOMER_NAME": "STRING",
                "CUSTOMER_PHONE": "STRING",
                "HASHDIFF": "STRING",
                "EFFECTIVE_FROM": "DATE",
                "LOAD_DATE": "DATE",
                "SOURCE": "STRING"
            }
        },
        "MAS_TWO_CDK_COMP": {
            "column_types": {
                "CUSTOMER_PK": "STRING",
                "ORDER_PK": "STRING",
                "CUSTOMER_NAME": "STRING",
                "CUSTOMER_PHONE": "STRING",
                "EXTENSION": "STRING",
                "HASHDIFF": "STRING",
                "EFFECTIVE_FROM": "DATE",
                "LOAD_DATE": "DATE",
                "SOURCE": "STRING"
            }
        }
    }


@fixture
def multi_active_satellite_cycle_bigquery(context):
    """
    Define the structures and metadata to perform load cycles for multi active satellites
    """

    set_metadata(context)

    context.seed_config = {
        "RAW_STAGE": {
            "column_types": {
                "CUSTOMER_ID": "STRING",
                "CUSTOMER_NAME": "STRING",
                "CUSTOMER_PHONE": "STRING",
                "EFFECTIVE_FROM": "DATE",
                "LOAD_DATE": "DATE",
                "SOURCE": "STRING"
            }
        },
        "RAW_STAGE_TS": {
            "column_types": {
                "CUSTOMER_ID": "STRING",
                "CUSTOMER_NAME": "STRING",
                "CUSTOMER_PHONE": "STRING",
                "EFFECTIVE_FROM": "DATETIME",
                "LOAD_DATETIME": "DATETIME",
                "SOURCE": "STRING"
            }
        },
        "RAW_STAGE_TWO_CDK": {
            "column_types": {
                "CUSTOMER_ID": "STRING",
                "CUSTOMER_NAME": "STRING",
                "CUSTOMER_PHONE": "STRING",
                "EXTENSION": "NUMERIC",
                "EFFECTIVE_FROM": "DATE",
                "LOAD_DATE": "DATE",
                "SOURCE": "STRING"
            }
        },
        "RAW_STAGE_TWO_CDK_TS": {
            "column_types": {
                "CUSTOMER_ID": "STRING",
                "CUSTOMER_NAME": "STRING",
                "CUSTOMER_PHONE": "STRING",
                "EXTENSION": "NUMERIC",
                "EFFECTIVE_FROM": "DATETIME",
                "LOAD_DATETIME": "DATETIME",
                "SOURCE": "STRING"
            }
        },
        "MAS": {
            "column_types": {
                "CUSTOMER_PK": "STRING",
                "HASHDIFF": "STRING",
                "CUSTOMER_PHONE": "STRING",
                "CUSTOMER_NAME": "STRING",
                "EFFECTIVE_FROM": "DATE",
                "LOAD_DATE": "DATE",
                "SOURCE": "STRING"
            }
        },
        "MAS_TS": {
            "column_types": {
                "CUSTOMER_PK": "STRING",
                "HASHDIFF": "STRING",
                "CUSTOMER_PHONE": "STRING",
                "CUSTOMER_NAME": "STRING",
                "EFFECTIVE_FROM": "DATETIME",
                "LOAD_DATETIME": "DATETIME",
                "SOURCE": "STRING"
            }
        },
        "MAS_NO_CDK_HASHDIFF": {
            "column_types": {
                "CUSTOMER_PK": "STRING",
                "CUSTOMER_NAME": "STRING",
                "CUSTOMER_PHONE": "STRING",
                "HASHDIFF": "STRING",
                "EFFECTIVE_FROM": "DATE",
                "LOAD_DATE": "DATE",
                "SOURCE": "STRING"
            }
        },
        "MAS_NO_PK_CDK_HASHDIFF": {
            "column_types": {
                "CUSTOMER_PK": "STRING",
                "CUSTOMER_NAME": "STRING",
                "CUSTOMER_PHONE": "STRING",
                "HASHDIFF": "STRING",
                "EFFECTIVE_FROM": "DATE",
                "LOAD_DATE": "DATE",
                "SOURCE": "STRING"
            }
        },
        "MAS_TWO_CDK": {
            "column_types": {
                "CUSTOMER_PK": "STRING",
                "HASHDIFF": "STRING",
                "CUSTOMER_PHONE": "STRING",
                "CUSTOMER_NAME": "STRING",
                "EXTENSION": "NUMERIC",
                "EFFECTIVE_FROM": "DATE",
                "LOAD_DATE": "DATE",
                "SOURCE": "STRING"
            }
        },
        "MAS_TWO_CDK_TS": {
            "column_types": {
                "CUSTOMER_PK": "STRING",
                "HASHDIFF": "STRING",
                "CUSTOMER_PHONE": "STRING",
                "CUSTOMER_NAME": "STRING",
                "EXTENSION": "NUMERIC",
                "EFFECTIVE_FROM": "DATETIME",
                "LOAD_DATETIME": "DATETIME",
                "SOURCE": "STRING"
            }
        },
        "MAS_TWO_CDK_NO_CDK_HASHDIFF": {
            "column_types": {
                "CUSTOMER_PK": "STRING",
                "CUSTOMER_NAME": "STRING",
                "CUSTOMER_PHONE": "STRING",
                "EXTENSION": "NUMERIC",
                "HASHDIFF": "STRING",
                "EFFECTIVE_FROM": "DATE",
                "LOAD_DATE": "DATE",
                "SOURCE": "STRING"
            }
        },
        "MAS_TWO_CDK_NO_PK_CDK_HASHDIFF": {
            "column_types": {
                "CUSTOMER_PK": "STRING",
                "CUSTOMER_NAME": "STRING",
                "CUSTOMER_PHONE": "STRING",
                "EXTENSION": "NUMERIC",
                "HASHDIFF": "STRING",
                "EFFECTIVE_FROM": "DATE",
                "LOAD_DATE": "DATE",
                "SOURCE": "STRING"
            }
        }
    }


# SQLServer


@fixture
def multi_active_satellite_sqlserver(context):
    """
    Define the structures and metadata to load multi active satellites
    """

    set_metadata(context)

    context.seed_config = {
        "RAW_STAGE": {
            "column_types": {
                "CUSTOMER_ID": "DECIMAL(38,0)",
                "CUSTOMER_NAME": "VARCHAR(50)",
                "CUSTOMER_PHONE": "VARCHAR(50)",
                "CUSTOMER_MT_ID": "VARCHAR(50)",
                "EFFECTIVE_FROM": "DATE",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR(50)"
            }
        },
        "RAW_STAGE_TZ": {
            "column_types": {
                "CUSTOMER_ID": "DECIMAL(38,0)",
                "CUSTOMER_NAME": "VARCHAR(50)",
                "CUSTOMER_PHONE": "VARCHAR(50)",
                "CUSTOMER_MT_ID": "VARCHAR(50)",
                "EFFECTIVE_FROM": "DATETIME2",
                "LOAD_DATE": "DATETIME2",
                "SOURCE": "VARCHAR(50)"
            }
        },
        "RAW_STAGE_TS": {
            "column_types": {
                "CUSTOMER_ID": "DECIMAL(38,0)",
                "CUSTOMER_NAME": "VARCHAR(50)",
                "CUSTOMER_PHONE": "VARCHAR(50)",
                "LOAD_DATETIME": "DATETIME2",
                "SOURCE": "VARCHAR(50)"
            }
        },
        "RAW_STAGE_TWO_CDK": {
            "column_types": {
                "CUSTOMER_ID": "DECIMAL(38,0)",
                "CUSTOMER_NAME": "VARCHAR(50)",
                "CUSTOMER_PHONE": "VARCHAR(50)",
                "EXTENSION": "DECIMAL(38,0)",
                "EFFECTIVE_FROM": "DATE",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR(50)"
            }
        },
        "RAW_STAGE_TWO_CDK_TS": {
            "column_types": {
                "CUSTOMER_ID": "DECIMAL(38,0)",
                "CUSTOMER_NAME": "VARCHAR(50)",
                "CUSTOMER_PHONE": "VARCHAR(50)",
                "EXTENSION": "DECIMAL(38,0)",
                "LOAD_DATETIME": "DATETIME2",
                "SOURCE": "VARCHAR(50)"
            }
        },
        "RAW_STAGE_COMP": {
            "column_types": {
                "CUSTOMER_ID": "DECIMAL(38,0)",
                "ORDER_ID": "VARCHAR(50)",
                "CUSTOMER_NAME": "VARCHAR(50)",
                "CUSTOMER_PHONE": "VARCHAR(50)",
                "CUSTOMER_MT_ID": "VARCHAR(50)",
                "EFFECTIVE_FROM": "DATE",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR(50)"
            }
        },
        "RAW_STAGE_TWO_CDK_COMP": {
            "column_types": {
                "CUSTOMER_ID": "DECIMAL(38,0)",
                "ORDER_ID": "VARCHAR(50)",
                "CUSTOMER_NAME": "VARCHAR(50)",
                "CUSTOMER_PHONE": "VARCHAR(50)",
                "EXTENSION": "DECIMAL(38,0)",
                "EFFECTIVE_FROM": "DATE",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR(50)"
            }
        },
        "MAS": {
            "column_types": {
                "CUSTOMER_PK": "BINARY(16)",
                "CUSTOMER_NAME": "VARCHAR(50)",
                "CUSTOMER_PHONE": "VARCHAR(50)",
                "HASHDIFF": "BINARY(16)",
                "EFFECTIVE_FROM": "DATE",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR(50)"
            }
        },
        "MAS_TZ": {
            "column_types": {
                "CUSTOMER_PK": "BINARY(16)",
                "CUSTOMER_NAME": "VARCHAR(50)",
                "CUSTOMER_PHONE": "VARCHAR(50)",
                "HASHDIFF": "BINARY(16)",
                "EFFECTIVE_FROM": "DATETIME2",
                "LOAD_DATE": "DATETIME2",
                "SOURCE": "VARCHAR(50)"
            }
        },
        "MAS_TS": {
            "column_types": {
                "CUSTOMER_PK": "BINARY(16)",
                "CUSTOMER_NAME": "VARCHAR(50)",
                "CUSTOMER_PHONE": "VARCHAR(50)",
                "HASHDIFF": "BINARY(16)",
                "EFFECTIVE_FROM": "DATETIME2",
                "LOAD_DATETIME": "DATETIME2",
                "SOURCE": "VARCHAR(50)"
            }
        },
        "MAS_HD_ALIAS": {
            "column_types": {
                "CUSTOMER_PK": "BINARY(16)",
                "CUSTOMER_NAME": "VARCHAR(50)",
                "CUSTOMER_PHONE": "VARCHAR(50)",
                "HASHDIFF": "BINARY(16)",
                "EFFECTIVE_FROM": "DATETIME2",
                "LOAD_DATE": "DATETIME2",
                "SOURCE": "VARCHAR(50)"
            }
        },
        "MAS_NO_CDK_HASHDIFF": {
            "column_types": {
                "CUSTOMER_PK": "BINARY(16)",
                "CUSTOMER_NAME": "VARCHAR(50)",
                "CUSTOMER_PHONE": "VARCHAR(50)",
                "HASHDIFF": "BINARY(16)",
                "EFFECTIVE_FROM": "DATE",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR(50)"
            }
        },
        "MAS_NO_PK_CDK_HASHDIFF": {
            "column_types": {
                "CUSTOMER_PK": "BINARY(16)",
                "CUSTOMER_NAME": "VARCHAR(50)",
                "CUSTOMER_PHONE": "VARCHAR(50)",
                "HASHDIFF": "BINARY(16)",
                "EFFECTIVE_FROM": "DATE",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR(50)"
            }
        },
        "MAS_TWO_CDK": {
            "column_types": {
                "CUSTOMER_PK": "BINARY(16)",
                "CUSTOMER_NAME": "VARCHAR(50)",
                "CUSTOMER_PHONE": "VARCHAR(50)",
                "EXTENSION": "DECIMAL(38,0)",
                "HASHDIFF": "BINARY(16)",
                "EFFECTIVE_FROM": "DATE",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR(50)"
            }
        },
        "MAS_TWO_CDK_TS": {
            "column_types": {
                "CUSTOMER_PK": "BINARY(16)",
                "CUSTOMER_NAME": "VARCHAR(50)",
                "CUSTOMER_PHONE": "VARCHAR(50)",
                "EXTENSION": "DECIMAL(38,0)",
                "HASHDIFF": "BINARY(16)",
                "EFFECTIVE_FROM": "DATETIME2",
                "LOAD_DATETIME": "DATETIME2",
                "SOURCE": "VARCHAR(50)"
            }
        },
        "MAS_TWO_CDK_NO_CDK_HASHDIFF": {
            "column_types": {
                "CUSTOMER_PK": "BINARY(16)",
                "CUSTOMER_NAME": "VARCHAR(50)",
                "CUSTOMER_PHONE": "VARCHAR(50)",
                "EXTENSION": "DECIMAL(38,0)",
                "HASHDIFF": "BINARY(16)",
                "EFFECTIVE_FROM": "DATE",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR(50)"
            }
        },
        "MAS_TWO_CDK_NO_PK_CDK_HASHDIFF": {
            "column_types": {
                "CUSTOMER_PK": "BINARY(16)",
                "CUSTOMER_NAME": "VARCHAR(50)",
                "CUSTOMER_PHONE": "VARCHAR(50)",
                "EXTENSION": "DECIMAL(38,0)",
                "HASHDIFF": "BINARY(16)",
                "EFFECTIVE_FROM": "DATE",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR(50)"
            }
        },
        "MAS_AC": {
            "column_types": {
                "CUSTOMER_PK": "BINARY(16)",
                "HASHDIFF": "BINARY(16)",
                "CUSTOMER_NAME": "VARCHAR(50)",
                "CUSTOMER_PHONE": "VARCHAR(50)",
                "CUSTOMER_MT_ID": "VARCHAR(50)",
                "EFFECTIVE_FROM": "DATE",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR(50)"
            }
        },
        "MAS_COMP": {
            "column_types": {
                "CUSTOMER_PK": "BINARY(16)",
                "ORDER_PK": "BINARY(16)",
                "CUSTOMER_NAME": "VARCHAR(50)",
                "CUSTOMER_PHONE": "VARCHAR(50)",
                "HASHDIFF": "BINARY(16)",
                "EFFECTIVE_FROM": "DATE",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR(50)"
            }
        },
        "MAS_TWO_CDK_COMP": {
            "column_types": {
                "CUSTOMER_PK": "BINARY(16)",
                "ORDER_PK": "BINARY(16)",
                "CUSTOMER_NAME": "VARCHAR(50)",
                "CUSTOMER_PHONE": "VARCHAR(50)",
                "EXTENSION": "DECIMAL(38,0)",
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

    set_metadata(context)

    context.seed_config = {
        "RAW_STAGE": {
            "column_types": {
                "CUSTOMER_ID": "DECIMAL(38,0)",
                "CUSTOMER_NAME": "VARCHAR(50)",
                "CUSTOMER_PHONE": "VARCHAR(50)",
                "EFFECTIVE_FROM": "DATE",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR(50)"
            }
        },
        "RAW_STAGE_TS": {
            "column_types": {
                "CUSTOMER_ID": "DECIMAL(38,0)",
                "CUSTOMER_NAME": "VARCHAR(50)",
                "CUSTOMER_PHONE": "VARCHAR(50)",
                "EFFECTIVE_FROM": "DATETIME2",
                "LOAD_DATETIME": "DATETIME2",
                "SOURCE": "VARCHAR(50)"
            }
        },
        "RAW_STAGE_TWO_CDK": {
            "column_types": {
                "CUSTOMER_ID": "DECIMAL(38,0)",
                "CUSTOMER_NAME": "VARCHAR(50)",
                "CUSTOMER_PHONE": "VARCHAR(50)",
                "EXTENSION": "DECIMAL(38,0)",
                "EFFECTIVE_FROM": "DATE",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR(50)"
            }
        },
        "RAW_STAGE_TWO_CDK_TS": {
            "column_types": {
                "CUSTOMER_ID": "DECIMAL(38,0)",
                "CUSTOMER_NAME": "VARCHAR(50)",
                "CUSTOMER_PHONE": "VARCHAR(50)",
                "EXTENSION": "DECIMAL(38,0)",
                "EFFECTIVE_FROM": "DATETIME2",
                "LOAD_DATETIME": "DATETIME2",
                "SOURCE": "VARCHAR(50)"
            }
        },
        "MAS": {
            "column_types": {
                "CUSTOMER_PK": "BINARY(16)",
                "HASHDIFF": "BINARY(16)",
                "CUSTOMER_PHONE": "VARCHAR(50)",
                "CUSTOMER_NAME": "VARCHAR(50)",
                "EFFECTIVE_FROM": "DATE",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR(50)"
            }
        },
        "MAS_TS": {
            "column_types": {
                "CUSTOMER_PK": "BINARY(16)",
                "HASHDIFF": "BINARY(16)",
                "CUSTOMER_PHONE": "VARCHAR(50)",
                "CUSTOMER_NAME": "VARCHAR(50)",
                "EFFECTIVE_FROM": "DATETIME2",
                "LOAD_DATETIME": "DATETIME2",
                "SOURCE": "VARCHAR(50)"
            }
        },
        "MAS_NO_CDK_HASHDIFF": {
            "column_types": {
                "CUSTOMER_PK": "BINARY(16)",
                "CUSTOMER_NAME": "VARCHAR(50)",
                "CUSTOMER_PHONE": "VARCHAR(50)",
                "HASHDIFF": "BINARY(16)",
                "EFFECTIVE_FROM": "DATE",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR(50)"
            }
        },
        "MAS_NO_PK_CDK_HASHDIFF": {
            "column_types": {
                "CUSTOMER_PK": "BINARY(16)",
                "CUSTOMER_NAME": "VARCHAR(50)",
                "CUSTOMER_PHONE": "VARCHAR(50)",
                "HASHDIFF": "BINARY(16)",
                "EFFECTIVE_FROM": "DATE",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR(50)"
            }
        },
        "MAS_TWO_CDK": {
            "column_types": {
                "CUSTOMER_PK": "BINARY(16)",
                "HASHDIFF": "BINARY(16)",
                "CUSTOMER_PHONE": "VARCHAR(50)",
                "CUSTOMER_NAME": "VARCHAR(50)",
                "EXTENSION": "DECIMAL(38,0)",
                "EFFECTIVE_FROM": "DATE",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR(50)"
            }
        },
        "MAS_TWO_CDK_TS": {
            "column_types": {
                "CUSTOMER_PK": "BINARY(16)",
                "HASHDIFF": "BINARY(16)",
                "CUSTOMER_PHONE": "VARCHAR(50)",
                "CUSTOMER_NAME": "VARCHAR(50)",
                "EXTENSION": "DECIMAL(38,0)",
                "EFFECTIVE_FROM": "DATETIME2",
                "LOAD_DATETIME": "DATETIME2",
                "SOURCE": "VARCHAR(50)"
            }
        },
        "MAS_TWO_CDK_NO_CDK_HASHDIFF": {
            "column_types": {
                "CUSTOMER_PK": "BINARY(16)",
                "CUSTOMER_NAME": "VARCHAR(50)",
                "CUSTOMER_PHONE": "VARCHAR(50)",
                "EXTENSION": "DECIMAL(38,0)",
                "HASHDIFF": "BINARY(16)",
                "EFFECTIVE_FROM": "DATE",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR(50)"
            }
        },
        "MAS_TWO_CDK_NO_PK_CDK_HASHDIFF": {
            "column_types": {
                "CUSTOMER_PK": "BINARY(16)",
                "CUSTOMER_NAME": "VARCHAR(50)",
                "CUSTOMER_PHONE": "VARCHAR(50)",
                "EXTENSION": "DECIMAL(38,0)",
                "HASHDIFF": "BINARY(16)",
                "EFFECTIVE_FROM": "DATE",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR(50)"
            }
        }
    }


# Postgres


@fixture
def multi_active_satellite_postgres(context):
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
        "STG_CUSTOMER_COMP": {
            "CUSTOMER_PK": "CUSTOMER_ID",
            "ORDER_PK": "ORDER_ID",
            "HASHDIFF": {"is_hashdiff": True,
                         "columns": ["CUSTOMER_ID", "ORDER_ID", "CUSTOMER_PHONE", "CUSTOMER_NAME"]}
        },
        "STG_CUSTOMER_NO_CDK_HASHDIFF": {
            "CUSTOMER_PK": "CUSTOMER_ID",
            "HASHDIFF": {"is_hashdiff": True,
                         "columns": ["CUSTOMER_ID", "CUSTOMER_NAME"]}
        },
        "STG_CUSTOMER_NO_PK_CDK_HASHDIFF": {
            "CUSTOMER_PK": "CUSTOMER_ID",
            "HASHDIFF": {"is_hashdiff": True,
                         "columns": ["CUSTOMER_NAME"]}
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
                         "columns": ["CUSTOMER_NAME"]}
        },
        "STG_CUSTOMER_TWO_CDK_COMP": {
            "CUSTOMER_PK": "CUSTOMER_ID",
            "ORDER_PK": "ORDER_ID",
            "HASHDIFF": {"is_hashdiff": True,
                         "columns": ["CUSTOMER_ID", "ORDER_ID", "CUSTOMER_PHONE", "CUSTOMER_NAME", "EXTENSION"]}
        }
    }

    context.derived_columns = {
        "STG_CUSTOMER": {
            "EFFECTIVE_FROM": "LOAD_DATE"
        },
        "STG_CUSTOMER_TZ": {
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
        },
        "STG_CUSTOMER_COMP": {
            "EFFECTIVE_FROM": "LOAD_DATE"
        },
        "STG_CUSTOMER_TWO_CDK_COMP": {
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
             "SOURCE"
             ],
        "RAW_STAGE_TZ":
            ["CUSTOMER_ID",
             "CUSTOMER_NAME",
             "CUSTOMER_PHONE",
             "EFFECTIVE_FROM",
             "LOAD_DATE",
             "SOURCE"
             ],
        "RAW_STAGE_COMP":
            ["CUSTOMER_ID",
             "ORDER_ID",
             "CUSTOMER_NAME",
             "CUSTOMER_PHONE",
             "EFFECTIVE_FROM",
             "LOAD_DATE",
             "SOURCE"
             ],
        "RAW_STAGE_TS":
            ["CUSTOMER_ID",
             "CUSTOMER_NAME",
             "CUSTOMER_PHONE",
             "EFFECTIVE_FROM",
             "LOAD_DATETIME",
             "SOURCE"
             ],
        "RAW_STAGE_TWO_CDK":
            ["CUSTOMER_ID",
             "CUSTOMER_NAME",
             "CUSTOMER_PHONE",
             "EXTENSION",
             "EFFECTIVE_FROM",
             "LOAD_DATE",
             "SOURCE"
             ],
        "RAW_STAGE_TWO_CDK_TS":
            ["CUSTOMER_ID",
             "CUSTOMER_NAME",
             "CUSTOMER_PHONE",
             "EXTENSION",
             "EFFECTIVE_FROM",
             "LOAD_DATETIME",
             "SOURCE"
             ],
        "RAW_STAGE_TWO_CDK_COMP":
            ["CUSTOMER_ID",
             "ORDER_ID",
             "CUSTOMER_NAME",
             "CUSTOMER_PHONE",
             "EXTENSION",
             "EFFECTIVE_FROM",
             "LOAD_DATE",
             "SOURCE"
             ]
    }

    context.vault_structure_columns = {
        "MAS": {
            "src_pk": "CUSTOMER_PK",
            "src_cdk": ["CUSTOMER_PHONE"],
            "src_payload": ["CUSTOMER_NAME"],
            "src_hashdiff": "HASHDIFF",
            "src_eff": "EFFECTIVE_FROM",
            "src_ldts": "LOAD_DATE",
            "src_source": "SOURCE"
        },
        "MAS_TZ": {
            "src_pk": "CUSTOMER_PK",
            "src_cdk": ["CUSTOMER_PHONE"],
            "src_payload": ["CUSTOMER_NAME"],
            "src_hashdiff": "HASHDIFF",
            "src_eff": "EFFECTIVE_FROM",
            "src_ldts": "LOAD_DATE",
            "src_source": "SOURCE"
        },
        "MAS_COMP": {
            "src_pk": ["CUSTOMER_PK", "ORDER_PK"],
            "src_cdk": ["CUSTOMER_PHONE"],
            "src_payload": ["CUSTOMER_NAME"],
            "src_hashdiff": "HASHDIFF",
            "src_eff": "EFFECTIVE_FROM",
            "src_ldts": "LOAD_DATE",
            "src_source": "SOURCE"
        },
        "MAS_HD_ALIAS": {
            "src_pk": "CUSTOMER_PK",
            "src_cdk": ["CUSTOMER_PHONE"],
            "src_payload": ["CUSTOMER_NAME"],
            "src_hashdiff": {"source_column": "CUSTOMER_HASHDIFF", "alias": "HASHDIFF"},
            "src_eff": "EFFECTIVE_FROM",
            "src_ldts": "LOAD_DATE",
            "src_source": "SOURCE"
        },
        "MAS_TS": {
            "src_pk": "CUSTOMER_PK",
            "src_cdk": ["CUSTOMER_PHONE"],
            "src_payload": ["CUSTOMER_NAME"],
            "src_hashdiff": "HASHDIFF",
            "src_eff": "EFFECTIVE_FROM",
            "src_ldts": "LOAD_DATETIME",
            "src_source": "SOURCE"
        },
        "MAS_NO_CDK_HASHDIFF": {
            "src_pk": "CUSTOMER_PK",
            "src_cdk": ["CUSTOMER_PHONE"],
            "src_payload": ["CUSTOMER_NAME"],
            "src_hashdiff": "HASHDIFF",
            "src_eff": "EFFECTIVE_FROM",
            "src_ldts": "LOAD_DATE",
            "src_source": "SOURCE"
        },
        "MAS_NO_PK_CDK_HASHDIFF": {
            "src_pk": "CUSTOMER_PK",
            "src_cdk": ["CUSTOMER_PHONE"],
            "src_payload": ["CUSTOMER_NAME"],
            "src_hashdiff": "HASHDIFF",
            "src_eff": "EFFECTIVE_FROM",
            "src_ldts": "LOAD_DATE",
            "src_source": "SOURCE"
        },
        "MAS_TWO_CDK": {
            "src_pk": "CUSTOMER_PK",
            "src_cdk": ["CUSTOMER_PHONE", "EXTENSION"],
            "src_payload": ["CUSTOMER_NAME"],
            "src_hashdiff": "HASHDIFF",
            "src_eff": "EFFECTIVE_FROM",
            "src_ldts": "LOAD_DATE",
            "src_source": "SOURCE"
        },
        "MAS_TWO_CDK_TS": {
            "src_pk": "CUSTOMER_PK",
            "src_cdk": ["CUSTOMER_PHONE", "EXTENSION"],
            "src_payload": ["CUSTOMER_NAME"],
            "src_hashdiff": "HASHDIFF",
            "src_eff": "EFFECTIVE_FROM",
            "src_ldts": "LOAD_DATETIME",
            "src_source": "SOURCE"
        },
        "MAS_TWO_CDK_NO_CDK_HASHDIFF": {
            "src_pk": "CUSTOMER_PK",
            "src_cdk": ["CUSTOMER_PHONE", "EXTENSION"],
            "src_payload": ["CUSTOMER_NAME"],
            "src_hashdiff": "HASHDIFF",
            "src_eff": "EFFECTIVE_FROM",
            "src_ldts": "LOAD_DATE",
            "src_source": "SOURCE"
        },
        "MAS_TWO_CDK_NO_PK_CDK_HASHDIFF": {
            "src_pk": "CUSTOMER_PK",
            "src_cdk": ["CUSTOMER_PHONE", "EXTENSION"],
            "src_payload": ["CUSTOMER_NAME"],
            "src_hashdiff": "HASHDIFF",
            "src_eff": "EFFECTIVE_FROM",
            "src_ldts": "LOAD_DATE",
            "src_source": "SOURCE"
        },
        "MAS_AC": {
            "src_pk": "CUSTOMER_PK",
            "src_cdk": ["CUSTOMER_PHONE"],
            "src_payload": ["CUSTOMER_NAME"],
            "src_hashdiff": "HASHDIFF",
            "src_extra_columns": "CUSTOMER_MT_ID",
            "src_eff": "EFFECTIVE_FROM",
            "src_ldts": "LOAD_DATE",
            "src_source": "SOURCE"
        },
        "MAS_TWO_CDK_COMP": {
            "src_pk": ["CUSTOMER_PK", "ORDER_PK"],
            "src_cdk": ["CUSTOMER_PHONE", "EXTENSION"],
            "src_payload": ["CUSTOMER_NAME"],
            "src_hashdiff": "HASHDIFF",
            "src_eff": "EFFECTIVE_FROM",
            "src_ldts": "LOAD_DATE",
            "src_source": "SOURCE"
        }
    }

    set_metadata(context)

    context.seed_config = {
        "RAW_STAGE": {
            "column_types": {
                "CUSTOMER_ID": "NUMERIC(38, 0)",
                "CUSTOMER_NAME": "VARCHAR",
                "CUSTOMER_PHONE": "VARCHAR",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR"
            }
        },
        "RAW_STAGE_TZ": {
            "column_types": {
                "CUSTOMER_ID": "NUMERIC(38, 0)",
                "CUSTOMER_NAME": "VARCHAR",
                "CUSTOMER_PHONE": "VARCHAR",
                "LOAD_DATE": "TIMESTAMPTZ",
                "SOURCE": "VARCHAR"
            }
        },
        "RAW_STAGE_TS": {
            "column_types": {
                "CUSTOMER_ID": "NUMERIC(38, 0)",
                "CUSTOMER_NAME": "VARCHAR",
                "CUSTOMER_PHONE": "VARCHAR",
                "LOAD_DATETIME": "TIMESTAMPTZ",
                "SOURCE": "VARCHAR"
            }
        },
        "RAW_STAGE_COMP": {
            "column_types": {
                "CUSTOMER_ID": "NUMERIC(38, 0)",
                "ORDER_ID": "VARCHAR",
                "CUSTOMER_NAME": "VARCHAR",
                "CUSTOMER_PHONE": "VARCHAR",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR"
            }
        },
        "RAW_STAGE_TWO_CDK": {
            "column_types": {
                "CUSTOMER_ID": "NUMERIC(38, 0)",
                "CUSTOMER_NAME": "VARCHAR",
                "CUSTOMER_PHONE": "VARCHAR",
                "EXTENSION": "NUMERIC(38, 0)",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR"
            }
        },
        "RAW_STAGE_TWO_CDK_TS": {
            "column_types": {
                "CUSTOMER_ID": "NUMERIC(38, 0)",
                "CUSTOMER_NAME": "VARCHAR",
                "CUSTOMER_PHONE": "VARCHAR",
                "EXTENSION": "NUMERIC(38, 0)",
                "LOAD_DATETIME": "TIMESTAMPTZ",
                "SOURCE": "VARCHAR"
            }
        },
        "RAW_STAGE_TWO_CDK_COMP": {
            "column_types": {
                "CUSTOMER_ID": "NUMERIC(38, 0)",
                "ORDER_ID": "VARCHAR",
                "CUSTOMER_NAME": "VARCHAR",
                "CUSTOMER_PHONE": "VARCHAR",
                "EXTENSION": "NUMERIC(38, 0)",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR"
            }
        },
        "MAS": {
            "column_types": {
                "CUSTOMER_PK": "BYTEA",
                "CUSTOMER_NAME": "VARCHAR",
                "CUSTOMER_PHONE": "VARCHAR",
                "HASHDIFF": "BYTEA",
                "EFFECTIVE_FROM": "DATE",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR"
            }
        },
        "MAS_TZ": {
            "column_types": {
                "CUSTOMER_PK": "BYTEA",
                "CUSTOMER_NAME": "VARCHAR",
                "CUSTOMER_PHONE": "VARCHAR",
                "HASHDIFF": "BYTEA",
                "EFFECTIVE_FROM": "TIMESTAMPTZ",
                "LOAD_DATE": "TIMESTAMPTZ",
                "SOURCE": "VARCHAR"
            }
        },
        "MAS_COMP": {
            "column_types": {
                "CUSTOMER_PK": "BYTEA",
                "ORDER_PK": "BYTEA",
                "CUSTOMER_NAME": "VARCHAR",
                "CUSTOMER_PHONE": "VARCHAR",
                "HASHDIFF": "BYTEA",
                "EFFECTIVE_FROM": "DATE",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR"
            }
        },
        "MAS_TWO_CDK_COMP": {
            "column_types": {
                "CUSTOMER_PK": "BYTEA",
                "ORDER_PK": "BYTEA",
                "CUSTOMER_NAME": "VARCHAR",
                "CUSTOMER_PHONE": "VARCHAR",
                "EXTENSION": "NUMERIC(38, 0)",
                "HASHDIFF": "BYTEA",
                "EFFECTIVE_FROM": "DATE",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR"
            }
        },
        "MAS_TS": {
            "column_types": {
                "CUSTOMER_PK": "BYTEA",
                "CUSTOMER_NAME": "VARCHAR",
                "CUSTOMER_PHONE": "VARCHAR",
                "HASHDIFF": "BYTEA",
                "EFFECTIVE_FROM": "TIMESTAMPTZ",
                "LOAD_DATETIME": "TIMESTAMPTZ",
                "SOURCE": "VARCHAR"
            }
        },
        "MAS_HD_ALIAS": {
            "column_types": {
                "CUSTOMER_PK": "BYTEA",
                "CUSTOMER_NAME": "VARCHAR",
                "CUSTOMER_PHONE": "VARCHAR",
                "HASHDIFF": "BYTEA",
                "EFFECTIVE_FROM": "TIMESTAMPTZ",
                "LOAD_DATE": "TIMESTAMPTZ",
                "SOURCE": "VARCHAR"
            }
        },
        "MAS_NO_CDK_HASHDIFF": {
            "column_types": {
                "CUSTOMER_PK": "BYTEA",
                "CUSTOMER_NAME": "VARCHAR",
                "CUSTOMER_PHONE": "VARCHAR",
                "HASHDIFF": "BYTEA",
                "EFFECTIVE_FROM": "DATE",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR"
            }
        },
        "MAS_NO_PK_CDK_HASHDIFF": {
            "column_types": {
                "CUSTOMER_PK": "BYTEA",
                "CUSTOMER_NAME": "VARCHAR",
                "CUSTOMER_PHONE": "VARCHAR",
                "HASHDIFF": "BYTEA",
                "EFFECTIVE_FROM": "DATE",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR"
            }
        },
        "MAS_TWO_CDK": {
            "column_types": {
                "CUSTOMER_PK": "BYTEA",
                "CUSTOMER_NAME": "VARCHAR",
                "CUSTOMER_PHONE": "VARCHAR",
                "EXTENSION": "NUMERIC(38, 0)",
                "HASHDIFF": "BYTEA",
                "EFFECTIVE_FROM": "DATE",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR"
            }
        },
        "MAS_TWO_CDK_TS": {
            "column_types": {
                "CUSTOMER_PK": "BYTEA",
                "CUSTOMER_NAME": "VARCHAR",
                "CUSTOMER_PHONE": "VARCHAR",
                "EXTENSION": "NUMERIC(38, 0)",
                "HASHDIFF": "BYTEA",
                "EFFECTIVE_FROM": "TIMESTAMPTZ",
                "LOAD_DATETIME": "TIMESTAMPTZ",
                "SOURCE": "VARCHAR"
            }
        },
        "MAS_TWO_CDK_NO_CDK_HASHDIFF": {
            "column_types": {
                "CUSTOMER_PK": "BYTEA",
                "CUSTOMER_NAME": "VARCHAR",
                "CUSTOMER_PHONE": "VARCHAR",
                "EXTENSION": "NUMERIC(38, 0)",
                "HASHDIFF": "BYTEA",
                "EFFECTIVE_FROM": "DATE",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR"
            }
        },
        "MAS_TWO_CDK_NO_PK_CDK_HASHDIFF": {
            "column_types": {
                "CUSTOMER_PK": "BYTEA",
                "CUSTOMER_NAME": "VARCHAR",
                "CUSTOMER_PHONE": "VARCHAR",
                "EXTENSION": "NUMERIC(38, 0)",
                "HASHDIFF": "BYTEA",
                "EFFECTIVE_FROM": "DATE",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR"
            }
        },
        "MAS_AC": {
            "column_types": {
                "CUSTOMER_PK": "BYTEA",
                "HASHDIFF": "BYTEA",
                "CUSTOMER_NAME": "VARCHAR",
                "CUSTOMER_PHONE": "VARCHAR",
                "CUSTOMER_MT_ID": "VARCHAR",
                "EFFECTIVE_FROM": "DATE",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR"
            }
        }
    }


@fixture
def multi_active_satellite_cycle_postgres(context):
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
                         "columns": ["CUSTOMER_NAME"]}
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
                         "columns": ["CUSTOMER_NAME"]}
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
        "MAS": {
            "src_pk": "CUSTOMER_PK",
            "src_cdk": ["CUSTOMER_PHONE"],
            "src_payload": ["CUSTOMER_NAME"],
            "src_hashdiff": "HASHDIFF",
            "src_eff": "EFFECTIVE_FROM",
            "src_ldts": "LOAD_DATE",
            "src_source": "SOURCE"
        },
        "MAS_TS": {
            "src_pk": "CUSTOMER_PK",
            "src_cdk": ["CUSTOMER_PHONE"],
            "src_payload": ["CUSTOMER_NAME"],
            "src_hashdiff": "HASHDIFF",
            "src_eff": "EFFECTIVE_FROM",
            "src_ldts": "LOAD_DATETIME",
            "src_source": "SOURCE"
        },
        "MAS_NO_CDK_HASHDIFF": {
            "src_pk": "CUSTOMER_PK",
            "src_cdk": ["CUSTOMER_PHONE"],
            "src_payload": ["CUSTOMER_NAME"],
            "src_hashdiff": "HASHDIFF",
            "src_eff": "EFFECTIVE_FROM",
            "src_ldts": "LOAD_DATE",
            "src_source": "SOURCE"
        },
        "MAS_NO_PK_CDK_HASHDIFF": {
            "src_pk": "CUSTOMER_PK",
            "src_cdk": ["CUSTOMER_PHONE"],
            "src_payload": ["CUSTOMER_NAME"],
            "src_hashdiff": "HASHDIFF",
            "src_eff": "EFFECTIVE_FROM",
            "src_ldts": "LOAD_DATE",
            "src_source": "SOURCE"
        },
        "MAS_TWO_CDK": {
            "src_pk": "CUSTOMER_PK",
            "src_cdk": ["CUSTOMER_PHONE", "EXTENSION"],
            "src_payload": ["CUSTOMER_NAME"],
            "src_hashdiff": "HASHDIFF",
            "src_eff": "EFFECTIVE_FROM",
            "src_ldts": "LOAD_DATE",
            "src_source": "SOURCE"
        },
        "MAS_TWO_CDK_TS": {
            "src_pk": "CUSTOMER_PK",
            "src_cdk": ["CUSTOMER_PHONE", "EXTENSION"],
            "src_payload": ["CUSTOMER_NAME"],
            "src_hashdiff": "HASHDIFF",
            "src_eff": "EFFECTIVE_FROM",
            "src_ldts": "LOAD_DATETIME",
            "src_source": "SOURCE"
        },
        "MAS_TWO_CDK_NO_CDK_HASHDIFF": {
            "src_pk": "CUSTOMER_PK",
            "src_cdk": ["CUSTOMER_PHONE", "EXTENSION"],
            "src_payload": ["CUSTOMER_NAME"],
            "src_hashdiff": "HASHDIFF",
            "src_eff": "EFFECTIVE_FROM",
            "src_ldts": "LOAD_DATE",
            "src_source": "SOURCE"
        },
        "MAS_TWO_CDK_NO_PK_CDK_HASHDIFF": {
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
            "column_types": {
                "CUSTOMER_ID": "NUMERIC(38, 0)",
                "CUSTOMER_NAME": "VARCHAR",
                "CUSTOMER_PHONE": "VARCHAR",
                "EFFECTIVE_FROM": "DATE",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR"
            }
        },
        "RAW_STAGE_TS": {
            "column_types": {
                "CUSTOMER_ID": "NUMERIC(38, 0)",
                "CUSTOMER_NAME": "VARCHAR",
                "CUSTOMER_PHONE": "VARCHAR",
                "EFFECTIVE_FROM": "TIMESTAMPTZ",
                "LOAD_DATETIME": "TIMESTAMPTZ",
                "SOURCE": "VARCHAR"
            }
        },
        "RAW_STAGE_TWO_CDK": {
            "column_types": {
                "CUSTOMER_ID": "NUMERIC(38, 0)",
                "CUSTOMER_NAME": "VARCHAR",
                "CUSTOMER_PHONE": "VARCHAR",
                "EXTENSION": "NUMERIC(38, 0)",
                "EFFECTIVE_FROM": "DATE",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR"
            }
        },
        "RAW_STAGE_TWO_CDK_TS": {
            "column_types": {
                "CUSTOMER_ID": "NUMERIC(38, 0)",
                "CUSTOMER_NAME": "VARCHAR",
                "CUSTOMER_PHONE": "VARCHAR",
                "EXTENSION": "NUMERIC(38, 0)",
                "EFFECTIVE_FROM": "TIMESTAMPTZ",
                "LOAD_DATETIME": "TIMESTAMPTZ",
                "SOURCE": "VARCHAR"
            }
        },
        "MAS": {
            "column_types": {
                "CUSTOMER_PK": "BYTEA",
                "HASHDIFF": "BYTEA",
                "CUSTOMER_PHONE": "VARCHAR",
                "CUSTOMER_NAME": "VARCHAR",
                "EFFECTIVE_FROM": "DATE",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR"
            }
        },
        "MAS_TS": {
            "column_types": {
                "CUSTOMER_PK": "BYTEA",
                "HASHDIFF": "BYTEA",
                "CUSTOMER_PHONE": "VARCHAR",
                "CUSTOMER_NAME": "VARCHAR",
                "EFFECTIVE_FROM": "TIMESTAMPTZ",
                "LOAD_DATETIME": "TIMESTAMPTZ",
                "SOURCE": "VARCHAR"
            }
        },
        "MAS_NO_CDK_HASHDIFF": {
            "column_types": {
                "CUSTOMER_PK": "BYTEA",
                "CUSTOMER_NAME": "VARCHAR",
                "CUSTOMER_PHONE": "VARCHAR",
                "HASHDIFF": "BYTEA",
                "EFFECTIVE_FROM": "DATE",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR"
            }
        },
        "MAS_NO_PK_CDK_HASHDIFF": {
            "column_types": {
                "CUSTOMER_PK": "BYTEA",
                "CUSTOMER_NAME": "VARCHAR",
                "CUSTOMER_PHONE": "VARCHAR",
                "HASHDIFF": "BYTEA",
                "EFFECTIVE_FROM": "DATE",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR"
            }
        },
        "MAS_TWO_CDK": {
            "column_types": {
                "CUSTOMER_PK": "BYTEA",
                "HASHDIFF": "BYTEA",
                "CUSTOMER_PHONE": "VARCHAR",
                "CUSTOMER_NAME": "VARCHAR",
                "EXTENSION": "NUMERIC(38, 0)",
                "EFFECTIVE_FROM": "DATE",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR"
            }
        },
        "MAS_TWO_CDK_TS": {
            "column_types": {
                "CUSTOMER_PK": "BYTEA",
                "HASHDIFF": "BYTEA",
                "CUSTOMER_PHONE": "VARCHAR",
                "CUSTOMER_NAME": "VARCHAR",
                "EXTENSION": "NUMERIC(38, 0)",
                "EFFECTIVE_FROM": "TIMESTAMPTZ",
                "LOAD_DATETIME": "TIMESTAMPTZ",
                "SOURCE": "VARCHAR"
            }
        },
        "MAS_TWO_CDK_NO_CDK_HASHDIFF": {
            "column_types": {
                "CUSTOMER_PK": "BYTEA",
                "CUSTOMER_NAME": "VARCHAR",
                "CUSTOMER_PHONE": "VARCHAR",
                "EXTENSION": "NUMERIC(38, 0)",
                "HASHDIFF": "BYTEA",
                "EFFECTIVE_FROM": "DATE",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR"
            }
        },
        "MAS_TWO_CDK_NO_PK_CDK_HASHDIFF": {
            "column_types": {
                "CUSTOMER_PK": "BYTEA",
                "CUSTOMER_NAME": "VARCHAR",
                "CUSTOMER_PHONE": "VARCHAR",
                "EXTENSION": "NUMERIC(38, 0)",
                "HASHDIFF": "BYTEA",
                "EFFECTIVE_FROM": "DATE",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR"
            }
        }
    }


# Databricks

@fixture
def multi_active_satellite_databricks(context):
    """
    Define the structures and metadata to load multi active satellites
    """

    set_metadata(context)

    context.seed_config = {
        "RAW_STAGE": {
            "column_types": {
                "CUSTOMER_ID": "STRING",
                "CUSTOMER_NAME": "STRING",
                "CUSTOMER_PHONE": "STRING",
                "CUSTOMER_MT_ID": "STRING",
                "EFFECTIVE_FROM": "DATE",
                "LOAD_DATE": "DATE",
                "SOURCE": "STRING"
            }
        },
        "RAW_STAGE_TZ": {
            "column_types": {
                "CUSTOMER_ID": "STRING",
                "CUSTOMER_NAME": "STRING",
                "CUSTOMER_PHONE": "STRING",
                "CUSTOMER_MT_ID": "STRING",
                "EFFECTIVE_FROM": "TIMESTAMP",
                "LOAD_DATE": "TIMESTAMP",
                "SOURCE": "STRING"
            }
        },
        "RAW_STAGE_TS": {
            "column_types": {
                "CUSTOMER_ID": "STRING",
                "CUSTOMER_NAME": "STRING",
                "CUSTOMER_PHONE": "STRING",
                "LOAD_DATETIME": "TIMESTAMP",
                "SOURCE": "STRING"
            }
        },
        "RAW_STAGE_TWO_CDK": {
            "column_types": {
                "CUSTOMER_ID": "STRING",
                "CUSTOMER_NAME": "STRING",
                "CUSTOMER_PHONE": "STRING",
                "EXTENSION": "STRING",
                "EFFECTIVE_FROM": "DATE",
                "LOAD_DATE": "DATE",
                "SOURCE": "STRING"
            }
        },
        "RAW_STAGE_TWO_CDK_TS": {
            "column_types": {
                "CUSTOMER_ID": "STRING",
                "CUSTOMER_NAME": "STRING",
                "CUSTOMER_PHONE": "STRING",
                "EXTENSION": "STRING",
                "LOAD_DATETIME": "TIMESTAMP",
                "SOURCE": "STRING"
            }
        },
        "RAW_STAGE_COMP": {
            "column_types": {
                "CUSTOMER_ID": "STRING",
                "ORDER_ID": "STRING",
                "CUSTOMER_NAME": "STRING",
                "CUSTOMER_PHONE": "STRING",
                "CUSTOMER_MT_ID": "STRING",
                "EFFECTIVE_FROM": "DATE",
                "LOAD_DATE": "DATE",
                "SOURCE": "STRING"
            }
        },
        "RAW_STAGE_TWO_CDK_COMP": {
            "column_types": {
                "CUSTOMER_ID": "STRING",
                "ORDER_ID": "STRING",
                "CUSTOMER_NAME": "STRING",
                "CUSTOMER_PHONE": "STRING",
                "EXTENSION": "STRING",
                "EFFECTIVE_FROM": "DATE",
                "LOAD_DATE": "DATE",
                "SOURCE": "STRING"
            }
        },
        "MAS": {
            "column_types": {
                "CUSTOMER_PK": "STRING",
                "CUSTOMER_NAME": "STRING",
                "CUSTOMER_PHONE": "STRING",
                "HASHDIFF": "STRING",
                "EFFECTIVE_FROM": "DATE",
                "LOAD_DATE": "DATE",
                "SOURCE": "STRING"
            }
        },
        "MAS_TZ": {
            "column_types": {
                "CUSTOMER_PK": "STRING",
                "CUSTOMER_NAME": "STRING",
                "CUSTOMER_PHONE": "STRING",
                "HASHDIFF": "STRING",
                "EFFECTIVE_FROM": "TIMESTAMP",
                "LOAD_DATE": "TIMESTAMP",
                "SOURCE": "STRING"
            }
        },
        "MAS_TS": {
            "column_types": {
                "CUSTOMER_PK": "STRING",
                "CUSTOMER_NAME": "STRING",
                "CUSTOMER_PHONE": "STRING",
                "HASHDIFF": "STRING",
                "EFFECTIVE_FROM": "TIMESTAMP",
                "LOAD_DATETIME": "TIMESTAMP",
                "SOURCE": "STRING"
            }
        },
        "MAS_HD_ALIAS": {
            "column_types": {
                "CUSTOMER_PK": "STRING",
                "CUSTOMER_NAME": "STRING",
                "CUSTOMER_PHONE": "STRING",
                "HASHDIFF": "STRING",
                "EFFECTIVE_FROM": "TIMESTAMP",
                "LOAD_DATE": "TIMESTAMP",
                "SOURCE": "STRING"
            }
        },
        "MAS_NO_CDK_HASHDIFF": {
            "column_types": {
                "CUSTOMER_PK": "STRING",
                "CUSTOMER_NAME": "STRING",
                "CUSTOMER_PHONE": "STRING",
                "HASHDIFF": "STRING",
                "EFFECTIVE_FROM": "DATE",
                "LOAD_DATE": "DATE",
                "SOURCE": "STRING"
            }
        },
        "MAS_NO_PK_CDK_HASHDIFF": {
            "column_types": {
                "CUSTOMER_PK": "STRING",
                "CUSTOMER_NAME": "STRING",
                "CUSTOMER_PHONE": "STRING",
                "HASHDIFF": "STRING",
                "EFFECTIVE_FROM": "DATE",
                "LOAD_DATE": "DATE",
                "SOURCE": "STRING"
            }
        },
        "MAS_TWO_CDK": {
            "column_types": {
                "CUSTOMER_PK": "STRING",
                "CUSTOMER_NAME": "STRING",
                "CUSTOMER_PHONE": "STRING",
                "EXTENSION": "STRING",
                "HASHDIFF": "STRING",
                "EFFECTIVE_FROM": "DATE",
                "LOAD_DATE": "DATE",
                "SOURCE": "STRING"
            }
        },
        "MAS_TWO_CDK_TS": {
            "column_types": {
                "CUSTOMER_PK": "STRING",
                "CUSTOMER_NAME": "STRING",
                "CUSTOMER_PHONE": "STRING",
                "EXTENSION": "STRING",
                "HASHDIFF": "STRING",
                "EFFECTIVE_FROM": "TIMESTAMP",
                "LOAD_DATETIME": "TIMESTAMP",
                "SOURCE": "STRING"
            }
        },
        "MAS_TWO_CDK_NO_CDK_HASHDIFF": {
            "column_types": {
                "CUSTOMER_PK": "STRING",
                "CUSTOMER_NAME": "STRING",
                "CUSTOMER_PHONE": "STRING",
                "EXTENSION": "STRING",
                "HASHDIFF": "STRING",
                "EFFECTIVE_FROM": "DATE",
                "LOAD_DATE": "DATE",
                "SOURCE": "STRING"
            }
        },
        "MAS_TWO_CDK_NO_PK_CDK_HASHDIFF": {
            "column_types": {
                "CUSTOMER_PK": "STRING",
                "CUSTOMER_NAME": "STRING",
                "CUSTOMER_PHONE": "STRING",
                "EXTENSION": "STRING",
                "HASHDIFF": "STRING",
                "EFFECTIVE_FROM": "DATE",
                "LOAD_DATE": "DATE",
                "SOURCE": "STRING"
            }
        },
        "MAS_AC": {
            "column_types": {
                "CUSTOMER_PK": "STRING",
                "HASHDIFF": "STRING",
                "CUSTOMER_NAME": "STRING",
                "CUSTOMER_PHONE": "STRING",
                "CUSTOMER_MT_ID": "STRING",
                "EFFECTIVE_FROM": "DATE",
                "LOAD_DATE": "DATE",
                "SOURCE": "STRING"
            }
        },
        "MAS_COMP": {
            "column_types": {
                "CUSTOMER_PK": "STRING",
                "ORDER_PK": "STRING",
                "CUSTOMER_NAME": "STRING",
                "CUSTOMER_PHONE": "STRING",
                "HASHDIFF": "STRING",
                "EFFECTIVE_FROM": "DATE",
                "LOAD_DATE": "DATE",
                "SOURCE": "STRING"
            }
        },
        "MAS_TWO_CDK_COMP": {
            "column_types": {
                "CUSTOMER_PK": "STRING",
                "ORDER_PK": "STRING",
                "CUSTOMER_NAME": "STRING",
                "CUSTOMER_PHONE": "STRING",
                "EXTENSION": "STRING",
                "HASHDIFF": "STRING",
                "EFFECTIVE_FROM": "DATE",
                "LOAD_DATE": "DATE",
                "SOURCE": "STRING"
            }
        }
    }


@fixture
def multi_active_satellite_cycle_databricks(context):
    """
    Define the structures and metadata to perform load cycles for multi active satellites
    """

    set_metadata(context)

    context.seed_config = {
        "RAW_STAGE": {
            "column_types": {
                "CUSTOMER_ID": "DECIMAL(38, 0)",
                "CUSTOMER_NAME": "VARCHAR(50)",
                "CUSTOMER_PHONE": "VARCHAR(50)",
                "EFFECTIVE_FROM": "DATE",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR(50)"
            }
        },
        "RAW_STAGE_TS": {
            "column_types": {
                "CUSTOMER_ID": "DECIMAL(38, 0)",
                "CUSTOMER_NAME": "VARCHAR(50)",
                "CUSTOMER_PHONE": "VARCHAR(50)",
                "EFFECTIVE_FROM": "TIMESTAMP",
                "LOAD_DATETIME": "TIMESTAMP",
                "SOURCE": "VARCHAR(50)"
            }
        },
        "RAW_STAGE_TWO_CDK": {
            "column_types": {
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
            "column_types": {
                "CUSTOMER_ID": "DECIMAL(38, 0)",
                "CUSTOMER_NAME": "VARCHAR(50)",
                "CUSTOMER_PHONE": "VARCHAR(50)",
                "EXTENSION": "DECIMAL(38, 0)",
                "EFFECTIVE_FROM": "TIMESTAMP",
                "LOAD_DATETIME": "TIMESTAMP",
                "SOURCE": "VARCHAR(50)"
            }
        },
        "MAS": {
            "column_types": {
                "CUSTOMER_PK": "STRING",
                "HASHDIFF": "STRING",
                "CUSTOMER_PHONE": "VARCHAR(50)",
                "CUSTOMER_NAME": "VARCHAR(50)",
                "EFFECTIVE_FROM": "DATE",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR(50)"
            }
        },
        "MAS_TS": {
            "column_types": {
                "CUSTOMER_PK": "STRING",
                "HASHDIFF": "STRING",
                "CUSTOMER_PHONE": "VARCHAR(50)",
                "CUSTOMER_NAME": "VARCHAR(50)",
                "EFFECTIVE_FROM": "TIMESTAMP",
                "LOAD_DATETIME": "TIMESTAMP",
                "SOURCE": "VARCHAR(50)"
            }
        },
        "MAS_NO_CDK_HASHDIFF": {
            "column_types": {
                "CUSTOMER_PK": "STRING",
                "CUSTOMER_NAME": "VARCHAR(50)",
                "CUSTOMER_PHONE": "VARCHAR(50)",
                "HASHDIFF": "STRING",
                "EFFECTIVE_FROM": "DATE",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR(50)"
            }
        },
        "MAS_NO_PK_CDK_HASHDIFF": {
            "column_types": {
                "CUSTOMER_PK": "STRING",
                "CUSTOMER_NAME": "VARCHAR(50)",
                "CUSTOMER_PHONE": "VARCHAR(50)",
                "HASHDIFF": "STRING",
                "EFFECTIVE_FROM": "DATE",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR(50)"
            }
        },
        "MAS_TWO_CDK": {
            "column_types": {
                "CUSTOMER_PK": "STRING",
                "HASHDIFF": "STRING",
                "CUSTOMER_PHONE": "VARCHAR(50)",
                "CUSTOMER_NAME": "VARCHAR(50)",
                "EXTENSION": "DECIMAL(38, 0)",
                "EFFECTIVE_FROM": "DATE",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR(50)"
            }
        },
        "MAS_TWO_CDK_TS": {
            "column_types": {
                "CUSTOMER_PK": "STRING",
                "HASHDIFF": "STRING",
                "CUSTOMER_PHONE": "VARCHAR(50)",
                "CUSTOMER_NAME": "VARCHAR(50)",
                "EXTENSION": "DECIMAL(38, 0)",
                "EFFECTIVE_FROM": "TIMESTAMP",
                "LOAD_DATETIME": "TIMESTAMP",
                "SOURCE": "VARCHAR(50)"
            }
        },
        "MAS_TWO_CDK_NO_CDK_HASHDIFF": {
            "column_types": {
                "CUSTOMER_PK": "STRING",
                "CUSTOMER_NAME": "VARCHAR(50)",
                "CUSTOMER_PHONE": "VARCHAR(50)",
                "EXTENSION": "DECIMAL(38, 0)",
                "HASHDIFF": "STRING",
                "EFFECTIVE_FROM": "DATE",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR(50)"
            }
        },
        "MAS_TWO_CDK_NO_PK_CDK_HASHDIFF": {
            "column_types": {
                "CUSTOMER_PK": "STRING",
                "CUSTOMER_NAME": "VARCHAR(50)",
                "CUSTOMER_PHONE": "VARCHAR(50)",
                "EXTENSION": "DECIMAL(38, 0)",
                "HASHDIFF": "STRING",
                "EFFECTIVE_FROM": "DATE",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR(50)"
            }
        }
    }
