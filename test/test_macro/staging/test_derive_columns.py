import pytest

import dbtvault_harness_utils

macro_name = "derive_columns"


@pytest.mark.macro
def test_derive_columns_correctly_generates_sql_with_source_columns(request):
    var_dict = {'source_model': 'raw_source', 'columns': {'SOURCE': "!STG_BOOKING", 'EFFECTIVE_FROM': 'LOADDATE'}}

    dbt_logs = dbtvault_harness_utils.run_dbt_models(model_names=[request.node.name],
                                                     args=var_dict)
    actual_sql = dbtvault_harness_utils.retrieve_compiled_model(request.node.name)
    expected_sql = dbtvault_harness_utils.retrieve_expected_sql(request)

    assert dbtvault_harness_utils.is_successful_run(dbt_logs)
    assert expected_sql == actual_sql


@pytest.mark.macro
def test_derive_columns_correctly_generates_sql_without_source_columns(request):
    var_dict = {'columns': {'SOURCE': "!STG_BOOKING", 'LOADDATE': 'EFFECTIVE_FROM'}}

    dbt_logs = dbtvault_harness_utils.run_dbt_models(model_names=[request.node.name],
                                                     args=var_dict)
    actual_sql = dbtvault_harness_utils.retrieve_compiled_model(request.node.name)
    expected_sql = dbtvault_harness_utils.retrieve_expected_sql(request)

    assert dbtvault_harness_utils.is_successful_run(dbt_logs)
    assert expected_sql == actual_sql


@pytest.mark.macro
def test_derive_columns_raises_error_with_only_source_columns(request):
    var_dict = {'source_model': 'raw_source'}

    dbt_logs = dbtvault_harness_utils.run_dbt_models(model_names=[request.node.name],
                                                     args=var_dict)

    assert "Invalid column configuration:" in dbt_logs
