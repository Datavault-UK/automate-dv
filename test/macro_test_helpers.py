import re
from pathlib import Path

from _pytest.fixtures import FixtureRequest

import test
from env import env_utils


def retrieve_compiled_model(model_name: str, exclude_comments=True):
    """
    Retrieve the compiled SQL for a specific dbt model
        :param model_name: Model name to check
        :param exclude_comments: Exclude comments from output
        :return: Contents of compiled SQL file
    """

    with open(test.COMPILED_TESTS_DBT_ROOT / f'{model_name}.sql') as f:
        file = f.readlines()

        if exclude_comments:
            file = [line for line in file if '--' not in line]

        return "".join(file).strip()


def retrieve_expected_sql(request: FixtureRequest):
    """
    Retrieve the expected SQL for a specific dbt model
        :param request: pytest request for calling test
        :return: Contents of compiled SQL file
    """

    test_path = Path(request.fspath.strpath)
    macro_folder = test_path.parent.name
    macro_under_test = test_path.stem.split('test_')[1]
    model_name = request.node.name

    with open(test.TEST_MACRO_ROOT / macro_folder / "expected" /
              macro_under_test / env_utils.platform() / f'{model_name}.sql') as f:
        file = f.readlines()

        processed_file = inject_parameters("".join(file),
                                           env_utils.set_qualified_names_for_macro_tests())

        return processed_file


def inject_parameters(file_contents: str, parameters: dict):
    """
    Replace placeholders in a file with the provided dictionary
        :param file_contents: String containing expected file contents
        :param parameters: Dictionary of parameters {placeholder: value}
        :return: Parsed/injected file
    """

    if not parameters:
        return file_contents
    else:
        for key, val in parameters.items():
            file_contents = re.sub(rf'\[{key}]', val, file_contents, flags=re.IGNORECASE)

        remaining_placeholders = re.findall("|".join([rf'\[{key}]' for key in parameters.keys()]), file_contents)

        if remaining_placeholders:
            raise ValueError(f"Unable to replace some placeholder values: {', '.join(remaining_placeholders)}")

        return file_contents


def is_successful_run(dbt_logs: str):
    return 'Done' in dbt_logs and 'SQL compilation error' not in dbt_logs
