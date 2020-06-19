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

    context.hash_mapping = {
        'CUSTOMER_PK': 'CUSTOMER_ID'
    }

    context.vault_structure_columns = {
        'src_pk': 'CUSTOMER_PK',
        'src_nk': 'CUSTOMER_ID',
        'src_ldts': 'LOADDATE',
        'src_source': 'SOURCE'
    }

    context.seed_config = {
        'column_types': {
            'CUSTOMER_PK': 'BINARY(16)',
            'CUSTOMER_ID': 'VARCHAR',
            'LOADDATE': 'DATE',
            'SOURCE': 'VARCHAR'
        }
    }


@fixture
def multi_source_hub(context):
    """
    Define the structures and metadata to load multi-source hubs
    """

    context.hash_mapping = {
        'PART_PK': 'PART_ID'
    }

    context.vault_structure_columns = {
        'src_pk': 'PART_PK',
        'src_nk': 'PART_ID',
        'src_ldts': 'LOADDATE',
        'src_source': 'SOURCE'
    }

    context.seed_config = {
        'column_types': {
            'PART_PK': 'BINARY(16)',
            'PART_ID': 'VARCHAR',
            'LOADDATE': 'DATE',
            'SOURCE': 'VARCHAR'
        }
    }


@fixture
def single_source_link(context):
    """
    Define the structures and metadata to load single-source links
    """

    context.hash_mapping = {
        'CUSTOMER_NATION_PK': ['CUSTOMER_ID', 'NATION_ID'],
        'CUSTOMER_FK': 'CUSTOMER_ID',
        'NATION_FK': 'NATION_ID',
    }

    context.vault_structure_columns = {
        'src_pk': 'CUSTOMER_NATION_PK',
        'src_fk': ['CUSTOMER_FK', 'NATION_FK'],
        'src_ldts': 'LOADDATE',
        'src_source': 'SOURCE'
    }

    context.seed_config = {
        'column_types': {
            'CUSTOMER_NATION_PK': 'BINARY(16)',
            'CUSTOMER_FK': 'BINARY(16)',
            'NATION_FK': 'BINARY(16)',
            'LOADDATE': 'DATE',
            'SOURCE': 'VARCHAR'
        }
    }


@fixture
def multi_source_link(context):
    """
    Define the structures and metadata to load single-source links
    """

    context.hash_mapping = {
        'CUSTOMER_NATION_PK': ['CUSTOMER_ID', 'NATION_ID'],
        'CUSTOMER_FK': 'CUSTOMER_ID',
        'NATION_FK': 'NATION_ID',
    }

    context.vault_structure_columns = {
        'src_pk': 'CUSTOMER_NATION_PK',
        'src_fk': ['CUSTOMER_FK', 'NATION_FK'],
        'src_ldts': 'LOADDATE',
        'src_source': 'SOURCE'
    }

    context.seed_config = {
        'column_types': {
            'CUSTOMER_NATION_PK': 'BINARY(16)',
            'CUSTOMER_FK': 'BINARY(16)',
            'NATION_FK': 'BINARY(16)',
            'LOADDATE': 'DATE',
            'SOURCE': 'VARCHAR'
        }
    }


@fixture
def satellite(context):
    """
    Define the structures and metadata to load satellites
    """

    context.hash_mapping = {
        'CUSTOMER_PK': 'CUSTOMER_ID',
        'HASHDIFF': {'is_hashdiff': True, 'columns': ['CUSTOMER_DOB', 'CUSTOMER_PHONE', 'CUSTOMER_NAME']}
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
        'column_types': {
            'CUSTOMER_PK': 'BINARY(16)',
            'CUSTOMER_NAME': 'VARCHAR',
            'CUSTOMER_PHONE': 'VARCHAR0',
            'CUSTOMER_DOB': 'DATE',
            'HASHDIFF': 'BINARY(16)',
            'EFFECTIVE_FROM': 'DATE',
            'LOADDATE': 'DATE',
            'SOURCE': 'VARCHAR'
        }
    }
