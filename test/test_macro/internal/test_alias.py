import pytest

from test import dbt_runner, macro_test_helpers

macro_name = "alias"


@pytest.mark.macro
def test_alias_single_correctly_generates_sql(request, generate_model):
    var_dict = {'alias_config': {"source_column": "CUSTOMER_HASHDIFF", "alias": "HASHDIFF"}, 'prefix': 'c'}

    generate_model()

    dbt_logs = dbt_runner.run_dbt_models(model_names=[request.node.name],
                                         args=var_dict)

    actual_sql = macro_test_helpers.retrieve_compiled_model(request.node.name)
    expected_sql = macro_test_helpers.retrieve_expected_sql(request)

    assert macro_test_helpers.is_successful_run(dbt_logs)
    assert actual_sql == expected_sql


@pytest.mark.macro
def test_alias_single_with_incorrect_column_format_in_metadata_raises_error(request, generate_model):
    var_dict = {'alias_config': {}, 'prefix': 'c'}

    generate_model()

    dbt_logs = dbt_runner.run_dbt_models(model_names=[request.node.name],
                                         args=var_dict)

    assert 'Invalid alias configuration:' in dbt_logs


@pytest.mark.macro
def test_alias_single_with_missing_column_metadata_raises_error(request, generate_model):
    var_dict = {'alias_config': '', 'prefix': 'c'}

    generate_model()

    dbt_logs = dbt_runner.run_dbt_models(model_names=[request.node.name],
                                         args=var_dict)

    assert 'Invalid alias configuration:' in dbt_logs


@pytest.mark.macro
def test_alias_single_with_undefined_column_metadata_raises_error(request, generate_model):
    var_dict = {'prefix': 'c'}

    generate_model()

    dbt_logs = dbt_runner.run_dbt_models(model_names=[request.node.name],
                                         args=var_dict)

    assert 'Invalid alias configuration:' in dbt_logs
