from helpers.TestData import TestData
from definitions import TESTS_ROOT


def before_scenario(context, scenario):
    context.testdata = TestData("{}}/features/helpers/credentials.json".format(TESTS_ROOT))


def after_scenario(context, scenario):
    context.testdata.close_connection()
