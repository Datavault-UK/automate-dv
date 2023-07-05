import os
from pathlib import Path
from unittest.mock import patch

from test import behave_helpers

directory_dict = {
    'csv': {
        'my_file_1.csv': "my, csv, file, 2",
        'my_file_2.csv': "my, csv, file, 3",
    },
    'models': {
        'my_file_1.sql': "SELECT * FROM 1",
        'my_file_2.sql': "SELECT * FROM 2",
    },
    'target': {
        'my_file_1.sql': "SELECT * FROM 1",
        'my_file_2.sql': "SELECT * FROM 2",
        'my_file_1.csv': "my, csv, file, 2",
        'my_file_2.csv': "my, csv, file, 3"
    }
}


def test_clean_seeds_success(sample_directory_tree):
    paths, tmp_dir = sample_directory_tree(directory_dict)

    tmp_csv_dir = Path(tmp_dir) / 'csv'

    assert set(os.listdir(tmp_csv_dir)) == {path.name for path in paths['csv']}

    with patch('test.TEMP_SEED_DIR', tmp_csv_dir):
        behave_helpers.clean_seeds()

    assert not os.listdir(tmp_csv_dir)


def test_clean_target_success(sample_directory_tree):
    paths, tmp_dir = sample_directory_tree(directory_dict)

    tmp_target_dir = Path(tmp_dir) / 'target'

    assert set(os.listdir(tmp_target_dir)) == {path.name for path in paths['target']}

    with patch('test.TEST_PROJECT_ROOT', tmp_dir):
        behave_helpers.clean_target()

    assert 'target' not in os.listdir(tmp_dir)


def test_clean_models_success(sample_directory_tree):
    paths, tmp_dir = sample_directory_tree(directory_dict)

    tmp_models_dir = Path(tmp_dir) / 'models'

    assert set(os.listdir(tmp_models_dir)) == {path.name for path in paths['models']}

    with patch('test.TEST_MODELS_ROOT', tmp_models_dir):
        behave_helpers.clean_models()

    assert not os.listdir(tmp_models_dir)
