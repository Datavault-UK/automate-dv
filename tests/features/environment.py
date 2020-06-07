from tests.dbt_test_utils import *
from fixtures import set_workdir
from behave.fixture import use_fixture_by_tag

fixture_registry = {
    "fixture.set_workdir": set_workdir}


def before_all(context):
    """
    Set up the full test environment and add objects to the context for use in steps
    """

    dbt_test_utils = DBTTestUtils()

    # Setup context
    context.config.setup_logging()
    context.dbt_test_utils = dbt_test_utils

    # Clean dbt folders and generated files
    DBTTestUtils.clean_csv()
    DBTTestUtils.clean_models()
    DBTTestUtils.clean_target()


def after_scenario(context, scenario):
    """
    Clean generated files after every scenario
        :param context: behave context
        :param scenario: Current scenario
    """

    DBTTestUtils.clean_csv()
    DBTTestUtils.clean_models()
    DBTTestUtils.clean_target()


def before_tag(context, tag):
    if tag.startswith("fixture."):
        return use_fixture_by_tag(tag, context, fixture_registry)
