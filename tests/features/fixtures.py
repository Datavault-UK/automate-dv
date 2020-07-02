from behave import fixture

from tests.test_utils.dbt_test_utils import *


@fixture
def set_workdir(context):
    """
    Set the working (run) dir for dbt
    """

    os.chdir(TESTS_DBT_ROOT)


@fixture
def single_source_hub(context):
    """
    Define the structures and metadata to load single-source hubs
    """

    context.hash_mapping_config = {
        'RAW_STAGE': {
            'CUSTOMER_PK': 'CUSTOMER_ID'
        }
    }

    context.vault_structure_columns = {
        'src_pk': 'CUSTOMER_PK',
        'src_nk': 'CUSTOMER_ID',
        'src_ldts': 'LOADDATE',
        'src_source': 'SOURCE'
    }

    context.seed_config = {
        'HUB': {
            'column_types': {
                'CUSTOMER_PK': 'BINARY(16)',
                'CUSTOMER_ID': 'VARCHAR',
                'LOADDATE': 'DATE',
                'SOURCE': 'VARCHAR'
            }
        }
    }


@fixture
def multi_source_hub(context):
    """
    Define the structures and metadata to load multi-source hubs
    """

    context.hash_mapping_config = {
        'RAW_STAGE_PARTS': {
            'PART_PK': 'PART_ID'
        },
        'RAW_STAGE_SUPPLIER': {
            'PART_PK': 'PART_ID',
            'SUPPLIER_PK': 'SUPPLIER_ID'
        },
        'RAW_STAGE_LINEITEM': {
            'PART_PK': 'PART_ID',
            'SUPPLIER_PK': 'SUPPLIER_ID',
            'ORDER_PK': 'ORDER_ID'
        }
    }

    context.vault_structure_columns = {
        'src_pk': 'PART_PK',
        'src_nk': 'PART_ID',
        'src_ldts': 'LOADDATE',
        'src_source': 'SOURCE'
    }

    context.seed_config = {
        'HUB': {
            'column_types': {
                'PART_PK': 'BINARY(16)',
                'PART_ID': 'VARCHAR',
                'LOADDATE': 'DATE',
                'SOURCE': 'VARCHAR'
            }
        }
    }


@fixture
def single_source_link(context):
    """
    Define the structures and metadata to load single-source links
    """

    context.hash_mapping_config = {
        'RAW_STAGE': {
            'CUSTOMER_NATION_PK': ['CUSTOMER_ID', 'NATION_ID'],
            'CUSTOMER_FK': 'CUSTOMER_ID',
            'NATION_FK': 'NATION_ID'
        }
    }

    context.vault_structure_columns = {
        'src_pk': 'CUSTOMER_NATION_PK',
        'src_fk': ['CUSTOMER_FK', 'NATION_FK'],
        'src_ldts': 'LOADDATE',
        'src_source': 'SOURCE'
    }

    context.seed_config = {
        'LINK': {
            'column_types': {
                'CUSTOMER_NATION_PK': 'BINARY(16)',
                'CUSTOMER_FK': 'BINARY(16)',
                'NATION_FK': 'BINARY(16)',
                'LOADDATE': 'DATE',
                'SOURCE': 'VARCHAR'
            }
        }
    }


@fixture
def multi_source_link(context):
    """
    Define the structures and metadata to load single-source links
    """

    context.hash_mapping_config = {
        'RAW_STAGE_SAP': {
            'CUSTOMER_NATION_PK': ['CUSTOMER_ID', 'NATION_ID'],
            'CUSTOMER_FK': 'CUSTOMER_ID',
            'NATION_FK': 'NATION_ID'
        },
        'RAW_STAGE_CRM': {
            'CUSTOMER_NATION_PK': ['CUSTOMER_ID', 'NATION_ID'],
            'CUSTOMER_FK': 'CUSTOMER_ID',
            'NATION_FK': 'NATION_ID'
        },
        'RAW_STAGE_WEB': {
            'CUSTOMER_NATION_PK': ['CUSTOMER_ID', 'NATION_ID'],
            'CUSTOMER_FK': 'CUSTOMER_ID',
            'NATION_FK': 'NATION_ID'
        },
    }

    context.vault_structure_columns = {
        'src_pk': 'CUSTOMER_NATION_PK',
        'src_fk': ['CUSTOMER_FK', 'NATION_FK'],
        'src_ldts': 'LOADDATE',
        'src_source': 'SOURCE'
    }

    context.seed_config = {
        'LINK': {
            'column_types': {
                'CUSTOMER_NATION_PK': 'BINARY(16)',
                'CUSTOMER_FK': 'BINARY(16)',
                'NATION_FK': 'BINARY(16)',
                'LOADDATE': 'DATE',
                'SOURCE': 'VARCHAR'
            }
        }
    }


@fixture
def satellite(context):
    """
    Define the structures and metadata to load satellites
    """

    context.hash_mapping_config = {
        'RAW_STAGE': {
            'CUSTOMER_PK': 'CUSTOMER_ID',
            'HASHDIFF': {'is_hashdiff': True, 'columns': ['CUSTOMER_DOB', 'CUSTOMER_PHONE', 'CUSTOMER_NAME']}
        }
    }

    context.derived_mapping = {
        'EFFECTIVE_FROM': 'LOADDATE'
    }

    context.vault_structure_columns = {
        'src_pk': 'CUSTOMER_PK',
        'src_payload': ['CUSTOMER_NAME', 'CUSTOMER_PHONE', 'CUSTOMER_DOB'],
        'src_hashdiff': 'HASHDIFF',
        'src_eff': 'EFFECTIVE_FROM',
        'src_ldts': 'LOADDATE',
        'src_source': 'SOURCE'
    }

    context.seed_config = {
        'RAW_STAGE': {
            'column_types': {
                'CUSTOMER_ID': 'NUMBER(38, 0)',
                'CUSTOMER_NAME': 'VARCHAR',
                'CUSTOMER_PHONE': 'VARCHAR',
                'CUSTOMER_DOB': 'DATE',
                'LOADDATE': 'DATE',
                'SOURCE': 'VARCHAR'
            }
        },
        'SATELLITE': {
            'column_types': {
                'CUSTOMER_PK': 'BINARY(16)',
                'CUSTOMER_NAME': 'VARCHAR',
                'CUSTOMER_PHONE': 'VARCHAR',
                'CUSTOMER_DOB': 'DATE',
                'HASHDIFF': 'BINARY(16)',
                'EFFECTIVE_FROM': 'DATE',
                'LOADDATE': 'DATE',
                'SOURCE': 'VARCHAR'
            }
        }
    }


@fixture
def satellite_cycle(context):
    """
    Define the structures and metadata to perform load cycles for satellites
    """

    context.hash_mapping_config = {
        'RAW_STAGE':
            {'CUSTOMER_PK': 'CUSTOMER_ID',
             'HASHDIFF': {'is_hashdiff': True,
                          'columns': ['CUSTOMER_DOB', 'CUSTOMER_ID', 'CUSTOMER_NAME']
                          }
             }
    }

    context.derived_mapping = {
        'EFFECTIVE_FROM': 'LOADDATE'
    }

    context.stage_columns = {
        'RAW_STAGE':
            ['CUSTOMER_ID',
             'CUSTOMER_NAME',
             'CUSTOMER_DOB',
             'EFFECTIVE_FROM',
             'LOADDATE',
             'SOURCE']
    }

    context.vault_structure_columns = {
        'src_pk': 'CUSTOMER_PK',
        'src_payload': ['CUSTOMER_NAME', 'CUSTOMER_DOB'],
        'src_hashdiff': 'HASHDIFF',
        'src_eff': 'EFFECTIVE_FROM',
        'src_ldts': 'LOADDATE',
        'src_source': 'SOURCE'
    }

    context.seed_config = {
        'RAW_STAGE': {
            'column_types': {
                'CUSTOMER_ID': 'VARCHAR',
                'CUSTOMER_NAME': 'VARCHAR',
                'CUSTOMER_DOB': 'DATE',
                'EFFECTIVE_FROM': 'DATE',
                'LOADDATE': 'DATE',
                'SOURCE': 'VARCHAR'
            }
        },
        'SATELLITE': {
            'column_types': {
                'CUSTOMER_PK': 'BINARY(16)',
                'CUSTOMER_NAME': 'VARCHAR',
                'CUSTOMER_DOB': 'DATE',
                'HASHDIFF': 'BINARY(16)',
                'EFFECTIVE_FROM': 'DATE',
                'LOADDATE': 'DATE',
                'SOURCE': 'VARCHAR'
            }
        }
    }


@fixture
def t_link(context):
    """
    Define the structures and metadata to perform load cycles for transactional links
    """

    context.hash_mapping_config = {
        'RAW_STAGE': {
            'TRANSACTION_PK': ['CUSTOMER_ID', 'TRANSACTION_NUMBER'],
            'CUSTOMER_FK': 'CUSTOMER_ID'
        }
    }

    context.derived_mapping = {
        'EFFECTIVE_FROM': 'LOADDATE'
    }

    context.vault_structure_columns = {
        'src_pk': 'TRANSACTION_PK',
        'src_fk': 'CUSTOMER_FK',
        'src_payload': ['TRANSACTION_NUMBER', 'TRANSACTION_DATE',
                        'TYPE', 'AMOUNT'],
        'src_eff': 'EFFECTIVE_FROM',
        'src_ldts': 'LOADDATE',
        'src_source': 'SOURCE'
    }

    context.seed_config = {
        'RAW_STAGE': {
            'column_types': {
                'CUSTOMER_ID': 'VARCHAR',
                'TRANSACTION_NUMBER': 'NUMBER(38,0)',
                'TRANSACTION_DATE': 'DATE',
                'TYPE': 'VARCHAR',
                'AMOUNT': 'NUMBER(38,2)',
                'LOADDATE': 'DATE',
                'SOURCE': 'VARCHAR'
            }
        },
        'T_LINK': {
            'column_types': {
                'TRANSACTION_PK': 'BINARY(16)',
                'CUSTOMER_FK': 'BINARY(16)',
                'TRANSACTION_NUMBER': 'NUMBER(38,0)',
                'TRANSACTION_DATE': 'DATE',
                'TYPE': 'VARCHAR',
                'AMOUNT': 'NUMBER(38,2)',
                'EFFECTIVE_FROM': 'DATE',
                'LOADDATE': 'DATE',
                'SOURCE': 'VARCHAR'
            }
        }
    }


@fixture
def cycle(context):
    """
    Define the structures and metadata to perform vault load cycles
    """

    context.hash_mapping_config = {
        'RAW_STAGE_CUSTOMER': {
            'CUSTOMER_PK': 'CUSTOMER_ID',
            'HASHDIFF': {'is_hashdiff': True,
                         'columns': ['CUSTOMER_DOB', 'CUSTOMER_ID', 'CUSTOMER_NAME']
                         }
        },
        'RAW_STAGE_BOOKING': {
            'CUSTOMER_PK': 'CUSTOMER_ID',
            'BOOKING_PK': 'BOOKING_ID',
            'CUSTOMER_BOOKING_PK': ['CUSTOMER_ID', 'BOOKING_ID'],
            'HASHDIFF': {'is_hashdiff': True,
                         'columns': ['BOOKING_DATE',
                                     'PRICE',
                                     'DEPARTURE_DATE',
                                     'DESTINATION']
                         }
        }
    }

    context.derived_mapping = {
        'EFFECTIVE_FROM': 'LOADDATE'
    }

    context.vault_structure_columns = {
        'HUB_CUSTOMER': {
            'source_model': ['raw_stage_customer_hashed',
                             'raw_stage_booking_hashed'],
            'src_pk': 'CUSTOMER_PK',
            'src_nk': 'CUSTOMER_ID',
            'src_ldts': 'LOADDATE',
            'src_source': 'SOURCE'
        },
        'HUB_BOOKING': {
            'source_model': 'raw_stage_booking_hashed',
            'src_pk': 'BOOKING_PK',
            'src_nk': 'BOOKING_ID',
            'src_ldts': 'LOADDATE',
            'src_source': 'SOURCE'
        },
        'LINK_CUSTOMER_BOOKING': {
            'source_model': 'raw_stage_booking_hashed',
            'src_pk': 'CUSTOMER_BOOKING_PK',
            'src_fk': ['CUSTOMER_PK', 'BOOKING_PK'],
            'src_ldts': 'LOADDATE',
            'src_source': 'SOURCE'
        },
        'SAT_CUST_CUSTOMER_DETAILS': {
            'source_model': 'raw_stage_customer_hashed',
            'src_pk': 'CUSTOMER_PK',
            'src_hashdiff': 'HASHDIFF',
            'src_payload': ['CUSTOMER_NAME', 'CUSTOMER_DOB'],
            'src_eff': 'EFFECTIVE_FROM',
            'src_ldts': 'LOADDATE',
            'src_source': 'SOURCE'
        },
        'SAT_BOOK_CUSTOMER_DETAILS': {
            'source_model': 'raw_stage_booking_hashed',
            'src_pk': 'CUSTOMER_PK',
            'src_hashdiff': 'HASHDIFF',
            'src_payload': ['PHONE', 'NATIONALITY'],
            'src_eff': 'EFFECTIVE_FROM',
            'src_ldts': 'LOADDATE',
            'src_source': 'SOURCE'
        },
        'SAT_BOOK_BOOKING_DETAILS': {
            'source_model': 'raw_stage_booking_hashed',
            'src_pk': 'BOOKING_PK',
            'src_hashdiff': 'HASHDIFF',
            'src_payload': ['PRICE', 'BOOKING_DATE',
                            'DEPARTURE_DATE', 'DESTINATION'],
            'src_eff': 'EFFECTIVE_FROM',
            'src_ldts': 'LOADDATE',
            'src_source': 'SOURCE'
        }
    }

    context.stage_columns = {
        'RAW_STAGE_CUSTOMER':
            ['CUSTOMER_ID',
             'CUSTOMER_NAME',
             'CUSTOMER_DOB',
             'EFFECTIVE_FROM',
             'LOADDATE',
             'SOURCE']
        ,
        'RAW_STAGE_BOOKING':
            ['BOOKING_ID',
             'CUSTOMER_ID',
             'BOOKING_DATE',
             'PRICE',
             'DEPARTURE_DATE',
             'DESTINATION',
             'PHONE',
             'NATIONALITY',
             'LOADDATE',
             'SOURCE']
    }

    context.seed_config = {
        'RAW_STAGE_CUSTOMER': {
            'column_types': {
                'CUSTOMER_ID': 'VARCHAR',
                'CUSTOMER_NAME': 'VARCHAR',
                'CUSTOMER_DOB': 'DATE',
                'EFFECTIVE_FROM': 'DATE',
                'LOADDATE': 'DATE',
                'SOURCE': 'VARCHAR'
            }
        },
        'RAW_STAGE_BOOKING': {
            'column_types': {
                'BOOKING_ID': 'VARCHAR',
                'CUSTOMER_ID': 'VARCHAR',
                'PRICE': 'NUMBER(38,2)',
                'DEPARTURE_DATE': 'DATE',
                'BOOKING_DATE': 'DATE',
                'PHONE': 'VARCHAR',
                'DESTINATION': 'VARCHAR',
                'NATIONALITY': 'VARCHAR',
                'LOADDATE': 'DATE',
                'SOURCE': 'VARCHAR'
            }
        },
        'HUB_CUSTOMER': {
            'column_types': {
                'CUSTOMER_PK': 'BINARY(16)',
                'CUSTOMER_ID': 'NUMBER(38,0)',
                'LOADDATE': 'DATE',
                'SOURCE': 'VARCHAR'
            }
        },
        'HUB_BOOKING': {
            'column_types': {
                'BOOKING_PK': 'BINARY(16)',
                'BOOKING_ID': 'NUMBER(38,0)',
                'LOADDATE': 'DATE',
                'SOURCE': 'VARCHAR'
            }
        },
        'LINK_CUSTOMER_BOOKING': {
            'column_types': {
                'CUSTOMER_BOOKING_PK': 'BINARY(16)',
                'CUSTOMER_PK': 'BINARY(16)',
                'BOOKING_PK': 'BINARY(16)',
                'LOADDATE': 'DATE',
                'SOURCE': 'VARCHAR'
            }
        },
        'SAT_CUST_CUSTOMER_DETAILS': {
            'column_types': {
                'CUSTOMER_PK': 'BINARY(16)',
                'HASHDIFF': 'BINARY(16)',
                'CUSTOMER_NAME': 'VARCHAR',
                'CUSTOMER_DOB': 'DATE',
                'EFFECTIVE_FROM': 'DATE',
                'LOADDATE': 'DATE',
                'SOURCE': 'VARCHAR'
            }
        },
        'SAT_BOOK_CUSTOMER_DETAILS': {
            'column_types': {
                'CUSTOMER_PK': 'BINARY(16)',
                'HASHDIFF': 'BINARY(16)',
                'PHONE': 'VARCHAR',
                'NATIONALITY': 'VARCHAR',
                'EFFECTIVE_FROM': 'DATE',
                'LOADDATE': 'DATE',
                'SOURCE': 'VARCHAR'
            }
        },
        'SAT_BOOK_BOOKING_DETAILS': {
            'column_types': {
                'BOOKING_PK': 'BINARY(16)',
                'HASHDIFF': 'BINARY(16)',
                'PRICE': 'NUMBER(38,2)',
                'BOOKING_DATE': 'DATE',
                'DEPARTURE_DATE': 'DATE',
                'DESTINATION': 'VARCHAR',
                'EFFECTIVE_FROM': 'DATE',
                'LOADDATE': 'DATE',
                'SOURCE': 'VARCHAR'
            }
        }
    }
