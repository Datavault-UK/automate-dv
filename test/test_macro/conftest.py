import os

import pytest

import dbtvault_generator
import dbtvault_harness_utils
import test
from test_macro import metadata

mark_metadata_mapping = {
    "single_source_hub": metadata.single_source_hub,
    "single_source_multi_nk_hub": metadata.single_source_multi_nk_hub,
    "multi_source_hub": metadata.multi_source_hub,
    "multi_source_multi_nk_hub": metadata.multi_source_multi_nk_hub
}


@pytest.hookimpl(trylast=True)
def pytest_collection_modifyitems(items):
    for item in items:
        current_marks = [mark.name for mark in item.own_markers]

        if any([mark in current_marks for mark in mark_metadata_mapping.keys()]):
            item.fixturenames.append('generate_model')


@pytest.fixture(autouse=True)
def generate_model(request):
    mark_name = [mark.name for mark in request.node.own_markers
                 if mark.name in mark_metadata_mapping.keys()][0]

    vault_structure = getattr(request.module, "vault_structure")

    dbtvault_generator.raw_vault_structure(model_name=request.node.name,
                                           vault_structure=vault_structure,
                                           **mark_metadata_mapping[mark_name]())


@pytest.fixture(scope='session', autouse=True)
def setup():
    os.environ['TARGET'] = dbtvault_harness_utils.target()
    os.chdir(test.TESTS_DBT_ROOT)
    dbtvault_harness_utils.clean_models()
    dbtvault_harness_utils.clean_target()
    dbtvault_harness_utils.replace_test_schema()
    dbtvault_harness_utils.run_dbt_seed()
    yield
