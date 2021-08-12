import pytest

from harness_utils import dbtvault_generator


@pytest.hookimpl(trylast=True)
def pytest_collection_modifyitems(items):
    macro_test_marks = [
        'single_source_hub'
    ]

    for item in items:
        current_marks = [mark.name for mark in item.own_markers]

        if any([mark in current_marks for mark in macro_test_marks]):
            item.fixturenames.append('generate_model')


@pytest.fixture(autouse=True)
def generate_model(request):
    mark_metadata_mapping = {
        "single_source_hub": metadata_single_source_hub,
        "multi_source_hub": metadata_multi_source_hub
    }

    mark_name = [mark.name for mark in request.node.own_markers
                 if mark.name in mark_metadata_mapping.keys()][0]

    vault_structure = getattr(request.module, "vault_structure")

    dbtvault_generator.raw_vault_structure(model_name=request.node.name,
                                           vault_structure=vault_structure,
                                           **mark_metadata_mapping[mark_name]())


def metadata_single_source_hub() -> dict:
    return dict(source_model="raw_source",
                src_pk="CUSTOMER_PK",
                src_nk="CUSTOMER_ID",
                src_ldts="LOADDATE",
                src_source="RECORD_SOURCE")


def metadata_multi_source_hub() -> dict:
    return dict(source_model="raw_source",
                src_pk="CUSTOMER_PK",
                src_nk="CUSTOMER_ID",
                src_ldts="LOADDATE",
                src_source="RECORD_SOURCE")



