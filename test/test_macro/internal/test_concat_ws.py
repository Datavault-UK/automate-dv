import pytest
from dbt.cli.main import dbtRunner

from test import dbt_runner, macro_test_helpers

macro_name = "concat_ws"

dbt_init = dbtRunner()


@pytest.mark.macro
def test_concat_ws_correctly_generates_string(request, generate_model):
    var_dict = {'string_list': [
        "BOOKING_DATE",
        'STG_BOOKING',
        "CUSTOMER_ID",
        "CUSTOMER_NAME"
    ]}

    generate_model()

    dbt_result, logs = dbt_runner.run_dbt_models(dbt_init, model_names=[request.node.name],
                                                 args=var_dict)

    actual_sql = macro_test_helpers.retrieve_compiled_model(request.node.name)
    expected_sql = macro_test_helpers.retrieve_expected_sql(request)

    assert dbt_result is True
    assert actual_sql == expected_sql
