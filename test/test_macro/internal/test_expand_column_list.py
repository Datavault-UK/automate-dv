import pytest

from test import dbtvault_harness_utils

macro_name = "expand_column_list"


@pytest.mark.macro
def test_expand_column_list_correctly_generates_list_with_nesting(request, generate_model):
    var_dict = {'columns': ['CUSTOMER_PK', ['ORDER_FK', 'BOOKING_FK']]}

    generate_model()

    dbt_logs = dbtvault_harness_utils.run_dbt_models(model_names=[request.node.name],
                                                     args=var_dict)

    actual_sql = dbtvault_harness_utils.retrieve_compiled_model(request.node.name)
    expected_sql = dbtvault_harness_utils.retrieve_expected_sql(request)

    assert dbtvault_harness_utils.is_successful_run(dbt_logs)
    assert actual_sql == expected_sql


@pytest.mark.macro
def test_expand_column_list_correctly_generates_list_with_extra_nesting(request, generate_model):
    var_dict = {'columns': ['CUSTOMER_PK', ['ORDER_FK', ['BOOKING_FK', 'TEST_COLUMN']]]}

    generate_model()

    dbt_logs = dbtvault_harness_utils.run_dbt_models(model_names=[request.node.name],
                                                     args=var_dict)

    actual_sql = dbtvault_harness_utils.retrieve_compiled_model(request.node.name)
    expected_sql = dbtvault_harness_utils.retrieve_expected_sql(request)

    assert dbtvault_harness_utils.is_successful_run(dbt_logs)
    assert actual_sql == expected_sql


@pytest.mark.macro
def test_expand_column_list_correctly_generates_list_with_no_nesting(request, generate_model):
    var_dict = {'columns': ['CUSTOMER_PK', 'ORDER_FK', 'BOOKING_FK']}

    generate_model()

    dbt_logs = dbtvault_harness_utils.run_dbt_models(model_names=[request.node.name],
                                                     args=var_dict)

    actual_sql = dbtvault_harness_utils.retrieve_compiled_model(request.node.name)
    expected_sql = dbtvault_harness_utils.retrieve_expected_sql(request)

    assert dbtvault_harness_utils.is_successful_run(dbt_logs)
    assert actual_sql == expected_sql


@pytest.mark.macro
def test_expand_column_list_raises_error_with_missing_columns(request, generate_model):
    generate_model()

    dbt_logs = dbtvault_harness_utils.run_dbt_models(model_names=[request.node.name])

    assert 'Expected a list of columns, got: None' in dbt_logs
