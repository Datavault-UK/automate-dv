import pytest

from test import dbt_runner, macro_test_helpers

macro_name = "rank_columns"


@pytest.mark.macro
def test_rank_columns_correctly_generates_ranked_columns_for_single_columns(request, generate_model):
    metadata = {
        "columns": {
            "DBTVAULT_RANK": {
                "partition_by": "CUSTOMER_ID",
                "order_by": "BOOKING_DATE"
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
def test_rank_columns_correctly_generates_ranked_columns_for_single_columns_asc(request, generate_model):
    metadata = {
        "columns": {
            "DBTVAULT_RANK": {
                "partition_by": "CUSTOMER_ID",
                "order_by": {"BOOKING_DATE": "ASC"}
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
def test_rank_columns_correctly_generates_ranked_columns_for_single_columns_desc(request, generate_model):
    metadata = {
        "columns": {
            "DBTVAULT_RANK": {
                "partition_by": "CUSTOMER_ID",
                "order_by": {"BOOKING_DATE": "DESC"}
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
def test_rank_columns_correctly_generates_ranked_columns_for_single_columns_multi_part(request, generate_model):
    metadata = {
        "columns": {
            "DBTVAULT_RANK": {
                "partition_by": ["CUSTOMER_ID",
                                 "CUSTOMER_PHONE"],
                "order_by": "BOOKING_DATE"
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
def test_rank_columns_correctly_generates_ranked_columns_for_single_columns_multi_order(request, generate_model):
    metadata = {
        "columns": {
            "DBTVAULT_RANK": {
                "partition_by": "CUSTOMER_ID",
                "order_by": ["BOOKING_DATE", 'LOAD_DATETIME']
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
def test_rank_columns_correctly_generates_ranked_columns_for_single_columns_multi_part_order(request, generate_model):
    metadata = {
        "columns": {
            "DBTVAULT_RANK": {
                "partition_by": ["CUSTOMER_ID",
                                 "CUSTOMER_PHONE"],
                "order_by": ["BOOKING_DATE", 'LOAD_DATETIME']
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
def test_rank_columns_correctly_generates_ranked_columns_for_single_columns_multi_part_order_dense(request,
                                                                                                   generate_model):
    metadata = {
        "columns": {
            "DBTVAULT_RANK": {
                "partition_by": ["CUSTOMER_ID",
                                 "CUSTOMER_PHONE"],
                "order_by": ["BOOKING_DATE", 'LOAD_DATETIME'],
                "dense_rank": True
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
def test_rank_columns_correctly_generates_ranked_columns_for_single_columns_dense_rank(request, generate_model):
    metadata = {
        "columns": {
            "DBTVAULT_RANK": {
                "partition_by": "CUSTOMER_ID",
                "order_by": "BOOKING_DATE",
                "dense_rank": True
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
def test_rank_columns_correctly_generates_ranked_columns_for_multiple_columns(request, generate_model):
    metadata = {
        "columns": {
            "DBTVAULT_RANK": {
                "partition_by": "CUSTOMER_ID",
                "order_by": "BOOKING_DATE"
            },
            "SAT_RANK": {
                "partition_by": "TRANSACTION_ID",
                "order_by": "TRANSACTION_DATE"
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
def test_rank_columns_correctly_generates_ranked_columns_for_multiple_columns_asc(request, generate_model):
    metadata = {
        "columns": {
            "DBTVAULT_RANK": {
                "partition_by": "CUSTOMER_ID",
                "order_by": {"BOOKING_DATE": "ASC"}
            },
            "SAT_RANK": {
                "partition_by": "TRANSACTION_ID",
                "order_by": {"TRANSACTION_DATE": "ASC"}
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
def test_rank_columns_correctly_generates_ranked_columns_for_multiple_columns_asc_desc(request, generate_model):
    metadata = {
        "columns": {
            "DBTVAULT_RANK": {
                "partition_by": "CUSTOMER_ID",
                "order_by": {"BOOKING_DATE": "ASC"}
            },
            "SAT_RANK": {
                "partition_by": "TRANSACTION_ID",
                "order_by": {"TRANSACTION_DATE": "DESC"}
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
def test_rank_columns_correctly_generates_ranked_columns_for_multiple_columns_multi_order_asc_desc(request,
                                                                                                   generate_model):
    metadata = {
        "columns": {
            "DBTVAULT_RANK": {
                "partition_by": "CUSTOMER_ID",
                "order_by": [{"BOOKING_DATE": "ASC"}, {"ORDER_DATE": "DESC"}]
            },
            "SAT_RANK": {
                "partition_by": "TRANSACTION_ID",
                "order_by": {"TRANSACTION_DATE": "DESC"}
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
def test_rank_columns_correctly_generates_ranked_columns_for_multiple_columns_multi_order_asc_none(request,
                                                                                                   generate_model):
    metadata = {
        "columns": {
            "DBTVAULT_RANK": {
                "partition_by": "CUSTOMER_ID",
                "order_by": [{"BOOKING_DATE": "ASC"}, "ORDER_DATE"]
            },
            "SAT_RANK": {
                "partition_by": "TRANSACTION_ID",
                "order_by": {"TRANSACTION_DATE": "DESC"}
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
def test_rank_columns_correctly_generates_ranked_columns_for_multiple_columns_dense_rank(request, generate_model):
    metadata = {
        "columns": {
            "DBTVAULT_RANK": {
                "partition_by": "CUSTOMER_ID",
                "order_by": "BOOKING_DATE",
                "dense_rank": True
            },
            "SAT_RANK": {
                "partition_by": "TRANSACTION_ID",
                "order_by": "TRANSACTION_DATE",
                "dense_rank": True
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
def test_rank_columns_correctly_generates_ranked_columns_for_multiple_columns_some_dense_rank(request, generate_model):
    metadata = {
        "columns": {
            "DBTVAULT_RANK": {
                "partition_by": "CUSTOMER_ID",
                "order_by": "BOOKING_DATE",
            },
            "SAT_RANK": {
                "partition_by": "TRANSACTION_ID",
                "order_by": "TRANSACTION_DATE",
                "dense_rank": True
            }
        }
    }

    generate_model(metadata)

    dbt_logs = dbt_runner.run_dbt_models(model_names=[request.node.name])

    actual_sql = macro_test_helpers.retrieve_compiled_model(request.node.name)
    expected_sql = macro_test_helpers.retrieve_expected_sql(request)

    assert macro_test_helpers.is_successful_run(dbt_logs)
    assert actual_sql == expected_sql
