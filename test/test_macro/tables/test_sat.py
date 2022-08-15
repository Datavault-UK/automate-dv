import pytest

from test import dbtvault_harness_utils

macro_name = "sat"


@pytest.mark.single_source_sat
def test_sat_correctly_generates_sql_for_payload_with_exclude_flag(request, generate_model):
    metadata = {
        "source_model": "raw_source_sat",
        "src_pk": "CUSTOMER_PK",
        "src_hashdiff": "HASHDIFF",
        "src_payload": {
            "exclude_columns": "true",
            "columns":
                [
                    "TEST_COLUMN_4",
                    "TEST_COLUMN_5",
                ]
        },
        "src_eff": "EFFECTIVE_FROM",
        "src_ldts": "LOAD_DATE",
        "src_source": "RECORD_SOURCE"
    }

    generate_model(metadata)

    dbt_logs = dbtvault_harness_utils.run_dbt_models(model_names=[request.node.name])

    actual_sql = dbtvault_harness_utils.retrieve_compiled_model(request.node.name)
    expected_sql = dbtvault_harness_utils.retrieve_expected_sql(request)

    assert dbtvault_harness_utils.is_successful_run(dbt_logs)
    assert actual_sql == expected_sql
