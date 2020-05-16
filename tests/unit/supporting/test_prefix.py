from tests.utils.dbt_test_utils import *

macro_folder = 'supporting'
dbt_test = DBTTestUtils(model_directory=f'{macro_folder}/prefix')
os.chdir(TESTS_DBT_ROOT)


def setup_function():
    dbt_test.clean_target()


def test_prefix_column_in_single_item_list_is_successful():
    model = 'test_prefix'
    expected_file_name = 'test_prefix_column_in_single_item_list_is_successful'

    var_dict = {'columns': ["CUSTOMER_HASHDIFF"], 'prefix': 'c'}
    process_logs = dbt_test.run_dbt_model(model=model, model_vars=var_dict)
    actual_sql = dbt_test.retrieve_compiled_model(model)
    expected_sql = dbt_test.retrieve_expected_sql(expected_file_name)

    assert 'Done' in process_logs
    assert expected_sql == actual_sql


def test_prefix_multiple_columns_is_successful():
    model = 'test_prefix'
    expected_file_name = 'test_prefix_multiple_columns_is_successful'

    var_dict = {'columns': ["CUSTOMER_HASHDIFF", 'CUSTOMER_PK', 'LOADDATE', 'SOURCE'], 'prefix': 'c'}
    process_logs = dbt_test.run_dbt_model(model=model, model_vars=var_dict)
    actual_sql = dbt_test.retrieve_compiled_model(model)
    expected_sql = dbt_test.retrieve_expected_sql(expected_file_name)

    assert 'Done' in process_logs
    assert expected_sql == actual_sql


def test_prefix_aliased_column_is_successful():
    model = 'test_prefix'
    expected_file_name = 'test_prefix_aliased_column_is_successful'

    columns = [{"source_column": "CUSTOMER_HASHDIFF", "alias": "HASHDIFF"}, "CUSTOMER_PK", "LOADDATE"]
    var_dict = {'columns': columns, 'prefix': 'c'}
    process_logs = dbt_test.run_dbt_model(model=model, model_vars=var_dict)
    actual_sql = dbt_test.retrieve_compiled_model(model)
    expected_sql = dbt_test.retrieve_expected_sql(expected_file_name)

    assert 'Done' in process_logs
    assert expected_sql == actual_sql


def test_prefix_aliased_column_with_alias_target_as_source_is_successful():
    model = 'test_prefix_alias_target'
    expected_file_name = 'test_prefix_aliased_column_with_alias_target_as_source_is_successful'

    columns = [{"source_column": "CUSTOMER_HASHDIFF", "alias": "HASHDIFF"}, "CUSTOMER_PK", "LOADDATE"]
    var_dict = {'columns': columns, 'prefix': 'c', 'alias_target': 'source'}
    process_logs = dbt_test.run_dbt_model(model=model, model_vars=var_dict)
    actual_sql = dbt_test.retrieve_compiled_model(model)
    expected_sql = dbt_test.retrieve_expected_sql(expected_file_name)

    assert 'Done' in process_logs
    assert expected_sql == actual_sql


def test_prefix_aliased_column_with_alias_target_as_target_is_successful():
    model = 'test_prefix_alias_target'
    expected_file_name = 'test_prefix_aliased_column_with_alias_target_as_target_is_successful'

    columns = [{"source_column": "CUSTOMER_HASHDIFF", "alias": "HASHDIFF"}, "CUSTOMER_PK", "LOADDATE"]
    var_dict = {'columns': columns, 'prefix': 'c', 'alias_target': 'target'}
    process_logs = dbt_test.run_dbt_model(model=model, model_vars=var_dict)
    actual_sql = dbt_test.retrieve_compiled_model(model)
    expected_sql = dbt_test.retrieve_expected_sql(expected_file_name)

    assert 'Done' in process_logs
    assert expected_sql == actual_sql


def test_prefix_with_no_columns_raises_error():
    model = 'test_prefix'
    var_dict = {'prefix': 'c'}

    process_logs = dbt_test.run_dbt_model(model=model, model_vars=var_dict)

    assert "Invalid parameters provided to prefix macro. Expected: "    "(columns [list/string], prefix_str [string]) got: (None, c)" in process_logs


def test_prefix_with_empty_column_list_raises_error():
    model = 'test_prefix'
    var_dict = {'columns': [], 'prefix': 'c'}

    process_logs = dbt_test.run_dbt_model(model=model, model_vars=var_dict)

    assert "Invalid parameters provided to prefix macro. Expected: "    "(columns [list/string], prefix_str [string]) got: ([], c)" in process_logs
