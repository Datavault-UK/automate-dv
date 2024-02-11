import pytest

import test
import os

from test import dbt_runner, macro_test_helpers
from dbt.cli.main import dbtRunner

macro_name = "standard_column_wrapper"

dbt_init = dbtRunner()


@pytest.mark.macro
def test_standard_column_wrapper_is_successful_with_defaults(request, generate_model):
    generate_model()

    dbt_result = dbt_runner.run_dbt_models(dbt_init, model_names=[request.node.name],
                                           args=dict())
    actual_sql = macro_test_helpers.retrieve_compiled_model(request.node.name)
    expected_sql = macro_test_helpers.retrieve_expected_sql(request)

    assert dbt_result is True
    assert actual_sql == expected_sql


@pytest.mark.macro
def test_standard_column_wrapper_is_successful_with_disabled_uppercase_upper_value(request, generate_model):
    var_dict = {'hash_content_casing': 'DISABLED'}

    generate_model()

    dbt_result = dbt_runner.run_dbt_models(dbt_init, model_names=[request.node.name],
                                           args=var_dict)
    actual_sql = macro_test_helpers.retrieve_compiled_model(request.node.name)
    expected_sql = macro_test_helpers.retrieve_expected_sql(request)

    assert dbt_result is True
    assert actual_sql == expected_sql


@pytest.mark.macro
def test_standard_column_wrapper_is_successful_with_disabled_uppercase_lower_value(request, generate_model):
    var_dict = {'hash_content_casing': 'disabled'}

    generate_model()

    dbt_result = dbt_runner.run_dbt_models(dbt_init, model_names=[request.node.name],
                                           args=var_dict)
    actual_sql = macro_test_helpers.retrieve_compiled_model(request.node.name)
    expected_sql = macro_test_helpers.retrieve_expected_sql(request)

    assert dbt_result is True
    assert actual_sql == expected_sql


@pytest.mark.macro
def test_standard_column_wrapper_is_successful_with_enabled_uppercase_upper_value(request, generate_model):
    var_dict = {'hash_content_casing': 'UPPER'}

    generate_model()

    dbt_result = dbt_runner.run_dbt_models(dbt_init, model_names=[request.node.name],
                                           args=var_dict)
    actual_sql = macro_test_helpers.retrieve_compiled_model(request.node.name)
    expected_sql = macro_test_helpers.retrieve_expected_sql(request)

    assert dbt_result is True
    assert actual_sql == expected_sql


@pytest.mark.macro
def test_standard_column_wrapper_is_successful_with_enabled_uppercase_lower_value(request, generate_model):
    var_dict = {'hash_content_casing': 'upper'}

    generate_model()

    dbt_result = dbt_runner.run_dbt_models(dbt_init, model_names=[request.node.name],
                                           args=var_dict)
    actual_sql = macro_test_helpers.retrieve_compiled_model(request.node.name)
    expected_sql = macro_test_helpers.retrieve_expected_sql(request)

    assert dbt_result is True
    assert actual_sql == expected_sql


@pytest.mark.macro
def test_standard_column_wrapper_raises_error_with_invalid_hash_content_value(request, generate_model):
    var_dict = {'hash_content_casing': 'INVALID'}

    generate_model()

    dbt_result = dbt_runner.run_dbt_models(dbt_init, model_names=[request.node.name],
                                           args=var_dict, logs_required=True)

    assert "Must provide a valid casing config for hash_content_casing. " \
           "'INVALID' was provided. Can be one of upper, disabled (case insensitive)" not in dbt_logs
