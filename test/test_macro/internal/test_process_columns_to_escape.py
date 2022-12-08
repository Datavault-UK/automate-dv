import pytest

from test import dbt_runner, macro_test_helpers

macro_name = "process_columns_to_escape"


@pytest.mark.macro
def test_process_columns_to_escape_with_list_is_successful(request, generate_model):
    var_dict = {
        'derived_columns_list': {
            'CUSTOMER_DETAILS': {
                'source_column': ['CUSTOMER_NAME', 'CUSTOMER_DOB', 'PHONE'],
                'escape': True
            },
            'SOURCE': "!STG_BOOKING",
            'EFFECTIVE_FROM': 'LOAD_DATE'
        }
    }

    generate_model()

    dbt_logs = dbt_runner.run_dbt_models(model_names=[request.node.name],
                                         args=var_dict)

    actual_sql = macro_test_helpers.retrieve_compiled_model(request.node.name)
    expected_sql = macro_test_helpers.retrieve_expected_sql(request)

    assert macro_test_helpers.is_successful_run(dbt_logs)
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

    dbt_logs = dbt_runner.run_dbt_models(model_names=[request.node.name],
                                         args=var_dict)

    actual_sql = macro_test_helpers.retrieve_compiled_model(request.node.name)
    expected_sql = macro_test_helpers.retrieve_expected_sql(request)

    assert macro_test_helpers.is_successful_run(dbt_logs)
    assert actual_sql == expected_sql
