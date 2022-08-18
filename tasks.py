import glob
import logging
import os
from pathlib import Path

import yaml
from invoke import Collection, task

import test
from env import env_utils
from test import groups

logger = logging.getLogger('dbtvault')
logger.setLevel(logging.INFO)


@task
def init_external(c, platform=None, project=None, env='external'):
    """
    Initial setup task for external developers to generate the profile.yml
    """
    if platform:
        c.platform = platform
    if project:
        c.project = project
    if env:
        c.env = env

    profile_path, _ = env_utils.setup_files(env, platform)
    logger.info(f"profiles.yml generated at: '{str(profile_path)}'")

    platform_vars = env_utils.REQUIRED_ENV_VARS[platform]

    logger.info(f"Please set the following environment variables:\n{', '.join(platform_vars)}")


@task
def setup(c, platform=None, project=None, disable_op=False, env='internal'):
    """
    Convenience task which runs all setup tasks in the correct sequence
        :param c: invoke context
        :param platform: dbt profile platform (Optional if defaults already set)
        (Optional if defaults already set)
        :param disable_op: Disable 1Password
        :param project: dbt project to run with (Optional if defaults already set)
        :param env: Environment to run in. local or pipeline
    """

    if disable_op:
        env = 'external'

    if platform:
        c.platform = platform
    if project:
        c.project = project
    if env:
        c.env = env

    set_defaults(c, platform=c.platform, project=c.project)
    logger.info(f"Platform set to '{c.platform}'")
    logger.info(f"Project set to '{c.project}'")
    logger.info(f"Environment set to '{c.env}'")

    if disable_op:
        os.environ['DBT_PROFILES_DIR'] = str(test.PROFILE_DIR)
    else:
        logger.info(f'Injecting credentials to files...')
        inject_for_platform(c, platform, env=env)

    logger.info('Checking dbt connection... (running dbt debug)')
    run_dbt(c, 'debug', platform=platform, project='test', disable_op=disable_op)

    logger.info(f'Installing dbtvault-dev in test project...')
    run_dbt(c, 'deps', platform=platform, project='test', disable_op=disable_op)
    logger.info(f'Setup complete!')


@task
def set_defaults(c, platform='snowflake', project='test'):
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

    if platform not in env_utils.AVAILABLE_PLATFORMS:
        logger.error(f"platform must be set to one of: {', '.join(env_utils.AVAILABLE_PLATFORMS)}")
        exit(0)

    with open(test.INVOKE_YML_FILE, 'w+') as file:
        yaml.dump(dict_file, file)
        logger.info(f'Defaults set.')
        logger.info(f'Project: {c.project}')


@task
def inject_to_file(c, from_file, to_file):
    """
    Injects secrets into plain text from secrethub. BE CAREFUL!
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
def inject_for_platform(c, platform, env='internal'):
    available_envs = ["pipeline", "internal", "external"]

    if platform not in env_utils.AVAILABLE_PLATFORMS:
        raise ValueError(f"Platform must be one of: {', '.join(env_utils.AVAILABLE_PLATFORMS)}")
    else:
        if env in available_envs:

            new_profile_path, db_template_path = env_utils.setup_files(env, platform)

            inject_to_file(c, from_file=new_profile_path, to_file='env/profiles.yml')
            inject_to_file(c, from_file=db_template_path, to_file='env/db.env')

            os.remove(new_profile_path)
            os.remove(db_template_path)

        else:
            raise ValueError(f"Environment '{env}' not available.")


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
def change_platform(c, platform, disable_op=False, env='internal'):
    """
    Change default platform
        :param c: invoke context
        :param platform: dbt profile platform (Optional if defaults already set)
        :param disable_op: Disable 1Password
        :param env: Environment to run in. local or pipeline
    """

    check_platform(c, platform)

    c.platform = platform

    if disable_op:
        pass
    else:
        inject_for_platform(c, platform=platform, env=env)

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
        :param platform: dbt profile platform/target
    """

    if platform in env_utils.AVAILABLE_PLATFORMS:
        logger.debug(f"Platform '{platform}' is available.")
        return True
    else:
        logger.error(
            f"Unexpected platform: '{platform}', available platforms: {', '.join(env_utils.AVAILABLE_PLATFORMS)}")
        exit(0)


@task
def run_dbt(c, dbt_args, platform=None, project=None, disable_op=False):
    """
    Run dbt in the context of the provided project with the provided dbt args.
        :param c: invoke context
        :param dbt_args: Arguments to run db with (proceeding dbt)
        :param platform: dbt profile platform/target
        :param project: dbt project to run with, either core (public dbtvault project),
        dev (dev project) or test (test project)
        :param disable_op: Disable 1Password
    """

    platform = c.platform if not platform else platform

    # Select dbt profile
    if check_platform(c, platform):
        os.environ['PLATFORM'] = platform

    if disable_op:
        env_utils.setup_db_creds(platform)
        command = f"dbt {dbt_args}"
        logger.info(f"Running dbt with command: '{command}'")
    else:
        # Set dbt profiles dir
        dbt_command = f"dbt {dbt_args}"
        os.environ['DBT_PROFILES_DIR'] = str(test.PROFILE_DIR)
        command = f"op run -- {dbt_command}"
        logger.info(f"Running dbt with command: '{dbt_command}'")

    # Run dbt in project directory
    project_dir = check_project(c, project)

    with c.cd(project_dir):
        c.run(command)


@task
def run_macro_tests(c, platform=None, disable_op=False):
    """
    Run macro tests with secrets
        :param c: invoke context
        :param platform: dbt profile platform/target
        :param disable_op: Disable 1Password
    """

    platform = c.platform if not platform else platform

    # Select dbt profile
    if check_platform(c, platform):
        os.environ['PLATFORM'] = platform
        logger.info(f"Running macro tests for '{platform}'.")

    pytest_command = f"pytest {str(test.TEST_MACRO_ROOT.absolute())} -n 4 -vv"

    if disable_op:
        env_utils.setup_db_creds(platform)
        command = pytest_command
    else:
        command = f"op run -- {pytest_command}"

    c.run(command)


@task
def run_harness_tests(c, platform=None, disable_op=False):
    """
    Run harness tests with secrets
        :param c: invoke context
        :param platform: dbt profile platform/target
        :param disable_op: Disable 1Password
    """

    platform = c.platform if not platform else platform

    # Select dbt profile
    if check_platform(c, platform):
        os.environ['PLATFORM'] = platform
        logger.info(f"Running harness tests for '{platform}'.")

    pytest_command = f"pytest {str(test.TEST_HARNESS_TESTS_ROOT.absolute())} -n 4 -vv"

    if disable_op:
        env_utils.setup_db_creds(platform)
        command = pytest_command
    else:
        command = f"op run -- {pytest_command}"

    c.run(command)


@task
def run_integration_tests(c, structures=None, subtype=None, platform=None, disable_op=False):
    feature_directories = {'staging', 'hubs', 'links', 't_links', 'sats', 'sats_with_oos', 'eff_sats',
                           'ma_sats', 'xts', 'bridge', 'pit', 'cycle'}

    sub_types = groups.feature_sub_types()

    structures = set(str(structures).split(","))

    platform = c.platform if not platform else platform

    # Select dbt profile
    if check_platform(c, platform):
        os.environ['PLATFORM'] = platform
        logger.info(f"Running integration tests for '{platform}'.")

    feature_directories.intersection_update(structures)

    collected_files = dict.fromkeys(feature_directories)

    logger.info(f"Running specific integration tests: {', '.join(feature_directories)}")

    for feat_dir in feature_directories:
        feat_files = glob.glob(f'**/{feat_dir}/*.feature', recursive=True)
        collected_files[feat_dir] = feat_files

        files = []

        if subtype:
            logger.info(f"Running subset of feature files: {feat_dir}/{subtype}")
            if feat_dir in sub_types:
                if subtype in sub_types[feat_dir]:

                    for file_substring in sub_types[feat_dir][subtype]:
                        for file_str in collected_files[feat_dir]:
                            if f'{file_substring}.feature' == Path(file_str).name:
                                files.append(file_str)

                collected_files[feat_dir] = files

        for struct, file_list in collected_files.items():

            if collected_files[struct]:
                logger.info(
                    f"Using the following feature files from {struct} directory: {', '.join(collected_files[struct])}")
            else:
                raise SystemExit(f"No feature files found for for {struct}. This is most likely unintended, "
                                 f"please check available feature directories and sub-types.")

        for file in collected_files[feat_dir]:
            pytest_command = f"behave '{file}'"

            if disable_op:
                env_utils.setup_db_creds(platform)
                command = pytest_command
            else:
                command = f"op run -- {pytest_command}"

            c.run(command)


ns = Collection(setup, init_external, set_defaults, inject_to_file, inject_for_platform, check_project, change_platform,
                check_platform, run_dbt, run_macro_tests, run_harness_tests, run_integration_tests)

ns.configure({'project': 'test', 'platform': 'snowflake', 'env': 'local'})
