import pytest

from test import dbt_runner, macro_test_helpers

macro_name = "hub"


@pytest.mark.single_source_hub
def test_hub_macro_correctly_generates_sql_for_single_source(request, generate_model):
    generate_model()

    dbt_logs = dbt_runner.run_dbt_models(model_names=[request.node.name],
                                         full_refresh=True)

    actual_sql = macro_test_helpers.retrieve_compiled_model(request.node.name)
    expected_sql = macro_test_helpers.retrieve_expected_sql(request)

    assert macro_test_helpers.is_successful_run(dbt_logs)
    assert actual_sql == expected_sql


@pytest.mark.single_source_multi_nk_hub
def test_hub_macro_correctly_generates_sql_for_single_source_multi_nk(request, generate_model):
    generate_model()

    dbt_logs = dbt_runner.run_dbt_models(model_names=[request.node.name],
                                         full_refresh=True)
    actual_sql = macro_test_helpers.retrieve_compiled_model(request.node.name)
    expected_sql = macro_test_helpers.retrieve_expected_sql(request)

    assert macro_test_helpers.is_successful_run(dbt_logs)
    assert actual_sql == expected_sql


@pytest.mark.single_source_hub
def test_hub_macro_correctly_generates_sql_for_incremental_single_source(request, generate_model):
    generate_model()

    dbt_logs_first_run = dbt_runner.run_dbt_models(mode='run',
                                                   model_names=[request.node.name],
                                                   full_refresh=True)
    dbt_logs_inc_run = dbt_runner.run_dbt_models(model_names=[request.node.name])
    actual_sql = macro_test_helpers.retrieve_compiled_model(request.node.name)
    expected_sql = macro_test_helpers.retrieve_expected_sql(request)

    assert macro_test_helpers.is_successful_run(dbt_logs_first_run)
    assert macro_test_helpers.is_successful_run(dbt_logs_inc_run)
    assert actual_sql == expected_sql


@pytest.mark.single_source_multi_nk_hub
def test_hub_macro_correctly_generates_sql_for_incremental_single_source_multi_nk(request, generate_model):
    generate_model()

    dbt_logs_first_run = dbt_runner.run_dbt_models(mode='run',
                                                   model_names=[request.node.name],
                                                   full_refresh=True)
    dbt_logs_inc_run = dbt_runner.run_dbt_models(model_names=[request.node.name])
    actual_sql = macro_test_helpers.retrieve_compiled_model(request.node.name)
    expected_sql = macro_test_helpers.retrieve_expected_sql(request)

    assert macro_test_helpers.is_successful_run(dbt_logs_first_run)
    assert macro_test_helpers.is_successful_run(dbt_logs_inc_run)
    assert actual_sql == expected_sql


@pytest.mark.multi_source_hub
def test_hub_macro_correctly_generates_sql_for_multi_source(request, generate_model):
    generate_model()

    dbt_logs = dbt_runner.run_dbt_models(model_names=[request.node.name],
                                         full_refresh=True)
    actual_sql = macro_test_helpers.retrieve_compiled_model(request.node.name)
    expected_sql = macro_test_helpers.retrieve_expected_sql(request)

    assert macro_test_helpers.is_successful_run(dbt_logs)
    assert actual_sql == expected_sql


@pytest.mark.multi_source_multi_nk_hub
def test_hub_macro_correctly_generates_sql_for_multi_source_multi_nk(request, generate_model):
    generate_model()

    dbt_logs = dbt_runner.run_dbt_models(model_names=[request.node.name],
                                         full_refresh=True)
    actual_sql = macro_test_helpers.retrieve_compiled_model(request.node.name)
    expected_sql = macro_test_helpers.retrieve_expected_sql(request)

    assert macro_test_helpers.is_successful_run(dbt_logs)
    assert actual_sql == expected_sql


@pytest.mark.multi_source_hub
def test_hub_macro_correctly_generates_sql_for_incremental_multi_source(request, generate_model):
    generate_model()

    dbt_logs_first_run = dbt_runner.run_dbt_models(mode='run',
                                                   model_names=[request.node.name],
                                                   full_refresh=True)
    dbt_logs_inc_run = dbt_runner.run_dbt_models(model_names=[request.node.name])
    actual_sql = macro_test_helpers.retrieve_compiled_model(request.node.name)
    expected_sql = macro_test_helpers.retrieve_expected_sql(request)

    assert macro_test_helpers.is_successful_run(dbt_logs_first_run)
    assert macro_test_helpers.is_successful_run(dbt_logs_inc_run)
    assert actual_sql == expected_sql


@pytest.mark.multi_source_multi_nk_hub
def test_hub_macro_correctly_generates_sql_for_incremental_multi_source_multi_nk(request, generate_model):
    generate_model()

    dbt_logs_first_run = dbt_runner.run_dbt_models(mode='run',
                                                   model_names=[request.node.name],
                                                   full_refresh=True)
    dbt_logs_inc_run = dbt_runner.run_dbt_models(model_names=[request.node.name])
    actual_sql = macro_test_helpers.retrieve_compiled_model(request.node.name)
    expected_sql = macro_test_helpers.retrieve_expected_sql(request)

    assert macro_test_helpers.is_successful_run(dbt_logs_first_run)
    assert macro_test_helpers.is_successful_run(dbt_logs_inc_run)
    assert actual_sql == expected_sql
