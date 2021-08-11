from behave import fixture


@fixture
def single_source_link(context):
    """
    Define the structures and metadata to load single-source links
    """

    context.hashed_columns = {
        "STG_CUSTOMER": {
            "CUSTOMER_NATION_PK": ["CUSTOMER_ID", "NATION_ID"],
            "CUSTOMER_FK": "CUSTOMER_ID",
            "NATION_FK": "NATION_ID"
        }
    }

    context.vault_structure_columns = {
        "LINK": {
            "src_pk": "CUSTOMER_NATION_PK",
            "src_fk": ["CUSTOMER_FK", "NATION_FK"],
            "src_ldts": "LOAD_DATE",
            "src_source": "SOURCE"
        }
    }

    context.seed_config = {
        "LINK": {
            "+column_types": {
                "CUSTOMER_NATION_PK": "BINARY(16)",
                "CUSTOMER_FK": "BINARY(16)",
                "NATION_FK": "BINARY(16)",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR"
            }
        },
        "RAW_STAGE": {
            "+column_types": {
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
def multi_source_link(context):
    """
    Define the structures and metadata to load single-source links
    """

    context.hashed_columns = {
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

    context.vault_structure_columns = {
        "LINK": {
            "src_pk": "CUSTOMER_NATION_PK",
            "src_fk": ["CUSTOMER_FK", "NATION_FK"],
            "src_ldts": "LOAD_DATE",
            "src_source": "SOURCE"
        }
    }

    context.seed_config = {
        "LINK": {
            "+column_types": {
                "CUSTOMER_NATION_PK": "BINARY(16)",
                "CUSTOMER_FK": "BINARY(16)",
                "NATION_FK": "BINARY(16)",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR"
            }
        },
        "RAW_STAGE_SAP": {
            "+column_types": {
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
            "+column_types": {
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
            "+column_types": {
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
def t_link(context):
    """
    Define the structures and metadata to load transactional links
    """

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

    context.vault_structure_columns = {
        "T_LINK": {
            "src_pk": "TRANSACTION_PK",
            "src_fk": ["CUSTOMER_FK", "ORDER_FK"],
            "src_payload": ["TRANSACTION_NUMBER", "TRANSACTION_DATE",
                            "TYPE", "AMOUNT"],
            "src_eff": "EFFECTIVE_FROM",
            "src_ldts": "LOAD_DATE",
            "src_source": "SOURCE"
        }
    }

    context.seed_config = {
        "RAW_STAGE": {
            "+column_types": {
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
            "+column_types": {
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
        }
    }
