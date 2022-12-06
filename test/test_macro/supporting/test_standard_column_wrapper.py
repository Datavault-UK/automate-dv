import pytest

from test import dbt_runner, macro_test_helpers

macro_name = "standard_column_wrapper"


@pytest.mark.macro
def test_standard_column_wrapper_is_successful(request, generate_model):
    generate_model()

    dbt_logs = dbt_runner.run_dbt_models(model_names=[request.node.name],
                                         args=dict())
    actual_sql = macro_test_helpers.retrieve_compiled_model(request.node.name)
    expected_sql = macro_test_helpers.retrieve_expected_sql(request)

    assert macro_test_helpers.is_successful_run(dbt_logs)
    assert actual_sql == expected_sql
