from behave.fixture import use_fixture_by_tag

from fixtures import set_workdir
from tests.test_utils.dbt_test_utils import *

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

    # Replace schema.yml with schema_test.bak
    DBTVAULTGenerator.clean_test_schema()


def after_scenario(context, scenario):
    """
    Clean generated files after every scenario
        :param context: behave context
        :param scenario: Current scenario
    """

    DBTTestUtils.clean_csv()
    DBTTestUtils.clean_models()
    DBTTestUtils.clean_target()

    DBTVAULTGenerator.clean_test_schema()


def before_tag(context, tag):
    if tag.startswith("fixture."):
        return use_fixture_by_tag(tag, context, fixture_registry)
