import pytest
from dbt.cli.main import dbtRunner

from test import dbt_runner, macro_test_helpers

macro_name = "hub"

dbt_init = dbtRunner()


@pytest.mark.single_source_hub
def test_hub_macro_correctly_generates_sql_for_single_source(request, generate_model):
    generate_model()

    dbt_result, _ = dbt_runner.run_dbt_models(dbt_init, model_names=[request.node.name],
                                                     full_refresh=True)

    actual_sql = macro_test_helpers.retrieve_compiled_model(request.node.name)
    expected_sql = macro_test_helpers.retrieve_expected_sql(request)

    assert dbt_result is True
    assert actual_sql == expected_sql


@pytest.mark.single_source_multi_nk_hub
def test_hub_macro_correctly_generates_sql_for_single_source_multi_nk(request, generate_model):
    generate_model()

    dbt_result, _ = dbt_runner.run_dbt_models(dbt_init, model_names=[request.node.name],
                                              full_refresh=True)
    actual_sql = macro_test_helpers.retrieve_compiled_model(request.node.name)
    expected_sql = macro_test_helpers.retrieve_expected_sql(request)

    assert dbt_result is True
    assert actual_sql == expected_sql


@pytest.mark.single_source_hub
def test_hub_macro_correctly_generates_sql_for_incremental_single_source(request, generate_model):
    generate_model()

    dbt_results_first_run, _ = dbt_runner.run_dbt_models(dbt_init, mode='run',
                                                         model_names=[request.node.name],
                                                         full_refresh=True)
    dbt_results_inc_run, _ = dbt_runner.run_dbt_models(dbt_init, model_names=[request.node.name])

    actual_sql = macro_test_helpers.retrieve_compiled_model(request.node.name)
    expected_sql = macro_test_helpers.retrieve_expected_sql(request)

    assert dbt_results_first_run is True
    assert dbt_results_inc_run is True
    assert actual_sql == expected_sql


@pytest.mark.single_source_multi_nk_hub
def test_hub_macro_correctly_generates_sql_for_incremental_single_source_multi_nk(request, generate_model):
    generate_model()

    dbt_results_first_run = dbt_runner.run_dbt_models(dbt_init, mode='run',
                                                      model_names=[request.node.name],
                                                      full_refresh=True)
    dbt_results_inc_run = dbt_runner.run_dbt_models(dbt_init, model_names=[request.node.name])
    actual_sql = macro_test_helpers.retrieve_compiled_model(request.node.name)
    expected_sql = macro_test_helpers.retrieve_expected_sql(request)

    assert dbt_results_first_run is True
    assert dbt_results_inc_run is True
    assert actual_sql == expected_sql


@pytest.mark.multi_source_hub
def test_hub_macro_correctly_generates_sql_for_multi_source(request, generate_model):
    generate_model()

    dbt_result, dbt_logs = dbt_runner.run_dbt_models(dbt_init, model_names=[request.node.name],
                                                     full_refresh=True)
    actual_sql = macro_test_helpers.retrieve_compiled_model(request.node.name)
    expected_sql = macro_test_helpers.retrieve_expected_sql(request)

    assert dbt_result is True
    assert actual_sql == expected_sql


@pytest.mark.multi_source_multi_nk_hub
def test_hub_macro_correctly_generates_sql_for_multi_source_multi_nk(request, generate_model):
    generate_model()

    dbt_result, dbt_logs = dbt_runner.run_dbt_models(dbt_init, model_names=[request.node.name],
                                                     full_refresh=True)
    actual_sql = macro_test_helpers.retrieve_compiled_model(request.node.name)
    expected_sql = macro_test_helpers.retrieve_expected_sql(request)

    assert dbt_result is True
    assert actual_sql == expected_sql


@pytest.mark.multi_source_hub
def test_hub_macro_correctly_generates_sql_for_incremental_multi_source(request, generate_model):
    generate_model()

    dbt_results_first_run = dbt_runner.run_dbt_models(dbt_init, mode='run',
                                                      model_names=[request.node.name],
                                                      full_refresh=True)
    dbt_results_inc_run = dbt_runner.run_dbt_models(dbt_init, model_names=[request.node.name])
    actual_sql = macro_test_helpers.retrieve_compiled_model(request.node.name)
    expected_sql = macro_test_helpers.retrieve_expected_sql(request)

    assert dbt_results_first_run is True
    assert dbt_results_inc_run is True
    assert actual_sql == expected_sql


@pytest.mark.multi_source_multi_nk_hub
def test_hub_macro_correctly_generates_sql_for_incremental_multi_source_multi_nk(request, generate_model):
    generate_model()

    dbt_results_first_run = dbt_runner.run_dbt_models(dbt_init, mode='run',
                                                      model_names=[request.node.name],
                                                      full_refresh=True)
    dbt_results_inc_run = dbt_runner.run_dbt_models(dbt_init, model_names=[request.node.name])
    actual_sql = macro_test_helpers.retrieve_compiled_model(request.node.name)
    expected_sql = macro_test_helpers.retrieve_expected_sql(request)

    assert dbt_results_first_run is True
    assert dbt_results_inc_run is True
    assert actual_sql == expected_sql
