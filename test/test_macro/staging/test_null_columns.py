import pytest

from test import macro_test_helpers, dbt_runner

macro_name = "null_columns"


@pytest.mark.macro
def test_null_columns_correctly_generates_sql_with_required_column(request, generate_model):
    var_dict = {'columns': {'REQUIRED': "CUSTOMER_ID"}}

    generate_model()

    dbt_logs = dbt_runner.run_dbt_models(model_names=[request.node.name],
                                                     args=var_dict)
    actual_sql = macro_test_helpers.retrieve_compiled_model(request.node.name)
    expected_sql = macro_test_helpers.retrieve_expected_sql(request)

    assert macro_test_helpers.is_successful_run(dbt_logs)
    assert actual_sql == expected_sql


@pytest.mark.macro
def test_null_columns_correctly_generates_sql_with_required_column_lc(request, generate_model):
    var_dict = {'columns': {'required': "CUSTOMER_ID"}}

    generate_model()

    dbt_logs = dbt_runner.run_dbt_models(model_names=[request.node.name],
                                                     args=var_dict)
    actual_sql = macro_test_helpers.retrieve_compiled_model(request.node.name)
    expected_sql = macro_test_helpers.retrieve_expected_sql(request)

    assert macro_test_helpers.is_successful_run(dbt_logs)
    assert actual_sql == expected_sql


@pytest.mark.macro
def test_null_columns_correctly_generates_sql_with_required_no_optional_column(request, generate_model):
    var_dict = {'columns': {"REQUIRED": "CUSTOMER_ID", "OPTIONAL": ""}}

    generate_model()

    dbt_logs = dbt_runner.run_dbt_models(model_names=[request.node.name],
                                                     args=var_dict)
    actual_sql = macro_test_helpers.retrieve_compiled_model(request.node.name)
    expected_sql = macro_test_helpers.retrieve_expected_sql(request)

    assert macro_test_helpers.is_successful_run(dbt_logs)
    assert actual_sql == expected_sql


@pytest.mark.macro
def test_null_columns_correctly_generates_sql_with_optional_column(request, generate_model):
    var_dict = {'columns': {'OPTIONAL': "CUSTOMER_REF"}}

    generate_model()

    dbt_logs = dbt_runner.run_dbt_models(model_names=[request.node.name],
                                                     args=var_dict)
    actual_sql = macro_test_helpers.retrieve_compiled_model(request.node.name)
    expected_sql = macro_test_helpers.retrieve_expected_sql(request)

    assert macro_test_helpers.is_successful_run(dbt_logs)
    assert actual_sql == expected_sql


@pytest.mark.macro
def test_null_columns_correctly_generates_sql_with_optional_column_lc(request, generate_model):
    var_dict = {'columns': {'optional': "CUSTOMER_REF"}}

    generate_model()

    dbt_logs = dbt_runner.run_dbt_models(model_names=[request.node.name],
                                                     args=var_dict)
    actual_sql = macro_test_helpers.retrieve_compiled_model(request.node.name)
    expected_sql = macro_test_helpers.retrieve_expected_sql(request)

    assert macro_test_helpers.is_successful_run(dbt_logs)
    assert actual_sql == expected_sql


@pytest.mark.macro
def test_null_columns_correctly_generates_sql_with_optional_no_required_column(request, generate_model):
    var_dict = {'columns': {"REQUIRED": "", "OPTIONAL": "CUSTOMER_REF"}}

    generate_model()

    dbt_logs = dbt_runner.run_dbt_models(model_names=[request.node.name],
                                                     args=var_dict)
    actual_sql = macro_test_helpers.retrieve_compiled_model(request.node.name)
    expected_sql = macro_test_helpers.retrieve_expected_sql(request)

    assert macro_test_helpers.is_successful_run(dbt_logs)
    assert actual_sql == expected_sql


@pytest.mark.macro
def test_null_columns_correctly_generates_sql_with_required_and_optional_column(request, generate_model):
    var_dict = {'columns': {"REQUIRED": "CUSTOMER_ID", "OPTIONAL": "CUSTOMER_REF"}}

    generate_model()

    dbt_logs = dbt_runner.run_dbt_models(model_names=[request.node.name],
                                                     args=var_dict)
    actual_sql = macro_test_helpers.retrieve_compiled_model(request.node.name)
    expected_sql = macro_test_helpers.retrieve_expected_sql(request)

    assert macro_test_helpers.is_successful_run(dbt_logs)
    assert actual_sql == expected_sql


@pytest.mark.macro
def test_null_columns_correctly_generates_sql_with_required_columns(request, generate_model):
    var_dict = {'columns': {'REQUIRED': ["CUSTOMER_ID", "ORDER_REF"]}}

    generate_model()

    dbt_logs = dbt_runner.run_dbt_models(model_names=[request.node.name],
                                                     args=var_dict)
    actual_sql = macro_test_helpers.retrieve_compiled_model(request.node.name)
    expected_sql = macro_test_helpers.retrieve_expected_sql(request)

    assert macro_test_helpers.is_successful_run(dbt_logs)
    assert actual_sql == expected_sql


@pytest.mark.macro
def test_null_columns_correctly_generates_sql_with_required_columns_no_optional_column(request, generate_model):
    var_dict = {'columns': {'REQUIRED': ["CUSTOMER_ID", "ORDER_REF"], 'OPTIONAL': ''}}

    generate_model()

    dbt_logs = dbt_runner.run_dbt_models(model_names=[request.node.name],
                                                     args=var_dict)
    actual_sql = macro_test_helpers.retrieve_compiled_model(request.node.name)
    expected_sql = macro_test_helpers.retrieve_expected_sql(request)

    assert macro_test_helpers.is_successful_run(dbt_logs)
    assert actual_sql == expected_sql


@pytest.mark.macro
def test_null_columns_correctly_generates_sql_with_optional_columns(request, generate_model):
    var_dict = {'columns': {'OPTIONAL': ["CUSTOMER_REF", "ORDER_LINE"]}}

    generate_model()

    dbt_logs = dbt_runner.run_dbt_models(model_names=[request.node.name],
                                                     args=var_dict)
    actual_sql = macro_test_helpers.retrieve_compiled_model(request.node.name)
    expected_sql = macro_test_helpers.retrieve_expected_sql(request)

    assert macro_test_helpers.is_successful_run(dbt_logs)
    assert actual_sql == expected_sql


@pytest.mark.macro
def test_null_columns_correctly_generates_sql_with_optional_columns_no_required_column(request, generate_model):
    var_dict = {'columns': {'REQUIRED': '', 'OPTIONAL': ["CUSTOMER_REF", "ORDER_LINE"]}}

    generate_model()

    dbt_logs = dbt_runner.run_dbt_models(model_names=[request.node.name],
                                                     args=var_dict)
    actual_sql = macro_test_helpers.retrieve_compiled_model(request.node.name)
    expected_sql = macro_test_helpers.retrieve_expected_sql(request)

    assert macro_test_helpers.is_successful_run(dbt_logs)
    assert actual_sql == expected_sql


@pytest.mark.macro
def test_null_columns_correctly_generates_sql_with_required_and_optional_columns(request, generate_model):
    var_dict = {'columns': {"REQUIRED": ["CUSTOMER_ID", "ORDER_REF"], "OPTIONAL": ["CUSTOMER_REF", "ORDER_LINE"]}}

    generate_model()

    dbt_logs = dbt_runner.run_dbt_models(model_names=[request.node.name],
                                                     args=var_dict)
    actual_sql = macro_test_helpers.retrieve_compiled_model(request.node.name)
    expected_sql = macro_test_helpers.retrieve_expected_sql(request)

    assert macro_test_helpers.is_successful_run(dbt_logs)
    assert actual_sql == expected_sql


@pytest.mark.macro
def test_null_columns_correctly_generates_sql_with_required_column_and_optional_columns(request, generate_model):
    var_dict = {'columns': {"REQUIRED": "CUSTOMER_ID", "OPTIONAL": ["CUSTOMER_REF", "ORDER_LINE"]}}

    generate_model()

    dbt_logs = dbt_runner.run_dbt_models(model_names=[request.node.name],
                                                     args=var_dict)
    actual_sql = macro_test_helpers.retrieve_compiled_model(request.node.name)
    expected_sql = macro_test_helpers.retrieve_expected_sql(request)

    assert macro_test_helpers.is_successful_run(dbt_logs)
    assert actual_sql == expected_sql


@pytest.mark.macro
def test_null_columns_correctly_generates_sql_with_required_columns_and_optional_column(request, generate_model):
    var_dict = {'columns': {"REQUIRED": ["CUSTOMER_ID", "ORDER_REF"], "OPTIONAL": "CUSTOMER_REF"}}

    generate_model()

    dbt_logs = dbt_runner.run_dbt_models(model_names=[request.node.name],
                                                     args=var_dict)
    actual_sql = macro_test_helpers.retrieve_compiled_model(request.node.name)
    expected_sql = macro_test_helpers.retrieve_expected_sql(request)

    assert macro_test_helpers.is_successful_run(dbt_logs)
    assert actual_sql == expected_sql


@pytest.mark.macro
def test_null_columns_correctly_generates_sql_with_required_and_optional_columns_lc(request, generate_model):
    var_dict = {'columns': {"required": ["CUSTOMER_ID", "ORDER_REF"], "optional": ["CUSTOMER_REF", "ORDER_LINE"]}}

    generate_model()

    dbt_logs = dbt_runner.run_dbt_models(model_names=[request.node.name],
                                                     args=var_dict)
    actual_sql = macro_test_helpers.retrieve_compiled_model(request.node.name)
    expected_sql = macro_test_helpers.retrieve_expected_sql(request)

    assert macro_test_helpers.is_successful_run(dbt_logs)
    assert actual_sql == expected_sql


