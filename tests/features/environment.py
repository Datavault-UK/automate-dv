from helpers.TestData import TestData


def before_scenario(context, scenario):
    context.testdata = TestData("/home/dev/PycharmProjects/SnowflakeDemo/tests/features/helpers/credentials.json")


def after_scenario(context, scenario):

    context.testdata.close_connection()
