from tests.utils.dbt_test_utils import *

macro_folder = 'supporting'
dbt_test = DBTTestUtils(model_directory=f'{macro_folder}/hash')
os.chdir(TESTS_DBT_ROOT)


def setup_function():
    dbt_test.clean_target()


def test_hash_single_column_is_successful():
    model = 'test_hash'
    expected_file_name = 'test_hash_single_column_is_successful'
    var_dict = {'columns': "CUSTOMER_ID", 'alias': 'c'}
    process_logs = dbt_test.run_dbt_model(model=model, model_vars=var_dict)
    actual_sql = dbt_test.retrieve_compiled_model(model)
    expected_sql = dbt_test.retrieve_expected_sql(expected_file_name)
    assert 'Done' in process_logs
    assert expected_sql == actual_sql


def test_hash_multi_column_with_no_sort_is_successful():
    model = 'test_hash'
    expected_file_name = 'test_hash_multi_column_with_no_sort_is_successful'
    var_dict = {'columns': ['CUSTOMER_ID', 'PHONE', 'DOB'], 'alias': 'c'}
    process_logs = dbt_test.run_dbt_model(model=model, model_vars=var_dict)
    actual_sql = dbt_test.retrieve_compiled_model(model)
    expected_sql = dbt_test.retrieve_expected_sql(expected_file_name)
    assert 'Done' in process_logs
    assert expected_sql == actual_sql


def test_hash_multi_column_with_sort_is_successful():
    model = 'test_hash_with_sort'
    expected_file_name = 'test_hash_multi_column_with_sort_is_successful'
    var_dict = {'columns': ['CUSTOMER_ID', 'PHONE', 'DOB'], 'alias': 'c', 'sort': 'true'}
    process_logs = dbt_test.run_dbt_model(model=model, model_vars=var_dict)
    actual_sql = dbt_test.retrieve_compiled_model(model)
    expected_sql = dbt_test.retrieve_expected_sql(expected_file_name)
    assert 'Done' in process_logs
    assert expected_sql == actual_sql
