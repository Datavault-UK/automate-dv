import logging
from pathlib import PurePath, Path

PROJECT_ROOT = PurePath(__file__).parents[1]
PROFILE_DIR = Path(f"{PROJECT_ROOT}/env")
TESTS_ROOT = Path(f"{PROJECT_ROOT}/test")
TEST_PROJECT_ROOT = Path(f"{TESTS_ROOT}/dbtvault_test")
TEST_MODELS_ROOT = TEST_PROJECT_ROOT / 'models'
TEST_MACRO_ROOT = Path(f"{TESTS_ROOT}/test_macro/")
TEST_HARNESS_TESTS_ROOT = Path(f"{TESTS_ROOT}/test_harness/")
SCHEMA_YML_FILE = TEST_MODELS_ROOT / 'schema.yml'
TEST_SCHEMA_YML_FILE = TEST_MODELS_ROOT / 'schema_test.yml'
DBT_PROJECT_YML_FILE = TEST_PROJECT_ROOT / 'dbt_project.yml'
INVOKE_YML_FILE = PROJECT_ROOT / 'invoke.yml'
OP_DB_FILE = PROJECT_ROOT / 'env/db.env'
BACKUP_TEST_SCHEMA_YML_FILE = TESTS_ROOT / 'backup_files/schema_test.bak.yml'
BACKUP_DBT_PROJECT_YML_FILE = TESTS_ROOT / 'backup_files/dbt_project.bak.yml'
COMPILED_TESTS_DBT_ROOT = Path(f"{TEST_PROJECT_ROOT}/target/compiled/dbtvault_test/models/")
ENV_TEMPLATE_DIR = PROJECT_ROOT / 'env/templates'

FEATURES_ROOT = TESTS_ROOT / 'features'
SEEDS_DIR = TEST_PROJECT_ROOT / 'seeds'
TEMP_SEED_DIR = TEST_PROJECT_ROOT / 'seeds/temp'

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
