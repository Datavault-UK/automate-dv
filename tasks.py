import logging
import os
from pathlib import Path

import yaml
from invoke import Collection, task

import test
from test import dbtvault_harness_utils

logger = logging.getLogger('dbtvault')
logger.setLevel(logging.INFO)


@task()
def setup(c, platform=None, project=None, disable_op=False):
    """
    Convenience task which runs all setup tasks in the correct sequence
        :param c: invoke context
        :param platform: dbt profile platform (Optional if defaults already set)
        (Optional if defaults already set)
        :param disable_op: Disable 1Password
        :param project: dbt project to run with (Optional if defaults already set)
    """
    if platform:
        c.platform = platform
    if project:
        c.project = project

    set_defaults(c, platform=c.platform, project=c.project)
    logger.info(f"Platform set to '{c.platform}'")
    logger.info(f"Project set to '{c.project}'")

    if disable_op:
        logger.info('Checking dbt connection... (running dbt debug)')
        run_dbt(c, 'debug', platform=platform, project='test', disable_op=disable_op)
    else:
        logger.info(f'Injecting credentials to files...')
        inject_for_platform(c, platform)

    logger.info(f'Installing dbtvault-dev in test project...')
    run_dbt(c, 'deps', platform=platform, project='test', disable_op=disable_op)
    logger.info(f'Setup complete!')


@task
def set_defaults(c, platform=None, project='test'):
    """
    Update the invoke namespace with new values
        :param c: invoke context
        :param platform: dbt profile platform
        :param project: dbt project to run with
    """

    dict_file = {'project': project,
                 'platform': platform}

    c.project = dict_file['project']
    c.platform = dict_file['platform']

    if platform not in test.AVAILABLE_PLATFORMS:
        logger.error(f"platform must be set to one of: {', '.join(test.AVAILABLE_PLATFORMS)}")
        exit(0)

    with open(test.INVOKE_YML_FILE, 'w+') as file:
        yaml.dump(dict_file, file)
        logger.info(f'Defaults set.')
        logger.info(f'Project: {c.project}')
        logger.info(f'Platform: {c.platform}')


@task
def inject_to_file(c, from_file, to_file):
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
def inject_for_platform(c, platform):
    if platform == 'snowflake':
        profiles_from_file = 'env/snowflake/profiles_snowflake.tpl.yml'
        db_from_file = 'env/snowflake/db_snowflake.tpl.env'

    elif platform == 'bigquery':
        profiles_from_file = 'env/bigquery/profiles_bigquery.tpl.yml'
        db_from_file = 'env/bigquery/db_bigquery.tpl.env'

    elif platform == 'sqlserver':
        profiles_from_file = 'env/sqlserver/profiles_sqlserver.tpl.yml'
        db_from_file = 'env/sqlserver/db_sqlserver.tpl.env'

    else:
        raise ValueError(f"Platform must be one of: {', '.join(test.AVAILABLE_PLATFORMS)}")

    inject_to_file(c, from_file=profiles_from_file, to_file='env/profiles.yml')
    inject_to_file(c, from_file=db_from_file, to_file='env/db.env')


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
def change_platform(c, platform, disable_op=False):
    """
    Change default platform platform
        :param c: invoke context
        :param platform: dbt profile platform (Optional if defaults already set)
        :param disable_op: Disable 1Password
    """

    check_platform(c, platform)

    c.platform = platform

    if disable_op:
        pass
    else:
        inject_for_platform(c, platform=platform)

    dict_file = {
        'project': c.project,
        'platform': c.platform}

    with open(test.INVOKE_YML_FILE, 'w') as file:
        yaml.dump(dict_file, file)
        logger.info(f"Platform set to '{c.platform}'")


@task
def check_platform(c, platform):
    """
    Check specified platform is available
        :param platform: platform to check
    """

    if platform in test.AVAILABLE_PLATFORMS:
        logger.debug(f"Platform '{platform}' is available.")
        return True
    else:
        logger.error(f"Unexpected platform: '{platform}', available platforms: {', '.join(test.AVAILABLE_PLATFORMS)}")
        exit(0)


@task
def run_dbt(c, dbt_args, platform=None, project=None, disable_op=False):
    """
    Run dbt in the context of the provided project with the provided dbt args.
        :param c: invoke context
        :param dbt_args: Arguments to run db with (proceeding dbt)
        :param platform: dbt profile platform
        :param project: dbt project to run with, either core (public dbtvault project),
        dev (dev project) or test (test project)
        :param disable_op: Disable 1Password
    """

    # Select dbt profile
    if check_platform(c, platform):
        os.environ['PLATFORM'] = platform

    if disable_op:
        dbtvault_harness_utils.setup_db_creds(platform)
        command = f"dbt {dbt_args}"
    else:
        # Set dbt profiles dir
        os.environ['DBT_PROFILES_DIR'] = str(test.PROFILE_DIR)
        command = f"op run --no-masking -- dbt {dbt_args}"

    # Run dbt in project directory
    project_dir = check_project(c, project)

    with c.cd(project_dir):
        c.run(command)


ns = Collection(setup, set_defaults, inject_to_file, inject_for_platform, check_project, change_platform,
                check_platform, run_dbt)
ns.configure({'project': 'test', 'platform': 'snowflake'})
