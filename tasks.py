from invoke import task
from pathlib import PurePath, Path
import os
import yaml

PROJECT_ROOT = PurePath(__file__).parents[0]
PROFILE_DIR = Path(f"{PROJECT_ROOT}/profiles")
SECRETHUB_FILE = Path(f"{PROJECT_ROOT}/secrethub.env")


@task
def run_tests(c, target, user=None):
    """
    Run macro tests with secrets
        :param c: invoke context
        :param target: dbt profile target
        :param user: Optional, the user to fetch credentials for, assuming SecretsHub contains sub-dirs for users.
    """

    if not user:
        target = c.config.get('secrets_user', None)

    available_targets = ['snowflake']

    if target in available_targets:

        print(f"Running on '{target}' with user '{user}'")

        command = f"secrethub run -v env={target} -v user={user} -- pytest -n 4 -vv"

        c.run(command)
    else:
        raise ValueError(f"Unexpected target, available targets: {', '.join(available_targets)}")


@task
def run_dbt(c, dbt_args, target=None, user=None, project=None):
    """
    Run dbt in the context of the provided project with the provided dbt args.
        :param c: invoke context
        :param dbt_args: Arguments to run db with (proceeding dbt)
        :param target: dbt profile target
        :param user: Optional, the user to fetch credentials for, assuming SecretsHub contains sub-dirs for users.
        :param project: dbt project to run with, either core (public dbtvault project), dev (dev project) or test (test project)
    """
    available_projects = {
        'core': {'work_dir': './src/dbtvault'},
        'dev': {'work_dir': './src/dbtvault-dev'},
        'test': {'work_dir': './tests/dbtvault_test'}}

    if not target:
        target = c.config.get('target', None)

    if not user:
        user = c.config.get('secrets_user', None)

    if not project:
        project = c.config.get('project', None)

    if all(v is None for v in [target, user, project]):
        raise ValueError('Expected target, user and project configurations, at least one is missing.')

    os.environ['DBT_PROFILES_DIR'] = str(PROFILE_DIR)

    command = f"secrethub run --env-file={SECRETHUB_FILE} -v env={target} -v user={user} -- dbt {dbt_args}"

    if project in set(available_projects):

        with c.cd(available_projects[project]['work_dir']):

            print(f'Running dbt with command: dbt {dbt_args}')

            if user:
                print(f'User: {user}')
            print(f'Project: {project}\n')

            c.run(command)


@task
def set_defaults(c, user=None, project=None, target=None):

    dict_file = {'secrets_user': user,
                 'project': project,
                 'target': target}

    dict_file = {k: v for k, v in dict_file.items() if v}

    with open('./invoke.yml', 'w') as file:
        yaml.dump(dict_file, file)


