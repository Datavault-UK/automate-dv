import pytest

from test import dbt_runner, macro_test_helpers

macro_name = "create_ghost_record"


@pytest.mark.macro
def test_create_ghost_record_with_all_string(request, generate_model):
    var_dict = {
        "source_model": "raw_source_sat",
        "src_pk": '"CUSTOMER_PK"',
        "src_hashdiff": '"HASHDIFF"',
        "src_payload": '"TEST_COLUMN_1"',
        "src_eff": '"EFFECTIVE_FROM"',
        "src_ldts": '"LOAD_DATE"',
        "src_source": '"RECORD_SOURCE"',
        "src_extra_columns": '"none"'
    }

    generate_model()

    dbt_logs = dbt_runner.run_dbt_models(model_names=[request.node.name], args=var_dict)

    actual_sql = macro_test_helpers.retrieve_compiled_model(request.node.name)
    expected_sql = macro_test_helpers.retrieve_expected_sql(request)

    assert macro_test_helpers.is_successful_run(dbt_logs)
    assert actual_sql == expected_sql


@pytest.mark.macro
def test_create_ghost_record_with_payload_and_extra_columns_as_lists(request, generate_model):
    var_dict = {
        "source_model": "raw_source_sat",
        "src_pk": '"CUSTOMER_PK"',
        "src_hashdiff": '"HASHDIFF"',
        "src_payload": '["TEST_COLUMN_1", "TEST_COLUMN_2", "TEST_COLUMN_3"]',
        "src_eff": '"EFFECTIVE_FROM"',
        "src_ldts": '"LOAD_DATE"',
        "src_source": '"RECORD_SOURCE"',
        "src_extra_columns": '["TEST_COLUMN_4", "TEST_COLUMN_5", "TEST_COLUMN_6"]'
    }

    generate_model()

    dbt_logs = dbt_runner.run_dbt_models(model_names=[request.node.name], args=var_dict)

    actual_sql = macro_test_helpers.retrieve_compiled_model(request.node.name)
    expected_sql = macro_test_helpers.retrieve_expected_sql(request)

    assert macro_test_helpers.is_successful_run(dbt_logs)
    assert actual_sql == expected_sql


@pytest.mark.macro
def test_create_ghost_record_with_all_string_hashing_with_sha(request, generate_model):
    var_dict = {
        "source_model": "raw_source_sat",
        "src_pk": '"CUSTOMER_PK"',
        "src_hashdiff": '"HASHDIFF"',
        "src_payload": '"TEST_COLUMN_1"',
        "src_eff": '"EFFECTIVE_FROM"',
        "src_ldts": '"LOAD_DATE"',
        "src_source": '"RECORD_SOURCE"',
        "src_extra_columns": '"none"',
        'hash': 'SHA'
    }

    generate_model()

    dbt_logs = dbt_runner.run_dbt_models(model_names=[request.node.name], args=var_dict)

    actual_sql = macro_test_helpers.retrieve_compiled_model(request.node.name)
    expected_sql = macro_test_helpers.retrieve_expected_sql(request)

    assert macro_test_helpers.is_successful_run(dbt_logs)
    assert actual_sql == expected_sql

@pytest.mark.macro
def test_create_ghost_record_with_payload_and_extra_columns_as_lists_hashing_with_sha(request, generate_model):
    var_dict = {
        "source_model": "raw_source_sat",
        "src_pk": '"CUSTOMER_PK"',
        "src_hashdiff": '"HASHDIFF"',
        "src_payload": '["TEST_COLUMN_1", "TEST_COLUMN_2", "TEST_COLUMN_3"]',
        "src_eff": '"EFFECTIVE_FROM"',
        "src_ldts": '"LOAD_DATE"',
        "src_source": '"RECORD_SOURCE"',
        "src_extra_columns": '["TEST_COLUMN_4", "TEST_COLUMN_5", "TEST_COLUMN_6"]',
        'hash': 'SHA'
    }

    generate_model()

    dbt_logs = dbt_runner.run_dbt_models(model_names=[request.node.name], args=var_dict)

    actual_sql = macro_test_helpers.retrieve_compiled_model(request.node.name)
    expected_sql = macro_test_helpers.retrieve_expected_sql(request)

    assert macro_test_helpers.is_successful_run(dbt_logs)
    assert actual_sql == expected_sql

@pytest.mark.macro
def test_create_ghost_record_with_all_string_and_different_source_system(request, generate_model):
    var_dict = {
        "source_model": "raw_source_sat",
        "src_pk": '"CUSTOMER_PK"',
        "src_hashdiff": '"HASHDIFF"',
        "src_payload": '"TEST_COLUMN_1"',
        "src_eff": '"EFFECTIVE_FROM"',
        "src_ldts": '"LOAD_DATE"',
        "src_source": '"RECORD_SOURCE"',
        "src_extra_columns": '"none"',
        'system_record_value': 'OTHER_SYSTEM'
    }

    generate_model()

    dbt_logs = dbt_runner.run_dbt_models(model_names=[request.node.name], args=var_dict)

    actual_sql = macro_test_helpers.retrieve_compiled_model(request.node.name)
    expected_sql = macro_test_helpers.retrieve_expected_sql(request)

    assert macro_test_helpers.is_successful_run(dbt_logs)
    assert actual_sql == expected_sql