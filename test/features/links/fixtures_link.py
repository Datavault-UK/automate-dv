from behave import fixture


def set_vault_structure_definition(context):
    context.vault_structure_columns = {
        "LINK": {
            "src_pk": "CUSTOMER_NATION_PK",
            "src_fk": ["CUSTOMER_FK", "NATION_FK"],
            "src_ldts": "LOAD_DATE",
            "src_source": "SOURCE"
        },
        "LINK_AC": {
            "src_pk": "CUSTOMER_NATION_PK",
            "src_fk": ["CUSTOMER_FK", "NATION_FK"],
            "src_extra_columns": "CUSTOMER_MT_ID",
            "src_ldts": "LOAD_DATE",
            "src_source": "SOURCE"
        }
    }


def set_staging_definition(context):
    context.hashed_columns = {
        "STG_CUSTOMER": {
            "CUSTOMER_NATION_PK": ["CUSTOMER_ID", "NATION_ID"],
            "CUSTOMER_FK": "CUSTOMER_ID",
            "NATION_FK": "NATION_ID"
        },
        "STG_SAP": {
            "CUSTOMER_NATION_PK": ["CUSTOMER_ID", "NATION_ID"],
            "CUSTOMER_FK": "CUSTOMER_ID",
            "NATION_FK": "NATION_ID"
        },
        "STG_CRM": {
            "CUSTOMER_NATION_PK": ["CUSTOMER_ID", "NATION_ID"],
            "CUSTOMER_FK": "CUSTOMER_ID",
            "NATION_FK": "NATION_ID"
        },
        "STG_WEB": {
            "CUSTOMER_NATION_PK": ["CUSTOMER_ID", "NATION_ID"],
            "CUSTOMER_FK": "CUSTOMER_ID",
            "NATION_FK": "NATION_ID"
        },
    }


def set_metadata(context):
    set_vault_structure_definition(context)

    set_staging_definition(context)


# Snowflake


@fixture
def single_source_link_snowflake(context):
    """
    Define the structures and metadata to load single-source links
    """

    set_metadata(context)

    context.seed_config = {
        "LINK": {
            "column_types": {
                "CUSTOMER_NATION_PK": "BINARY(16)",
                "CUSTOMER_FK": "BINARY(16)",
                "NATION_FK": "BINARY(16)",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR"
            }
        },
        "LINK_AC": {
            "column_types": {
                "CUSTOMER_NATION_PK": "BINARY(16)",
                "CUSTOMER_FK": "BINARY(16)",
                "NATION_FK": "BINARY(16)",
                "CUSTOMER_MT_ID": "VARCHAR",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR"
            }
        },
        "RAW_STAGE": {
            "column_types": {
                "CUSTOMER_ID": "VARCHAR",
                "NATION_ID": "VARCHAR",
                "CUSTOMER_NAME": "VARCHAR",
                "CUSTOMER_DOB": "DATE",
                "CUSTOMER_PHONE": "VARCHAR",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR"
            }
        }
    }


@fixture
def single_source_comp_pk_link_snowflake(context):
    """
    Define the structures and metadata to load single-source links with composite PK
    """

    set_metadata(context)

    context.vault_structure_columns['LINK'] = {
        "src_pk": ["CUSTOMER_NATION_PK", "COMP_PK"],
        "src_fk": ["CUSTOMER_FK", "NATION_FK"],
        "src_ldts": "LOAD_DATE",
        "src_source": "SOURCE"
    }

    context.hashed_columns['STG_CUSTOMER'] = {
        "CUSTOMER_NATION_PK": ["CUSTOMER_ID", "NATION_ID"],
        "COMP_PK": "CUSTOMER_ID",
        "CUSTOMER_FK": "CUSTOMER_ID",
        "NATION_FK": "NATION_ID",
    }

    context.seed_config = {
        "LINK": {
            "column_types": {
                "CUSTOMER_NATION_PK": "BINARY(16)",
                "COMP_PK": "BINARY(16)",
                "CUSTOMER_FK": "BINARY(16)",
                "NATION_FK": "BINARY(16)",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR"
            }
        },
        "RAW_STAGE": {
            "column_types": {
                "CUSTOMER_ID": "VARCHAR",
                "NATION_ID": "VARCHAR",
                "CUSTOMER_NAME": "VARCHAR",
                "CUSTOMER_DOB": "DATE",
                "CUSTOMER_PHONE": "VARCHAR",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR"
            }
        }
    }


@fixture
def multi_source_link_snowflake(context):
    """
    Define the structures and metadata to load single-source links
    """

    set_metadata(context)

    context.vault_structure_columns = {
        **context.vault_structure_columns,
        **{
            'LINK': {
                "src_pk": "CUSTOMER_NATION_PK",
                "src_fk": ["CUSTOMER_FK", "NATION_FK"],
                "src_ldts": "LOAD_DATE",
                "src_source": "SOURCE"
            }
        }}

    context.seed_config = {
        "LINK": {
            "column_types": {
                "CUSTOMER_NATION_PK": "BINARY(16)",
                "CUSTOMER_FK": "BINARY(16)",
                "NATION_FK": "BINARY(16)",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR"
            }
        },
        "RAW_STAGE_SAP": {
            "column_types": {
                "CUSTOMER_ID": "VARCHAR",
                "NATION_ID": "VARCHAR",
                "CUSTOMER_NAME": "VARCHAR",
                "CUSTOMER_DOB": "DATE",
                "CUSTOMER_PHONE": "VARCHAR",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR"
            }
        },
        "RAW_STAGE_CRM": {
            "column_types": {
                "CUSTOMER_ID": "VARCHAR",
                "NATION_ID": "VARCHAR",
                "CUSTOMER_NAME": "VARCHAR",
                "CUSTOMER_DOB": "DATE",
                "CUSTOMER_PHONE": "VARCHAR",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR"
            }
        },
        "RAW_STAGE_WEB": {
            "column_types": {
                "CUSTOMER_ID": "VARCHAR",
                "NATION_ID": "VARCHAR",
                "CUSTOMER_NAME": "VARCHAR",
                "CUSTOMER_DOB": "DATE",
                "CUSTOMER_PHONE": "VARCHAR",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR"
            }
        }
    }


# BigQuery


@fixture
def single_source_link_bigquery(context):
    """
    Define the structures and metadata to load single-source links
    """

    set_metadata(context)

    context.seed_config = {
        "LINK": {
            "column_types": {
                "CUSTOMER_NATION_PK": "STRING",
                "CUSTOMER_FK": "STRING",
                "NATION_FK": "STRING",
                "LOAD_DATE": "DATE",
                "SOURCE": "STRING"
            }
        },
        "LINK_AC": {
            "column_types": {
                "CUSTOMER_NATION_PK": "STRING",
                "CUSTOMER_FK": "STRING",
                "NATION_FK": "STRING",
                "CUSTOMER_MT_ID": "STRING",
                "LOAD_DATE": "DATE",
                "SOURCE": "STRING"
            }
        },
        "RAW_STAGE": {
            "column_types": {
                "CUSTOMER_ID": "STRING",
                "NATION_ID": "STRING",
                "CUSTOMER_NAME": "STRING",
                "CUSTOMER_DOB": "DATE",
                "CUSTOMER_PHONE": "STRING",
                "CUSTOMER_MT_ID": "STRING",
                "LOAD_DATE": "DATE",
                "SOURCE": "STRING"
            }
        }
    }


@fixture
def single_source_comp_pk_link_bigquery(context):
    """
    Define the structures and metadata to load single-source links with composite PK
    """

    set_metadata(context)

    context.vault_structure_columns = {
        **context.vault_structure_columns,
        **{
            'LINK': {
                "src_pk": ["CUSTOMER_NATION_PK", "COMP_PK"],
                "src_fk": ["CUSTOMER_FK", "NATION_FK"],
                "src_ldts": "LOAD_DATE",
                "src_source": "SOURCE"
            }
        }}

    context.hashed_columns['STG_CUSTOMER'] = {
        **context.hashed_columns['STG_CUSTOMER'],
        **{
            'COMP_PK': 'CUSTOMER_ID'
        }}

    context.seed_config = {
        "LINK": {
            "column_types": {
                "CUSTOMER_NATION_PK": "STRING",
                "COMP_PK": "STRING",
                "CUSTOMER_FK": "STRING",
                "NATION_FK": "STRING",
                "LOAD_DATE": "DATE",
                "SOURCE": "STRING"
            }
        },
        "RAW_STAGE": {
            "column_types": {
                "CUSTOMER_ID": "STRING",
                "NATION_ID": "STRING",
                "CUSTOMER_NAME": "STRING",
                "CUSTOMER_DOB": "DATE",
                "CUSTOMER_PHONE": "STRING",
                "LOAD_DATE": "DATE",
                "SOURCE": "STRING"
            }
        }
    }


@fixture
def multi_source_link_bigquery(context):
    """
    Define the structures and metadata to load single-source links
    """

    set_metadata(context)

    context.vault_structure_columns = {
        **context.vault_structure_columns,
        **{
            'LINK': {
                "src_pk": "CUSTOMER_NATION_PK",
                "src_fk": ["CUSTOMER_FK", "NATION_FK"],
                "src_ldts": "LOAD_DATE",
                "src_source": "SOURCE"
            }
        }}

    context.seed_config = {
        "LINK": {
            "column_types": {
                "CUSTOMER_NATION_PK": "STRING",
                "CUSTOMER_FK": "STRING",
                "NATION_FK": "STRING",
                "LOAD_DATE": "DATE",
                "SOURCE": "STRING"
            }
        },
        "RAW_STAGE_SAP": {
            "column_types": {
                "CUSTOMER_ID": "STRING",
                "NATION_ID": "STRING",
                "CUSTOMER_NAME": "STRING",
                "CUSTOMER_DOB": "DATE",
                "CUSTOMER_PHONE": "STRING",
                "LOAD_DATE": "DATE",
                "SOURCE": "STRING"
            }
        },
        "RAW_STAGE_CRM": {
            "column_types": {
                "CUSTOMER_ID": "STRING",
                "NATION_ID": "STRING",
                "CUSTOMER_NAME": "STRING",
                "CUSTOMER_DOB": "DATE",
                "CUSTOMER_PHONE": "STRING",
                "LOAD_DATE": "DATE",
                "SOURCE": "STRING"
            }
        },
        "RAW_STAGE_WEB": {
            "column_types": {
                "CUSTOMER_ID": "STRING",
                "NATION_ID": "STRING",
                "CUSTOMER_NAME": "STRING",
                "CUSTOMER_DOB": "DATE",
                "CUSTOMER_PHONE": "STRING",
                "LOAD_DATE": "DATE",
                "SOURCE": "STRING"
            }
        }
    }


# SQLServer


@fixture
def single_source_link_sqlserver(context):
    """
    Define the structures and metadata to load single-source links
    """

    set_metadata(context)

    context.seed_config = {
        "LINK": {
            "column_types": {
                "CUSTOMER_NATION_PK": "BINARY(16)",
                "CUSTOMER_FK": "BINARY(16)",
                "NATION_FK": "BINARY(16)",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR(50)"
            }
        },
        "LINK_AC": {
            "column_types": {
                "CUSTOMER_NATION_PK": "BINARY(16)",
                "CUSTOMER_FK": "BINARY(16)",
                "NATION_FK": "BINARY(16)",
                "CUSTOMER_MT_ID": "VARCHAR(50)",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR(50)"
            }
        },
        "RAW_STAGE": {
            "column_types": {
                "CUSTOMER_ID": "VARCHAR(50)",
                "NATION_ID": "VARCHAR(50)",
                "CUSTOMER_NAME": "VARCHAR(50)",
                "CUSTOMER_MT_ID": "VARCHAR(20)",
                "CUSTOMER_DOB": "DATE",
                "CUSTOMER_PHONE": "VARCHAR(50)",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR(50)"
            }
        }
    }


@fixture
def single_source_comp_pk_link_sqlserver(context):
    """
    Define the structures and metadata to load single-source links with composite PK
    """

    set_metadata(context)

    context.vault_structure_columns['LINK'] = {
        "src_pk": ["CUSTOMER_NATION_PK", "COMP_PK"],
        "src_fk": ["CUSTOMER_FK", "NATION_FK"],
        "src_ldts": "LOAD_DATE",
        "src_source": "SOURCE"
    }

    context.hashed_columns['STG_CUSTOMER'] = {
        "CUSTOMER_NATION_PK": ["CUSTOMER_ID", "NATION_ID"],
        "COMP_PK": "CUSTOMER_ID",
        "CUSTOMER_FK": "CUSTOMER_ID",
        "NATION_FK": "NATION_ID",
    }

    context.seed_config = {
        "LINK": {
            "column_types": {
                "CUSTOMER_NATION_PK": "BINARY(16)",
                "COMP_PK": "BINARY(16)",
                "CUSTOMER_FK": "BINARY(16)",
                "NATION_FK": "BINARY(16)",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR(10)"
            }
        },
        "RAW_STAGE": {
            "column_types": {
                "CUSTOMER_ID": "VARCHAR(50)",
                "NATION_ID": "VARCHAR(50)",
                "CUSTOMER_NAME": "VARCHAR(50)",
                "CUSTOMER_DOB": "DATE",
                "CUSTOMER_PHONE": "VARCHAR(50)",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR(10)"
            }
        }
    }


@fixture
def multi_source_link_sqlserver(context):
    """
    Define the structures and metadata to load single-source links
    """

    set_metadata(context)

    context.seed_config = {
        "LINK": {
            "column_types": {
                "CUSTOMER_NATION_PK": "BINARY(16)",
                "CUSTOMER_FK": "BINARY(16)",
                "NATION_FK": "BINARY(16)",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR(50)"
            }
        },
        "RAW_STAGE_SAP": {
            "column_types": {
                "CUSTOMER_ID": "VARCHAR(50)",
                "NATION_ID": "VARCHAR(50)",
                "CUSTOMER_NAME": "VARCHAR(50)",
                "CUSTOMER_DOB": "DATE",
                "CUSTOMER_PHONE": "VARCHAR(50)",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR(50)"
            }
        },
        "RAW_STAGE_CRM": {
            "column_types": {
                "CUSTOMER_ID": "VARCHAR(50)",
                "NATION_ID": "VARCHAR(50)",
                "CUSTOMER_NAME": "VARCHAR(50)",
                "CUSTOMER_DOB": "DATE",
                "CUSTOMER_PHONE": "VARCHAR(50)",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR(50)"
            }
        },
        "RAW_STAGE_WEB": {
            "column_types": {
                "CUSTOMER_ID": "VARCHAR(50)",
                "NATION_ID": "VARCHAR(50)",
                "CUSTOMER_NAME": "VARCHAR(50)",
                "CUSTOMER_DOB": "DATE",
                "CUSTOMER_PHONE": "VARCHAR(50)",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR(50)"
            }
        }
    }


# Databricks

@fixture
def single_source_link_databricks(context):
    """
    Define the structures and metadata to load single-source links
    """

    set_metadata(context)

    context.seed_config = {
        "LINK": {
            "column_types": {
                "CUSTOMER_NATION_PK": "VARCHAR(100)",
                "CUSTOMER_FK": "VARCHAR(100)",
                "NATION_FK": "VARCHAR(100)",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR(100)"
            }
        },
        "RAW_STAGE": {
            "column_types": {
                "CUSTOMER_ID": "VARCHAR(100)",
                "NATION_ID": "VARCHAR(100)",
                "CUSTOMER_NAME": "VARCHAR(100)",
                "CUSTOMER_DOB": "DATE",
                "CUSTOMER_PHONE": "VARCHAR(100)",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR(100)"
            }
        }
    }
