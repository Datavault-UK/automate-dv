from behave import fixture


@fixture
def sts_snowflake(context):
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

# SQLServer

@fixture
def sts_sqlserver(context):
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
                "CUSTOMER_ID": "DECIMAL(38, 0)",
                "CUSTOMER_NAME": "VARCHAR(10)",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR(10)"
            }
        },
        "STS": {
            "column_types": {
                "CUSTOMER_PK": "BINARY(16)",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR(10",
                "STATUS": "VARCHAR(10"
            }
        }
    }

# BigQuery

@fixture
def sts_bigquery(context):
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
                "CUSTOMER_ID": "STRING",
                "CUSTOMER_NAME": "STRING",
                "LOAD_DATE": "DATE",
                "SOURCE": "STRING"
            }
        },
        "STS": {
            "column_types": {
                "CUSTOMER_PK": "STRING",
                "LOAD_DATE": "DATE",
                "SOURCE": "STRING",
                "STATUS": "STRING"
            }
        }
    }
