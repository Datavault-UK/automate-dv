import logging
import os
from pathlib import Path

import yaml
from invoke import task

import test

logger = logging.getLogger('dbtvault')


@task()
def setup(c, target=None, user=None, project=None):
    """
    Convenience task which runs all setup tasks in the correct sequence
        :param c: invoke context
        :param target: dbt profile target (Optional if defaults already set)
        :param user: The user to fetch credentials for, assuming SecretsHub contains sub-dirs for users.
        (Optional if defaults already set)
        :param project: dbt project to run with (Optional if defaults already set)
    """

    target, user, project = params(c, target=target, project=project, user=user)

    logger.info(f'Setting defaults...')
    set_defaults(c, target, user, project)
    logger.info(f'Injecting credentials to files...')
    inject_to_file(c)
    inject_to_file(c, from_file='op/db.env', to_file='op/db_details.env')
    logger.info(f'Checking project directory...')
    check_project(c)
    logger.info(f'Installing dbtvault-dev in test project...')
    run_dbt(c, 'deps', target=target, user=user, project='test')
    logger.info(f'Setup complete!')


@task
def set_defaults(c, target=None, user=None, project='test'):
    """
    Generate an 'invoke.yml' file
        :param c: invoke context
        :param target: dbt profile target
        :param user: The user to fetch credentials for, assuming SecretsHub contains sub-dirs for users.
        :param project: dbt project to run with
    """

    dict_file = {
        'secrets_user': user, 'project': project, 'target': target}

    if target not in test.AVAILABLE_TARGETS:
        logger.error(f"Target must be set to one of: {', '.join(test.AVAILABLE_TARGETS)}")
        exit(0)

    dict_file = {k: v for k, v in dict_file.items() if v}

    with open('invoke.yml', 'w') as file:
        yaml.dump(dict_file, file)
        logger.info(f'Defaults set.')
        logger.info(f'secrets_user: {user}')
        logger.info(f'project: {project}')
        logger.info(f'target: {target}')


@task
def inject_to_file(c, from_file='profiles/profiles.tpl.yml', to_file='profiles/profiles.yml'):
    """
    Injects secrets into plain text from secrethub. BE CAREFUL! By default this is stored in
    profiles/profiles.yml, which is an ignored file in git.
        :param c: invoke context
        :param from_file: File which includes 1Password paths to extract into plain text
        :param to_file: File to store plain text in
    """

    to_file_path = Path(to_file).absolute()

    if os.path.exists(to_file_path):
        os.remove(to_file_path)

    command = f"op inject -i {from_file} -o {to_file}"

    c.run(command)


@task
def check_project(c, project='test'):
    """
    Check specified project is available.
        :param c: invoke context
        :param project: Project to check
        :return: work_dir: Working directory for the selected project
    """

    available_projects = {
        "dev": {"work_dir": str(test.PROJECT_ROOT / "dbtvault-dev")},
        "test": {"work_dir": str(test.TESTS_ROOT / "dbtvault_test")},
    }

    if not project:
        project = c.config.get('project', None)

    if project in available_projects:
        logger.info(
            f"Project '{project}' is available at: '{Path(available_projects[project]['work_dir']).absolute()}'")
        return available_projects[project]['work_dir']
    else:
        logger.error(f"Unexpected project '{project}', available projects: {', '.join(available_projects)}")
        exit(0)


@task
def change_target(c, target):
    """
    Change default target platform
        :param c: invoke context
        :param target: dbt profile target (Optional if defaults already set)
    """

    check_target(target)

    dict_file = {
        'secrets_user': c.config.get('secrets_user', None),
        'project': c.config.get('project', None),
        'target': target}

    with open('invoke.yml', 'w') as file:
        yaml.dump(dict_file, file)
        logger.info(f"Target set to '{target}'")


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

    target, user, project = params(c, target=target, user=user, project=project)

    # Select dbt profile
    if check_target(c, target):
        os.environ['TARGET'] = target

    # Set dbt profiles dir
    os.environ['DBT_PROFILES_DIR'] = str(test.PROFILE_DIR)

    command = f"op run --no-masking -- dbt {dbt_args}"

    # Run dbt in project directory
    project_dir = check_project(c, project)

    with c.cd(project_dir):

        if user:
            logger.info(f'User: {user}')

        logger.info(f'Project: {project}')
        logger.info(f'Target: {target}')
        logger.info(f"Profiles.yml: {test.PROFILE_DIR / 'profiles.yml'}")

        c.run(command)


@task
def check_target(c, target):
    """
    Check specified target is available
        :param target: Target to check
        :return: bool
    """

    available_targets = ['snowflake', 'bigquery', 'sqlserver']

    if target in available_targets:
        logger.info(f"Target '{target}' is available.")
        return True
    else:
        logger.error(f"Unexpected target: '{target}', available targets: {', '.join(available_targets)}")
        exit(0)


def params(c, target, user, project):
    """
    Validate parameters
        :param c: invoke context
        :param target: dbt profile target
        :param user: The user to fetch credentials for, assuming SecretsHub contains sub-dirs for users.
        :param project: dbt project to run with, either core (public dbtvault project)
        :return: tuple of values
    """

    # Get config
    if not target:
        target = c.config.get('target', None)

    if not user:
        user = c.config.get('secrets_user', None)

    if not project:
        project = c.config.get('project', 'test')

    # Raise error if any are null
    if all(v is None for v in [target, user, project]):
        logger.error('Expected target, user and project configurations, at least one is missing.')
        exit(0)

    return target, user, project
