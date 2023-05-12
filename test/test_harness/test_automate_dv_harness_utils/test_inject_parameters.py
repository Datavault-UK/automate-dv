from test import macro_test_helpers


def test_inject_parameters_success():
    sample_file_contents = "SELECT * FROM [DATABASE].[SCHEMA].[TABLE]"

    expected_file_contents = "SELECT * FROM test_db.test_schema.test_table"

    params = {
        "DATABASE": "test_db",
        "SCHEMA": "test_schema",
        "TABLE": "test_table"
    }

    actual_file_contents = macro_test_helpers.inject_parameters(sample_file_contents,
                                                                params)

    assert actual_file_contents == expected_file_contents


def test_inject_parameters_case_insensitive_success():
    sample_file_contents = "SELECT * FROM [DATABASE].[SCHEMA].[TABLE]"

    expected_file_contents = "SELECT * FROM test_db.test_schema.test_table"

    params = {
        "database": "test_db",
        "ScHEmA": "test_schema",
        "TABLE": "test_table"
    }

    actual_file_contents = macro_test_helpers.inject_parameters(sample_file_contents,
                                                                params)

    assert actual_file_contents == expected_file_contents


def test_inject_parameters_missing_placeholders_success():
    sample_file_contents = "SELECT * FROM [DATABASE].[SCHEMA]"

    expected_file_contents = "SELECT * FROM test_db.test_schema"

    params = {
        "DATABASE": "test_db",
        "SCHEMA": "test_schema",
        "TABLE": "test_table"
    }

    actual_file_contents = macro_test_helpers.inject_parameters(sample_file_contents,
                                                                params)

    assert actual_file_contents == expected_file_contents


def test_inject_parameters_missing_params_success():
    sample_file_contents = "SELECT * FROM [DATABASE].[SCHEMA].[TABLE]"

    expected_file_contents = "SELECT * FROM test_db.test_schema.[TABLE]"

    params = {
        "DATABASE": "test_db",
        "SCHEMA": "test_schema"
    }

    actual_file_contents = macro_test_helpers.inject_parameters(sample_file_contents,
                                                                params)

    assert actual_file_contents == expected_file_contents
