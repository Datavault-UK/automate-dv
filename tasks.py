import logging
import os
from shutil import copytree, ignore_patterns, rmtree
from pathlib import PurePath, Path

import yaml
from invoke import task

from test_project.test_utils.dbt_test_utils import DBTTestUtils

PROJECT_ROOT = PurePath(__file__).parents[0]
PROFILE_DIR = Path(f"{PROJECT_ROOT}/profiles")

logger = logging.getLogger('dbt')

dbt_utils = DBTTestUtils()


@task
def check_project(c, project='public'):
    """
    Check specified project is available.
        :param c: invoke context
        :param project: Project to check
        :return: work_dir: Working directory for the selected project
    """

    available_projects = {
        'dev': {'work_dir': './'},
        'test': {'work_dir': './test_project/dbtvault_test'},
    }

    if project in available_projects:
        logger.info(
            f"Project '{project}' is available at: '{Path(available_projects[project]['work_dir']).absolute()}'")
        return available_projects[project]['work_dir']
    else:
        raise ValueError(f"Unexpected project '{project}', available projects: {', '.join(available_projects)}")


@task
def inject_to_file(c, target=None, user=None, from_file='secrethub_dev.env', to_file='pycharm.env'):
    """
    Injects secrets into plain text from secrethub. BE CAREFUL! By default this is stored in
    pycharm.env, which is an ignored file in git.
        :param c: invoke context
        :param target: dbt profile target
        :param user: Optional, the user to fetch credentials for, assuming SecretsHub contains sub-dirs for users.
        :param from_file: File which includes secrethub paths to extract into plain text
        :param to_file: File to store plain text in
    """

    if not user:
        user = c.config.get('secrets_user', None)

    if not target:
        target = c.config.get('target', None)

    command = f"secrethub inject --env-file secrethub/secrethub.env -f -v env={target} -v user={user} -i {from_file} -o {to_file}"

    c.run(command)


@task
def set_defaults(c, target=None, user=None, project=None):
    """
    Generate an 'invoke.yml' file
    :param c: invoke context
    :param target: dbt profile target
    :param user: Optional, the user to fetch credentials for, assuming SecretsHub contains sub-dirs for users.
    :param project: dbt project to run with, either core (public dbtvault project), dev (dev project) or test (test project)
    """

    dict_file = {
        'secrets_user': user, 'project': project, 'target': target}

    dict_file = {k: v for k, v in dict_file.items() if v}

    with open('./invoke.yml', 'w') as file:
        yaml.dump(dict_file, file)
        logger.info(f'Defaults set.')
        logger.info(f'secrets_users: {user}')
        logger.info(f'project: {project}')
        logger.info(f'target: {target}')


@task
def macro_tests(c, target=None, user=None, env_file='secrethub_dev.env'):
    """
    Run macro tests with secrets
        :param c: invoke context
        :param target: dbt profile target
        :param user: Optional, the user to fetch credentials for, assuming SecretsHub contains sub-dirs for users.
        :param env_file: Environment file to use for secrethub
    """

    if not user:
        user = c.config.get('secrets_user', None)

    if not target:
        target = c.config.get('target', None)

    if check_target(target):
        os.environ['TARGET'] = target

        logger.info(f"Running on '{target}' with user '{user}' and environment file '{env_file}'")

        command = f"secrethub run --no-masking --env-file={PROJECT_ROOT}/secrethub/{env_file} -v env={target} -v user={user}" \
                  f" -- pytest {'$(cat /tmp/macro-tests-to-run)' if user == 'circleci' else ''} --ignore=tests/test_utils/test_dbt_test_utils.py -n 4 -vv " \
                  f"--junitxml=test-results/macro_tests/junit.xml"

        c.run(command)


@task
def integration_tests(c, target=None, user=None, env_file='secrethub_dev.env'):
    """
    Run integration (bdd/behave) tests with secrets
        :param c: invoke context
        :param target: dbt profile target
        :param user: Optional, the user to fetch credentials for, assuming SecretsHub contains sub-dirs for users.
        :param env_file: Environment file to use for secrethub
    """

    if not user:
        user = c.config.get('secrets_user', None)

    if not target:
        target = c.config.get('target', None)

    if check_target(target):
        os.environ['TARGET'] = target

        logger.info(f"Running on '{target}' with user '{user}'")

        command = f"secrethub run --no-masking --env-file={PROJECT_ROOT}/secrethub/{env_file} -v env={target} -v user={user}" \
                  f" -- behave {'$(cat /tmp/feature-tests-to-run)' if user == 'circleci' else ''} --junit --junit-directory ../../test-results/integration_tests/"

        c.run(command)


@task
def run_dbt(c, dbt_args, target=None, user=None, project=None, env_file='secrethub_dev.env'):
    """
    Run dbt in the context of the provided project with the provided dbt args.
        :param c: invoke context
        :param dbt_args: Arguments to run db with (proceeding dbt)
        :param target: dbt profile target
        :param user: Optional, the user to fetch credentials for, assuming SecretsHub contains sub-dirs for users.
        :param project: dbt project to run with, either core (public dbtvault project),
        dev (dev project) or test (test project)
        :param env_file: Environment file to use for secrethub
    """

    # Get config
    if not target:
        target = c.config.get('target', None)

    if not user:
        user = c.config.get('secrets_user', None)

    if not project:
        project = c.config.get('project', None)

    # Raise error if any are null
    if all(v is None for v in [target, user, project]):
        raise ValueError('Expected target, user and project configurations, at least one is missing.')

    # Select dbt profile
    if check_target(target):
        os.environ['TARGET'] = target

    # Set dbt profiles dir
    os.environ['DBT_PROFILES_DIR'] = str(PROFILE_DIR)

    command = f"secrethub run --no-masking --env-file={PROJECT_ROOT}/secrethub/{env_file} -v user={user} -- dbt {dbt_args}"

    # Run dbt in project directory
    project_dir = check_project(c, project)

    with c.cd(project_dir):

        if user:
            logger.info(f'User: {user}')

        logger.info(f'Project: {project}')
        logger.info(f'Target: {target}')
        logger.info(f'Env file: {PROJECT_ROOT}/{env_file}\n')

        c.run(command)


@task
def release(c):
    """
    Bump version and merge
        :param c: invoke context
    """

    dev_folder = 'src/dbtvault-dev'
    public_folder = 'src/dbtvault'

    rmtree(public_folder)
    copytree(src=dev_folder, dst=public_folder, ignore=ignore_patterns('target', 'logs', '*.env'))


def check_target(target: str):
    """
    Check specified target is available
        :param target: Target to check
        :return: bool
    """

    available_targets = ['snowflake', 'bigquery']

    if target in available_targets:
        return True
    else:
        raise ValueError(f"Unexpected target: '{target}', available targets: {', '.join(available_targets)}")
