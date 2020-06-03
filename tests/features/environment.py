from unittest.mock import Mock

from vaultBase.cliParse import CLIParse
from vaultBase.logger import Logger
from vaultBase.testing.dbTestUtils import DBTestUtils

from steps.step_vars import DATABASE
from tests.dbt_test_utils import *


def before_all(context):
    """
    Set up the full test environment and add objects to the context for use in steps
    """

    config_path = FEATURES_ROOT / 'config'

    context.db_utils = DBTestUtils()
    context.dbt_test_utils = DBTTestUtils()

    cli_args = CLIParse("dbtvault Behave Tests", "dbtvault")
    cli_args.config_name = str(config_path / 'config')
    cli_args.get_log_level = Mock(return_value=logging.DEBUG)

    logger = Logger("dbtvault-test", cli_args)

    credentials = {
        "engine": os.getenv('TARGET', None),
        "un": os.getenv('SNOWFLAKE_DB_USER', None),
        "pw": os.getenv('SNOWFLAKE_DB_PW', None),
        "account": os.getenv('SNOWFLAKE_DB_ACCOUNT', None),
        "warehouse": os.getenv('SNOWFLAKE_DB_WH', None),
        "db": os.getenv('SNOWFLAKE_DB_DATABASE', None),
        "schema": os.getenv('SNOWFLAKE_DB_SCHEMA', None),
        "role": os.getenv('SNOWFLAKE_DB_ROLE', None)
    }

    if all(v is None for k, v in credentials.items()):
        raise SystemExit('Credentials not correctly loaded, please check environment.')

    connector = Connector(logger, credentials)

    context.connection = connector


def before_scenario(context, scenario):
    """
    Re-create the database before every scenario
    """

    context.connection.execute(f"DROP DATABASE IF EXISTS {DATABASE}")

    context.connection.execute(f"CREATE DATABASE IF NOT EXISTS {DATABASE}")
