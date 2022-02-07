import pytest

from test import dbtvault_harness_utils

macro_name = "as_constant"


@pytest.mark.macro
def test_as_constant_single_correctly_generates_string(request, generate_model):
    var_dict = {'column_str': '!STG_BOOKING'}

    generate_model()

    dbt_logs = dbtvault_harness_utils.run_dbt_models(model_names=[request.node.name],
                                                     args=var_dict)

    actual_sql = dbtvault_harness_utils.retrieve_compiled_model(request.node.name)
    expected_sql = dbtvault_harness_utils.retrieve_expected_sql(request)

    assert dbtvault_harness_utils.is_successful_run(dbt_logs)
    assert actual_sql == expected_sql


@pytest.mark.macro
def test_as_constant_column_name_correctly_generates_string(request, generate_model):
    var_dict = {'column_str': 'STG_BOOKING'}

    generate_model()

    dbt_logs = dbtvault_harness_utils.run_dbt_models(model_names=[request.node.name],
                                                     args=var_dict)

    actual_sql = dbtvault_harness_utils.retrieve_compiled_model(request.node.name)
    expected_sql = dbtvault_harness_utils.retrieve_expected_sql(request)

    assert dbtvault_harness_utils.is_successful_run(dbt_logs)
    assert actual_sql == expected_sql


@pytest.mark.macro
def test_as_constant_column_str_is_empty_string_raises_error(request, generate_model):
    var_dict = {'column_str': ''}

    generate_model()

    dbt_logs = dbtvault_harness_utils.run_dbt_models(model_names=[request.node.name],
                                                     args=var_dict)

    assert "Invalid columns_str object provided. Must be a string and not null." in dbt_logs


@pytest.mark.macro
def test_as_comstant_column_str_is_none_raises_error(request, generate_model):
    var_dict = {'column_str': None}

    generate_model()

    dbt_logs = dbtvault_harness_utils.run_dbt_models(model_names=[request.node.name],
                                                     args=var_dict)

    assert "Invalid columns_str object provided. Must be a string and not null." in dbt_logs


@pytest.mark.macro
def test_as_constant_expression1_is_successful(request, generate_model):
    var_dict = {'column_str': 'STATUS::INT'}

    generate_model()

    dbt_logs = dbtvault_harness_utils.run_dbt_models(model_names=[request.node.name],
                                                     args=var_dict)

    actual_sql = dbtvault_harness_utils.retrieve_compiled_model(request.node.name)
    expected_sql = dbtvault_harness_utils.retrieve_expected_sql(request)

    assert dbtvault_harness_utils.is_successful_run(dbt_logs)
    assert actual_sql == expected_sql


@pytest.mark.macro
def test_as_constant_expression2_is_successful(request, generate_model):
    var_dict = {'column_str': 'CAST(STATUS AS INT)'}

    generate_model()

    dbt_logs = dbtvault_harness_utils.run_dbt_models(model_names=[request.node.name],
                                                     args=var_dict)

    actual_sql = dbtvault_harness_utils.retrieve_compiled_model(request.node.name)
    expected_sql = dbtvault_harness_utils.retrieve_expected_sql(request)

    assert dbtvault_harness_utils.is_successful_run(dbt_logs)
    assert actual_sql == expected_sql


