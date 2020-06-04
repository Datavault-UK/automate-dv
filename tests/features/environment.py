from tests.dbt_test_utils import *


def before_all(context):
    """
    Set up the full test environment and add objects to the context for use in steps
    """

    context.config.setup_logging()
    context.dbt_test_utils = DBTTestUtils()


def after_scenario(context, scenario):
    """
    Clean generated csv after every scenario
    :param context: behave context
    :param scenario: Current scenario
    """

    DBTTestUtils.clean_csv()
