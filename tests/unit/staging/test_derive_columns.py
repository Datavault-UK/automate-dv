from tests.utils.dbt_test_utils import *

macro_folder = 'staging'
dbt_test = DBTTestUtils(model_directory=f'{macro_folder}/derive_columns')
os.chdir(TESTS_DBT_ROOT)


def setup_function():
    dbt_test.clean_target()


def test_derive_columns_correctly_generates_sql_with_source_columns():
    model = 'test_derive_columns_with_source_columns'
    expected_file_name = 'test_derive_columns_correctly_generates_sql_with_source_columns'
    var_dict = {'source_model': 'raw_source', 'columns': {'SOURCE': "!STG_BOOKING", 'EFFECTIVE_FROM': 'LOADDATE'}}

    process_logs = dbt_test.run_dbt_model(model=model, model_vars=var_dict)
    expected_sql = dbt_test.retrieve_expected_sql(expected_file_name)
    actual_sql = dbt_test.retrieve_compiled_model(model)

    assert 'Done' in process_logs
    assert expected_sql == actual_sql


def test_derive_columns_correctly_generates_sql_without_source_columns():
    model = 'test_derive_columns_without_source_columns'
    expected_file_name = 'test_derive_columns_correctly_generates_sql_without_source_columns'
    var_dict = {'columns': {'SOURCE': "!STG_BOOKING", 'LOADDATE': 'EFFECTIVE_FROM'}}

    process_logs = dbt_test.run_dbt_model(model=model, model_vars=var_dict)
    actual_sql = dbt_test.retrieve_compiled_model(model)
    expected_sql = dbt_test.retrieve_expected_sql(expected_file_name)

    assert 'Done' in process_logs
    assert expected_sql == actual_sql


def test_derive_columns_correctly_generates_sql_with_only_source_columns():
    model = 'test_derive_columns_with_only_source_columns'
    expected_file_name = 'test_derive_columns_correctly_generates_sql_with_only_source_columns'
    var_dict = {'source_model': 'raw_source'}

    process_logs = dbt_test.run_dbt_model(model=model, model_vars=var_dict)
    actual_sql = dbt_test.retrieve_compiled_model(model)
    expected_sql = dbt_test.retrieve_expected_sql(expected_file_name)

    assert 'Done' in process_logs
    assert expected_sql == actual_sql
