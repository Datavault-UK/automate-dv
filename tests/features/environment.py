from helpers.TestData import TestData


def before_scenario(context, scenario):
    context.testdata = TestData("/home/dev/PycharmProjects/SnowflakeDemo3/tests/features/helpers/credentials.json")

