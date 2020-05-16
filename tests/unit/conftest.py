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


@pytest.fixture(autouse=True)
def clean_target(dbt_test_utils):
    DBTTestUtils.clean_target()
    yield


@pytest.fixture(autouse=True)
def set_dbt_directory():
    os.chdir(TESTS_DBT_ROOT)
    yield
