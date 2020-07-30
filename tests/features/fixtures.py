from behave import fixture

from tests.test_utils.dbt_test_utils import *

"""
The fixtures here are used to supply runtime metadata to tests, in place of metadata usually provided via vars or a YAML config
"""


@fixture
def set_workdir(context):
    """
    Set the working (run) dir for dbt
    """

    os.chdir(TESTS_DBT_ROOT)


@fixture
def sha(context):
    """
    Augment the metadata for a vault structure load to work with SHA hashing instead of MD5
    """

    context.hashing = 'sha'

    if hasattr(context, 'seed_config'):

        config = dict(context.seed_config)

        for k, v in config.items():

            for c, t in config[k]['column_types'].items():

                if t == 'BINARY(16)':
                    config[k]['column_types'][c] = 'BINARY(32)'

    else:
        raise ValueError('sha fixture used before vault structure fixture.')


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
        'HUB': {
            'src_pk': 'CUSTOMER_PK',
            'src_nk': 'CUSTOMER_ID',
            'src_ldts': 'LOAD_DATE',
            'src_source': 'SOURCE'
        }
    }

    context.seed_config = {
        'HUB': {
            'column_types': {
                'CUSTOMER_PK': 'BINARY(16)',
                'CUSTOMER_ID': 'VARCHAR',
                'LOAD_DATE': 'DATE',
                'SOURCE': 'VARCHAR'
            }
        },
        'RAW_STAGE': {
            'column_types': {
                'CUSTOMER_ID': 'VARCHAR',
                'CUSTOMER_NAME': 'VARCHAR',
                'LOAD_DATE': 'DATE',
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
        'HUB': {
            'src_pk': 'PART_PK',
            'src_nk': 'PART_ID',
            'src_ldts': 'LOAD_DATE',
            'src_source': 'SOURCE'
        }
    }

    context.seed_config = {
        'HUB': {
            'column_types': {
                'PART_PK': 'BINARY(16)',
                'PART_ID': 'VARCHAR',
                'LOAD_DATE': 'DATE',
                'SOURCE': 'VARCHAR'
            }
        },
        'RAW_STAGE_PARTS': {
            'column_types': {
                'PART_ID': 'VARCHAR',
                'PART_NAME': 'VARCHAR',
                'PART_TYPE': 'VARCHAR',
                'PART_SIZE': 'VARCHAR',
                'PART_RETAILPRICE': 'NUMBER(38,2)',
                'LOAD_DATE': 'DATE',
                'SOURCE': 'VARCHAR'
            }
        },
        'RAW_STAGE_SUPPLIER': {
            'column_types': {
                'PART_ID': 'VARCHAR',
                'SUPPLIER_ID': 'VARCHAR',
                'AVAILQTY': 'FLOAT',
                'SUPPLYCOST': 'NUMBER(38,2)',
                'LOAD_DATE': 'DATE',
                'SOURCE': 'VARCHAR'
            }
        },
        'RAW_STAGE_LINEITEM': {
            'column_types': {
                'ORDER_ID': 'VARCHAR',
                'PART_ID': 'VARCHAR',
                'SUPPLIER_ID': 'VARCHAR',
                'LINENUMBER': 'FLOAT',
                'QUANTITY': 'FLOAT',
                'EXTENDED_PRICE': 'NUMBER(38,2)',
                'DISCOUNT': 'NUMBER(38,2)',
                'LOAD_DATE': 'DATE',
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
        'LINK': {
            'src_pk': 'CUSTOMER_NATION_PK',
            'src_fk': ['CUSTOMER_FK', 'NATION_FK'],
            'src_ldts': 'LOAD_DATE',
            'src_source': 'SOURCE'
        }
    }

    context.seed_config = {
        'LINK': {
            'column_types': {
                'CUSTOMER_NATION_PK': 'BINARY(16)',
                'CUSTOMER_FK': 'BINARY(16)',
                'NATION_FK': 'BINARY(16)',
                'LOAD_DATE': 'DATE',
                'SOURCE': 'VARCHAR'
            }
        },
        'RAW_STAGE': {
            'column_types': {
                'CUSTOMER_ID': 'VARCHAR',
                'NATION_ID': 'VARCHAR',
                'CUSTOMER_NAME': 'VARCHAR',
                'CUSTOMER_DOB': 'DATE',
                'CUSTOMER_PHONE': 'VARCHAR',
                'LOAD_DATE': 'DATE',
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
        'LINK': {
            'src_pk': 'CUSTOMER_NATION_PK',
            'src_fk': ['CUSTOMER_FK', 'NATION_FK'],
            'src_ldts': 'LOAD_DATE',
            'src_source': 'SOURCE'
        }
    }

    context.seed_config = {
        'LINK': {
            'column_types': {
                'CUSTOMER_NATION_PK': 'BINARY(16)',
                'CUSTOMER_FK': 'BINARY(16)',
                'NATION_FK': 'BINARY(16)',
                'LOAD_DATE': 'DATE',
                'SOURCE': 'VARCHAR'
            }
        },
        'RAW_STAGE_SAP': {
            'column_types': {
                'CUSTOMER_ID': 'VARCHAR',
                'NATION_ID': 'VARCHAR',
                'CUSTOMER_NAME': 'VARCHAR',
                'CUSTOMER_DOB': 'DATE',
                'CUSTOMER_PHONE': 'VARCHAR',
                'LOAD_DATE': 'DATE',
                'SOURCE': 'VARCHAR'
            }
        },
        'RAW_STAGE_CRM': {
            'column_types': {
                'CUSTOMER_ID': 'VARCHAR',
                'NATION_ID': 'VARCHAR',
                'CUSTOMER_NAME': 'VARCHAR',
                'CUSTOMER_DOB': 'DATE',
                'CUSTOMER_PHONE': 'VARCHAR',
                'LOAD_DATE': 'DATE',
                'SOURCE': 'VARCHAR'
            }
        },
        'RAW_STAGE_WEB': {
            'column_types': {
                'CUSTOMER_ID': 'VARCHAR',
                'NATION_ID': 'VARCHAR',
                'CUSTOMER_NAME': 'VARCHAR',
                'CUSTOMER_DOB': 'DATE',
                'CUSTOMER_PHONE': 'VARCHAR',
                'LOAD_DATE': 'DATE',
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
            'HASHDIFF': {'is_hashdiff': True,
                         'columns': ['CUSTOMER_ID', 'CUSTOMER_DOB', 'CUSTOMER_PHONE', 'CUSTOMER_NAME']}
        }
    }

    context.derived_mapping = {
        'RAW_STAGE': {
            'EFFECTIVE_FROM': 'LOAD_DATE'
        }
    }

    context.vault_structure_columns = {
        'SATELLITE': {
            'src_pk': 'CUSTOMER_PK',
            'src_payload': ['CUSTOMER_NAME', 'CUSTOMER_PHONE', 'CUSTOMER_DOB'],
            'src_hashdiff': 'HASHDIFF',
            'src_eff': 'EFFECTIVE_FROM',
            'src_ldts': 'LOAD_DATE',
            'src_source': 'SOURCE'
        }
    }

    context.seed_config = {
        'RAW_STAGE': {
            'column_types': {
                'CUSTOMER_ID': 'NUMBER(38, 0)',
                'CUSTOMER_NAME': 'VARCHAR',
                'CUSTOMER_PHONE': 'VARCHAR',
                'CUSTOMER_DOB': 'DATE',
                'LOAD_DATE': 'DATE',
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
                'LOAD_DATE': 'DATE',
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
        'RAW_STAGE': {
            'EFFECTIVE_FROM': 'LOAD_DATE'
        }
    }

    context.stage_columns = {
        'RAW_STAGE':
            ['CUSTOMER_ID',
             'CUSTOMER_NAME',
             'CUSTOMER_DOB',
             'EFFECTIVE_FROM',
             'LOAD_DATE',
             'SOURCE']
    }

    context.vault_structure_columns = {
        'SATELLITE': {
            'src_pk': 'CUSTOMER_PK',
            'src_payload': ['CUSTOMER_NAME', 'CUSTOMER_DOB'],
            'src_hashdiff': 'HASHDIFF',
            'src_eff': 'EFFECTIVE_FROM',
            'src_ldts': 'LOAD_DATE',
            'src_source': 'SOURCE'
        }
    }

    context.seed_config = {
        'RAW_STAGE': {
            'column_types': {
                'CUSTOMER_ID': 'VARCHAR',
                'CUSTOMER_NAME': 'VARCHAR',
                'CUSTOMER_DOB': 'DATE',
                'EFFECTIVE_FROM': 'DATE',
                'LOAD_DATE': 'DATE',
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
                'LOAD_DATE': 'DATE',
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
        'RAW_STAGE': {
            'EFFECTIVE_FROM': 'TRANSACTION_DATE'
        }
    }

    context.vault_structure_columns = {
        'T_LINK': {
            'src_pk': 'TRANSACTION_PK',
            'src_fk': 'CUSTOMER_FK',
            'src_payload': ['TRANSACTION_NUMBER', 'TRANSACTION_DATE',
                            'TYPE', 'AMOUNT'],
            'src_eff': 'EFFECTIVE_FROM',
            'src_ldts': 'LOAD_DATE',
            'src_source': 'SOURCE'
        }
    }

    context.seed_config = {
        'RAW_STAGE': {
            'column_types': {
                'CUSTOMER_ID': 'VARCHAR',
                'TRANSACTION_NUMBER': 'NUMBER(38,0)',
                'TRANSACTION_DATE': 'DATE',
                'TYPE': 'VARCHAR',
                'AMOUNT': 'NUMBER(38,2)',
                'LOAD_DATE': 'DATE',
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
                'LOAD_DATE': 'DATE',
                'SOURCE': 'VARCHAR'
            }
        }
    }


@fixture
def eff_satellite(context):
    """
    Define the structures and metadata to load effectivity satellites
    """

    context.hash_mapping_config = {
        'RAW_STAGE': {
            'CUSTOMER_ORDER_PK': ['CUSTOMER_ID', 'ORDER_ID'],
            'CUSTOMER_PK': 'CUSTOMER_ID',
            'ORDER_PK': 'ORDER_ID'
        }
    }

    context.derived_mapping = {
        'RAW_STAGE': {
            'EFFECTIVE_FROM': 'LOAD_DATE',
            'START_DATE': "TO_DATE(\'2020-01-09\')",
            'END_DATE': "TO_DATE(\'9999-12-31\')"
        }
    }

    context.vault_structure_columns = {
        'LINK': {
            'src_pk': 'CUSTOMER_ORDER_PK',
            'src_fk': ['CUSTOMER_PK', 'ORDER_PK'],
            'src_ldts': 'LOAD_DATE',
            'src_source': 'SOURCE'
        },
        'EFF_SAT': {
            'src_pk': 'CUSTOMER_ORDER_PK',
            'src_dfk': 'CUSTOMER_PK',
            'src_sfk': 'ORDER_PK',
            'src_start_date': 'START_DATE',
            'src_end_date': 'END_DATE',
            'src_eff': 'EFFECTIVE_FROM',
            'src_ldts': 'LOAD_DATE',
            'src_source': 'SOURCE',
            'link_model': "LINK",
        }
    }

    context.seed_config = {
        'RAW_STAGE': {
            'column_types': {
                'CUSTOMER_ID': 'NUMBER(38, 0)',
                'ORDER_ID': 'VARCHAR',
                'START_DATE': 'DATE',
                'END_DATE': 'DATE',
                'LOAD_DATE': 'DATE',
                'SOURCE': 'VARCHAR'
            }
        },
        'LINK': {
            'column_types': {
                'CUSTOMER_ORDER_PK': 'BINARY(16)',
                'CUSTOMER_PK': 'BINARY(16)',
                'ORDER_PK': 'BINARY(16)',
                'LOAD_DATE': 'DATE',
                'SOURCE': 'VARCHAR'
            }
        },
        'EFF_SAT': {
            'column_types': {
                'CUSTOMER_ORDER_PK': 'BINARY(16)',
                'CUSTOMER_PK': 'BINARY(16)',
                'ORDER_PK': 'BINARY(16)',
                'START_DATE': 'DATE',
                'END_DATE': 'DATE',
                'EFFECTIVE_FROM': 'DATE',
                'LOAD_DATE': 'DATE',
                'SOURCE': 'VARCHAR'
            }
        },
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
            'HASHDIFF_BOOK_CUSTOMER_DETAILS': {'is_hashdiff': True,
                                               'columns': ['CUSTOMER_ID',
                                                           'NATIONALITY',
                                                           'PHONE']
                                               },
            'HASHDIFF_BOOK_BOOKING_DETAILS': {'is_hashdiff': True,
                                              'columns': ['BOOKING_ID',
                                                          'BOOKING_DATE',
                                                          'PRICE',
                                                          'DEPARTURE_DATE',
                                                          'DESTINATION']
                                              }
        }
    }

    context.derived_mapping = {
        'RAW_STAGE_CUSTOMER': {
            'EFFECTIVE_FROM': 'LOAD_DATE'
        },
        'RAW_STAGE_BOOKING': {
            'EFFECTIVE_FROM': 'BOOKING_DATE'
        }
    }

    context.vault_structure_columns = {
        'HUB_CUSTOMER': {
            'source_model': ['raw_stage_customer_hashed',
                             'raw_stage_booking_hashed'],
            'src_pk': 'CUSTOMER_PK',
            'src_nk': 'CUSTOMER_ID',
            'src_ldts': 'LOAD_DATE',
            'src_source': 'SOURCE'
        },
        'HUB_BOOKING': {
            'source_model': 'raw_stage_booking_hashed',
            'src_pk': 'BOOKING_PK',
            'src_nk': 'BOOKING_ID',
            'src_ldts': 'LOAD_DATE',
            'src_source': 'SOURCE'
        },
        'LINK_CUSTOMER_BOOKING': {
            'source_model': 'raw_stage_booking_hashed',
            'src_pk': 'CUSTOMER_BOOKING_PK',
            'src_fk': ['CUSTOMER_PK', 'BOOKING_PK'],
            'src_ldts': 'LOAD_DATE',
            'src_source': 'SOURCE'
        },
        'SAT_CUST_CUSTOMER_DETAILS': {
            'source_model': 'raw_stage_customer_hashed',
            'src_pk': 'CUSTOMER_PK',
            'src_hashdiff': 'HASHDIFF',
            'src_payload': ['CUSTOMER_NAME', 'CUSTOMER_DOB'],
            'src_eff': 'EFFECTIVE_FROM',
            'src_ldts': 'LOAD_DATE',
            'src_source': 'SOURCE'
        },
        'SAT_BOOK_CUSTOMER_DETAILS': {
            'source_model': 'raw_stage_booking_hashed',
            'src_pk': 'CUSTOMER_PK',
            'src_hashdiff': {'source_column': 'HASHDIFF_BOOK_CUSTOMER_DETAILS',
                             'alias': 'HASHDIFF'},
            'src_payload': ['PHONE', 'NATIONALITY'],
            'src_eff': 'EFFECTIVE_FROM',
            'src_ldts': 'LOAD_DATE',
            'src_source': 'SOURCE'
        },
        'SAT_BOOK_BOOKING_DETAILS': {
            'source_model': 'raw_stage_booking_hashed',
            'src_pk': 'BOOKING_PK',
            'src_hashdiff': {'source_column': 'HASHDIFF_BOOK_BOOKING_DETAILS',
                             'alias': 'HASHDIFF'},
            'src_payload': ['PRICE', 'BOOKING_DATE',
                            'DEPARTURE_DATE', 'DESTINATION'],
            'src_eff': 'EFFECTIVE_FROM',
            'src_ldts': 'LOAD_DATE',
            'src_source': 'SOURCE'
        }
    }

    context.stage_columns = {
        'RAW_STAGE_CUSTOMER':
            ['CUSTOMER_ID',
             'CUSTOMER_NAME',
             'CUSTOMER_DOB',
             'EFFECTIVE_FROM',
             'LOAD_DATE',
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
             'LOAD_DATE',
             'SOURCE']
    }

    context.seed_config = {
        'RAW_STAGE_CUSTOMER': {
            'column_types': {
                'CUSTOMER_ID': 'VARCHAR',
                'CUSTOMER_NAME': 'VARCHAR',
                'CUSTOMER_DOB': 'DATE',
                'EFFECTIVE_FROM': 'DATE',
                'LOAD_DATE': 'DATE',
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
                'LOAD_DATE': 'DATE',
                'SOURCE': 'VARCHAR'
            }
        },
        'HUB_CUSTOMER': {
            'column_types': {
                'CUSTOMER_PK': 'BINARY(16)',
                'CUSTOMER_ID': 'VARCHAR',
                'LOAD_DATE': 'DATE',
                'SOURCE': 'VARCHAR'
            }
        },
        'HUB_BOOKING': {
            'column_types': {
                'BOOKING_PK': 'BINARY(16)',
                'BOOKING_ID': 'VARCHAR',
                'LOAD_DATE': 'DATE',
                'SOURCE': 'VARCHAR'
            }
        },
        'LINK_CUSTOMER_BOOKING': {
            'column_types': {
                'CUSTOMER_BOOKING_PK': 'BINARY(16)',
                'CUSTOMER_PK': 'BINARY(16)',
                'BOOKING_PK': 'BINARY(16)',
                'LOAD_DATE': 'DATE',
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
                'LOAD_DATE': 'DATE',
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
                'LOAD_DATE': 'DATE',
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
                'LOAD_DATE': 'DATE',
                'SOURCE': 'VARCHAR'
            }
        }
    }
