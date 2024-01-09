import pytest

import test
import os

from test import dbt_runner, macro_test_helpers
from dbt.cli.main import dbtRunner

macro_name = "select_hash_alg"

dbt_init = dbtRunner()


@pytest.mark.macro
def test_select_hash_alg_is_successful_md5_with_upper(request, generate_model):
    var_dict = {'hash': 'MD5'}

    generate_model()

    dbt_logs = dbt_runner.run_dbt_models(dbt_init, model_names=[request.node.name],
                                         args=var_dict)
    dbt_logs_logs = dbt_runner.run_dbt_models(dbt_init, model_names=[request.node.name],
                                              args=var_dict, logs_required=True)
    actual_sql = macro_test_helpers.retrieve_compiled_model(request.node.name)
    expected_sql = macro_test_helpers.retrieve_expected_sql(request)

    assert dbt_logs
    assert actual_sql == expected_sql

    assert "Configured hash ('md5') not recognised. Must be one of: md5, sha (case insensitive)" not in dbt_logs_logs


@pytest.mark.macro
def test_select_hash_alg_is_successful_md5_with_lower(request, generate_model):
    var_dict = {'hash': 'md5'}

    generate_model()

    dbt_logs = dbt_runner.run_dbt_models(dbt_init, model_names=[request.node.name],
                                         args=var_dict)
    actual_sql = macro_test_helpers.retrieve_compiled_model(request.node.name)
    expected_sql = macro_test_helpers.retrieve_expected_sql(request)

    assert dbt_logs
    assert actual_sql == expected_sql


@pytest.mark.macro
def test_select_hash_alg_is_successful_sha_with_upper(request, generate_model):
    var_dict = {'hash': 'SHA'}

    generate_model()

    dbt_logs = dbt_runner.run_dbt_models(dbt_init, model_names=[request.node.name],
                                         args=var_dict)
    dbt_logs_logs = dbt_runner.run_dbt_models(dbt_init, model_names=[request.node.name],
                                              args=var_dict, logs_required=True)
    actual_sql = macro_test_helpers.retrieve_compiled_model(request.node.name)
    expected_sql = macro_test_helpers.retrieve_expected_sql(request)

    assert dbt_logs
    assert actual_sql == expected_sql

    assert "Configured hash ('sha') not recognised. Must be one of: md5, sha (case insensitive)" not in dbt_logs_logs


@pytest.mark.macro
def test_select_hash_alg_is_successful_sha_with_lower(request, generate_model):
    var_dict = {'hash': 'sha'}

    generate_model()

    dbt_logs = dbt_runner.run_dbt_models(dbt_init, model_names=[request.node.name],
                                         args=var_dict)
    actual_sql = macro_test_helpers.retrieve_compiled_model(request.node.name)
    expected_sql = macro_test_helpers.retrieve_expected_sql(request)

    assert dbt_logs
    assert actual_sql == expected_sql


@pytest.mark.macro
def test_select_hash_alg_is_successful_empty_defaults_to_md5(request, generate_model):
    var_dict = {'hash': ''}

    generate_model()

    dbt_logs = dbt_runner.run_dbt_models(dbt_init, model_names=[request.node.name],
                                         args=var_dict)
    dbt_logs_logs = dbt_runner.run_dbt_models(dbt_init, model_names=[request.node.name],
                                              args=var_dict, logs_required=True)
    actual_sql = macro_test_helpers.retrieve_compiled_model(request.node.name)
    expected_sql = macro_test_helpers.retrieve_expected_sql(request)

    assert dbt_logs
    assert actual_sql == expected_sql

    assert "Configured hash ('') not recognised. Must be one of: md5, sha (case insensitive)" in dbt_logs_logs


@pytest.mark.macro
def test_select_hash_alg_is_successful_none_defaults_to_md5(request, generate_model):
    var_dict = {'hash': 'sha1'}

    generate_model()

    dbt_logs = dbt_runner.run_dbt_models(dbt_init, model_names=[request.node.name],
                                         args=var_dict)

    assert "Configured hash ('sha1') not recognised. Must be one of: md5, sha (case insensitive)" in dbt_logs


@pytest.mark.macro
def test_select_hash_alg_is_successful_none_defaults_to_md5(request, generate_model):
    var_dict = {'hash': 'SHA1'}

    generate_model()

    dbt_logs = dbt_runner.run_dbt_models(dbt_init, model_names=[request.node.name],
                                         args=var_dict, logs_required=True)

    assert "Configured hash ('sha1') not recognised. Must be one of: md5, sha (case insensitive)" in dbt_logs
