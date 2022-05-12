from behave import fixture


@fixture
def sts(context):
    """
    Define the structures and metadata to load Status Tracking Satellites (STS)
    """

    context.hashed_columns = {
        "STG_CUSTOMER": {
            "CUSTOMER_PK": "CUSTOMER_ID"
        }
    }

    context.derived_columns = {
        "STG_CUSTOMER": {
            "EFFECTIVE_FROM": "LOAD_DATE"
        }
    }

    context.vault_structure_columns = {
        "STS": {
            "src_pk": "CUSTOMER_PK",
            "src_status": "STATUS",
            "src_ldts": "LOAD_DATE",
            "src_source": "SOURCE"
        }
    }

    context.seed_config = {
        "RAW_STAGE": {
            "column_types": {
                "CUSTOMER_ID": "NUMBER(38, 0)",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR",
                "STATUS": "VARCHAR"
            }
        },
        "STS": {
            "column_types": {
                "CUSTOMER_PK": "BINARY(16)",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR",
                "STATUS": "VARCHAR"
            }
        }
    }
