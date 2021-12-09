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
def single_source_comppk_link(context):
    """
    Define the structures and metadata to load single-source links with composite PK
    """

    context.hashed_columns = {
        "STG_CUSTOMER": {
            "CUSTOMER_NATION_PK": ["CUSTOMER_ID", "NATION_ID"],
            "COMP_PK": "CUSTOMER_ID",
            "CUSTOMER_FK": "CUSTOMER_ID",
            "NATION_FK": "NATION_ID"
        }
    }

    context.vault_structure_columns = {
        "LINK": {
            "src_pk": ["CUSTOMER_NATION_PK", "COMP_PK"],
            "src_fk": ["CUSTOMER_FK", "NATION_FK"],
            "src_ldts": "LOAD_DATE",
            "src_source": "SOURCE"
        }
    }

    context.seed_config = {
        "LINK": {
            "+column_types": {
                "CUSTOMER_NATION_PK": "BINARY(16)",
                "COMP_PK": "BINARY(16)",
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
def single_source_link_bigquery(context):
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
                "CUSTOMER_NATION_PK": "STRING",
                "CUSTOMER_FK": "STRING",
                "NATION_FK": "STRING",
                "LOAD_DATE": "DATE",
                "SOURCE": "STRING"
            }
        },
        "RAW_STAGE": {
            "+column_types": {
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
                "CUSTOMER_NATION_PK": "STRING",
                "CUSTOMER_FK": "STRING",
                "NATION_FK": "STRING",
                "LOAD_DATE": "DATE",
                "SOURCE": "STRING"
            }
        },
        "RAW_STAGE_SAP": {
            "+column_types": {
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
            "+column_types": {
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
            "+column_types": {
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
def single_source_comppk_link_bigquery(context):
    """
    Define the structures and metadata to load single-source links with composite PK
    """

    context.hashed_columns = {
        "STG_CUSTOMER": {
            "CUSTOMER_NATION_PK": ["CUSTOMER_ID", "NATION_ID"],
            "COMP_PK": "CUSTOMER_ID",
            "CUSTOMER_FK": "CUSTOMER_ID",
            "NATION_FK": "NATION_ID"
        }
    }

    context.vault_structure_columns = {
        "LINK": {
            "src_pk": ["CUSTOMER_NATION_PK", "COMP_PK"],
            "src_fk": ["CUSTOMER_FK", "NATION_FK"],
            "src_ldts": "LOAD_DATE",
            "src_source": "SOURCE"
        }
    }

    context.seed_config = {
        "LINK": {
            "+column_types": {
                "CUSTOMER_NATION_PK": "BINARY(16)",
                "COMP_PK": "BINARY(16)",
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
def single_source_link_sqlserver(context):
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
                "SOURCE": "VARCHAR(50)"
            }
        },
        "RAW_STAGE": {
            "+column_types": {
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


@fixture
def multi_source_link_sqlserver(context):
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
                "SOURCE": "VARCHAR(50)"
            }
        },
        "RAW_STAGE_SAP": {
            "+column_types": {
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
            "+column_types": {
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
            "+column_types": {
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


@fixture
def single_source_comppk_link_sqlserver(context):
    """
    Define the structures and metadata to load single-source links with composite PK
    """

    context.hashed_columns = {
        "STG_CUSTOMER": {
            "CUSTOMER_NATION_PK": ["CUSTOMER_ID", "NATION_ID"],
            "COMP_PK": "CUSTOMER_ID",
            "CUSTOMER_FK": "CUSTOMER_ID",
            "NATION_FK": "NATION_ID"
        }
    }

    context.vault_structure_columns = {
        "LINK": {
            "src_pk": ["CUSTOMER_NATION_PK", "COMP_PK"],
            "src_fk": ["CUSTOMER_FK", "NATION_FK"],
            "src_ldts": "LOAD_DATE",
            "src_source": "SOURCE"
        }
    }

    context.seed_config = {
        "LINK": {
            "+column_types": {
                "CUSTOMER_NATION_PK": "BINARY(16)",
                "COMP_PK": "BINARY(16)",
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


