import json
import os

import pytest
from filelock import FileLock

import test
from env import env_utils
from test import dbtvault_generator, behave_helpers, dbt_runner
from . import structure_metadata

mark_metadata_mapping = {
    "single_source_hub": structure_metadata.single_source_hub,
    "single_source_multi_nk_hub": structure_metadata.single_source_multi_nk_hub,
    "multi_source_hub": structure_metadata.multi_source_hub,
    "multi_source_multi_nk_hub": structure_metadata.multi_source_multi_nk_hub,
    "single_source_link": structure_metadata.single_source_link,
    "multi_source_link": structure_metadata.multi_source_link,
}


@pytest.fixture()
def generate_model(request):
    def _generate_model(metadata=None):

        macro_name = getattr(request.module, "macro_name")
        applied_marks = set(marker.name for marker in request.node.own_markers)
        available_marks = set(mark_metadata_mapping.keys())
        selected_mark = list(applied_marks & available_marks)

        if selected_mark:
            if selected_mark[0] in mark_metadata_mapping.keys() and selected_mark[0] != "macro":
                dbtvault_generator.raw_vault_structure(model_name=request.node.name,
                                                       vault_structure=macro_name,
                                                       **mark_metadata_mapping[selected_mark[0]]())
        elif "macro" in applied_marks:

            dbtvault_generator.macro_model(macro_name=macro_name,
                                           model_name=request.node.name,
                                           metadata=metadata)

        else:
            if applied_marks:
                raise ValueError(f"Invalid mark(s): {', '.join(applied_marks)}")
            else:
                raise ValueError(f"Missing a mark (e.g. @pytest.mark.macro)")

    yield _generate_model


@pytest.fixture(scope='session', autouse=True)
def setup(tmp_path_factory, worker_id):
    def test_setup():
        os.chdir(test.TEST_PROJECT_ROOT)
        env_utils.setup_environment()
        behave_helpers.clean_models()
        behave_helpers.clean_target()
        behave_helpers.replace_test_schema()
        dbt_runner.run_dbt_seeds()

    # If not parallel
    if worker_id == "master":
        test_setup()
    else:
        root_tmp_dir = tmp_path_factory.getbasetemp().parent

        fn = root_tmp_dir / "flag.tmp"

        # Create a file and use locks to indicate setup has already occurred, avoid repeating setup
        with FileLock(str(fn) + ".lock"):
            if fn.is_file():
                os.chdir(test.TEST_PROJECT_ROOT)
                env_utils.setup_environment()
            else:
                test_setup()
                fn.write_text(json.dumps({'status': 'in-use'}))
