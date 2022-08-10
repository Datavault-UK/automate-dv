from behave import fixture


def set_vault_structure_definition(context):
    context.vault_structure_columns = {
        "T_LINK": {
            "src_pk": "TRANSACTION_PK",
            "src_fk": ["CUSTOMER_FK", "ORDER_FK"],
            "src_payload": ["TRANSACTION_NUMBER", "TRANSACTION_DATE",
                            "TYPE", "AMOUNT"],
            "src_eff": "EFFECTIVE_FROM",
            "src_ldts": "LOAD_DATE",
            "src_source": "SOURCE"
        },
        "T_LINK_AC": {
            "src_pk": "TRANSACTION_PK",
            "src_fk": ["CUSTOMER_FK", "ORDER_FK"],
            "src_payload": ["TRANSACTION_NUMBER", "TRANSACTION_DATE",
                            "TYPE", "AMOUNT"],
            "src_extra_columns": "CUSTOMER_MT_ID",
            "src_eff": "EFFECTIVE_FROM",
            "src_ldts": "LOAD_DATE",
            "src_source": "SOURCE"
        },
        "T_LINK_COMP_PK": {
            "src_pk": "TRANSACTION_PK",
            "src_fk": ["CUSTOMER_FK", "ORDER_FK"],
            "src_payload": ["TRANSACTION_NUMBER", "TRANSACTION_DATE",
                            "TYPE", "AMOUNT"],
            "src_eff": "EFFECTIVE_FROM",
            "src_ldts": "LOAD_DATE",
            "src_source": "SOURCE"
        }
    }


def set_staging_definition(context):
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


def set_metadata(context):
    set_vault_structure_definition(context)

    set_staging_definition(context)


@fixture
def t_link_snowflake(context):
    """
    Define the structures and metadata to load transactional links
    """

    set_metadata(context)

    context.seed_config = {
        "RAW_STAGE": {
            "column_types": {
                "CUSTOMER_ID": "VARCHAR",
                "ORDER_ID": "VARCHAR",
                "TRANSACTION_NUMBER": "NUMBER(38,0)",
                "TRANSACTION_DATE": "DATE",
                "TYPE": "VARCHAR",
                "AMOUNT": "NUMBER(38,2)",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR"
            }
        },
        "T_LINK": {
            "column_types": {
                "TRANSACTION_PK": "BINARY(16)",
                "CUSTOMER_FK": "BINARY(16)",
                "ORDER_FK": "BINARY(16)",
                "TRANSACTION_NUMBER": "NUMBER(38,0)",
                "TRANSACTION_DATE": "DATE",
                "TYPE": "VARCHAR",
                "AMOUNT": "NUMBER(38,2)",
                "EFFECTIVE_FROM": "DATE",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR"
            }
        },
        "T_LINK_AC": {
            "column_types": {
                "TRANSACTION_PK": "BINARY(16)",
                "CUSTOMER_FK": "BINARY(16)",
                "ORDER_FK": "BINARY(16)",
                "TRANSACTION_NUMBER": "NUMBER(38,0)",
                "TRANSACTION_DATE": "DATE",
                "TYPE": "VARCHAR",
                "AMOUNT": "NUMBER(38,2)",
                "CUSTOMER_MT_ID": "VARCHAR",
                "EFFECTIVE_FROM": "DATE",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR"
            }
        }
    }


@fixture
def t_link_bigquery(context):
    """
    Define the structures and metadata to load transactional links
    """

    set_metadata(context)

    context.seed_config = {
        "RAW_STAGE": {
            "column_types": {
                "CUSTOMER_ID": "STRING",
                "ORDER_ID": "STRING",
                "TRANSACTION_NUMBER": "STRING",
                "TRANSACTION_DATE": "DATE",
                "TYPE": "STRING",
                "AMOUNT": "STRING",
                "LOAD_DATE": "DATE",
                "SOURCE": "STRING"
            }
        },
        "T_LINK": {
            "column_types": {
                "TRANSACTION_PK": "STRING",
                "CUSTOMER_FK": "STRING",
                "ORDER_FK": "STRING",
                "TRANSACTION_NUMBER": "STRING",
                "TRANSACTION_DATE": "DATE",
                "TYPE": "STRING",
                "AMOUNT": "STRING",
                "EFFECTIVE_FROM": "DATE",
                "LOAD_DATE": "DATE",
                "SOURCE": "STRING"
            }
        },
        "T_LINK_AC": {
            "column_types": {
                "TRANSACTION_PK": "STRING",
                "CUSTOMER_FK": "STRING",
                "ORDER_FK": "STRING",
                "TRANSACTION_NUMBER": "STRING",
                "TRANSACTION_DATE": "DATE",
                "TYPE": "STRING",
                "AMOUNT": "STRING",
                "CUSTOMER_MT_ID": "STRING",
                "EFFECTIVE_FROM": "DATE",
                "LOAD_DATE": "DATE",
                "SOURCE": "STRING"
            }
        },
        "T_LINK_COMP_PK": {
            "column_types": {
                "TRANSACTION_PK": "STRING",
                "CUSTOMER_FK": "STRING",
                "ORDER_FK": "STRING",
                "TRANSACTION_NUMBER": "STRING",
                "TRANSACTION_DATE": "DATE",
                "TYPE": "STRING",
                "AMOUNT": "STRING",
                "EFFECTIVE_FROM": "DATE",
                "LOAD_DATE": "DATE",
                "SOURCE": "STRING"
            }
        }
    }


@fixture
def t_link_sqlserver(context):
    """
    Define the structures and metadata to load transactional links
    """

    set_metadata(context)

    context.seed_config = {
        "RAW_STAGE": {
            "column_types": {
                "CUSTOMER_ID": "VARCHAR(50)",
                "ORDER_ID": "VARCHAR(50)",
                "TRANSACTION_NUMBER": "DECIMAL(38,0)",
                "TRANSACTION_DATE": "DATE",
                "CUSTOMER_MT_ID": "VARCHAR(13)",
                "TYPE": "VARCHAR(50)",
                "AMOUNT": "DECIMAL(38,2)",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR(50)"
            }
        },
        "T_LINK": {
            "column_types": {
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
        },
        "T_LINK_AC": {
            "column_types": {
                "TRANSACTION_PK": "BINARY(16)",
                "CUSTOMER_FK": "BINARY(16)",
                "ORDER_FK": "BINARY(16)",
                "TRANSACTION_NUMBER": "VARCHAR(50)",
                "TRANSACTION_DATE": "DATE",
                "TYPE": "VARCHAR(50)",
                "AMOUNT": "VARCHAR(50)",
                "CUSTOMER_MT_ID": "VARCHAR(13)",
                "EFFECTIVE_FROM": "DATE",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR(50)"
            }
        }
    }


@fixture
def t_link_comp_pk(context):
    """
    Define the structures and metadata to load transactional links with composite src_pk
    """

    set_metadata(context)

    context.seed_config = {
        "RAW_STAGE": {
            "column_types": {
                "CUSTOMER_ID": "VARCHAR",
                "ORDER_ID": "VARCHAR",
                "TRANSACTION_NUMBER": "NUMBER(38,0)",
                "TRANSACTION_DATE": "DATE",
                "TYPE": "VARCHAR",
                "AMOUNT": "NUMBER(38,2)",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR"
            }
        },
        "T_LINK_COMP_PK": {
            "column_types": {
                "TRANSACTION_PK": "BINARY(16)",
                "TRANSACTION_NUMBER": "NUMBER(38,0)",
                "CUSTOMER_FK": "BINARY(16)",
                "ORDER_FK": "BINARY(16)",
                "TRANSACTION_DATE": "DATE",
                "TYPE": "VARCHAR",
                "AMOUNT": "NUMBER(38,2)",
                "EFFECTIVE_FROM": "DATE",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR"
            }
        }
    }


@fixture
def t_link_comp_pk_bigquery(context):
    """
    Define the structures and metadata to load transactional links with composite src_pk
    """

    set_metadata(context)

    context.seed_config = {
        "RAW_STAGE": {
            "column_types": {
                "CUSTOMER_ID": "STRING",
                "ORDER_ID": "STRING",
                "TRANSACTION_NUMBER": "STRING",
                "TRANSACTION_DATE": "DATE",
                "TYPE": "STRING",
                "AMOUNT": "STRING",
                "LOAD_DATE": "DATE",
                "SOURCE": "STRING"
            }
        },
        "T_LINK_COMP_PK": {
            "column_types": {
                "TRANSACTION_PK": "STRING",
                "TRANSACTION_NUMBER": "STRING",
                "CUSTOMER_FK": "STRING",
                "ORDER_FK": "STRING",
                "TRANSACTION_DATE": "DATE",
                "TYPE": "STRING",
                "AMOUNT": "STRING",
                "EFFECTIVE_FROM": "DATE",
                "LOAD_DATE": "DATE",
                "SOURCE": "STRING"
            }
        }
    }


@fixture
def t_link_comp_pk_sqlserver(context):
    """
    Define the structures and metadata to load transactional links with composite src_pk
    """

    set_metadata(context)

    context.seed_config = {
        "RAW_STAGE": {
            "column_types": {
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
        "T_LINK_COMP_PK": {
            "column_types": {
                "TRANSACTION_PK": "BINARY(16)",
                "TRANSACTION_NUMBER": "DECIMAL(38,0)",
                "CUSTOMER_FK": "BINARY(16)",
                "ORDER_FK": "BINARY(16)",
                "TRANSACTION_DATE": "DATE",
                "TYPE": "VARCHAR(50)",
                "AMOUNT": "DECIMAL(38,2)",
                "EFFECTIVE_FROM": "DATE",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR(50)"
            }
        }
    }
