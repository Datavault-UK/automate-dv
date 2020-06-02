from unittest.mock import Mock

from vaultBase.cliParse import CLIParse
from vaultBase.connector import Connector
from vaultBase.logger import Logger
from vaultBase.testing.dbTestUtils import DBTestUtils

from tests.dbt_test_utils import *
from steps.step_vars import DATABASE


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
        "engine": os.getenv('DB_ENGINE'),
        "un": os.getenv('DB_USER'),
        "pw": os.getenv('DB_PW'),
        "account": os.getenv('DB_ACCOUNT'),
        "warehouse": os.getenv('DB_WH'),
        "db": os.getenv('DB_DATABASE'),
        "schema": os.getenv('DB_SCHEMA'),
        "role": os.getenv('DB_ROLE')
    }

    connector = Connector(logger, credentials)

    context.connection = connector


def before_scenario(context, scenario):
    """
    Re-create the database before every scenario
    """

    context.connection.execute(f"DROP DATABASE IF EXISTS {DATABASE}")

    context.connection.execute(f"CREATE DATABASE IF NOT EXISTS {DATABASE}")
