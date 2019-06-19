import os
from pathlib import PurePath

from behave import *

import bindings

use_step_matcher("parse")


@when("I run the vaultLoader without command line arguments")
def step_impl(context):
    bindings.run()

    for file_name in os.listdir("tests/features/helpers/logs"):

        context.timestamp = PurePath(file_name).stem.replace("vaultLoader-", "")

    try:
        context.timestamp
    except AttributeError:
        assert False


@when("I run the vaultLoader with an invalid file path via the command line.")
def step_impl(context):
    context.configpath = "./config/invalid"
    context.output = bindings.run(context.configpath)


@when("I run the vaultLoader without a local config file or command line argument.")
def step_impl(context):
    """
    This test specifies a config name parameter anyway because by default the program will
    look in the local directory for config.ini, which does exist, because of other tests, and
    we don't want it to, so we force a different file name so that it will not find it.
    """
    context.configpath = "./config_bad"
    context.output = bindings.run(context.configpath)


@step("the logfile will contain 'Config file loaded successfully'.")
def step_impl(context):
    result = bindings.checking_log_file_contents(
        os.path.join("tests/features/helpers/logs/", "vaultLoader-{}.log".format(context.timestamp)), "Config file",
        "loaded successfully")

    assert result


@step("the logfile will contain version information")
def step_impl(context):
    result = bindings.checking_log_file_contents(
        os.path.join("tests/features/helpers/logs/", "vaultLoader-{}.log".format(context.timestamp)), "Version:", "Date:", "Status:")

    assert result


@then("there will be a log message with a config load error.")
def step_impl(context):
    if "Problems loading config file" in context.output:
        assert True
    else:
        assert False

    if context.configpath in context.output:
        assert True
    else:
        assert False

    if "Config file not found" in context.output:
        assert True
    else:
        assert False
