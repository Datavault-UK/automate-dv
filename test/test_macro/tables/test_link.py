import pytest

import test
import os

from test import dbt_runner, macro_test_helpers
from dbt.cli.main import dbtRunner

macro_name = "link"

dbt_init = dbtRunner()


@pytest.mark.single_source_link
def test_link_macro_correctly_generates_sql_for_single_source(request, generate_model):
    generate_model()

    dbt_logs = dbt_runner.run_dbt_models(dbt_init, model_names=[request.node.name],
                                         full_refresh=True)
    actual_sql = macro_test_helpers.retrieve_compiled_model(request.node.name)
    expected_sql = macro_test_helpers.retrieve_expected_sql(request)

    assert dbt_logs
    assert actual_sql == expected_sql


@pytest.mark.single_source_link
def test_link_macro_correctly_generates_sql_for_incremental_single_source(request, generate_model):
    generate_model()

    dbt_logs_first_run = dbt_runner.run_dbt_models(dbt_init, mode='run',
                                                   model_names=[request.node.name],
                                                   full_refresh=True)
    dbt_logs_inc_run = dbt_runner.run_dbt_models(dbt_init, model_names=[request.node.name])
    actual_sql = macro_test_helpers.retrieve_compiled_model(request.node.name)
    expected_sql = macro_test_helpers.retrieve_expected_sql(request)

    assert dbt_logs_first_run
    assert dbt_logs_inc_run
    assert actual_sql == expected_sql


@pytest.mark.multi_source_link
def test_link_macro_correctly_generates_sql_for_multi_source(request, generate_model):
    generate_model()

    dbt_logs = dbt_runner.run_dbt_models(dbt_init, model_names=[request.node.name],
                                         full_refresh=True)
    actual_sql = macro_test_helpers.retrieve_compiled_model(request.node.name)
    expected_sql = macro_test_helpers.retrieve_expected_sql(request)

    assert dbt_logs
    assert actual_sql == expected_sql


@pytest.mark.multi_source_link
def test_link_macro_correctly_generates_sql_for_incremental_multi_source(request, generate_model):
    generate_model()

    dbt_logs_first_run = dbt_runner.run_dbt_models(dbt_init, mode='run',
                                                   model_names=[request.node.name],
                                                   full_refresh=True)
    dbt_logs_inc_run = dbt_runner.run_dbt_models(dbt_init, model_names=[request.node.name])
    actual_sql = macro_test_helpers.retrieve_compiled_model(request.node.name)
    expected_sql = macro_test_helpers.retrieve_expected_sql(request)

    assert dbt_logs_first_run
    assert dbt_logs_inc_run
    assert actual_sql == expected_sql
