import pytest

from test import dbtvault_harness_utils

macro_name = "escape_column_name"


@pytest.mark.macro
def test_escape_string_with_single_quotes_is_successful(request, generate_model):
    var_dict = {'columns': 'COLUMN1'}

    generate_model()

    dbt_logs = dbtvault_harness_utils.run_dbt_models(model_names=[request.node.name],
                                                     args=var_dict)
    actual_sql = dbtvault_harness_utils.retrieve_compiled_model(request.node.name)
    expected_sql = dbtvault_harness_utils.retrieve_expected_sql(request)

    assert dbtvault_harness_utils.is_successful_run(dbt_logs)
    assert actual_sql == expected_sql


@pytest.mark.macro
def test_escape_string_with_double_quotes_is_successful(request, generate_model):
    var_dict = {'columns': "COLUMN1"}

    generate_model()

    dbt_logs = dbtvault_harness_utils.run_dbt_models(model_names=[request.node.name],
                                                     args=var_dict)
    actual_sql = dbtvault_harness_utils.retrieve_compiled_model(request.node.name)
    expected_sql = dbtvault_harness_utils.retrieve_expected_sql(request)

    assert dbtvault_harness_utils.is_successful_run(dbt_logs)
    assert actual_sql == expected_sql


@pytest.mark.macro
def test_escape_single_item_list_with_single_quotes_is_successful(request, generate_model):
    var_dict = {'columns': ['COLUMN1']}

    generate_model()

    dbt_logs = dbtvault_harness_utils.run_dbt_models(model_names=[request.node.name],
                                                     args=var_dict)
    actual_sql = dbtvault_harness_utils.retrieve_compiled_model(request.node.name)
    expected_sql = dbtvault_harness_utils.retrieve_expected_sql(request)

    assert dbtvault_harness_utils.is_successful_run(dbt_logs)
    assert actual_sql == expected_sql


@pytest.mark.macro
def test_escape_single_item_list_with_double_quotes_is_successful(request, generate_model):
    var_dict = {'columns': ["COLUMN1"]}

    generate_model()

    dbt_logs = dbtvault_harness_utils.run_dbt_models(model_names=[request.node.name],
                                                     args=var_dict)
    actual_sql = dbtvault_harness_utils.retrieve_compiled_model(request.node.name)
    expected_sql = dbtvault_harness_utils.retrieve_expected_sql(request)

    assert dbtvault_harness_utils.is_successful_run(dbt_logs)
    assert actual_sql == expected_sql


@pytest.mark.macro
def test_escape_multiple_item_list_with_single_quotes_is_successful(request, generate_model):
    var_dict = {'columns': ['COLUMN1', 'COLUMN_2', 'COLUMN-3', '_COLUMN4', 'COLUMN 5']}

    generate_model()

    dbt_logs = dbtvault_harness_utils.run_dbt_models(model_names=[request.node.name],
                                                     args=var_dict)
    actual_sql = dbtvault_harness_utils.retrieve_compiled_model(request.node.name)
    expected_sql = dbtvault_harness_utils.retrieve_expected_sql(request)

    assert dbtvault_harness_utils.is_successful_run(dbt_logs)
    assert actual_sql == expected_sql


@pytest.mark.macro
def test_escape_multiple_item_list_with_double_quotes_is_successful(request, generate_model):
    var_dict = {'columns': ["COLUMN1", "COLUMN_2", "COLUMN-3", "_COLUMN4", "COLUMN 5"]}

    generate_model()

    dbt_logs = dbtvault_harness_utils.run_dbt_models(model_names=[request.node.name],
                                                     args=var_dict)
    actual_sql = dbtvault_harness_utils.retrieve_compiled_model(request.node.name)
    expected_sql = dbtvault_harness_utils.retrieve_expected_sql(request)

    assert dbtvault_harness_utils.is_successful_run(dbt_logs)
    assert actual_sql == expected_sql


@pytest.mark.macro
def test_escape_multiple_item_list_with_single_and_double_quotes_is_successful(request, generate_model):
    var_dict = {'columns': ["COLUMN1", 'COLUMN_2', 'COLUMN-3', "_COLUMN4", "COLUMN 5"]}

    generate_model()

    dbt_logs = dbtvault_harness_utils.run_dbt_models(model_names=[request.node.name],
                                                     args=var_dict)
    actual_sql = dbtvault_harness_utils.retrieve_compiled_model(request.node.name)
    expected_sql = dbtvault_harness_utils.retrieve_expected_sql(request)

    assert dbtvault_harness_utils.is_successful_run(dbt_logs)
    assert actual_sql == expected_sql


@pytest.mark.macro
def test_escape_no_column_list_raises_error(request, generate_model):
    var_dict = {}

    process_logs = self.dbt_test_utils.run_dbt_model(model_name=self.current_test_name, args=var_dict)

    assert "Expected a column name or a list of column names, got: None" in process_logs


@pytest.mark.macro
def test_escape_empty_column_string_raises_error(request, generate_model):
    var_dict = {'columns': ''}

    process_logs = self.dbt_test_utils.run_dbt_model(model_name=self.current_test_name, args=var_dict)

    assert "Expected a column name or a list of column names, got: None" in process_logs


@pytest.mark.macro
def test_escape_empty_column_list_raises_error(request, generate_model):
    var_dict = {'columns': []}

    process_logs = self.dbt_test_utils.run_dbt_model(model_name=self.current_test_name, args=var_dict)

    assert "Expected a column name or a list of column names, got: None" in process_logs


@pytest.mark.macro
def test_escape_string_not_a_string_raises_error(request, generate_model):
    var_dict = {'columns': 123}

    process_logs = self.dbt_test_utils.run_dbt_model(model_name=self.current_test_name, args=var_dict)

    assert "Invalid column name(s) provided. Must be a string or a list of strings." in process_logs


@pytest.mark.macro
def test_escape_column_list_not_strings_raises_error(request, generate_model):
    var_dict = {'columns': [123, {'a': 'b'}]}

    process_logs = self.dbt_test_utils.run_dbt_model(model_name=self.current_test_name, args=var_dict)

    assert "Invalid column name(s) provided. Must be a string." in process_logs
