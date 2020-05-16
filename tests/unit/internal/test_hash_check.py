from tests.utils.dbt_test_utils import *

macro_folder = 'internal'
dbt_test = DBTTestUtils(model_directory=f'{macro_folder}/hash_check')
os.chdir(TESTS_DBT_ROOT)

model = 'test_hash_check'


def setup_function():
    dbt_test.clean_target()


def test_hash_check_with_md5_setting():
    expected_file_name = 'test_hash_check_with_md5_setting'
    var_dict = {'hash': 'MD5', 'col': '^^'}
    process_logs = dbt_test.run_dbt_model(model=model, model_vars=var_dict)
    actual_sql = dbt_test.retrieve_compiled_model(model)
    expected_sql = dbt_test.retrieve_expected_sql(expected_file_name)
    assert 'Done' in process_logs
    assert expected_sql == actual_sql


def test_hash_check_with_sha_setting():
    expected_file_name = 'test_hash_check_with_sha_setting'
    var_dict = {'hash': 'SHA', 'col': '^^'}
    process_logs = dbt_test.run_dbt_model(model=model, model_vars=var_dict)
    actual_sql = dbt_test.retrieve_compiled_model(model)
    expected_sql = dbt_test.retrieve_expected_sql(expected_file_name)
    assert 'Done' in process_logs
    assert expected_sql == actual_sql


def test_hash_check_with_default_setting():
    expected_file_name = 'test_hash_check_with_default_setting'
    var_dict = {'col': '^^'}
    process_logs = dbt_test.run_dbt_model(model=model, model_vars=var_dict)
    actual_sql = dbt_test.retrieve_compiled_model(model)
    expected_sql = dbt_test.retrieve_expected_sql(expected_file_name)
    assert 'Done' in process_logs
    assert expected_sql == actual_sql
