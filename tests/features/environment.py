from tests.dbt_test_utils import *
from fixtures import set_workdir
from behave.fixture import use_fixture_by_tag

fixture_registry = {
    "fixture.set_workdir": set_workdir}


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


def before_tag(context, tag):
    if tag.startswith("fixture."):
        return use_fixture_by_tag(tag, context, fixture_registry)
