import os
from pathlib import Path
from unittest.mock import patch

from harness_utils import dbtvault_harness_utils


def test_clean_csv_success(sample_directory_tree):
    paths, tmp_dir = sample_directory_tree

    tmp_csv_dir = Path(tmp_dir) / 'csv'

    assert set(os.listdir(tmp_csv_dir)) == {path.name for path in paths['csv']}

    with patch('test.CSV_DIR', tmp_csv_dir):
        dbtvault_harness_utils.clean_csv()

    assert not os.listdir(tmp_csv_dir)


def test_clean_target_success(sample_directory_tree):
    paths, tmp_dir = sample_directory_tree

    tmp_target_dir = Path(tmp_dir) / 'target'

    assert set(os.listdir(tmp_target_dir)) == {path.name for path in paths['target']}

    with patch('test.TESTS_DBT_ROOT', tmp_dir):
        dbtvault_harness_utils.clean_target()

    assert 'target' not in os.listdir(tmp_dir)


def test_clean_models_success(sample_directory_tree):
    paths, tmp_dir = sample_directory_tree

    tmp_models_dir = Path(tmp_dir) / 'models'

    assert set(os.listdir(tmp_models_dir)) == {path.name for path in paths['models']}

    with patch('test.FEATURE_MODELS_ROOT', tmp_models_dir):
        dbtvault_harness_utils.clean_models()

    assert not os.listdir(tmp_models_dir)
