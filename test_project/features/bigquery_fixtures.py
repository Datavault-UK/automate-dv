from behave import fixture

from test_project.test_utils.dbt_test_utils import *
@fixture
def t_link_bigquery(context):
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
                "CUSTOMER_ID": "STRING",
                "ORDER_ID": "STRING",
                "TRANSACTION_NUMBER": "NUMERIC",
                "TRANSACTION_DATE": "DATE",
                "TYPE": "STRING",
                "AMOUNT": "NUMERIC",
                "LOAD_DATE": "DATE",
                "SOURCE": "STRING"
            }
        },
        "T_LINK": {
            "+column_types": {
                "TRANSACTION_PK": "STRING",
                "CUSTOMER_FK": "STRING",
                "ORDER_FK": "STRING",
                "TRANSACTION_NUMBER": "NUMERIC",
                "TRANSACTION_DATE": "DATE",
                "TYPE": "STRING",
                "AMOUNT": "NUMERIC",
                "EFFECTIVE_FROM": "DATE",
                "LOAD_DATE": "DATE",
                "SOURCE": "STRING"
            }
        }
    }
