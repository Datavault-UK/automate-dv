from behave import fixture


@fixture
def sts2(context):
    """
    Define the structures and metadata to load Status Tracking Satellites (STS)
    """

    context.hashed_columns = {
        "STG_CUSTOMER": {
            "CUSTOMER_PK": "CUSTOMER_ID"
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
                "CUSTOMER_NAME": "VARCHAR",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR"
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


@fixture
def sts2_cycle(context):
    """
    Define the structures and metadata to perform load cycles for satellites
    """

    context.hashed_columns = {
        "STG_CUSTOMER": {
            "CUSTOMER_PK": "CUSTOMER_ID"
        }
    }

    context.stage_columns = {
        "RAW_STAGE":
            ["CUSTOMER_ID",
             "CUSTOMER_NAME",
             "LOAD_DATE",
             "SOURCE"]
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
                "CUSTOMER_NAME": "VARCHAR",
                "LOAD_DATE": "DATETIME",
                "SOURCE": "VARCHAR"
            }
        },
        "STS": {
            "column_types": {
                "CUSTOMER_PK": "BINARY(16)",
                "LOAD_DATE": "DATETIME",
                "SOURCE": "VARCHAR",
                "STATUS": "VARCHAR"
            }
        }
    }
