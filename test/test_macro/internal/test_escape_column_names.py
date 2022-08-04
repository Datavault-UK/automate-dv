import pytest

from test import dbt_runner, macro_test_helpers

macro_name = "escape_column_names"


@pytest.mark.macro
def test_escape_string_with_single_quotes_is_successful(request, generate_model):
    var_dict = {'columns': 'COLUMN1'}

    generate_model()

    dbt_logs = dbt_runner.run_dbt_models(model_names=[request.node.name],
                                         args=var_dict)
    actual_sql = macro_test_helpers.retrieve_compiled_model(request.node.name)
    expected_sql = macro_test_helpers.retrieve_expected_sql(request)

    assert macro_test_helpers.is_successful_run(dbt_logs)
    assert actual_sql == expected_sql


@pytest.mark.macro
def test_escape_string_with_double_quotes_is_successful(request, generate_model):
    var_dict = {'columns': "COLUMN1"}

    generate_model()

    dbt_logs = dbt_runner.run_dbt_models(model_names=[request.node.name],
                                         args=var_dict)
    actual_sql = macro_test_helpers.retrieve_compiled_model(request.node.name)
    expected_sql = macro_test_helpers.retrieve_expected_sql(request)

    assert macro_test_helpers.is_successful_run(dbt_logs)
    assert actual_sql == expected_sql


@pytest.mark.macro
def test_escape_single_item_list_with_single_quotes_is_successful(request, generate_model):
    var_dict = {'columns': ['COLUMN1']}

    generate_model()

    dbt_logs = dbt_runner.run_dbt_models(model_names=[request.node.name],
                                         args=var_dict)
    actual_sql = macro_test_helpers.retrieve_compiled_model(request.node.name)
    expected_sql = macro_test_helpers.retrieve_expected_sql(request)

    assert macro_test_helpers.is_successful_run(dbt_logs)
    assert actual_sql == expected_sql


@pytest.mark.macro
def test_escape_single_item_list_with_double_quotes_is_successful(request, generate_model):
    var_dict = {'columns': ["COLUMN1"]}

    generate_model()

    dbt_logs = dbt_runner.run_dbt_models(model_names=[request.node.name],
                                         args=var_dict)
    actual_sql = macro_test_helpers.retrieve_compiled_model(request.node.name)
    expected_sql = macro_test_helpers.retrieve_expected_sql(request)

    assert macro_test_helpers.is_successful_run(dbt_logs)
    assert actual_sql == expected_sql


@pytest.mark.macro
def test_escape_multiple_item_list_with_single_quotes_is_successful(request, generate_model):
    var_dict = {'columns': ['COLUMN1', 'COLUMN_2', 'COLUMN-3', '_COLUMN4', 'COLUMN 5']}

    generate_model()

    dbt_logs = dbt_runner.run_dbt_models(model_names=[request.node.name],
                                         args=var_dict)
    actual_sql = macro_test_helpers.retrieve_compiled_model(request.node.name)
    expected_sql = macro_test_helpers.retrieve_expected_sql(request)

    assert macro_test_helpers.is_successful_run(dbt_logs)
    assert actual_sql == expected_sql


@pytest.mark.macro
def test_escape_multiple_item_list_with_double_quotes_is_successful(request, generate_model):
    var_dict = {'columns': ["COLUMN1", "COLUMN_2", "COLUMN-3", "_COLUMN4", "COLUMN 5"]}

    generate_model()

    dbt_logs = dbt_runner.run_dbt_models(model_names=[request.node.name],
                                         args=var_dict)
    actual_sql = macro_test_helpers.retrieve_compiled_model(request.node.name)
    expected_sql = macro_test_helpers.retrieve_expected_sql(request)

    assert macro_test_helpers.is_successful_run(dbt_logs)
    assert actual_sql == expected_sql


@pytest.mark.macro
def test_escape_multiple_item_list_with_single_and_double_quotes_is_successful(request, generate_model):
    var_dict = {'columns': ["COLUMN1", 'COLUMN_2', 'COLUMN-3', "_COLUMN4", "COLUMN 5"]}

    generate_model()

    dbt_logs = dbt_runner.run_dbt_models(model_names=[request.node.name],
                                         args=var_dict)
    actual_sql = macro_test_helpers.retrieve_compiled_model(request.node.name)
    expected_sql = macro_test_helpers.retrieve_expected_sql(request)

    assert macro_test_helpers.is_successful_run(dbt_logs)
    assert actual_sql == expected_sql


@pytest.mark.macro
def test_escape_no_columns_is_successful(request, generate_model):
    var_dict = {}

    generate_model()

    dbt_logs = dbt_runner.run_dbt_models(model_names=[request.node.name],
                                         args=var_dict)

    assert macro_test_helpers.is_successful_run(dbt_logs)


@pytest.mark.macro
def test_columns_is_none_is_successful(request, generate_model):
    var_dict = {'columns': None}

    generate_model()

    dbt_logs = dbt_runner.run_dbt_models(model_names=[request.node.name],
                                         args=var_dict)

    assert macro_test_helpers.is_successful_run(dbt_logs)


@pytest.mark.macro
def test_escape_empty_column_string_raises_error(request, generate_model):
    var_dict = {'columns': ''}

    generate_model()

    dbt_logs = dbt_runner.run_dbt_models(model_names=[request.node.name],
                                         args=var_dict)

    assert "Expected a column name or a list of column names, got an empty string" in dbt_logs


@pytest.mark.macro
def test_escape_empty_column_list_is_successful(request, generate_model):
    var_dict = {'columns': []}

    generate_model()

    dbt_logs = dbt_runner.run_dbt_models(model_names=[request.node.name],
                                         args=var_dict)

    assert macro_test_helpers.is_successful_run(dbt_logs)


@pytest.mark.macro
def test_escape_string_not_a_string_raises_error(request, generate_model):
    var_dict = {'columns': 123}

    generate_model()

    dbt_logs = dbt_runner.run_dbt_models(model_names=[request.node.name],
                                         args=var_dict)

    assert "Invalid column name(s) provided. Must be a string," \
           " a list of strings, or a dictionary of hashdiff metadata." in dbt_logs


@pytest.mark.macro
def test_escape_column_list_not_strings_raises_error(request, generate_model):
    var_dict = {'columns': [123, {'a': 'b'}]}

    generate_model()

    dbt_logs = dbt_runner.run_dbt_models(model_names=[request.node.name],
                                         args=var_dict)

    assert "Invalid columns object provided. Must be a list of lists, dictionaries or strings." in dbt_logs


@pytest.mark.macro
def test_escape_string_with_single_quotes_backticks_is_successful(request, generate_model):
    var_dict = {'columns': 'COLUMN1', 'escape_char_left': '`', 'escape_char_right': '`'}

    generate_model()

    dbt_logs = dbt_runner.run_dbt_models(model_names=[request.node.name],
                                         args=var_dict)
    actual_sql = macro_test_helpers.retrieve_compiled_model(request.node.name)
    expected_sql = macro_test_helpers.retrieve_expected_sql(request)

    assert macro_test_helpers.is_successful_run(dbt_logs)
    assert actual_sql == expected_sql


@pytest.mark.macro
def test_escape_string_with_double_quotes_backticks_is_successful(request, generate_model):
    var_dict = {'columns': "COLUMN1", 'escape_char_left': "`", 'escape_char_right': "`"}

    generate_model()

    dbt_logs = dbt_runner.run_dbt_models(model_names=[request.node.name],
                                         args=var_dict)
    actual_sql = macro_test_helpers.retrieve_compiled_model(request.node.name)
    expected_sql = macro_test_helpers.retrieve_expected_sql(request)

    assert macro_test_helpers.is_successful_run(dbt_logs)
    assert actual_sql == expected_sql


@pytest.mark.macro
def test_escape_single_item_list_with_single_quotes_backticks_is_successful(request, generate_model):
    var_dict = {'columns': ['COLUMN1'], 'escape_char_left': '`', 'escape_char_right': '`'}

    generate_model()

    dbt_logs = dbt_runner.run_dbt_models(model_names=[request.node.name],
                                         args=var_dict)
    actual_sql = macro_test_helpers.retrieve_compiled_model(request.node.name)
    expected_sql = macro_test_helpers.retrieve_expected_sql(request)

    assert macro_test_helpers.is_successful_run(dbt_logs)
    assert actual_sql == expected_sql


@pytest.mark.macro
def test_escape_single_item_list_with_double_quotes_backticks_is_successful(request, generate_model):
    var_dict = {'columns': ["COLUMN1"], 'escape_char_left': "`", 'escape_char_right': "`"}

    generate_model()

    dbt_logs = dbt_runner.run_dbt_models(model_names=[request.node.name],
                                         args=var_dict)
    actual_sql = macro_test_helpers.retrieve_compiled_model(request.node.name)
    expected_sql = macro_test_helpers.retrieve_expected_sql(request)

    assert macro_test_helpers.is_successful_run(dbt_logs)
    assert actual_sql == expected_sql


@pytest.mark.macro
def test_escape_multiple_item_list_with_single_quotes_backticks_is_successful(request, generate_model):
    var_dict = {'columns': ['COLUMN1', 'COLUMN_2', 'COLUMN-3', '_COLUMN4', 'COLUMN 5'], 'escape_char_left': '`',
                'escape_char_right': '`'}

    generate_model()

    dbt_logs = dbt_runner.run_dbt_models(model_names=[request.node.name],
                                         args=var_dict)
    actual_sql = macro_test_helpers.retrieve_compiled_model(request.node.name)
    expected_sql = macro_test_helpers.retrieve_expected_sql(request)

    assert macro_test_helpers.is_successful_run(dbt_logs)
    assert actual_sql == expected_sql


@pytest.mark.macro
def test_escape_multiple_item_list_with_double_quotes_backticks_is_successful(request, generate_model):
    var_dict = {'columns': ["COLUMN1", "COLUMN_2", "COLUMN-3", "_COLUMN4", "COLUMN 5"], 'escape_char_left': "`",
                'escape_char_right': "`"}

    generate_model()

    dbt_logs = dbt_runner.run_dbt_models(model_names=[request.node.name],
                                         args=var_dict)
    actual_sql = macro_test_helpers.retrieve_compiled_model(request.node.name)
    expected_sql = macro_test_helpers.retrieve_expected_sql(request)

    assert macro_test_helpers.is_successful_run(dbt_logs)
    assert actual_sql == expected_sql


@pytest.mark.macro
def test_escape_multiple_item_list_with_single_and_double_quotes_backticks_is_successful(request, generate_model):
    var_dict = {'columns': ["COLUMN1", 'COLUMN_2', 'COLUMN-3', "_COLUMN4", "COLUMN 5"], 'escape_char_left': "`",
                'escape_char_right': '`'}

    generate_model()

    dbt_logs = dbt_runner.run_dbt_models(model_names=[request.node.name],
                                         args=var_dict)
    actual_sql = macro_test_helpers.retrieve_compiled_model(request.node.name)
    expected_sql = macro_test_helpers.retrieve_expected_sql(request)

    assert macro_test_helpers.is_successful_run(dbt_logs)
    assert actual_sql == expected_sql


@pytest.mark.macro
def test_escape_string_with_single_quotes_sbrackets_is_successful(request, generate_model):
    var_dict = {'columns': 'COLUMN1', 'escape_char_left': '[', 'escape_char_right': ']'}

    generate_model()

    dbt_logs = dbt_runner.run_dbt_models(model_names=[request.node.name],
                                         args=var_dict)
    actual_sql = macro_test_helpers.retrieve_compiled_model(request.node.name)
    expected_sql = macro_test_helpers.retrieve_expected_sql(request)

    assert macro_test_helpers.is_successful_run(dbt_logs)
    assert actual_sql == expected_sql


@pytest.mark.macro
def test_escape_string_with_double_quotes_sbrackets_is_successful(request, generate_model):
    var_dict = {'columns': "COLUMN1", 'escape_char_left': "[", 'escape_char_right': "]"}

    generate_model()

    dbt_logs = dbt_runner.run_dbt_models(model_names=[request.node.name],
                                         args=var_dict)
    actual_sql = macro_test_helpers.retrieve_compiled_model(request.node.name)
    expected_sql = macro_test_helpers.retrieve_expected_sql(request)

    assert macro_test_helpers.is_successful_run(dbt_logs)
    assert actual_sql == expected_sql


@pytest.mark.macro
def test_escape_single_item_list_with_single_quotes_sbrackets_is_successful(request, generate_model):
    var_dict = {'columns': ['COLUMN1'], 'escape_char_left': '[', 'escape_char_right': ']'}

    generate_model()

    dbt_logs = dbt_runner.run_dbt_models(model_names=[request.node.name],
                                         args=var_dict)
    actual_sql = macro_test_helpers.retrieve_compiled_model(request.node.name)
    expected_sql = macro_test_helpers.retrieve_expected_sql(request)

    assert macro_test_helpers.is_successful_run(dbt_logs)
    assert actual_sql == expected_sql


@pytest.mark.macro
def test_escape_single_item_list_with_double_quotes_sbrackets_is_successful(request, generate_model):
    var_dict = {'columns': ["COLUMN1"], 'escape_char_left': "[", 'escape_char_right': "]"}

    generate_model()

    dbt_logs = dbt_runner.run_dbt_models(model_names=[request.node.name],
                                         args=var_dict)
    actual_sql = macro_test_helpers.retrieve_compiled_model(request.node.name)
    expected_sql = macro_test_helpers.retrieve_expected_sql(request)

    assert macro_test_helpers.is_successful_run(dbt_logs)
    assert actual_sql == expected_sql


@pytest.mark.macro
def test_escape_multiple_item_list_with_single_quotes_sbrackets_is_successful(request, generate_model):
    var_dict = {'columns': ['COLUMN1', 'COLUMN_2', 'COLUMN-3', '_COLUMN4', 'COLUMN 5'], 'escape_char_left': '[',
                'escape_char_right': ']'}

    generate_model()

    dbt_logs = dbt_runner.run_dbt_models(model_names=[request.node.name],
                                         args=var_dict)
    actual_sql = macro_test_helpers.retrieve_compiled_model(request.node.name)
    expected_sql = macro_test_helpers.retrieve_expected_sql(request)

    assert macro_test_helpers.is_successful_run(dbt_logs)
    assert actual_sql == expected_sql


@pytest.mark.macro
def test_escape_multiple_item_list_with_double_quotes_sbrackets_is_successful(request, generate_model):
    var_dict = {'columns': ["COLUMN1", "COLUMN_2", "COLUMN-3", "_COLUMN4", "COLUMN 5"], 'escape_char_left': "[",
                'escape_char_right': "]"}

    generate_model()

    dbt_logs = dbt_runner.run_dbt_models(model_names=[request.node.name],
                                         args=var_dict)
    actual_sql = macro_test_helpers.retrieve_compiled_model(request.node.name)
    expected_sql = macro_test_helpers.retrieve_expected_sql(request)

    assert macro_test_helpers.is_successful_run(dbt_logs)
    assert actual_sql == expected_sql


@pytest.mark.macro
def test_escape_multiple_item_list_with_single_and_double_quotes_sbrackets_is_successful(request, generate_model):
    var_dict = {'columns': ["COLUMN1", 'COLUMN_2', 'COLUMN-3', "_COLUMN4", "COLUMN 5"], 'escape_char_left': '[',
                'escape_char_right': "]"}

    generate_model()

    dbt_logs = dbt_runner.run_dbt_models(model_names=[request.node.name],
                                         args=var_dict)
    actual_sql = macro_test_helpers.retrieve_compiled_model(request.node.name)
    expected_sql = macro_test_helpers.retrieve_expected_sql(request)

    assert macro_test_helpers.is_successful_run(dbt_logs)
    assert actual_sql == expected_sql


@pytest.mark.macro
def test_column_is_none_is_successful(request, generate_model):
    var_dict = {'columns': None}

    generate_model()

    dbt_logs = dbt_runner.run_dbt_models(model_names=[request.node.name],
                                         args=var_dict)

    actual_sql = macro_test_helpers.retrieve_compiled_model(request.node.name)

    assert macro_test_helpers.is_successful_run(dbt_logs)
    assert actual_sql == 'None'


@pytest.mark.macro
def test_escape_dictionary_with_single_quotes_is_successful(request, generate_model):
    var_dict = {'columns': {"source_column": 'COLUMN1', "alias": 'COLUMN2'}}

    generate_model()

    dbt_logs = dbt_runner.run_dbt_models(model_names=[request.node.name],
                                         args=var_dict)
    actual_sql = macro_test_helpers.retrieve_compiled_model(request.node.name)
    expected_sql = macro_test_helpers.retrieve_expected_sql(request)

    assert macro_test_helpers.is_successful_run(dbt_logs)
    assert actual_sql == expected_sql


@pytest.mark.macro
def test_escape_dictionary_with_single_quotes_backticks_is_successful(request, generate_model):
    var_dict = {'columns': {"source_column": 'COLUMN1', "alias": 'COLUMN2'}, 'escape_char_left': '`',
                'escape_char_right': '`'}

    generate_model()

    dbt_logs = dbt_runner.run_dbt_models(model_names=[request.node.name],
                                         args=var_dict)
    actual_sql = macro_test_helpers.retrieve_compiled_model(request.node.name)
    expected_sql = macro_test_helpers.retrieve_expected_sql(request)

    assert macro_test_helpers.is_successful_run(dbt_logs)
    assert actual_sql == expected_sql


@pytest.mark.macro
def test_escape_dictionary_with_single_quotes_sbrackets_is_successful(request, generate_model):
    var_dict = {'columns': {"source_column": 'COLUMN1', "alias": 'COLUMN2'}, 'escape_char_left': '[',
                'escape_char_right': ']'}

    generate_model()

    dbt_logs = dbt_runner.run_dbt_models(model_names=[request.node.name],
                                         args=var_dict)
    actual_sql = macro_test_helpers.retrieve_compiled_model(request.node.name)
    expected_sql = macro_test_helpers.retrieve_expected_sql(request)

    assert macro_test_helpers.is_successful_run(dbt_logs)
    assert actual_sql == expected_sql


@pytest.mark.macro
def test_escape_dictionary_with_double_quotes_is_successful(request, generate_model):
    var_dict = {'columns': {"source_column": "COLUMN1", "alias": "COLUMN2"}}

    generate_model()

    dbt_logs = dbt_runner.run_dbt_models(model_names=[request.node.name],
                                         args=var_dict)
    actual_sql = macro_test_helpers.retrieve_compiled_model(request.node.name)
    expected_sql = macro_test_helpers.retrieve_expected_sql(request)

    assert macro_test_helpers.is_successful_run(dbt_logs)
    assert actual_sql == expected_sql


@pytest.mark.macro
def test_escape_dictionary_with_double_quotes_backticks_is_successful(request, generate_model):
    var_dict = {'columns': {"source_column": "COLUMN1", "alias": "COLUMN2"}, 'escape_char_left': '`',
                'escape_char_right': '`'}

    generate_model()

    dbt_logs = dbt_runner.run_dbt_models(model_names=[request.node.name],
                                         args=var_dict)
    actual_sql = macro_test_helpers.retrieve_compiled_model(request.node.name)
    expected_sql = macro_test_helpers.retrieve_expected_sql(request)

    assert macro_test_helpers.is_successful_run(dbt_logs)
    assert actual_sql == expected_sql


@pytest.mark.macro
def test_escape_dictionary_with_double_quotes_sbrackets_is_successful(request, generate_model):
    var_dict = {'columns': {"source_column": "COLUMN1", "alias": "COLUMN2"}, 'escape_char_left': '[',
                'escape_char_right': ']'}

    generate_model()

    dbt_logs = dbt_runner.run_dbt_models(model_names=[request.node.name],
                                         args=var_dict)
    actual_sql = macro_test_helpers.retrieve_compiled_model(request.node.name)
    expected_sql = macro_test_helpers.retrieve_expected_sql(request)

    assert macro_test_helpers.is_successful_run(dbt_logs)
    assert actual_sql == expected_sql


@pytest.mark.macro
def test_escape_partial_dictionary_raises_error_1(request, generate_model):
    var_dict = {'columns': {"source_column": "COLUMN1"}}

    generate_model()

    dbt_logs = dbt_runner.run_dbt_models(model_names=[request.node.name],
                                         args=var_dict)

    assert "Invalid column name(s) provided. " \
           "Must be a string, a list of strings, or a dictionary of hashdiff metadata." in dbt_logs


@pytest.mark.macro
def test_escape_partial_dictionary_raises_error_2(request, generate_model):
    var_dict = {'columns': {"alias": "COLUMN2"}}

    generate_model()

    dbt_logs = dbt_runner.run_dbt_models(model_names=[request.node.name],
                                         args=var_dict)

    assert "Invalid column name(s) provided. " \
           "Must be a string, a list of strings, or a dictionary of hashdiff metadata." in dbt_logs


@pytest.mark.macro
def test_column_is_empty_dictionary_is_successful(request, generate_model):
    var_dict = {'columns': {}}

    generate_model()

    dbt_logs = dbt_runner.run_dbt_models(model_names=[request.node.name],
                                         args=var_dict)

    actual_sql = macro_test_helpers.retrieve_compiled_model(request.node.name)

    assert macro_test_helpers.is_successful_run(dbt_logs)
    assert actual_sql == '{}'
