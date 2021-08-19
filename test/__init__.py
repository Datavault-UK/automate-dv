import logging
from pathlib import PurePath, Path

PROJECT_ROOT = PurePath(__file__).parents[1]
PROFILE_DIR = Path(f"{PROJECT_ROOT}/env")
TESTS_ROOT = Path(f"{PROJECT_ROOT}/test")
TESTS_DBT_ROOT = Path(f"{TESTS_ROOT}/dbtvault_test")
TEST_MODELS_ROOT = TESTS_DBT_ROOT / 'models'
SCHEMA_YML_FILE = TEST_MODELS_ROOT / 'schema.yml'
TEST_SCHEMA_YML_FILE = TEST_MODELS_ROOT / 'schema_test.yml'
DBT_PROJECT_YML_FILE = TESTS_DBT_ROOT / 'dbt_project.yml'
INVOKE_YML_FILE = PROJECT_ROOT / 'invoke.yml'
OP_DB_FILE = PROJECT_ROOT / 'env/db.env'
BACKUP_TEST_SCHEMA_YML_FILE = TESTS_ROOT / 'backup_files/schema_test.bak.yml'
BACKUP_DBT_PROJECT_YML_FILE = TESTS_ROOT / 'backup_files/dbt_project.bak.yml'
COMPILED_TESTS_DBT_ROOT = Path(f"{TESTS_DBT_ROOT}/target/compiled/dbtvault_test/models/")
TEST_MACRO_ROOT = Path(f"{TESTS_ROOT}/test_macro/")
FEATURES_ROOT = TESTS_ROOT / 'features'
CSV_DIR = TESTS_DBT_ROOT / 'data/temp'

AVAILABLE_PLATFORMS = ['snowflake', 'bigquery', 'sqlserver']

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
