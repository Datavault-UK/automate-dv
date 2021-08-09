from behave import fixture


@fixture
def staging(context):
    """
    Define the structures and metadata to load a hashed staging layer
    """

    context.seed_config = {

        "STG_CUSTOMER": {
            "+column_types": {
                "CUSTOMER_ID": "VARCHAR",
                "CUSTOMER_NAME": "VARCHAR",
                "CUSTOMER_DOB": "VARCHAR",
                "CUSTOMER_PHONE": "VARCHAR",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR",
                "CUSTOMER_PK": "BINARY(16)",
                "HASHDIFF": "BINARY(16)",
                "EFFECTIVE_FROM": "DATE"
            }
        },
        "RAW_STAGE": {
            "+column_types": {
                "CUSTOMER_ID": "VARCHAR",
                "CUSTOMER_NAME": "VARCHAR",
                "CUSTOMER_DOB": "VARCHAR",
                "CUSTOMER_PHONE": "VARCHAR",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR"
            }
        }
    }
