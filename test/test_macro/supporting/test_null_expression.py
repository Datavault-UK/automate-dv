import pytest

import test
import os

from test import dbt_runner, macro_test_helpers
from dbt.cli.main import dbtRunner

macro_name = "null_expression"

dbt_init = dbtRunner()


@pytest.mark.macro
def test_null_expression_is_successful(request, generate_model):
    var_dict = {'column_str': 'TEST_COLUMN'}

    generate_model()

    dbt_logs = dbt_runner.run_dbt_models(dbt_init, model_names=[request.node.name],
                                         args=var_dict)
    actual_sql = macro_test_helpers.retrieve_compiled_model(request.node.name)
    expected_sql = macro_test_helpers.retrieve_expected_sql(request)

    assert dbt_logs
    assert actual_sql == expected_sql


@pytest.mark.macro
def test_null_expression_with_custom_placeholder_is_successful(request, generate_model):
    var_dict = {'column_str': 'TEST_COLUMN',
                'null_placeholder_string': '!!'}

    generate_model()

    dbt_logs = dbt_runner.run_dbt_models(dbt_init, model_names=[request.node.name],
                                         args=var_dict)
    actual_sql = macro_test_helpers.retrieve_compiled_model(request.node.name)
    expected_sql = macro_test_helpers.retrieve_expected_sql(request)

    assert dbt_logs
    assert actual_sql == expected_sql


@pytest.mark.macro
def test_null_expression_with_no_column_str_raises_errors(request, generate_model):
    generate_model()

    dbt_logs = dbt_runner.run_dbt_models(dbt_init, model_names=[request.node.name],
                                         args=dict(), logs_required=True)

    assert "Must provide a column_str argument to null expression macro!" in dbt_logs
