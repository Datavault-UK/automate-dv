import pytest

from test import dbt_runner, macro_test_helpers

macro_name = "stage"


@pytest.mark.macro
def test_stage_correctly_generates_sql_from_yaml(request, generate_model):
    metadata = {
        "source_model": "raw_source",
        "hashed_columns": {
            "CUSTOMER_PK": "CUSTOMER_ID",
            "CUST_CUSTOMER_HASHDIFF": {
                "is_hashdiff": True,
                "columns": ["CUSTOMER_DOB", "CUSTOMER_ID", "CUSTOMER_NAME"]
            },
            "CUSTOMER_HASHDIFF": {
                "is_hashdiff": True,
                "columns": ["CUSTOMER_ID", "NATIONALITY", "PHONE"]
            }
        },
        "derived_columns": {
            "SOURCE": "!STG_BOOKING",
            "EFFECTIVE_FROM": "BOOKING_DATE"
        }
    }

    generate_model(metadata)

    dbt_logs = dbt_runner.run_dbt_models(model_names=[request.node.name])

    actual_sql = macro_test_helpers.retrieve_compiled_model(request.node.name)
    expected_sql = macro_test_helpers.retrieve_expected_sql(request)

    assert macro_test_helpers.is_successful_run(dbt_logs)
    assert actual_sql == expected_sql


@pytest.mark.macro
def test_stage_correctly_generates_sql_from_yaml_with_escape1(request, generate_model):
    metadata = {
        "source_model": "raw_source",
        "hashed_columns": {
            "CUSTOMER_PK": "CUSTOMER_ID",
            "CUST_CUSTOMER_HASHDIFF": {
                "is_hashdiff": True,
                "columns": ["CUSTOMER_DOB", "CUSTOMER_ID", "CUSTOMER_NAME"]
            },
            "CUSTOMER_HASHDIFF": {
                "is_hashdiff": True,
                "columns": ["CUSTOMER_ID", "NATIONALITY", "PHONE"]
            }
        },
        "derived_columns": {
            "SOURCE": "!STG_BOOKING",
            "EFFECTIVE_FROM": {
                "source_column": "BOOKING_DATE",
                "escape": True
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
def test_stage_correctly_generates_sql_from_yaml_with_escape2(request, generate_model):
    metadata = {
        "source_model": "raw_source",
        "hashed_columns": {
            "CUSTOMER_PK": "CUSTOMER_ID",
            "CUST_CUSTOMER_HASHDIFF": {
                "is_hashdiff": True,
                "columns": ["CUSTOMER_DOB", "CUSTOMER_ID", "CUSTOMER_NAME"]
            },
            "CUSTOMER_HASHDIFF": {
                "is_hashdiff": True,
                "columns": ["CUSTOMER_ID", "NATIONALITY", "PHONE"]
            }
        },
        "derived_columns": {
            "SOURCE": "!STG_BOOKING",
            "BOOKING_DETAILS": {
                "source_column": ["BOOKING_DATE", "!STG_BOOKING", "CUSTOMER_ID", "CUSTOMER_NAME"],
                "escape": True
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
def test_stage_correctly_generates_sql_from_yaml_with_escape3(request, generate_model):
    metadata = {
        "source_model": "raw_source",
        "hashed_columns": {
            "CUSTOMER_PK": "CUSTOMER_ID",
            "CUST_CUSTOMER_HASHDIFF": {
                "is_hashdiff": True,
                "columns": ["CUSTOMER_DOB", "CUSTOMER_ID", "CUSTOMER_NAME"]
            },
            "CUSTOMER_HASHDIFF": {
                "is_hashdiff": True,
                "columns": ["CUSTOMER_ID", "NATIONALITY", "PHONE"]
            }
        },
        "derived_columns": {
            "BOOKING_FLAG": "NOT \"TEST COLUMN\"",
            "EFFECTIVE_FROM": "TO_VARCHAR(\"CREATED DATE\"::date, 'DD-MM-YYYY')"
        }
    }

    generate_model(metadata)

    dbt_logs = dbt_runner.run_dbt_models(model_names=[request.node.name])

    actual_sql = macro_test_helpers.retrieve_compiled_model(request.node.name)
    expected_sql = macro_test_helpers.retrieve_expected_sql(request)

    assert macro_test_helpers.is_successful_run(dbt_logs)
    assert actual_sql == expected_sql


@pytest.mark.macro
def test_stage_correctly_generates_sql_from_yaml_with_concat(request, generate_model):
    metadata = {
        "source_model": "raw_source",
        "hashed_columns": {
            "CUSTOMER_PK": "CUSTOMER_ID",
            "CUST_CUSTOMER_HASHDIFF": {
                "is_hashdiff": True,
                "columns": ["CUSTOMER_DOB", "CUSTOMER_ID", "CUSTOMER_NAME"]
            },
            "CUSTOMER_HASHDIFF": {
                "is_hashdiff": True,
                "columns": ["CUSTOMER_ID", "NATIONALITY", "PHONE"]
            }
        },
        "derived_columns": {
            "SOURCE": "!STG_BOOKING",
            "BOOKING_DETAILS": ["BOOKING_DATE", "!STG_BOOKING", "CUSTOMER_ID", "CUSTOMER_NAME"]
        }
    }

    generate_model(metadata)

    dbt_logs = dbt_runner.run_dbt_models(model_names=[request.node.name])

    actual_sql = macro_test_helpers.retrieve_compiled_model(request.node.name)
    expected_sql = macro_test_helpers.retrieve_expected_sql(request)

    assert macro_test_helpers.is_successful_run(dbt_logs)
    assert actual_sql == expected_sql


@pytest.mark.macro
def test_stage_correctly_generates_sql_from_yaml_with_source_style(request, generate_model):
    metadata = {
        "source_model": {
            "test_macro": "source"
        },
        "hashed_columns": {
            "CUSTOMER_PK": "CUSTOMER_ID",
            "CUST_CUSTOMER_HASHDIFF": {
                "is_hashdiff": True,
                "columns": ["CUSTOMER_DOB", "CUSTOMER_ID", "CUSTOMER_NAME"]
            },
            "CUSTOMER_HASHDIFF": {
                "is_hashdiff": True,
                "columns": ["CUSTOMER_ID", "NATIONALITY", "PHONE"]
            }
        },
        "derived_columns": {
            "SOURCE": "!STG_BOOKING",
            "EFFECTIVE_FROM": "LOAD_DATE"
        }
    }

    generate_model(metadata)

    dbt_logs = dbt_runner.run_dbt_models(model_names=[request.node.name])

    actual_sql = macro_test_helpers.retrieve_compiled_model(request.node.name)
    expected_sql = macro_test_helpers.retrieve_expected_sql(request)

    assert macro_test_helpers.is_successful_run(dbt_logs)
    assert actual_sql == expected_sql


@pytest.mark.macro
def test_stage_correctly_generates_sql_from_yaml_with_ranked(request, generate_model):
    metadata = {
        "source_model": "raw_source",
        "hashed_columns": {
            "CUSTOMER_PK": "CUSTOMER_ID",
            "CUST_CUSTOMER_HASHDIFF": {
                "is_hashdiff": True,
                "columns": ["CUSTOMER_DOB", "CUSTOMER_ID", "CUSTOMER_NAME"]
            },
            "CUSTOMER_HASHDIFF": {
                "is_hashdiff": True,
                "columns": ["CUSTOMER_ID", "NATIONALITY", "PHONE"]
            }
        },
        "derived_columns": {
            "SOURCE": "!STG_BOOKING",
            "EFFECTIVE_FROM": "BOOKING_DATE"
        },
        "ranked_columns": {
            "DBTVAULT_RANK": {
                "partition_by": "CUSTOMER_ID",
                "order_by": "LOAD_DATE"
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
def test_stage_correctly_generates_sql_from_yaml_with_composite_pk(request, generate_model):
    metadata = {
        "source_model": "raw_source",
        "hashed_columns": {
            "CUSTOMER_PK": ["CUSTOMER_ID", "CUSTOMER_NAME"],
            "CUST_CUSTOMER_HASHDIFF": {
                "is_hashdiff": True,
                "columns": ["CUSTOMER_DOB", "CUSTOMER_ID", "CUSTOMER_NAME"]
            },
            "CUSTOMER_HASHDIFF": {
                "is_hashdiff": True,
                "columns":
                    ["CUSTOMER_ID", "NATIONALITY", "PHONE"]
            }
        },
        "derived_columns": {
            "SOURCE": "!STG_BOOKING",
            "EFFECTIVE_FROM": "BOOKING_DATE"
        }
    }

    generate_model(metadata)

    dbt_logs = dbt_runner.run_dbt_models(model_names=[request.node.name])

    actual_sql = macro_test_helpers.retrieve_compiled_model(request.node.name)
    expected_sql = macro_test_helpers.retrieve_expected_sql(request)

    assert macro_test_helpers.is_successful_run(dbt_logs)
    assert actual_sql == expected_sql


@pytest.mark.macro
def test_stage_correctly_generates_sql_for_only_source_columns_from_yaml(request, generate_model):
    metadata = {
        "include_source_columns": True,
        "source_model": "raw_source"
    }

    generate_model(metadata)

    dbt_logs = dbt_runner.run_dbt_models(model_names=[request.node.name])

    actual_sql = macro_test_helpers.retrieve_compiled_model(request.node.name)
    expected_sql = macro_test_helpers.retrieve_expected_sql(request)

    assert macro_test_helpers.is_successful_run(dbt_logs)
    assert actual_sql == expected_sql


@pytest.mark.macro
def test_stage_correctly_generates_sql_for_only_source_columns_and_missing_flag_from_yaml(request, generate_model):
    metadata = {
        "source_model": "raw_source"
    }

    generate_model(metadata)

    dbt_logs = dbt_runner.run_dbt_models(model_names=[request.node.name])

    actual_sql = macro_test_helpers.retrieve_compiled_model(request.node.name)
    expected_sql = macro_test_helpers.retrieve_expected_sql(request)

    assert macro_test_helpers.is_successful_run(dbt_logs)
    assert actual_sql == expected_sql


@pytest.mark.macro
def test_stage_correctly_generates_sql_for_only_hashing_from_yaml(request, generate_model):
    metadata = {
        "source_model": "raw_source",
        "include_source_columns": False,
        "hashed_columns": {
            "CUSTOMER_PK": "CUSTOMER_ID",
            "CUST_CUSTOMER_HASHDIFF": {
                "is_hashdiff": True,
                "columns": ["CUSTOMER_DOB", "CUSTOMER_ID", "CUSTOMER_NAME"]
            },
            "CUSTOMER_HASHDIFF": {
                "is_hashdiff": True,
                "columns": ["CUSTOMER_ID", "NATIONALITY", "PHONE"]
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
def test_stage_correctly_generates_sql_for_only_derived_from_yaml(request, generate_model):
    metadata = {
        "include_source_columns": False,
        "source_model": "raw_source",
        "derived_columns": {
            "SOURCE": "!STG_BOOKING",
            "EFFECTIVE_FROM": "LOAD_DATE"
        }
    }

    generate_model(metadata)

    dbt_logs = dbt_runner.run_dbt_models(model_names=[request.node.name])

    actual_sql = macro_test_helpers.retrieve_compiled_model(request.node.name)
    expected_sql = macro_test_helpers.retrieve_expected_sql(request)

    assert macro_test_helpers.is_successful_run(dbt_logs)
    assert actual_sql == expected_sql


@pytest.mark.macro
def test_stage_correctly_generates_sql_for_only_ranked_from_yaml(request, generate_model):
    metadata = {
        "include_source_columns": False,
        "source_model": "raw_source",
        "ranked_columns": {
            "DBTVAULT_RANK": {
                "partition_by": "CUSTOMER_ID",
                "order_by": "LOAD_DATE"
            },
            "SAT_LOAD_RANK": {
                "partition_by": "CUSTOMER_ID",
                "order_by": "LOAD_DATE"}
        }
    }

    generate_model(metadata)

    dbt_logs = dbt_runner.run_dbt_models(model_names=[request.node.name])

    actual_sql = macro_test_helpers.retrieve_compiled_model(request.node.name)
    expected_sql = macro_test_helpers.retrieve_expected_sql(request)

    assert macro_test_helpers.is_successful_run(dbt_logs)
    assert actual_sql == expected_sql


@pytest.mark.macro
def test_stage_correctly_generates_sql_for_hashing_and_source_from_yaml(request, generate_model):
    metadata = {
        "source_model": "raw_source",
        "hashed_columns": {
            "CUSTOMER_PK": "CUSTOMER_ID",
            "CUST_CUSTOMER_HASHDIFF": {
                "is_hashdiff": True,
                "columns": ["CUSTOMER_DOB", "CUSTOMER_ID", "CUSTOMER_NAME"]
            },
            "CUSTOMER_HASHDIFF": {
                "is_hashdiff": True,
                "columns": ["CUSTOMER_ID", "NATIONALITY", "PHONE"]
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
def test_stage_correctly_generates_sql_for_hashing_and_source_from_yaml_for_single_hash(request, generate_model):
    metadata = {
        "source_model": "raw_source",
        "hashed_columns": {
            "CUST_CUSTOMER_HASHDIFF": {
                "is_hashdiff": True,
                "columns": ["CUSTOMER_DOB", "CUSTOMER_ID", "CUSTOMER_NAME"]
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
def test_stage_correctly_generates_sql_for_hashing_and_source_from_yaml_for_single_hash_and_include(request,
                                                                                                    generate_model):
    metadata = {
        "source_model": "raw_source",
        "include_source_columns": True,
        "hashed_columns": {
            "HASHDIFF": {
                "is_hashdiff": True,
                "columns": ["CUSTOMER_DOB", "CUSTOMER_ID", "CUSTOMER_NAME"]
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
def test_stage_correctly_generates_sql_for_hashing_and_source_from_yaml_for_multi_hash_and_include(request,
                                                                                                   generate_model):
    metadata = {
        "source_model": "raw_source",
        "include_source_columns": True,
        "hashed_columns": {
            "CUSTOMER_PK": "CUSTOMER_ID",
            "CUST_CUSTOMER_HASHDIFF": {
                "is_hashdiff": True,
                "columns": ["CUSTOMER_DOB", "CUSTOMER_ID", "CUSTOMER_NAME"]
            },
            "CUSTOMER_HASHDIFF": {
                "is_hashdiff": True,
                "columns": ["CUSTOMER_ID", "NATIONALITY", "PHONE"]
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
def test_stage_correctly_generates_sql_for_hashing_and_derived_from_yaml(request, generate_model):
    metadata = {
        "source_model": "raw_source",
        "include_source_columns": False,
        "hashed_columns": {
            "CUSTOMER_PK": "CUSTOMER_ID",
            "CUST_CUSTOMER_HASHDIFF": {
                "is_hashdiff": True,
                "columns": ["CUSTOMER_DOB", "CUSTOMER_ID", "CUSTOMER_NAME"]
            },
            "CUSTOMER_HASHDIFF": {
                "is_hashdiff": True,
                "columns": ["CUSTOMER_ID", "NATIONALITY", "PHONE"]
            }
        },
        "derived_columns": {
            "SOURCE": "!STG_BOOKING",
            "EFFECTIVE_FROM": "BOOKING_DATE"
        }
    }

    generate_model(metadata)

    dbt_logs = dbt_runner.run_dbt_models(model_names=[request.node.name])

    actual_sql = macro_test_helpers.retrieve_compiled_model(request.node.name)
    expected_sql = macro_test_helpers.retrieve_expected_sql(request)

    assert macro_test_helpers.is_successful_run(dbt_logs)
    assert actual_sql == expected_sql


@pytest.mark.macro
def test_stage_correctly_generates_sql_for_derived_and_source_from_yaml(request, generate_model):
    metadata = {
        "source_model": "raw_source",
        "derived_columns": {
            "SOURCE": "!STG_BOOKING",
            "EFFECTIVE_FROM": "BOOKING_DATE"
        }
    }

    generate_model(metadata)

    dbt_logs = dbt_runner.run_dbt_models(model_names=[request.node.name])

    actual_sql = macro_test_helpers.retrieve_compiled_model(request.node.name)
    expected_sql = macro_test_helpers.retrieve_expected_sql(request)

    assert macro_test_helpers.is_successful_run(dbt_logs)
    assert actual_sql == expected_sql


@pytest.mark.macro
def test_stage_correctly_generates_sql_for_hashing_with_exclude_flag(request, generate_model):
    metadata = {
        "source_model": "raw_source",
        "derived_columns": {
            "SOURCE": "!STG_BOOKING",
            "EFFECTIVE_FROM": "LOAD_DATE"
        },
        "hashed_columns": {
            "CUSTOMER_PK": "CUSTOMER_ID",
            "CUSTOMER_HASHDIFF": {
                "is_hashdiff": True,
                "exclude_columns": True,
                "columns": [
                    "BOOKING_FK",
                    "ORDER_FK",
                    "CUSTOMER_PK",
                    "LOAD_DATE",
                    "RECORD_SOURCE"]
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
def test_stage_correctly_generates_sql_for_hashing_with_exclude_flag_no_columns(request, generate_model):
    metadata = {
        "source_model": "raw_source",
        "derived_columns": {
            "SOURCE": "!STG_BOOKING",
            "EFFECTIVE_FROM": "LOAD_DATE"
        },
        "hashed_columns": {
            "CUSTOMER_PK": "CUSTOMER_ID",
            "CUSTOMER_HASHDIFF": {
                "is_hashdiff": True,
                "exclude_columns": True
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
def test_stage_correctly_generates_sql_for_only_hashing_with_exclude_flag(request, generate_model):
    metadata = {
        "source_model": "raw_source",
        "include_source_columns": False,
        "hashed_columns": {
            "CUSTOMER_PK": "CUSTOMER_ID",
            "CUSTOMER_HASHDIFF": {
                "is_hashdiff": True,
                "exclude_columns": True,
                "columns": [
                    "BOOKING_FK",
                    "ORDER_FK",
                    "CUSTOMER_PK",
                    "LOAD_DATE",
                    "RECORD_SOURCE"]
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
def test_stage_correctly_generates_sql_for_only_source_and_hashing_with_exclude_flag(request, generate_model):
    metadata = {
        "source_model": "raw_source",
        "hashed_columns": {
            "CUSTOMER_PK": "CUSTOMER_ID",
            "CUSTOMER_HASHDIFF": {
                "is_hashdiff": True,
                "exclude_columns": True,
                "columns":
                    ["BOOKING_FK",
                     "ORDER_FK",
                     "CUSTOMER_PK",
                     "LOAD_DATE",
                     "RECORD_SOURCE"]
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
def test_stage_raises_error_with_missing_source(request, generate_model):
    metadata = {
        "hashed_columns": {
            "CUSTOMER_PK": "CUSTOMER_ID",
            "CUST_CUSTOMER_HASHDIFF": {
                "is_hashdiff": True,
                "columns": ["CUSTOMER_DOB", "CUSTOMER_ID", "CUSTOMER_NAME"]
            },
            "CUSTOMER_HASHDIFF": {
                "is_hashdiff": True,
                "columns":
                    ["CUSTOMER_ID", "NATIONALITY", "PHONE"]
            }
        },
        "derived_columns": {
            "SOURCE": "!STG_BOOKING",
            "EFFECTIVE_FROM": "LOAD_DATE"
        }
    }

    generate_model(metadata)

    dbt_logs = dbt_runner.run_dbt_models(model_names=[request.node.name])

    assert 'Staging error: Missing source_model configuration. ' \
           'A source model name must be provided.' in dbt_logs
