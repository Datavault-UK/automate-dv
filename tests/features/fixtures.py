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
    Define the structure to load for single-source hubs
    """

    context.vault_structure_columns = {
        'src_pk': 'CUSTOMER_PK',
        'src_nk': 'CUSTOMER_ID',
        'src_ldts': 'LOADDATE',
        'src_source': 'SOURCE'
    }


@fixture
def multi_source_hub(context):
    """
    Define the structure to load for multi-source hubs
    """

    context.vault_structure_columns = {
        'src_pk': 'PART_PK',
        'src_nk': 'PART_ID',
        'src_ldts': 'LOADDATE',
        'src_source': 'SOURCE'
    }
