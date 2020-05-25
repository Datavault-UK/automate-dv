import pytest
from tests.utils.dbt_test_utils import *
from pathlib import Path


@pytest.fixture(scope="class")
def dbt_test_utils(request):
    """
    Configure the model_directory in DBTTestUtils using the directory structure of the macro under test.
    """

    test_path = Path(request.fspath.strpath)
    macro_folder = test_path.parent.name
    macro_under_test = test_path.stem.split('test_')[1]

    request.cls.dbt_test_utils = DBTTestUtils(model_directory=f"{macro_folder}/{macro_under_test}")


@pytest.fixture(autouse=True, scope='session')
def clean_target():
    """ Clean the target folder for each session"""
    DBTTestUtils.clean_target()
    yield


@pytest.fixture(autouse=True)
def set_dbt_directory():
    """ Set the current working directory as the dbt project location for each test"""
    os.chdir(TESTS_DBT_ROOT)
    yield


@pytest.fixture(autouse=True)
def expected_filename(request):
    """ Provide the current test name to every test, as the filename for the expected output file for that test"""

    request.cls.current_test_name = request.node.name


@pytest.fixture(scope='class')
def run_seeds():
    os.chdir(TESTS_DBT_ROOT)
    DBTTestUtils.run_dbt_seed()
    yield
