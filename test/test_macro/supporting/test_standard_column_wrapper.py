import pytest

from test import dbt_runner, macro_test_helpers

macro_name = "standard_column_wrapper"


@pytest.mark.macro
def test_standard_column_wrapper_is_successful_with_defaults(request, generate_model):
    generate_model()

    dbt_logs = dbt_runner.run_dbt_models(model_names=[request.node.name],
                                         args=dict())
    actual_sql = macro_test_helpers.retrieve_compiled_model(request.node.name)
    expected_sql = macro_test_helpers.retrieve_expected_sql(request)

    assert macro_test_helpers.is_successful_run(dbt_logs)
    assert actual_sql == expected_sql


@pytest.mark.macro
def test_standard_column_wrapper_is_successful_with_disabled_uppercase_upper_value(request, generate_model):
    var_dict = {'hash_content_casing': 'DISABLED'}

    generate_model()

    dbt_logs = dbt_runner.run_dbt_models(model_names=[request.node.name],
                                         args=var_dict)
    actual_sql = macro_test_helpers.retrieve_compiled_model(request.node.name)
    expected_sql = macro_test_helpers.retrieve_expected_sql(request)

    assert macro_test_helpers.is_successful_run(dbt_logs)
    assert actual_sql == expected_sql


@pytest.mark.macro
def test_standard_column_wrapper_is_successful_with_disabled_uppercase_lower_value(request, generate_model):
    var_dict = {'hash_content_casing': 'disabled'}

    generate_model()

    dbt_logs = dbt_runner.run_dbt_models(model_names=[request.node.name],
                                         args=var_dict)
    actual_sql = macro_test_helpers.retrieve_compiled_model(request.node.name)
    expected_sql = macro_test_helpers.retrieve_expected_sql(request)

    assert macro_test_helpers.is_successful_run(dbt_logs)
    assert actual_sql == expected_sql


@pytest.mark.macro
def test_standard_column_wrapper_is_successful_with_enabled_uppercase_upper_value(request, generate_model):
    var_dict = {'hash_content_casing': 'UPPER'}

    generate_model()

    dbt_logs = dbt_runner.run_dbt_models(model_names=[request.node.name],
                                         args=var_dict)
    actual_sql = macro_test_helpers.retrieve_compiled_model(request.node.name)
    expected_sql = macro_test_helpers.retrieve_expected_sql(request)

    assert macro_test_helpers.is_successful_run(dbt_logs)
    assert actual_sql == expected_sql


@pytest.mark.macro
def test_standard_column_wrapper_is_successful_with_enabled_uppercase_lower_value(request, generate_model):
    var_dict = {'hash_content_casing': 'upper'}

    generate_model()

    dbt_logs = dbt_runner.run_dbt_models(model_names=[request.node.name],
                                         args=var_dict)
    actual_sql = macro_test_helpers.retrieve_compiled_model(request.node.name)
    expected_sql = macro_test_helpers.retrieve_expected_sql(request)

    assert macro_test_helpers.is_successful_run(dbt_logs)
    assert actual_sql == expected_sql


@pytest.mark.macro
def test_standard_column_wrapper_raises_error_with_invalid_hash_content_value(request, generate_model):
    var_dict = {'hash_content_casing': 'INVALID'}

    generate_model()

    dbt_logs = dbt_runner.run_dbt_models(model_names=[request.node.name],
                                         args=var_dict)

    assert "Must provide a valid casing config for hash_content_casing. " \
           "'INVALID' was provided. Can be one of upper, disabled (case insensitive)" not in dbt_logs
