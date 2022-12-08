import pytest

from test import dbt_runner, macro_test_helpers

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

    dbt_logs = dbt_runner.run_dbt_models(model_names=[request.node.name])

    actual_sql = macro_test_helpers.retrieve_compiled_model(request.node.name)
    expected_sql = macro_test_helpers.retrieve_expected_sql(request)

    assert macro_test_helpers.is_successful_run(dbt_logs)
    assert actual_sql == expected_sql


@pytest.mark.single_source_sat
def test_sat_correctly_generates_sql_when_hashdiff_columns_is_added_to_excluded(request, generate_model):
    metadata = {
        "source_model": "raw_source_sat",
        "src_pk": "CUSTOMER_PK",
        "src_hashdiff": "HASHDIFF",
        "src_payload": {
            "exclude_columns": "true",
            "columns":
                [
                    "HASHDIFF",
                    "TEST_COLUMN_4",
                    "TEST_COLUMN_5",
                ]
        },
        "src_eff": "EFFECTIVE_FROM",
        "src_ldts": "LOAD_DATE",
        "src_source": "RECORD_SOURCE"
    }

    generate_model(metadata)

    dbt_logs = dbt_runner.run_dbt_models(model_names=[request.node.name])

    actual_sql = macro_test_helpers.retrieve_compiled_model(request.node.name)
    expected_sql = macro_test_helpers.retrieve_expected_sql(request)

    assert macro_test_helpers.is_successful_run(dbt_logs)
    assert actual_sql == expected_sql


@pytest.mark.single_source_sat
def test_sat_correctly_generates_sql_when_all_required_columns_are_added_to_excluded(request, generate_model):
    metadata = {
        "source_model": "raw_source_sat",
        "src_pk": "CUSTOMER_PK",
        "src_hashdiff": "HASHDIFF",
        "src_payload": {
            "exclude_columns": "true",
            "columns":
                [
                    "RECORD_SOURCE",
                    "LOAD_DATE",
                    "EFFECTIVE_FROM",
                    "CUSTOMER_PK",
                    "HASHDIFF",
                    "TEST_COLUMN_4",
                    "TEST_COLUMN_5",
                ]
        },
        "src_eff": "EFFECTIVE_FROM",
        "src_ldts": "LOAD_DATE",
        "src_source": "RECORD_SOURCE"
    }

    generate_model(metadata)

    dbt_logs = dbt_runner.run_dbt_models(model_names=[request.node.name])

    actual_sql = macro_test_helpers.retrieve_compiled_model(request.node.name)
    expected_sql = macro_test_helpers.retrieve_expected_sql(request)

    assert macro_test_helpers.is_successful_run(dbt_logs)
    assert actual_sql == expected_sql


@pytest.mark.single_source_sat
def test_sat_correctly_generates_sql_when_all_columns_are_added_to_excluded(request, generate_model):
    metadata = {
        "source_model": "raw_source_sat",
        "src_pk": "CUSTOMER_PK",
        "src_hashdiff": "HASHDIFF",
        "src_payload": {
            "exclude_columns": "true",
            "columns":
                [
                    "TEST_COLUMN_1",
                    "TEST_COLUMN_2",
                    "TEST_COLUMN_3",
                    "TEST_COLUMN_4",
                    "TEST_COLUMN_5",
                    "TEST_COLUMN_6",
                    "TEST_COLUMN_7",
                    "TEST_COLUMN_8",
                    "TEST_COLUMN_9",
                ]
        },
        "src_eff": "EFFECTIVE_FROM",
        "src_ldts": "LOAD_DATE",
        "src_source": "RECORD_SOURCE"
    }

    generate_model(metadata)

    dbt_logs = dbt_runner.run_dbt_models(model_names=[request.node.name])

    actual_sql = macro_test_helpers.retrieve_compiled_model(request.node.name)
    expected_sql = macro_test_helpers.retrieve_expected_sql(request)

    assert macro_test_helpers.is_successful_run(dbt_logs)
    assert actual_sql == expected_sql


@pytest.mark.single_source_sat
def test_sat_correctly_generates_sql_when_no_columns_added_all_excluded(request, generate_model):
    metadata = {
        "source_model": "raw_source_sat",
        "src_pk": "CUSTOMER_PK",
        "src_hashdiff": "HASHDIFF",
        "src_payload": {
            "exclude_columns": "true"
        },
        "src_eff": "EFFECTIVE_FROM",
        "src_ldts": "LOAD_DATE",
        "src_source": "RECORD_SOURCE"
    }

    generate_model(metadata)

    dbt_logs = dbt_runner.run_dbt_models(model_names=[request.node.name])

    actual_sql = macro_test_helpers.retrieve_compiled_model(request.node.name)
    expected_sql = macro_test_helpers.retrieve_expected_sql(request)

    assert macro_test_helpers.is_successful_run(dbt_logs)
    assert actual_sql == expected_sql


@pytest.mark.single_source_sat
def test_sat_correctly_generates_sql_when_no_columns_added_all_excluded_incremental(request, generate_model):
    metadata = {
        "source_model": "raw_source_sat",
        "src_pk": "CUSTOMER_PK",
        "src_hashdiff": "HASHDIFF",
        "src_payload": {
            "exclude_columns": "true"
        },
        "src_eff": "EFFECTIVE_FROM",
        "src_ldts": "LOAD_DATE",
        "src_source": "RECORD_SOURCE"
    }

    generate_model(metadata)

    dbt_runner.run_dbt_models(mode='run', model_names=[request.node.name])
    dbt_logs = dbt_runner.run_dbt_models(mode='run', model_names=[request.node.name])

    actual_sql = macro_test_helpers.retrieve_compiled_model(request.node.name)
    expected_sql = macro_test_helpers.retrieve_expected_sql(request)

    assert macro_test_helpers.is_successful_run(dbt_logs)
    assert actual_sql == expected_sql
