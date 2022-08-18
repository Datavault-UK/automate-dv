import json
import logging
import sys

import pexpect

import test
from env import env_utils


def run_dbt_command(command) -> str:
    """
    Run a command in dbt and capture dbt logs.
        :param command: Command to run.
        :return: dbt logs
    """

    if 'dbt' not in command and isinstance(command, list):
        command = ['dbt'] + command
    elif 'dbt' not in command and isinstance(command, str):
        command = ['dbt', command]

    joined_command = " ".join(command)

    test.logger.log(msg=f"Running on platform {str(env_utils.platform()).upper()}", level=logging.INFO)

    test.logger.log(msg=f"Running with dbt command: {joined_command}", level=logging.INFO)

    child = pexpect.spawn(command=joined_command, cwd=test.TEST_PROJECT_ROOT, encoding="utf-8", timeout=1000)
    child.logfile_read = sys.stdout
    logs = child.read()
    child.close()

    return logs


def run_dbt_seeds(seed_file_names=None, full_refresh=False) -> str:
    """
    Run seed files in dbt
        :return: dbt logs
    """

    if isinstance(seed_file_names, str):
        seed_file_names = [seed_file_names]

    command = ['dbt', 'seed']

    if seed_file_names:
        command.extend(['--select', " ".join(seed_file_names), '--full-refresh'])

    if "full-refresh" not in command and full_refresh:
        command.append('--full-refresh')

    return run_dbt_command(command)


def run_dbt_seed_model(seed_model_name=None) -> str:
    """
    Run seed model files in dbt
        :return: dbt logs
    """

    command = ['dbt', 'run']

    if seed_model_name:
        command.extend(['-m', seed_model_name, '--full-refresh'])

    return run_dbt_command(command)


def run_dbt_models(*, mode='compile', model_names: list, args=None, full_refresh=False) -> str:
    """
    Run or Compile a specific dbt model, with optionally provided variables.
        :param mode: dbt command to run, 'run' or 'compile'. Defaults to compile
        :param model_names: List of model names to run
        :param args: variable dictionary to provide to dbt
        :param full_refresh: Run a full refresh
        :return Log output of dbt run operation
    """

    model_name_string = " ".join(model_names)

    command = ['dbt', mode, '-m', model_name_string]

    if full_refresh:
        command.append('--full-refresh')

    if args:
        args = json.dumps(args)
        command.extend([f"--vars '{args}'"])

    return run_dbt_command(command)


def run_dbt_operation(macro_name: str, args=None) -> str:
    """
    Run a specified macro in dbt, with the given arguments.
        :param macro_name: Name of macro/operation
        :param args: Arguments to provide
        :return: dbt logs
    """
    command = ['run-operation', f'{macro_name}']

    if args:
        args = str(args).replace('\'', '')
        command.extend([f"--args '{args}'"])

    return run_dbt_command(command)
