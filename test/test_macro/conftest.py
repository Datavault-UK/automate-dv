import os

import pytest

import test
from test import dbtvault_generator
from test import dbtvault_harness_utils
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
            if selected_mark[0] in mark_metadata_mapping.keys() and selected_mark[0] is not "macro":
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
def setup():
    dbtvault_harness_utils.setup_environment()
    os.chdir(test.TESTS_DBT_ROOT)
    dbtvault_harness_utils.clean_models()
    dbtvault_harness_utils.clean_target()
    dbtvault_harness_utils.replace_test_schema()
    dbtvault_harness_utils.run_dbt_seed()
    yield
