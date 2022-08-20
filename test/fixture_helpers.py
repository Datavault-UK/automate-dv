from typing import List


def compile_aliased_metadata(aliased_metadata: List[dict], metadata: dict) -> dict:
    compiled = dict()

    for metadata_definition in aliased_metadata:
        for table_name in metadata_definition['aliases']:
            compiled = {**compiled, **{table_name: {'column_types': metadata_definition['column_types']}}}

    return {**compiled, **metadata}
