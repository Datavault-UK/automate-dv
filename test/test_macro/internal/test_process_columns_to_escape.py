import pytest

import test
import os

from test import dbt_runner, macro_test_helpers
from dbt.cli.main import dbtRunner

macro_name = "process_columns_to_escape"

dbt_init = dbtRunner()


@pytest.mark.macro
def test_process_columns_to_escape_with_list_is_successful(request, generate_model):
    var_dict = {
        'derived_columns_list': {
            'CUSTOMER_DETAILS': {
                'source_column': ['CUSTOMER_NAME', 'CUSTOMER DOB', 'PHONE'],
                'escape': True
            },
            'SOURCE': "!STG_BOOKING",
            'EFFECTIVE_FROM': 'LOAD_DATE'
        }
    }

    generate_model()

    dbt_result = dbt_runner.run_dbt_models(dbt_init, model_names=[request.node.name],
                                           args=var_dict)

    actual_sql = macro_test_helpers.retrieve_compiled_model(request.node.name)
    expected_sql = macro_test_helpers.retrieve_expected_sql(request)

    assert dbt_result is True
    assert actual_sql == expected_sql


@pytest.mark.macro
def test_process_columns_to_escape_with_string_is_successful(request, generate_model):
    var_dict = {
        'derived_columns_list': {
            'CUSTOMER_DETAILS': {
                'source_column': 'PHONE',
                'escape': True
            },
            'SOURCE': "!STG_BOOKING",
            'EFFECTIVE_FROM': 'LOAD_DATE'
        }
    }

    generate_model()

    dbt_result = dbt_runner.run_dbt_models(dbt_init, model_names=[request.node.name],
                                           args=var_dict)

    actual_sql = macro_test_helpers.retrieve_compiled_model(request.node.name)
    expected_sql = macro_test_helpers.retrieve_expected_sql(request)

    assert dbt_result is True
    assert actual_sql == expected_sql


@pytest.mark.macro
def test_process_columns_to_escape_with_not_string_is_successful(request, generate_model):
    var_dict = {
        'derived_columns_list': {
            'CUSTOMER_NAME': {
                'source_column': 'CUSTOMER NAME',
                'escape': True
            },
            'EFFECTIVE_FROM': 'LOAD_DATE',
            'SOURCE': '!RAW_STAGE',
            'INVERTED_FLAG': 'NOT "CUSTOMER FLAG"'
        }
    }

    generate_model()

    dbt_result = dbt_runner.run_dbt_models(dbt_init, model_names=[request.node.name],
                                           args=var_dict)

    actual_sql = macro_test_helpers.retrieve_compiled_model(request.node.name)
    expected_sql = macro_test_helpers.retrieve_expected_sql(request)

    assert dbt_result is True
    assert actual_sql == expected_sql


@pytest.mark.macro
def test_process_columns_to_escape_with_multiple_not_string_is_successful(request, generate_model):
    var_dict = {
        'derived_columns_list': {
            'EFFECTIVE_FROM': 'LOAD_DATE',
            'SOURCE': '!RAW_STAGE',
            'INVERTED_FLAG': 'NOT "CUSTOMER FLAG" AND NOT "CUSTOMER NAME"'
        }
    }

    generate_model()

    dbt_result = dbt_runner.run_dbt_models(dbt_init, model_names=[request.node.name],
                                           args=var_dict)

    actual_sql = macro_test_helpers.retrieve_compiled_model(request.node.name)
    expected_sql = macro_test_helpers.retrieve_expected_sql(request)

    assert dbt_result is True
    assert actual_sql == expected_sql
