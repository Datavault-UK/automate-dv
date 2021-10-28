import pytest

from test import dbtvault_harness_utils

macro_name = "alias_all"


@pytest.mark.macro
def test_alias_all_correctly_generates_sql_for_full_alias_list_with_prefix(request, generate_model):
    var_dict = {'columns': [{"source_column": "CUSTOMER_HASHDIFF", "alias": "HASHDIFF"},
                            {"source_column": "ORDER_HASHDIFF", "alias": "HASHDIFF"},
                            {"source_column": "BOOKING_HASHDIFF", "alias": "HASHDIFF"}],
                'prefix': 'c'}

    generate_model()

    dbt_logs = dbtvault_harness_utils.run_dbt_models(model_names=[request.node.name],
                                                     args=var_dict)

    actual_sql = dbtvault_harness_utils.retrieve_compiled_model(request.node.name)
    expected_sql = dbtvault_harness_utils.retrieve_expected_sql(request)

    assert dbtvault_harness_utils.is_successful_run(dbt_logs)
    assert actual_sql == expected_sql


@pytest.mark.macro
def test_alias_all_correctly_generates_sql_for_partial_alias_list_with_prefix(request, generate_model):
    var_dict = {'columns': [{"source_column": "CUSTOMER_HASHDIFF", "alias": "HASHDIFF"},
                            "ORDER_HASHDIFF",
                            {"source_column": "BOOKING_HASHDIFF", "alias": "HASHDIFF"}],
                'prefix': 'c'}

    generate_model()

    dbt_logs = dbtvault_harness_utils.run_dbt_models(model_names=[request.node.name],
                                                     args=var_dict)

    actual_sql = dbtvault_harness_utils.retrieve_compiled_model(request.node.name)
    expected_sql = dbtvault_harness_utils.retrieve_expected_sql(request)

    assert dbtvault_harness_utils.is_successful_run(dbt_logs)
    assert actual_sql == expected_sql


@pytest.mark.macro
def test_alias_all_correctly_generates_sql_for_full_alias_list_without_prefix(request, generate_model):
    var_dict = {'columns': [{"source_column": "CUSTOMER_HASHDIFF", "alias": "HASHDIFF"},
                            {"source_column": "ORDER_HASHDIFF", "alias": "HASHDIFF"},
                            {"source_column": "BOOKING_HASHDIFF", "alias": "HASHDIFF"}]}

    generate_model()

    dbt_logs = dbtvault_harness_utils.run_dbt_models(model_names=[request.node.name],
                                                     args=var_dict)

    actual_sql = dbtvault_harness_utils.retrieve_compiled_model(request.node.name)
    expected_sql = dbtvault_harness_utils.retrieve_expected_sql(request)

    assert dbtvault_harness_utils.is_successful_run(dbt_logs)
    assert actual_sql == expected_sql


@pytest.mark.macro
def test_alias_all_correctly_generates_sql_for_partial_alias_list_without_prefix(request, generate_model):
    var_dict = {'columns': [{"source_column": "CUSTOMER_HASHDIFF", "alias": "HASHDIFF"},
                            "ORDER_HASHDIFF",
                            {"source_column": "BOOKING_HASHDIFF", "alias": "HASHDIFF"}]}

    generate_model()

    dbt_logs = dbtvault_harness_utils.run_dbt_models(model_names=[request.node.name],
                                                     args=var_dict)

    actual_sql = dbtvault_harness_utils.retrieve_compiled_model(request.node.name)
    expected_sql = dbtvault_harness_utils.retrieve_expected_sql(request)

    assert dbtvault_harness_utils.is_successful_run(dbt_logs)
    assert actual_sql == expected_sql
