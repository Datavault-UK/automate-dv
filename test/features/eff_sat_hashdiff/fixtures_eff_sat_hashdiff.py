from behave import fixture


@fixture
def eff_satellite_hashdiff(context):
    """
    Define the structures and metadata to load effectivity satellites
    """

    context.hashed_columns = {
        "STG_CUSTOMER": {
            "CUSTOMER_ORDER_PK": ["CUSTOMER_ID", "ORDER_ID"],
            "CUSTOMER_PK": "CUSTOMER_ID",
            "ORDER_PK": "ORDER_ID",
            "HASHDIFF": ["CUSTOMER_ID", "ORDER_ID", "STATUS", "EFFECTIVE_FROM"]
        }
    }

    context.vault_structure_columns = {
        "EFF_SAT": {
            "src_pk": "CUSTOMER_ORDER_PK",
            "src_dfk": ["ORDER_PK"],
            "src_sfk": "CUSTOMER_PK",
            "status": "STATUS",
            "src_eff": "EFFECTIVE_FROM",
            "src_ldts": "LOAD_DATE",
            "src_source": "SOURCE"
        }
    }

    context.seed_config = {
        "RAW_STAGE": {
            "+column_types": {
                "CUSTOMER_ID": "NUMBER(38, 0)",
                "ORDER_ID": "VARCHAR",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR",
                "STATUS": "BOOLEAN"
            }
        },
        "EFF_SAT": {
            "+column_types": {
                "CUSTOMER_ORDER_PK": "BINARY(16)",
                "CUSTOMER_PK": "BINARY(16)",
                "ORDER_PK": "BINARY(16)",
                "STATUS": "BOOLEAN",
                "EFFECTIVE_FROM": "DATE",
                "HASHDIFF": "BINARY(16)",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR"
            }
        }
    }


