import pytest

from test import dbt_runner, macro_test_helpers

macro_name = "hash_columns"


@pytest.mark.macro
def test_hash_columns_correctly_generates_hashed_columns_for_single_columns(request, generate_model):
    metadata = {
        "columns": {
            "BOOKING_PK": "BOOKING_REF",
            "CUSTOMER_PK": "CUSTOMER_ID"
        }
    }

    generate_model(metadata)

    dbt_logs = dbt_runner.run_dbt_models(model_names=[request.node.name])

    actual_sql = macro_test_helpers.retrieve_compiled_model(request.node.name)
    expected_sql = macro_test_helpers.retrieve_expected_sql(request)

    assert macro_test_helpers.is_successful_run(dbt_logs)
    assert actual_sql == expected_sql


@pytest.mark.macro
def test_hash_columns_correctly_generates_hashed_columns_for_composite_columns_hashdiff(request, generate_model):
    metadata = {
        "columns": {
            "BOOKING_PK": "BOOKING_REF",
            "CUSTOMER_DETAILS": {
                "is_hashdiff": True,
                "columns":
                    ["ADDRESS", "PHONE", "NAME"]
            }
        }
    }

    generate_model(metadata)

    dbt_logs = dbt_runner.run_dbt_models(model_names=[request.node.name])

    actual_sql = macro_test_helpers.retrieve_compiled_model(request.node.name)
    expected_sql = macro_test_helpers.retrieve_expected_sql(request)

    assert macro_test_helpers.is_successful_run(dbt_logs)
    assert actual_sql == expected_sql


@pytest.mark.macro
def test_hash_columns_correctly_generates_hashed_columns_for_composite_columns_non_hashdiff(request, generate_model):
    metadata = {
        "columns": {
            "BOOKING_PK": "BOOKING_REF",
            "CUSTOMER_DETAILS": ["ADDRESS", "PHONE", "NAME"]
        }
    }

    generate_model(metadata)

    dbt_logs = dbt_runner.run_dbt_models(model_names=[request.node.name])

    actual_sql = macro_test_helpers.retrieve_compiled_model(request.node.name)
    expected_sql = macro_test_helpers.retrieve_expected_sql(request)

    assert macro_test_helpers.is_successful_run(dbt_logs)
    assert actual_sql == expected_sql


@pytest.mark.macro
def test_hash_columns_correctly_generates_hashed_columns_for_multiple_composite_columns_hashdiff(request,
                                                                                                 generate_model):
    metadata = {
        "columns": {
            "BOOKING_PK": "BOOKING_REF",
            "CUSTOMER_DETAILS": {
                "is_hashdiff": True,
                "columns": [
                    "PHONE",
                    "NATIONALITY",
                    "CUSTOMER_ID"]
            },
            "ORDER_DETAILS": {
                "is_hashdiff": True,
                "columns": [
                    "ORDER_DATE",
                    "ORDER_AMOUNT"]
            }
        }
    }

    generate_model(metadata)

    dbt_logs = dbt_runner.run_dbt_models(model_names=[request.node.name])

    actual_sql = macro_test_helpers.retrieve_compiled_model(request.node.name)
    expected_sql = macro_test_helpers.retrieve_expected_sql(request)

    assert macro_test_helpers.is_successful_run(dbt_logs)
    assert actual_sql == expected_sql


@pytest.mark.macro
def test_hash_columns_correctly_generates_unsorted_hashed_columns_for_composite_columns_mapping(request,
                                                                                                generate_model):
    metadata = {
        "columns": {
            "BOOKING_PK": "BOOKING_REF",
            "CUSTOMER_DETAILS": {
                "columns": ["ADDRESS", "PHONE", "NAME"]
            }
        }
    }

    generate_model(metadata)

    dbt_logs = dbt_runner.run_dbt_models(model_names=[request.node.name])

    actual_sql = macro_test_helpers.retrieve_compiled_model(request.node.name)
    expected_sql = macro_test_helpers.retrieve_expected_sql(request)

    assert macro_test_helpers.is_successful_run(dbt_logs)
    assert actual_sql == expected_sql


@pytest.mark.macro
def test_hash_columns_correctly_generates_sql_from_yaml(request, generate_model):
    metadata = {
        "columns": {
            "BOOKING_PK": "BOOKING_REF",
            "CUSTOMER_PK": "CUSTOMER_ID",
            "CUSTOMER_BOOKING_PK": [
                "CUSTOMER_ID",
                "BOOKING_REF"
            ],
            "BOOK_CUSTOMER_HASHDIFF": {
                "is_hashdiff": True,
                "columns": [
                    "PHONE",
                    "NATIONALITY",
                    "CUSTOMER_ID"
                ]
            },
            "BOOK_BOOKING_HASHDIFF": {
                "is_hashdiff": True,
                "columns": [
                    "BOOKING_REF",
                    "BOOKING_DATE",
                    "DEPARTURE_DATE",
                    "PRICE",
                    "DESTINATION"
                ]
            }
        }
    }

    generate_model(metadata)

    dbt_logs = dbt_runner.run_dbt_models(model_names=[request.node.name])

    actual_sql = macro_test_helpers.retrieve_compiled_model(request.node.name)
    expected_sql = macro_test_helpers.retrieve_expected_sql(request)

    assert macro_test_helpers.is_successful_run(dbt_logs)
    assert actual_sql == expected_sql


@pytest.mark.macro
def test_hash_columns_correctly_generates_sql_with_constants_from_yaml(request, generate_model):
    metadata = {
        "columns": {
            "BOOKING_PK": "BOOKING_REF",
            "CUSTOMER_PK": ["CUSTOMER_ID", '!9999-12-31'],
            "CUSTOMER_BOOKING_PK": [
                "CUSTOMER_ID",
                "BOOKING_REF"
            ],
            "BOOK_CUSTOMER_HASHDIFF": {
                "is_hashdiff": True,
                "columns": ["PHONE",
                            "NATIONALITY",
                            "CUSTOMER_ID"]
            },
            "BOOK_BOOKING_HASHDIFF": {
                "is_hashdiff": True,
                "columns": [
                    "BOOKING_REF",
                    "!STG",
                    "BOOKING_DATE",
                    "DEPARTURE_DATE",
                    "PRICE",
                    "DESTINATION"]
            }
        }
    }

    generate_model(metadata)

    dbt_logs = dbt_runner.run_dbt_models(model_names=[request.node.name])

    actual_sql = macro_test_helpers.retrieve_compiled_model(request.node.name)
    expected_sql = macro_test_helpers.retrieve_expected_sql(request)

    assert macro_test_helpers.is_successful_run(dbt_logs)
    assert actual_sql == expected_sql


@pytest.mark.macro
def test_hash_columns_raises_warning_if_mapping_without_hashdiff(request, generate_model):
    metadata = {
        "columns": {
            "BOOKING_PK": "BOOKING_REF",
            "CUSTOMER_PK": "CUSTOMER_ID",
            "CUSTOMER_BOOKING_PK": ["CUSTOMER_ID", "BOOKING_REF"],
            "BOOK_CUSTOMER_HASHDIFF": {
                "columns": [
                    "PHONE",
                    "NATIONALITY",
                    "CUSTOMER_ID"]
            },
            "BOOK_BOOKING_HASHDIFF": {
                "columns": [
                    "BOOKING_REF",
                    "BOOKING_DATE",
                    "DEPARTURE_DATE",
                    "PRICE",
                    "DESTINATION"]
            }
        }
    }

    generate_model(metadata)

    dbt_logs = dbt_runner.run_dbt_models(model_names=[request.node.name])

    actual_sql = macro_test_helpers.retrieve_compiled_model(request.node.name)
    expected_sql = macro_test_helpers.retrieve_expected_sql(request)

    assert macro_test_helpers.is_successful_run(dbt_logs)
    assert actual_sql == expected_sql
    warning_message = "You provided a list of columns under a 'columns' key, " \
                      "but did not provide the 'is_hashdiff' flag. Use list syntax for PKs."

    assert warning_message in dbt_logs
