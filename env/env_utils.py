import copy
import os
import shutil
import sys
from pathlib import Path
from typing import Tuple

import ruamel.yaml
import yaml
from dotenv import dotenv_values
from environs import Env

import test

REQUIRED_ENV_VARS = {
    "snowflake": [
        "SNOWFLAKE_DB_ACCOUNT", "SNOWFLAKE_DB_USER",
        "SNOWFLAKE_DB_PW", "SNOWFLAKE_DB_ROLE",
        "SNOWFLAKE_DB_DATABASE", "SNOWFLAKE_DB_WH",
        "SNOWFLAKE_DB_SCHEMA"],
    "bigquery": [
        "GCP_PROJECT_ID", "GCP_DATASET"],
    "sqlserver": [
        "SQLSERVER_DB_SERVER", "SQLSERVER_DB_PORT",
        "SQLSERVER_DB_DATABASE", "SQLSERVER_DB_SCHEMA",
        "SQLSERVER_DB_USER", "SQLSERVER_DB_PW"
    ],
    "databricks": [
        "DATABRICKS_SCHEMA", "DATABRICKS_HOST",
        "DATABRICKS_PORT", "DATABRICKS_TOKEN",
        "DATABRICKS_ENDPOINT"
    ]
}

AVAILABLE_PLATFORMS = [p.lower() for p in list(REQUIRED_ENV_VARS)]


def platform():
    """Gets the target platform as set by the user via the invoke CLI, stored in invoke.yml"""

    if os.path.isfile(test.INVOKE_YML_FILE):

        with open(test.INVOKE_YML_FILE) as config:
            config_dict = yaml.safe_load(config)
            plt = config_dict.get('platform').lower()

            if plt not in AVAILABLE_PLATFORMS:
                test.logger.error(f"Platform must be set to one of: {', '.join(AVAILABLE_PLATFORMS)} "
                                  f"in '{test.INVOKE_YML_FILE}'")
                sys.exit(0)
            else:
                return plt
    else:
        test.logger.error(f"'{test.INVOKE_YML_FILE}' not found. Please run 'inv setup'")
        sys.exit(0)


def is_pipeline():
    return os.getenv('PIPELINE_JOB') and os.getenv('PIPELINE_BRANCH')


def set_qualified_names_for_macro_tests():
    """
    Database and schema names for generated SQL during macro tests changes based on user.
    This function generates those names.
    """

    def sanitise_strings(unsanitised_str):
        return unsanitised_str.replace("-", "_").replace(".", "_").replace("/", "_").replace(' ', '_')

    pipeline_metadata = {
        "snowflake": {
            "SCHEMA_NAME": f"{os.getenv('SNOWFLAKE_DB_SCHEMA')}_{os.getenv('SNOWFLAKE_DB_USER')}"
                           f"_{os.getenv('PIPELINE_BRANCH')}_{os.getenv('PIPELINE_JOB')}".upper(),
            "DATABASE_NAME": os.getenv('SNOWFLAKE_DB_DATABASE')
        },
        "bigquery": {
            "DATASET_NAME": f"{os.getenv('GCP_DATASET')}_{os.getenv('GCP_USER')}"
                            f"_{os.getenv('PIPELINE_BRANCH')}_{os.getenv('PIPELINE_JOB')}".upper()
        }
    }

    local_metadata = {
        "snowflake": {
            "SCHEMA_NAME": f"{os.getenv('SNOWFLAKE_DB_SCHEMA')}_{os.getenv('SNOWFLAKE_DB_USER')}".upper(),
            "DATABASE_NAME": os.getenv('SNOWFLAKE_DB_DATABASE')
        },
        "bigquery": {
            "DATASET_NAME": f"{os.getenv('GCP_DATASET')}_{os.getenv('GCP_USER')}".upper()
        },
        # "databricks": f"{os.getenv('DATABRICKS_SCHEMA')}".upper()
    }

    if is_pipeline():
        return {k: sanitise_strings(v) for k, v in pipeline_metadata[platform()].items()}
    else:
        return {k: sanitise_strings(v) for k, v in local_metadata[platform()].items()}


def setup_db_creds(plt):
    env = Env()

    if os.path.isfile(test.OP_DB_FILE):
        env.read_env(test.OP_DB_FILE)

    details = {key: env(key) for key in REQUIRED_ENV_VARS[plt]}

    if not all([v for v in details.values()]):
        test.logger.error(f"{str(plt).title()} environment details incomplete or not found. "
                          f"Please check your 'env/db.env' file "
                          f"or ensure the required variables are added to your environment: "
                          f"{', '.join(REQUIRED_ENV_VARS[plt])}")
        sys.exit(0)
    else:
        return details


def setup_environment():
    p = platform()
    setup_db_creds(plt=p)

    if not os.getenv('DBT_PROFILES_DIR') and os.path.isfile(test.PROFILE_DIR / 'profiles.yml'):
        os.environ['DBT_PROFILES_DIR'] = str(test.PROFILE_DIR)

    os.environ['PLATFORM'] = p


def write_profile_platform_subset(template_path, platform_name):
    yaml_handler = ruamel.yaml.YAML()
    yaml_handler.indent(mapping=2, offset=2)
    yaml_handler.preserve_quotes = True

    new_profile_path = template_path.parent.parent.parent / f'composed/{platform_name}_profile.yml'.lower()

    with open(template_path) as fh_r:
        yaml_dict = yaml_handler.load(fh_r)

    new_profile_dict = copy.deepcopy(yaml_dict)

    for k, v in yaml_dict['dbtvault']['outputs'].items():
        if k != platform_name:
            del new_profile_dict['dbtvault']['outputs'][k]

    new_profile_dict['dbtvault']['target'] = platform_name

    with open(new_profile_path, 'w') as fh_w:
        yaml_handler.dump(new_profile_dict, fh_w)

    return new_profile_path


def write_db_platform_subset(template_path, platform_name, env):
    new_db_path = template_path.parent.parent.parent / f'composed/{platform_name}_db.env'.lower()

    config = dotenv_values(f"env/templates/db/db_{env}.tpl.env")

    env_subset = {k: v for k, v in config.items() if k in REQUIRED_ENV_VARS[platform_name]}

    with open(new_db_path, 'w') as fw_w:
        for k, v in env_subset.items():
            fw_w.write(f'{k.upper()}="{v}"\n')

    return new_db_path


def setup_files(env, platform_name) -> Tuple[Path, Path]:
    profile_template_path = Path(test.ENV_TEMPLATE_DIR / f'profile/profiles_{env}.tpl.yml').absolute()
    db_template_path = Path(test.ENV_TEMPLATE_DIR / f'db/db_{env}.tpl.env').absolute()

    if env in ["internal", "pipeline"]:
        new_profile_path = write_profile_platform_subset(profile_template_path, platform_name)
        new_db_path = write_db_platform_subset(db_template_path, platform_name, env)
        return Path(new_profile_path).absolute(), Path(new_db_path).absolute()
    else:
        new_profile_path = write_profile_platform_subset(profile_template_path, platform_name)
        profile_path = test.ENV_TEMPLATE_DIR.parent / 'profiles.yml'
        shutil.copy(new_profile_path, profile_path)

        os.remove(new_profile_path)
        return Path(profile_path).absolute(), ""
