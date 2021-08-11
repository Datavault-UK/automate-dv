import pytest

from test.test_utils.dbtvault_harness_utils import *


@pytest.fixture(scope="function", autouse=True)
def dbt_test_utils():
    """
    Configure the model_directory in DBTTestUtils using the directory structure of the macro under test.
    """

    yield DBTVAULTHarnessUtils()
