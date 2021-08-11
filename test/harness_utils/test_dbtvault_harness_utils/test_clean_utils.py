import tempfile
from pathlib import Path
from unittest.mock import patch

import pytest


@pytest.fixture()
def sample_directory_tree(tmp_path):
    directory_dict = {
        'csv': {
            'my_file_1.csv': "my, csv, file, 2",
            'my_file_2.csv': "my, csv, file, 3",
        },
        'sql': {
            'my_file_1.sql': "SELECT * FROM 1",
            'my_file_2.sql': "SELECT * FROM 2",
        },
        'target': {
            'my_file_1.sql': "SELECT * FROM 1",
            'my_file_2.sql': "SELECT * FROM 2",
        }
    }

    paths = dict()

    # Generate directory structure from the above dict
    for k, v in directory_dict.items():
        full_path = Path(tmp_path) / k
        Path(full_path).mkdir(parents=True)
        if isinstance(v, dict):
            paths[k] = list()
            for ik, iv in v.items():
                if '.' in ik:
                    file_name, ext = ik.split('.')
                    file = tempfile.NamedTemporaryFile(prefix=file_name, suffix=f'.{ext}', dir=full_path, delete=False)
                    full_file_path = Path(full_path) / file.name
                    paths[k].append(full_file_path)
                    with open(full_file_path, 'w+') as f:
                        f.write(iv)
    return paths


def test_clean_csv_success(tmp_path, sample_directory_tree):
    
    with patch('test.INVOKE_YML_FILE', Path(file.name)):
        sample_directory_tree['csv']
    assert False


def test_clean_target_success(tmp_path):
    assert False


def test_clean_models_success(tmp_path):
    assert False
