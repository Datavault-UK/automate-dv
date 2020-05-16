from tests.utils.dbt_test_utils import *

macro_folder = 'internal'
dbt_test = DBTTestUtils(model_directory=f'{macro_folder}/alias')
os.chdir(TESTS_DBT_ROOT)


def setup_function():
    dbt_test.clean_target()


def test_check_relation_returns_true_for_ref():
    model = 'test_check_relation_returns_true_for_ref'
    process_logs = dbt_test.run_dbt_model(model=model)
    assert 'True' in process_logs
    assert 'Done' in process_logs


def test_check_relation_returns_true_for_source():
    model = 'test_check_relation_returns_true_for_source'
    process_logs = dbt_test.run_dbt_model(model=model)
    assert 'True' in process_logs
    assert 'Done' in process_logs


def test_check_relation_returns_false_for_non_relation():
    model = 'test_check_relation_returns_false_for_non_relation'
    process_logs = dbt_test.run_dbt_model(model=model)
    assert 'False' in process_logs
    assert 'Done' in process_logs
