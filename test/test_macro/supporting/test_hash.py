import pytest

from test import dbt_runner, macro_test_helpers

macro_name = "hash"


@pytest.mark.macro
def test_hash_single_column_is_successful_md5(request, generate_model):
    var_dict = {'columns': "CUSTOMER_ID", 'alias': 'CUSTOMER_PK'}

    generate_model()

    dbt_logs = dbt_runner.run_dbt_models(model_names=[request.node.name],
                                         args=var_dict)
    actual_sql = macro_test_helpers.retrieve_compiled_model(request.node.name)
    expected_sql = macro_test_helpers.retrieve_expected_sql(request)

    assert macro_test_helpers.is_successful_run(dbt_logs)
    assert actual_sql == expected_sql


@pytest.mark.macro
def test_hash_single_column_is_successful_sha(request, generate_model):
    var_dict = {'columns': "CUSTOMER_ID", 'alias': 'CUSTOMER_PK', 'hash': 'SHA'}

    generate_model()

    dbt_logs = dbt_runner.run_dbt_models(model_names=[request.node.name],
                                         args=var_dict)
    actual_sql = macro_test_helpers.retrieve_compiled_model(request.node.name)
    expected_sql = macro_test_helpers.retrieve_expected_sql(request)

    assert macro_test_helpers.is_successful_run(dbt_logs)
    assert actual_sql == expected_sql


@pytest.mark.macro
def test_hash_single_item_list_column_for_pk_is_successful(request, generate_model):
    var_dict = {'columns': ["CUSTOMER_ID"], 'alias': 'CUSTOMER_PK'}

    generate_model()

    dbt_logs = dbt_runner.run_dbt_models(model_names=[request.node.name],
                                         args=var_dict)
    actual_sql = macro_test_helpers.retrieve_compiled_model(request.node.name)
    expected_sql = macro_test_helpers.retrieve_expected_sql(request)

    assert macro_test_helpers.is_successful_run(dbt_logs)
    assert actual_sql == expected_sql


@pytest.mark.macro
def test_hash_single_item_list_column_for_hashdiff_is_successful(request, generate_model):
    var_dict = {'columns': ["CUSTOMER_ID"], 'alias': 'HASHDIFF', 'is_hashdiff': 'true'}

    generate_model()

    dbt_logs = dbt_runner.run_dbt_models(model_names=[request.node.name],
                                         args=var_dict)
    actual_sql = macro_test_helpers.retrieve_compiled_model(request.node.name)
    expected_sql = macro_test_helpers.retrieve_expected_sql(request)

    assert macro_test_helpers.is_successful_run(dbt_logs)
    assert actual_sql == expected_sql


@pytest.mark.macro
def test_hash_multi_column_as_pk_is_successful_md5(request, generate_model):
    var_dict = {'columns': ['CUSTOMER_ID', 'PHONE', 'DOB'], 'alias': 'CUSTOMER_PK'}

    generate_model()

    dbt_logs = dbt_runner.run_dbt_models(model_names=[request.node.name],
                                         args=var_dict)
    actual_sql = macro_test_helpers.retrieve_compiled_model(request.node.name)
    expected_sql = macro_test_helpers.retrieve_expected_sql(request)

    assert macro_test_helpers.is_successful_run(dbt_logs)
    assert actual_sql == expected_sql


@pytest.mark.macro
def test_hash_multi_column_as_pk_is_successful_sha(request, generate_model):
    var_dict = {'columns': ['CUSTOMER_ID', 'PHONE', 'DOB'],
                'alias': 'CUSTOMER_PK', 'hash': 'SHA'}

    generate_model()

    dbt_logs = dbt_runner.run_dbt_models(model_names=[request.node.name],
                                         args=var_dict)
    actual_sql = macro_test_helpers.retrieve_compiled_model(request.node.name)
    expected_sql = macro_test_helpers.retrieve_expected_sql(request)

    assert macro_test_helpers.is_successful_run(dbt_logs)
    assert actual_sql == expected_sql


@pytest.mark.macro
def test_hash_multi_column_as_pk_is_successful_custom_concat(request, generate_model):
    var_dict = {'columns': ['CUSTOMER_ID', 'PHONE', 'DOB'], 'alias': 'CUSTOMER_PK', 'concat_string': '~~'}

    generate_model()

    dbt_logs = dbt_runner.run_dbt_models(model_names=[request.node.name],
                                         args=var_dict)
    actual_sql = macro_test_helpers.retrieve_compiled_model(request.node.name)
    expected_sql = macro_test_helpers.retrieve_expected_sql(request)

    assert macro_test_helpers.is_successful_run(dbt_logs)
    assert actual_sql == expected_sql


@pytest.mark.macro
def test_hash_multi_column_as_pk_is_successful_custom_null(request, generate_model):
    var_dict = {'columns': ['CUSTOMER_ID', 'PHONE', 'DOB'], 'alias': 'CUSTOMER_PK', 'null_placeholder_string': '!!'}

    generate_model()

    dbt_logs = dbt_runner.run_dbt_models(model_names=[request.node.name],
                                         args=var_dict)
    actual_sql = macro_test_helpers.retrieve_compiled_model(request.node.name)
    expected_sql = macro_test_helpers.retrieve_expected_sql(request)

    assert macro_test_helpers.is_successful_run(dbt_logs)
    assert actual_sql == expected_sql


@pytest.mark.macro
def test_hash_multi_column_as_pk_is_successful_custom_null_concat(request, generate_model):
    var_dict = {'columns': ['CUSTOMER_ID', 'PHONE', 'DOB'], 'alias': 'CUSTOMER_PK',
                'concat_string': '@@', 'null_placeholder_string': '!!'}

    generate_model()

    dbt_logs = dbt_runner.run_dbt_models(model_names=[request.node.name],
                                         args=var_dict)
    actual_sql = macro_test_helpers.retrieve_compiled_model(request.node.name)
    expected_sql = macro_test_helpers.retrieve_expected_sql(request)

    assert macro_test_helpers.is_successful_run(dbt_logs)
    assert actual_sql == expected_sql


@pytest.mark.macro
def test_hash_multi_column_as_hashdiff_is_successful_md5(request, generate_model):
    var_dict = {'columns': ['CUSTOMER_ID', 'PHONE', 'DOB'], 'alias': 'HASHDIFF',
                'is_hashdiff': 'true'}

    generate_model()

    dbt_logs = dbt_runner.run_dbt_models(model_names=[request.node.name],
                                         args=var_dict)
    actual_sql = macro_test_helpers.retrieve_compiled_model(request.node.name)
    expected_sql = macro_test_helpers.retrieve_expected_sql(request)

    assert macro_test_helpers.is_successful_run(dbt_logs)
    assert actual_sql == expected_sql


@pytest.mark.macro
def test_hash_multi_column_as_hashdiff_is_successful_sha(request, generate_model):
    var_dict = {'columns': ['CUSTOMER_ID', 'PHONE', 'DOB'], 'alias': 'HASHDIFF',
                'is_hashdiff': 'true', 'hash': 'SHA'}

    generate_model()

    dbt_logs = dbt_runner.run_dbt_models(model_names=[request.node.name],
                                         args=var_dict)
    actual_sql = macro_test_helpers.retrieve_compiled_model(request.node.name)
    expected_sql = macro_test_helpers.retrieve_expected_sql(request)

    assert macro_test_helpers.is_successful_run(dbt_logs)
    assert actual_sql == expected_sql


@pytest.mark.macro
def test_hash_single_column_expression3_is_successful_md5(request, generate_model):
    var_dict = {'columns': "!SOMEVALUE", 'alias': 'CUSTOMER_PK'}

    generate_model()

    dbt_logs = dbt_runner.run_dbt_models(model_names=[request.node.name],
                                         args=var_dict)
    actual_sql = macro_test_helpers.retrieve_compiled_model(request.node.name)
    expected_sql = macro_test_helpers.retrieve_expected_sql(request)

    assert macro_test_helpers.is_successful_run(dbt_logs)
    assert actual_sql == expected_sql


@pytest.mark.macro
def test_hash_multi_column_expression4_is_successful_md5(request, generate_model):
    var_dict = {'columns': ['CUSTOMER_ID', 'PHONE', 'DOB', '!SOMEVALUE'], 'alias': 'CUSTOMER_PK'}

    generate_model()

    dbt_logs = dbt_runner.run_dbt_models(model_names=[request.node.name],
                                         args=var_dict)
    actual_sql = macro_test_helpers.retrieve_compiled_model(request.node.name)
    expected_sql = macro_test_helpers.retrieve_expected_sql(request)

    assert macro_test_helpers.is_successful_run(dbt_logs)
    assert actual_sql == expected_sql
