import pytest

from test import dbtvault_harness_utils

macro_name = "as_constant"


@pytest.mark.macro
def test_as_constant_single_correctly_generates_string(request, generate_model):
    var_dict = {'column_str': '!STG_BOOKING'}

    generate_model()

    dbt_logs = dbtvault_harness_utils.run_dbt_models(model_names=[request.node.name],
                                                     args=var_dict)

    actual_sql = dbtvault_harness_utils.retrieve_compiled_model(request.node.name)
    expected_sql = dbtvault_harness_utils.retrieve_expected_sql(request)

    assert dbtvault_harness_utils.is_successful_run(dbt_logs)
    assert actual_sql == expected_sql
