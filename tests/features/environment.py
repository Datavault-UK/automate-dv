from tests.dbt_test_utils import *


def before_all(context):
    """
    Set up the full test environment and add objects to the context for use in steps
    """

    context.dbt_test_utils = DBTTestUtils()


def after_scenario(context, scenario):
    DBTTestUtils.clean_csv()
