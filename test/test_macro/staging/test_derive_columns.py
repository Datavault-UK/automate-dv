import pytest

from test import dbt_runner, macro_test_helpers

macro_name = "derive_columns"


@pytest.mark.macro
def test_derive_columns_correctly_generates_sql_with_source_columns(request, generate_model):
    var_dict = {'source_model': 'raw_source', 'columns': {'SOURCE': "!STG_BOOKING", 'EFFECTIVE_FROM': 'LOAD_DATE'}}

    generate_model()

    dbt_logs = dbt_runner.run_dbt_models(model_names=[request.node.name],
                                         args=var_dict)
    actual_sql = macro_test_helpers.retrieve_compiled_model(request.node.name)
    expected_sql = macro_test_helpers.retrieve_expected_sql(request)

    assert macro_test_helpers.is_successful_run(dbt_logs)
    assert actual_sql == expected_sql


@pytest.mark.macro
def test_derive_columns_correctly_generates_sql_without_source_columns(request, generate_model):
    var_dict = {'columns': {'SOURCE': "!STG_BOOKING", 'LOAD_DATE': 'EFFECTIVE_FROM'}}

    generate_model()

    dbt_logs = dbt_runner.run_dbt_models(model_names=[request.node.name],
                                         args=var_dict)
    actual_sql = macro_test_helpers.retrieve_compiled_model(request.node.name)
    expected_sql = macro_test_helpers.retrieve_expected_sql(request)

    assert macro_test_helpers.is_successful_run(dbt_logs)
    assert actual_sql == expected_sql


@pytest.mark.macro
def test_derive_columns_raises_error_with_only_source_columns(request, generate_model):
    var_dict = {'source_model': 'raw_source'}

    generate_model()

    dbt_logs = dbt_runner.run_dbt_models(model_names=[request.node.name],
                                         args=var_dict)

    assert "Invalid column configuration:" in dbt_logs


@pytest.mark.macro
def test_derive_columns_correctly_generates_sql_with_source_columns_concat(request, generate_model):
    var_dict = {'source_model': 'raw_source',
                'columns': {'CUSTOMER_DETAILS': ['CUSTOMER_NAME', 'CUSTOMER_DOB', 'PHONE'], 'SOURCE': "!STG_BOOKING",
                            'EFFECTIVE_FROM': 'LOAD_DATE'}}

    generate_model()

    dbt_logs = dbt_runner.run_dbt_models(model_names=[request.node.name],
                                         args=var_dict)
    actual_sql = macro_test_helpers.retrieve_compiled_model(request.node.name)
    expected_sql = macro_test_helpers.retrieve_expected_sql(request)

    assert macro_test_helpers.is_successful_run(dbt_logs)
    assert actual_sql == expected_sql


@pytest.mark.macro
def test_derive_columns_correctly_generates_sql_with_source_columns_concat_including_constant(request, generate_model):
    var_dict = {'source_model': 'raw_source',
                'columns': {'CUSTOMER_DETAILS': ['CUSTOMER_NAME', 'CUSTOMER_DOB', 'PHONE', '!PRIMARY'],
                            'SOURCE': "!STG_BOOKING", 'EFFECTIVE_FROM': 'LOAD_DATE'}}

    generate_model()

    dbt_logs = dbt_runner.run_dbt_models(model_names=[request.node.name],
                                         args=var_dict)
    actual_sql = macro_test_helpers.retrieve_compiled_model(request.node.name)
    expected_sql = macro_test_helpers.retrieve_expected_sql(request)

    assert macro_test_helpers.is_successful_run(dbt_logs)
    assert actual_sql == expected_sql


@pytest.mark.macro
def test_derive_columns_correctly_generates_sql_without_source_columns_concat(request, generate_model):
    var_dict = {'columns': {'CUSTOMER_DETAILS': ['CUSTOMER_NAME', 'CUSTOMER_DOB', 'PHONE'], 'SOURCE': "!STG_BOOKING",
                            'EFFECTIVE_FROM': 'LOAD_DATE'}}

    generate_model()

    dbt_logs = dbt_runner.run_dbt_models(model_names=[request.node.name],
                                         args=var_dict)
    actual_sql = macro_test_helpers.retrieve_compiled_model(request.node.name)
    expected_sql = macro_test_helpers.retrieve_expected_sql(request)

    assert macro_test_helpers.is_successful_run(dbt_logs)
    assert actual_sql == expected_sql


@pytest.mark.macro
def test_derive_columns_correctly_generates_sql_without_source_columns_concat_escaped1(request, generate_model):
    var_dict = {
        'columns': {'CUSTOMER_DETAILS': {'source_column': ['CUSTOMER_NAME', 'CUSTOMER DOB', 'PHONE'], 'escape': True},
                    'SOURCE': "!STG_BOOKING", 'EFFECTIVE_FROM': 'LOAD_DATE'}}

    generate_model()

    dbt_logs = dbt_runner.run_dbt_models(model_names=[request.node.name],
                                         args=var_dict)
    actual_sql = macro_test_helpers.retrieve_compiled_model(request.node.name)
    expected_sql = macro_test_helpers.retrieve_expected_sql(request)

    assert macro_test_helpers.is_successful_run(dbt_logs)
    assert actual_sql == expected_sql


@pytest.mark.macro
def test_derive_columns_correctly_generates_sql_without_source_columns_concat_escaped2(request, generate_model):
    var_dict = {
        'columns': {'CUSTOMER_DETAILS': {'source_column': ['CUSTOMER_NAME', 'CUSTOMER_DOB', 'PHONE'], 'escape': False},
                    'SOURCE': "!STG_BOOKING", 'EFFECTIVE_FROM': 'LOAD_DATE'}}

    generate_model()

    dbt_logs = dbt_runner.run_dbt_models(model_names=[request.node.name],
                                         args=var_dict)
    actual_sql = macro_test_helpers.retrieve_compiled_model(request.node.name)
    expected_sql = macro_test_helpers.retrieve_expected_sql(request)

    assert macro_test_helpers.is_successful_run(dbt_logs)
    assert actual_sql == expected_sql


@pytest.mark.macro
def test_derive_columns_correctly_generates_sql_without_source_columns_concat_escaped3(request, generate_model):
    var_dict = {'columns': {
        'CUSTOMER_DETAILS': {'source_column': ['CUSTOMER_NAME', 'CUSTOMER DOB', 'PHONE', '!WEBSITE'], 'escape': True},
        'SOURCE': "!STG_BOOKING", 'EFFECTIVE_FROM': 'LOAD_DATE'}}

    generate_model()

    dbt_logs = dbt_runner.run_dbt_models(model_names=[request.node.name],
                                         args=var_dict)
    actual_sql = macro_test_helpers.retrieve_compiled_model(request.node.name)
    expected_sql = macro_test_helpers.retrieve_expected_sql(request)

    assert macro_test_helpers.is_successful_run(dbt_logs)
    assert actual_sql == expected_sql


@pytest.mark.macro
def test_derive_columns_correctly_generates_sql_with_escaped_column1(request, generate_model):
    var_dict = {'source_model': 'raw_source',
                'columns': {'BOOKING_TYPE': {'source_column': 'BOOKING TYPE', 'escape': True},
                            'BOOKING_SOURCE': {'source_column': '!WEBSITE', 'escape': False}}}

    generate_model()

    dbt_logs = dbt_runner.run_dbt_models(model_names=[request.node.name],
                                         args=var_dict)
    actual_sql = macro_test_helpers.retrieve_compiled_model(request.node.name)
    expected_sql = macro_test_helpers.retrieve_expected_sql(request)

    assert macro_test_helpers.is_successful_run(dbt_logs)
    assert actual_sql == expected_sql


@pytest.mark.macro
def test_derive_columns_correctly_generates_sql_with_escaped_column2(request, generate_model):
    var_dict = {'source_model': 'raw_source',
                'columns': {'BOOKING_TYPE': {'source_column': 'BOOKING TYPE', 'escape': True},
                            'BOOKING_SOURCE': {'source_column': '!WEBSITE', 'escape': True}}}

    generate_model()

    dbt_logs = dbt_runner.run_dbt_models(model_names=[request.node.name],
                                         args=var_dict)
    actual_sql = macro_test_helpers.retrieve_compiled_model(request.node.name)
    expected_sql = macro_test_helpers.retrieve_expected_sql(request)

    assert macro_test_helpers.is_successful_run(dbt_logs)
    assert actual_sql == expected_sql


@pytest.mark.macro
def test_derive_columns_correctly_generates_sql_without_escaped_column(request, generate_model):
    var_dict = {'source_model': 'raw_source',
                'columns': {'BOOKING_TYPE': 'BOOKING_TYPE_ORIGINAL', 'BOOKING_SOURCE': '!WEBSITE'}}

    generate_model()

    dbt_logs = dbt_runner.run_dbt_models(model_names=[request.node.name],
                                         args=var_dict)
    actual_sql = macro_test_helpers.retrieve_compiled_model(request.node.name)
    expected_sql = macro_test_helpers.retrieve_expected_sql(request)

    assert macro_test_helpers.is_successful_run(dbt_logs)
    assert actual_sql == expected_sql


@pytest.mark.macro
def test_derive_columns_correctly_generates_sql_mixed_escaped_column(request, generate_model):
    var_dict = {'source_model': 'raw_source',
                'columns': {'BOOKING_TYPE': {'source_column': 'BOOKING TYPE', 'escape': True},
                            'BOOKING_SOURCE': '!WEBSITE'}}

    generate_model()

    dbt_logs = dbt_runner.run_dbt_models(model_names=[request.node.name],
                                         args=var_dict)
    actual_sql = macro_test_helpers.retrieve_compiled_model(request.node.name)
    expected_sql = macro_test_helpers.retrieve_expected_sql(request)

    assert macro_test_helpers.is_successful_run(dbt_logs)
    assert actual_sql == expected_sql
