from behave import fixture


def set_vault_structure_definition(context):
    context.vault_structure_columns = {
        "REF_TABLE": {
            "src_pk": "DATE_PK",
            "src_extra_columns": ["YEAR", "MONTH", "DAY", "DAY_OF_WEEK"],
            "src_ldts": "LOAD_DATE",
            "src_source": "SOURCE"
        },
        "REF_TABLE_NO_AUDIT": {
            "src_pk": "DATE_PK",
            "src_extra_columns": ["YEAR", "MONTH", "DAY", "DAY_OF_WEEK"]
        }
    }


def set_metadata(context):
    set_vault_structure_definition(context)


# Snowflake

@fixture
def single_source_ref_table_snowflake(context):
    """
    Define the structures and metadata to load single-source reference tables
    """

    set_metadata(context)

    context.seed_config = {
        "REF_TABLE": {
            "column_types": {
                "DATE_PK": "DATE",
                "YEAR": "VARCHAR",
                "MONTH": "VARCHAR",
                "DAY": "VARCHAR",
                "DAY_OF_WEEK": "VARCHAR",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR"
            }
        },
        "REF_TABLE_NO_AUDIT": {
            "column_types": {
                "DATE_PK": "DATE",
                "YEAR": "VARCHAR",
                "MONTH": "VARCHAR",
                "DAY": "VARCHAR",
                "DAY_OF_WEEK": "VARCHAR"
            }
        },
        "RAW_REF_TABLE": {
            "column_types": {
                "DATE_PK": "DATE",
                "YEAR": "VARCHAR",
                "MONTH": "VARCHAR",
                "DAY": "VARCHAR",
                "DAY_OF_WEEK": "VARCHAR",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR"
            }
        }
    }


# BigQuery

@fixture
def single_source_ref_table_bigquery(context):
    """
    Define the structures and metadata to load single-source reference tables
    """

    set_metadata(context)

    context.seed_config = {
        "REF_TABLE": {
            "column_types": {
                "DATE_PK": "DATE",
                "YEAR": "STRING",
                "MONTH": "STRING",
                "DAY": "STRING",
                "DAY_OF_WEEK": "STRING",
                "LOAD_DATE": "DATE",
                "SOURCE": "STRING"
            }
        },
        "REF_TABLE_NO_AUDIT": {
            "column_types": {
                "DATE_PK": "DATE",
                "YEAR": "STRING",
                "MONTH": "STRING",
                "DAY": "STRING",
                "DAY_OF_WEEK": "STRING"
            }
        },
        "RAW_REF_TABLE": {
            "column_types": {
                "DATE_PK": "DATE",
                "YEAR": "STRING",
                "MONTH": "STRING",
                "DAY": "STRING",
                "DAY_OF_WEEK": "STRING",
                "LOAD_DATE": "DATE",
                "SOURCE": "STRING"
            }
        }
    }


# SQLServer

@fixture
def single_source_ref_table_sqlserver(context):
    """
    Define the structures and metadata to load single-source reference tables
    """

    set_metadata(context)

    context.seed_config = {
        "REF_TABLE": {
            "column_types": {
                "DATE_PK": "DATE",
                "YEAR": "VARCHAR(4)",
                "MONTH": "VARCHAR(2)",
                "DAY": "VARCHAR(10)",
                "DAY_OF_WEEK": "VARCHAR(10)",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR(3)"
            }
        },
        "REF_TABLE_NO_AUDIT": {
            "column_types": {
                "DATE_PK": "DATE",
                "YEAR": "VARCHAR(4)",
                "MONTH": "VARCHAR(2)",
                "DAY": "VARCHAR(10)",
                "DAY_OF_WEEK": "VARCHAR(10)",
            }
        },
        "RAW_REF_TABLE": {
            "column_types": {
                "DATE_PK": "DATE",
                "YEAR": "VARCHAR(4)",
                "MONTH": "VARCHAR(2)",
                "DAY": "VARCHAR(10)",
                "DAY_OF_WEEK": "VARCHAR(10)",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR(3)"
            }
        }
    }


# Databricks

@fixture
def single_source_ref_table_databricks(context):
    """
    Define the structures and metadata to load single-source reference tables
    """

    set_metadata(context)

    context.seed_config = {
        "REF_TABLE": {
            "column_types": {
                "DATE_PK": "DATE",
                "YEAR": "STRING",
                "MONTH": "STRING",
                "DAY": "STRING",
                "DAY_OF_WEEK": "STRING",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR(100)"
            }
        },
        "REF_TABLE_NO_AUDIT": {
            "column_types": {
                "DATE_PK": "DATE",
                "YEAR": "STRING",
                "MONTH": "STRING",
                "DAY": "STRING",
                "DAY_OF_WEEK": "STRING",
            }
        },
        "RAW_REF_TABLE": {
            "column_types": {
                "DATE_PK": "DATE",
                "YEAR": "STRING",
                "MONTH": "STRING",
                "DAY": "STRING",
                "DAY_OF_WEEK": "STRING",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR(100)"
            }
        }
    }


# Postgres

@fixture
def single_source_ref_table_postgres(context):
    """
    Define the structures and metadata to load single-source reference tables
    """

    set_metadata(context)

    context.seed_config = {
        "REF_TABLE": {
            "column_types": {
                "DATE_PK": "DATE",
                "YEAR": "VARCHAR",
                "MONTH": "VARCHAR",
                "DAY": "VARCHAR",
                "DAY_OF_WEEK": "VARCHAR",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR"
            }
        },
        "REF_TABLE_NO_AUDIT": {
            "column_types": {
                "DATE_PK": "DATE",
                "YEAR": "VARCHAR",
                "MONTH": "VARCHAR",
                "DAY": "VARCHAR",
                "DAY_OF_WEEK": "VARCHAR"
            }
        },
        "RAW_REF_TABLE": {
            "column_types": {
                "DATE_PK": "DATE",
                "YEAR": "VARCHAR",
                "MONTH": "VARCHAR",
                "DAY": "VARCHAR",
                "DAY_OF_WEEK": "VARCHAR",
                "LOAD_DATE": "DATE",
                "SOURCE": "VARCHAR"
            }
        }
    }
