import logging
from unittest.mock import Mock

from vaultBase.cliParse import CLIParse
from vaultBase.configReader import ConfigReader
from vaultBase.connector import Connector
from vaultBase.logger import Logger
from vaultBase.testing.configGenerator import ConfigGenerator
from vaultBase.testing.dbTestUtils import DBTestUtils

from definitions import FEATURES_ROOT


def before_scenario(context, scenario):
    config_path = FEATURES_ROOT / 'config'
    credentials_path = FEATURES_ROOT / 'config' / 'credentials.json'

    context.dbutils = DBTestUtils()

    cli_args = CLIParse("dbtvault Behave Tests", "dbtvault")
    cli_args.config_name = str(config_path / 'config')
    cli_args.get_log_level = Mock(return_value=logging.DEBUG)

    config_gen = ConfigGenerator()
    config_gen.from_template("MAIN", file_path=config_path / "config.ini",
                             amend_dict={'credentials': {'path': credentials_path}})

    logger = Logger("dbtvault-test", cli_args)
    config = ConfigReader(logger, cli_args)

    context.connection = Connector(logger, config.credentials)
