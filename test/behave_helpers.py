import glob
import os
import shutil
from pathlib import Path

import test
from test.dbt_runner import run_dbt_operation


def clean_target():
    """
    Deletes content in target folder (compiled SQL)
    Faster than running dbt clean.
    """

    shutil.rmtree(test.TEST_PROJECT_ROOT / 'target', ignore_errors=True)


def clean_seeds(model_name=None):
    """
    Deletes csv files in csv folder.
    """

    if model_name:
        delete_files = [test.TEMP_SEED_DIR / f"{model_name.lower()}.csv"]
    else:
        delete_files = []
        for (dir_path, dir_names, filenames) in os.walk(test.TEMP_SEED_DIR):
            for filename in filenames:
                if filename != ".gitkeep":
                    delete_files.append(Path(dir_path) / filename)

    for file in delete_files:
        if os.path.isfile(file):
            os.remove(file)


def clean_models(model_name=None):
    """
    Deletes models in features folder.
    """

    if model_name:
        delete_files = [test.TEST_MODELS_ROOT / f"{model_name.lower()}.sql"]
    else:
        delete_files = [file for file in glob.glob(str(test.TEST_MODELS_ROOT / '*.sql'), recursive=True)]

    for file in delete_files:
        if os.path.isfile(file):
            os.remove(file)


def replace_test_schema():
    """
    Drop and create the TEST schema
    """

    run_dbt_operation(macro_name='recreate_current_schemas')


def create_test_schemas():
    """
    Create TEST schemas
    """

    run_dbt_operation(macro_name='create_test_schemas')


def drop_test_schemas():
    """
    Drop TEST schemas
    """

    run_dbt_operation(macro_name='drop_test_schemas')
