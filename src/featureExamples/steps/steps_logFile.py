import os
import time
from pathlib import PurePath

from behave import *

import bindings

use_step_matcher("parse")


@when("I run the vaultLoader with command line arguments")
def step_impl(context):
    program_output = bindings.run("tests/features/helpers/config/config_tests")

    for file_name in os.listdir("tests/features/helpers/logs/"):

        context.timestamp = PurePath(file_name).stem.replace("vaultLoader-", "")

    try:
        context.timestamp
    except AttributeError:
        assert False


@when("I run the vaultLoader with a protected logging directory")
def step_impl(context):
    context.output = bindings.run("tests/config/config_logging_perms")


@when("I run the vaultLoader with a non-existent logging directory")
def step_impl(context):
    context.output = bindings.run("tests/config/config_logging_missing")


@then("there will be a logfile")
def step_impl(context):
    if os.path.isfile(os.path.join("tests/features/helpers/logs/", "vaultLoader-{}.log".format(context.timestamp))):
        assert True
    else:
        assert False


@step("the logfile name will start with 'vaultLoader-'")
def step_impl(context):
    for file_name in os.listdir("tests/features/helpers/logs/"):
        if file_name.startswith('vaultLoader-'):
            assert True
        else:
            assert False


@step("the logfile name will end with a datetime stamp formatted as d-m-Y_I:M:S")
def step_impl(context):
    try:
        # If incorrect time format,strptime will cause a ValueError and the test will fail.
        time.strptime(context.timestamp, "%d-%m-%Y_%H:%M:%S")

        assert True
    except ValueError:

        assert False


@step("the logfile name will be of type .log")
def step_impl(context):
    for file_name in os.listdir("tests/features/helpers/logs/"):
        if file_name.endswith('.log'):
            assert True
        else:
            assert False


@step("there will be an error saying that permission is denied.")
def step_impl(context):
    if "Permission denied for writing log file to specified location" in context.output:
        assert True
    else:
        assert False


@step("there will be an error saying that the directory is inaccessible.")
def step_impl(context):
    if "Unable to write to log file: Specified directory inaccessible" in context.output:
        assert True
    else:
        assert False
