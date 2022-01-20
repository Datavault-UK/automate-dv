import logging
import tempfile
from pathlib import Path
from unittest.mock import patch

import pytest
import yaml

from env import env_utils


def test_platform_correctly_read(tmp_path):
    file = tempfile.NamedTemporaryFile(prefix="test_invoke", suffix='.yml', dir=tmp_path)

    expected_dict = {
        'project': 'test',
        'platform': 'snowflake'
    }

    with open(Path(file.name), 'w') as f:
        yaml.dump(expected_dict, f)

    with patch('test.INVOKE_YML_FILE', Path(file.name)):
        actual_dict = env_utils.platform()
        assert actual_dict == expected_dict['platform']


def test_platform_invalid_target_error(tmp_path, caplog, temporary_prop):
    file = tempfile.NamedTemporaryFile(prefix="test_invoke", suffix='.yml', dir=tmp_path)

    expected_dict = {
        'project': 'test',
        'platform': 'java'
    }

    with open(Path(file.name), 'w') as f:
        yaml.dump(expected_dict, f)

    with patch('test.INVOKE_YML_FILE', Path(file.name)):
        with caplog.at_level(logging.ERROR):
            with pytest.raises(SystemExit):
                env_utils.platform()

    expected_error_msg = f"Platform must be set to one of: {', '.join(env_utils.AVAILABLE_PLATFORMS)} " \
                         f"in '{Path(file.name)}'"
    assert expected_error_msg in caplog.text


def test_platform_missing_file_error(tmp_path, caplog, temporary_prop):
    missing_file_path = Path(tmp_path / 'my_missing_file.yml')

    with patch('test.INVOKE_YML_FILE', missing_file_path):
        with caplog.at_level(logging.ERROR):
            with pytest.raises(SystemExit):
                env_utils.platform()

    expected_error_msg = f"'{missing_file_path}' not found. Please run 'inv setup'"
    assert expected_error_msg in caplog.text
