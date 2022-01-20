import copy
import shutil
from pathlib import Path
from typing import Tuple

import ruamel.yaml
from dotenv import dotenv_values

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


def write_profile_platform_subset(template_path, platform):
    yaml_handler = ruamel.yaml.YAML()
    yaml_handler.indent(mapping=2, offset=2)

    new_profile_path = template_path.parent / f'{platform}_profile.yml'.lower()

    with open(template_path) as fh_r:
        yaml_dict = yaml_handler.load(fh_r)

    new_profile_dict = copy.deepcopy(yaml_dict)

    for k, v in yaml_dict['dbtvault']['outputs'].items():
        if k != platform:
            del new_profile_dict['dbtvault']['outputs'][k]

    new_profile_dict['dbtvault']['target'] = platform

    with open(new_profile_path, 'w') as fh_w:
        yaml_handler.dump(new_profile_dict, fh_w)

    return new_profile_path


def write_db_platform_subset(template_path, platform, env):
    new_db_path = template_path.parent / f'{platform}_db.env'.lower()

    config = dotenv_values(f"env/templates/db/db_{env}.tpl.env")

    env_subset = {k: v for k, v in config.items() if k in REQUIRED_ENV_VARS[platform]}

    with open(new_db_path, 'w') as fw_w:
        for k, v in env_subset.items():
            fw_w.write(f'{k.upper()}="{v}"\n')

    return new_db_path


def setup_files(env, platform) -> Tuple[Path, Path]:
    profile_template_path = Path(test.ENV_TEMPLATE_DIR / f'profile/profiles_{env}.tpl.yml').absolute()
    db_template_path = Path(test.ENV_TEMPLATE_DIR / f'db/db_{env}.tpl.env').absolute()

    new_profile_path = write_profile_platform_subset(profile_template_path, platform)
    new_db_path = write_db_platform_subset(db_template_path, platform, env)

    if env in ["internal", "pipeline"]:
        return Path(new_profile_path).absolute(), Path(new_db_path).absolute()
    else:
        profile_path = test.ENV_TEMPLATE_DIR.parent / 'profiles.yml'
        shutil.copy(new_profile_path, profile_path)

        return Path(profile_path).absolute(), ""
