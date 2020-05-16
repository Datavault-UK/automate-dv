from tests.utils.dbt_test_utils import *

macro_folder = 'tables'
dbt_test = DBTTestUtils(model_directory=f'{macro_folder}/link')
os.chdir(TESTS_DBT_ROOT)


def setup_function():
    dbt_test.clean_target()


def test_link_macro_correctly_generates_sql_for_single_source():
    model = 'test_link_macro_single_source'
    expected_file_name = 'test_link_macro_single_source'

    process_logs = dbt_test.run_dbt_model(model=model, full_refresh=True)
    actual_sql = dbt_test.retrieve_compiled_model(model)
    expected_sql = dbt_test.retrieve_expected_sql(expected_file_name)

    assert 'Done' in process_logs
    assert expected_sql == actual_sql


def test_link_macro_correctly_generates_sql_for_incremental_single_source():
    model = 'test_link_macro_single_source'
    expected_file_name = 'test_link_macro_incremental_single_source'

    process_logs_first_run = dbt_test.run_dbt_model(mode='run', model=model, full_refresh=True)
    process_logs_inc_run = dbt_test.run_dbt_model(mode='run', model=model)
    actual_sql = dbt_test.retrieve_compiled_model(model)
    expected_sql = dbt_test.retrieve_expected_sql(expected_file_name)

    assert 'Done' in process_logs_first_run
    assert 'Done' in process_logs_inc_run
    assert expected_sql == actual_sql


def test_link_macro_correctly_generates_sql_for_multi_source():
    model = 'test_link_macro_multi_source'
    expected_file_name = 'test_link_macro_multi_source'

    process_logs = dbt_test.run_dbt_model(model=model, full_refresh=True)
    actual_sql = dbt_test.retrieve_compiled_model(model)
    expected_sql = dbt_test.retrieve_expected_sql(expected_file_name)

    assert 'Done' in process_logs
    assert expected_sql == actual_sql


def test_link_macro_correctly_generates_sql_for_incremental_multi_source():
    model = 'test_link_macro_multi_source'
    expected_file_name = 'test_link_macro_incremental_multi_source'

    process_logs_first_run = dbt_test.run_dbt_model(mode='run', model=model, full_refresh=True)
    process_logs_inc_run = dbt_test.run_dbt_model(mode='run', model=model)
    actual_sql = dbt_test.retrieve_compiled_model(model)
    expected_sql = dbt_test.retrieve_expected_sql(expected_file_name)

    assert 'Done' in process_logs_first_run
    assert 'Done' in process_logs_inc_run
    assert expected_sql == actual_sql
