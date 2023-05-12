import ruamel.yaml
import test

def write_seed_properties(seed_name: str, seed_config: dict):
    yml = ruamel.yaml.YAML()

    seed_property = {
        'version': 2,
        'seeds': [
            {'name': seed_name,
             'config': {
                 'schema': 'development',
                 'quote_columns': True,
                 'column_types': seed_config['column_types']
             }}
        ]
    }

    with open(test.TEMP_SEED_DIR / 'properties_test.yml', 'w+') as f:
        yml.width = 150
        yml.indent(sequence=4, offset=2)

        yml.dump(seed_property, f)


def write_model_test_properties(actual_model_name, expected_model_name, unique_id, columns_to_compare):
    yml = ruamel.yaml.YAML()

    test_property = {
        'version': 2,
        'models': [
            {'name': actual_model_name,
             'tests': [{
                 "expect_tables_to_match": {
                     "expected_seed": expected_model_name,
                     "unique_id": unique_id,
                     "compare_columns": columns_to_compare
                 }
             }]}
        ]
    }

    with open(test.TEST_MODELS_ROOT / 'schema_test.yml', 'w+') as f:
        yml.width = 150
        yml.indent(sequence=4, offset=2)

        yml.dump(test_property, f)


def generate_model(model_name, sql):
    template = f"""
    {{{{- config(materialized='table') -}}}}

    {sql}
    """

    with open(test.TEST_MODELS_ROOT / f"{model_name}.sql", "w") as f:
        f.write(template.strip())