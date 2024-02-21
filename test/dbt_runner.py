import json
from pathlib import Path

from dbt.cli.main import dbtRunnerResult


def run_dbt_command(dbt_class, command, logs_required=False, use_colours=False) -> (bool, str):
    """
    Run a command in dbt and capture dbt logs.
        :param dbt_class: dbt Runner object
        :param command: Command to run.
        :param logs_required: True if error message in the logs needs to be read
        :param use_colours: If false, remove ASCII escape codes for colours from log output, so it's easier to read.
        :return: dbt logs
    """
    if 'dbt' in command and isinstance(command, list):
        command.remove('dbt')

    if not logs_required:

        res: dbtRunnerResult = dbt_class.invoke(command)

        return res.success, ''

    else:
        if not use_colours:
            command = [*['--no-use-colors-file'], *command]

        res: dbtRunnerResult = dbt_class.invoke(command)

        if res.exception:
            return res.success, str(res.exception)
        else:
            log_file_path = Path(f"{res.result.args['log_path']}/dbt.log")
            if log_file_path.exists():
                return res.success, log_file_path.read_text()
            else:
                return res.success, ""


def run_dbt_seeds(dbt_class, seed_file_names=None, full_refresh=False, logs_required=False) -> bool | str:
    """
    Run seed files in dbt
        :return: dbt logs
    """

    if isinstance(seed_file_names, str):
        seed_file_names = [seed_file_names]

    command = ['seed']

    if seed_file_names:
        command.extend(['--select', " ".join(seed_file_names), '--full-refresh'])

    if "full-refresh" not in command and full_refresh:
        command.append('--full-refresh')

    return run_dbt_command(dbt_class, command, logs_required=logs_required)


def run_dbt_seed_model(dbt_class, seed_model_name=None, logs_required=False) -> bool | str:
    """
    Run seed model files in dbt
        :return: dbt logs
    """

    command = ['dbt', 'run']

    if seed_model_name:
        command.extend(['-m', seed_model_name, '--full-refresh'])

    return run_dbt_command(dbt_class, command, logs_required=logs_required)


def run_dbt_models(dbt_class, *, mode='compile', model_names: list, args=None, full_refresh=False,
                   return_logs=False) -> bool | str:
    """
    Run or Compile a specific dbt model, with optionally provided variables.
        :param dbt_class: dbt Runner object
        :param mode: dbt command to run, 'run' or 'compile'. Defaults to compile
        :param model_names: List of model names to run
        :param args: variable dictionary to provide to dbt
        :param full_refresh: Run a full refresh
        :param return_logs: If true, return logs from dbt
        :return Log output of dbt run operation
    """

    model_name_string = " ".join(model_names)

    command = [mode, '-m', model_name_string]

    if full_refresh:
        command.append('--full-refresh')

    if args:
        args = json.dumps(args)
        command.extend(['--vars', str(args)])

    return run_dbt_command(dbt_class, command, logs_required=return_logs)


def run_dbt_operation(dbt_class, macro_name: str, args=None, dbt_vars=None, logs_required=False) -> bool | str:
    """
    Run a specified macro in dbt, with the given arguments.
        :param dbt_class: dbt Runner object
        :param macro_name: Name of macro/operation
        :param args: Arguments to provide
        :param dbt_vars: context variable for any additional configuration
        :param logs_required: If true, return logs from dbt
        :return: dbt logs
    """
    command = ['run-operation', f'{macro_name}']

    if args:
        args = str(args).replace('\'', '')
        command.extend(['--args', f"{args}"])

    if dbt_vars:
        vargs = json.dumps(dbt_vars)
        command.extend(['--vars', f"{vargs}"])

    return run_dbt_command(dbt_class, command, logs_required)
