import logging
from pathlib import PurePath, Path

PROJECT_ROOT = PurePath(__file__).parents[1]
PROFILE_DIR = Path(f"{PROJECT_ROOT}/profiles")
TESTS_ROOT = Path(f"{PROJECT_ROOT}/test")
TESTS_DBT_ROOT = Path(f"{TESTS_ROOT}/dbtvault_test")
MODELS_ROOT = TESTS_DBT_ROOT / 'models'
SCHEMA_YML_FILE = MODELS_ROOT / 'schema.yml'
TEST_SCHEMA_YML_FILE = MODELS_ROOT / 'schema_test.yml'
DBT_PROJECT_YML_FILE = TESTS_DBT_ROOT / 'dbt_project.yml'
INVOKE_YML_FILE = PROJECT_ROOT / 'invoke.yml'
BACKUP_TEST_SCHEMA_YML_FILE = TESTS_ROOT / 'backup_files/schema_test.bak.yml'
BACKUP_DBT_PROJECT_YML_FILE = TESTS_ROOT / 'backup_files/dbt_project.bak.yml'
FEATURE_MODELS_ROOT = MODELS_ROOT / 'feature'
COMPILED_TESTS_DBT_ROOT = Path(f"{TESTS_DBT_ROOT}/target/compiled/dbtvault_test/models/unit")
EXPECTED_OUTPUT_FILE_ROOT = Path(f"{TESTS_ROOT}/unit/expected_model_output")
FEATURES_ROOT = TESTS_ROOT / 'features'
CSV_DIR = TESTS_DBT_ROOT / 'data/temp'

AVAILABLE_TARGETS = ['snowflake', 'bigquery', 'sqlserver']

# Setup logging
logger = logging.getLogger('dbtvault')

logging.basicConfig(level=logging.INFO)

if not logger.handlers:
    ch = logging.StreamHandler()
    ch.setLevel(logging.DEBUG)
    formatter = logging.Formatter('(%(name)s) %(levelname)s: %(message)s')
    ch.setFormatter(formatter)

    logger.addHandler(ch)
    logger.setLevel(logging.DEBUG)
    logger.propagate = False
