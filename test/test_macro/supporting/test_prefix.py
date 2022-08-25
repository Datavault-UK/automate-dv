import pytest

from test import dbt_runner, macro_test_helpers

macro_name = "prefix"


@pytest.mark.macro
def test_prefix_column_in_single_item_list_is_successful(request, generate_model):
    var_dict = {'columns': ["CUSTOMER_HASHDIFF"], 'prefix': 'c'}

    generate_model()

    dbt_logs = dbt_runner.run_dbt_models(model_names=[request.node.name],
                                         args=var_dict)
    actual_sql = macro_test_helpers.retrieve_compiled_model(request.node.name)
    expected_sql = macro_test_helpers.retrieve_expected_sql(request)

    assert macro_test_helpers.is_successful_run(dbt_logs)
    assert actual_sql == expected_sql


@pytest.mark.macro
def test_prefix_multiple_columns_is_successful(request, generate_model):
    var_dict = {'columns': ["CUSTOMER_HASHDIFF", 'CUSTOMER_PK', 'LOAD_DATE', 'SOURCE'], 'prefix': 'c'}

    generate_model()

    dbt_logs = dbt_runner.run_dbt_models(model_names=[request.node.name],
                                         args=var_dict)
    actual_sql = macro_test_helpers.retrieve_compiled_model(request.node.name)
    expected_sql = macro_test_helpers.retrieve_expected_sql(request)

    assert macro_test_helpers.is_successful_run(dbt_logs)
    assert actual_sql == expected_sql


@pytest.mark.macro
def test_prefix_aliased_column_is_successful(request, generate_model):
    var_dict = {'columns': [{"source_column": "CUSTOMER_HASHDIFF", "alias": "HASHDIFF"}, "CUSTOMER_PK", "LOAD_DATE"],
                'prefix': 'c'}

    generate_model()

    dbt_logs = dbt_runner.run_dbt_models(model_names=[request.node.name],
                                         args=var_dict)
    actual_sql = macro_test_helpers.retrieve_compiled_model(request.node.name)
    expected_sql = macro_test_helpers.retrieve_expected_sql(request)

    assert macro_test_helpers.is_successful_run(dbt_logs)
    assert actual_sql == expected_sql


@pytest.mark.macro
def test_prefix_aliased_column_with_alias_target_as_source_is_successful(request, generate_model):
    var_dict = {'columns': [{"source_column": "CUSTOMER_HASHDIFF", "alias": "HASHDIFF"}, "CUSTOMER_PK", "LOAD_DATE"],
                'prefix': 'c', 'alias_target': 'source'}

    generate_model()

    dbt_logs = dbt_runner.run_dbt_models(model_names=[request.node.name],
                                         args=var_dict)
    actual_sql = macro_test_helpers.retrieve_compiled_model(request.node.name)
    expected_sql = macro_test_helpers.retrieve_expected_sql(request)

    assert macro_test_helpers.is_successful_run(dbt_logs)
    assert actual_sql == expected_sql


@pytest.mark.macro
def test_prefix_aliased_column_with_alias_target_as_target_is_successful(request, generate_model):
    var_dict = {'columns': [{"source_column": "CUSTOMER_HASHDIFF", "alias": "HASHDIFF"}, "CUSTOMER_PK", "LOAD_DATE"],
                'prefix': 'c', 'alias_target': 'target'}

    generate_model()

    dbt_logs = dbt_runner.run_dbt_models(model_names=[request.node.name],
                                         args=var_dict)
    actual_sql = macro_test_helpers.retrieve_compiled_model(request.node.name)
    expected_sql = macro_test_helpers.retrieve_expected_sql(request)

    assert macro_test_helpers.is_successful_run(dbt_logs)
    assert actual_sql == expected_sql


@pytest.mark.macro
def test_prefix_with_no_columns_raises_error(request, generate_model):
    var_dict = {'prefix': 'c', 'columns': []}

    generate_model()

    dbt_logs = dbt_runner.run_dbt_models(model_names=[request.node.name], args=var_dict)

    assert "Invalid parameters provided to prefix macro. Expected: " \
           "(columns [list/string], prefix_str [string]) got: ([], c)" in dbt_logs


@pytest.mark.macro
def test_prefix_with_empty_column_list_raises_error(request, generate_model):
    var_dict = {'columns': [], 'prefix': 'c'}

    generate_model()

    dbt_logs = dbt_runner.run_dbt_models(model_names=[request.node.name], args=var_dict)

    assert "Invalid parameters provided to prefix macro. Expected: " \
           "(columns [list/string], prefix_str [string]) got: ([], c)" in dbt_logs
