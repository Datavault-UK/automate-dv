from behave import fixture

from tests.dbt_test_utils import *


@fixture
def set_workdir(context):
    os.chdir(TESTS_DBT_ROOT)
