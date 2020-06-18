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
