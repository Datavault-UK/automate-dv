import pytest

import dbtvault_harness_utils

macro_name = "prefix"


@pytest.mark.macro
def test_prefix_column_in_single_item_list_is_successful(request):
    var_dict = {'columns': ["CUSTOMER_HASHDIFF"], 'prefix': 'c'}

    dbt_logs = dbtvault_harness_utils.run_dbt_models(model_names=[request.node.name],
                                                     args=var_dict)
    actual_sql = dbtvault_harness_utils.retrieve_compiled_model(request.node.name)
    expected_sql = dbtvault_harness_utils.retrieve_expected_sql(request)

    assert dbtvault_harness_utils.is_successful_run(dbt_logs)
    assert expected_sql == actual_sql


@pytest.mark.macro
def test_prefix_multiple_columns_is_successful(request):
    var_dict = {'columns': ["CUSTOMER_HASHDIFF", 'CUSTOMER_PK', 'LOADDATE', 'SOURCE'], 'prefix': 'c'}

    dbt_logs = dbtvault_harness_utils.run_dbt_models(model_names=[request.node.name],
                                                     args=var_dict)
    actual_sql = dbtvault_harness_utils.retrieve_compiled_model(request.node.name)
    expected_sql = dbtvault_harness_utils.retrieve_expected_sql(request)

    assert dbtvault_harness_utils.is_successful_run(dbt_logs)
    assert expected_sql == actual_sql


@pytest.mark.macro
def test_prefix_aliased_column_is_successful(request):
    columns = [{"source_column": "CUSTOMER_HASHDIFF", "alias": "HASHDIFF"}, "CUSTOMER_PK", "LOADDATE"]
    var_dict = {'columns': columns, 'prefix': 'c'}

    dbt_logs = dbtvault_harness_utils.run_dbt_models(model_names=[request.node.name],
                                                     args=var_dict)
    actual_sql = dbtvault_harness_utils.retrieve_compiled_model(request.node.name)
    expected_sql = dbtvault_harness_utils.retrieve_expected_sql(request)

    assert dbtvault_harness_utils.is_successful_run(dbt_logs)
    assert expected_sql == actual_sql


@pytest.mark.macro
def test_prefix_aliased_column_with_alias_target_as_source_is_successful(request):
    columns = [{"source_column": "CUSTOMER_HASHDIFF", "alias": "HASHDIFF"}, "CUSTOMER_PK", "LOADDATE"]
    var_dict = {'columns': columns, 'prefix': 'c', 'alias_target': 'source'}

    dbt_logs = dbtvault_harness_utils.run_dbt_models(model_names=[request.node.name],
                                                     args=var_dict)
    actual_sql = dbtvault_harness_utils.retrieve_compiled_model(request.node.name)
    expected_sql = dbtvault_harness_utils.retrieve_expected_sql(request)

    assert dbtvault_harness_utils.is_successful_run(dbt_logs)
    assert expected_sql == actual_sql


@pytest.mark.macro
def test_prefix_aliased_column_with_alias_target_as_target_is_successful(request):
    columns = [{"source_column": "CUSTOMER_HASHDIFF", "alias": "HASHDIFF"}, "CUSTOMER_PK", "LOADDATE"]
    var_dict = {'columns': columns, 'prefix': 'c', 'alias_target': 'target'}

    dbt_logs = dbtvault_harness_utils.run_dbt_models(model_names=[request.node.name],
                                                     args=var_dict)
    actual_sql = dbtvault_harness_utils.retrieve_compiled_model(request.node.name)
    expected_sql = dbtvault_harness_utils.retrieve_expected_sql(request)

    assert dbtvault_harness_utils.is_successful_run(dbt_logs)
    assert expected_sql == actual_sql


@pytest.mark.macro
def test_prefix_with_no_columns_raises_error(request):
    var_dict = {'prefix': 'c', 'columns': []}

    dbt_logs = dbtvault_harness_utils.run_dbt_models(model_names=[request.node.name], args=var_dict)

    assert "Invalid parameters provided to prefix macro. Expected: " \
           "(columns [list/string], prefix_str [string]) got: ([], c)" in dbt_logs


@pytest.mark.macro
def test_prefix_with_empty_column_list_raises_error(request):
    var_dict = {'columns': [], 'prefix': 'c'}

    dbt_logs = dbtvault_harness_utils.run_dbt_models(model_names=[request.node.name], args=var_dict)

    assert "Invalid parameters provided to prefix macro. Expected: " \
           "(columns [list/string], prefix_str [string]) got: ([], c)" in dbt_logs
