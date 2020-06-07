from invoke import task
from pathlib import PurePath, Path
import os
import yaml
import logging
from tests.dbt_test_utils import DBTTestUtils

PROJECT_ROOT = PurePath(__file__).parents[0]
PROFILE_DIR = Path(f"{PROJECT_ROOT}/profiles")
SECRETHUB_FILE = Path(f"{PROJECT_ROOT}/secrethub.env")

logger = logging.getLogger('dbt')

dbt_utils = DBTTestUtils()


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


@task
def check_project(c, project='core'):
    """
    Check specified project is available.
        :param c: invoke context
        :param project: Project to check
        :return: work_dir: Working directory for the selected project
    """

    available_projects = {
        'core': {'work_dir': './src/dbtvault'},
        'dev': {'work_dir': './src/dbtvault-dev'},
        'test': {'work_dir': './tests/dbtvault_test'}}

    if project in available_projects:
        logger.info(f"Project '{project}' is available at: '{Path(available_projects[project]['work_dir']).absolute()}'")
        return available_projects[project]['work_dir']
    else:
        raise ValueError(f"Unexpected project '{project}', available projects: {', '.join(available_projects)}")


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
def run_tests(c, target, user=None):
    """
    Run macro tests with secrets
        :param c: invoke context
        :param target: dbt profile target
        :param user: Optional, the user to fetch credentials for, assuming SecretsHub contains sub-dirs for users.
    """

    if not user:
        user = c.config.get('secrets_user', None)

    if not target:
        user = c.config.get('target', None)

    if check_target(target):

        os.environ['TARGET'] = target

        logger.info(f"Running on '{target}' with user '{user}'")

        command = f"secrethub run -v env={target} -v user={user} -- pytest -n 4 -vv"

        c.run(command)


@task
def run_dbt(c, dbt_args, target=None, user=None, project=None):
    """
    Run dbt in the context of the provided project with the provided dbt args.
        :param c: invoke context
        :param dbt_args: Arguments to run db with (proceeding dbt)
        :param target: dbt profile target
        :param user: Optional, the user to fetch credentials for, assuming SecretsHub contains sub-dirs for users.
        :param project: dbt project to run with, either core (public dbtvault project),
        dev (dev project) or test (test project)
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

    command = f"secrethub run --env-file={SECRETHUB_FILE} -v user={user} -- dbt {dbt_args}"

    # Run dbt in project directory
    project_dir = check_project(c, project)

    with c.cd(project_dir):

        if user:
            logger.info(f'User: {user}')

        logger.info(f'Project: {project}')
        logger.info(f'Target: {target}\n')

        dbt_utils.run_command(command)
