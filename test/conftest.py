import tempfile
from pathlib import Path

import pytest


def dict_to_directories(dir_dict: dict, root_path: Path):
    """ Generate directory structure from the provided dict representing a directory structure """
    paths = dict()

    for k, v in dir_dict.items():
        full_path = Path(root_path) / k
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


@pytest.fixture()
def sample_directory_tree(tmp_path):
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

    paths = dict_to_directories(directory_dict, tmp_path)

    return paths, tmp_path
