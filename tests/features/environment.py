from vaultBase.testing.dbTestUtils import DBTestUtils

from definitions import TESTS_ROOT


# TODO: Fully integrate DBUtils
def before_scenario(context, scenario):
    context.dbutils = DBTestUtils()


def after_scenario(context, scenario):
    context.testdata.close_connection()
