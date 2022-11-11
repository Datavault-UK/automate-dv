import pytest

from test import dbt_runner, macro_test_helpers

macro_name = "create_ghost_record"

@pytest.mark.macro
def test_create_ghost_record_with_all_string(request, generate_model):
    var_dict = {
        "source_model": "raw_source_sat",
        "src_pk": "CUSTOMER_PK",
        "src_hashdiff": "HASHDIFF",
        "src_payload": "TEST_COLUMN_1",
        "src_eff": "EFFECTIVE_FROM",
        "src_ldts": "LOAD_DATE",
        "src_source": "SOURCE",
        "src_extra_columns": "none"
    }

    generate_model()

    dbt_logs = dbt_runner.run_dbt_models(model_names=[request.node.name], args=var_dict)

    actual_sql = macro_test_helpers.retrieve_compiled_model(request.node.name)
    expected_sql = macro_test_helpers.retrieve_expected_sql(request)

    assert macro_test_helpers.is_successful_run(dbt_logs)
    assert actual_sql == expected_sql
