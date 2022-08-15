from behave.fixture import use_fixture_by_tag

from env import env_utils
from test import dbtvault_generator, behave_helpers
from test.features import behave_fixtures
from test.features.bridge import fixtures_bridge
from test.features.cycle import fixtures_cycle
from test.features.eff_sats import fixtures_eff_sat
from test.features.hubs import fixtures_hub
from test.features.links import fixtures_link
from test.features.ma_sats import fixtures_ma_sat
from test.features.pit import fixtures_pit
from test.features.sats import fixtures_sat
from test.features.staging import fixtures_staging
from test.features.t_links import fixtures_t_link
from test.features.xts import fixtures_xts

fixture_registry_utils = {
    "fixture.enable_sha": behave_fixtures.enable_sha,
    "fixture.enable_auto_end_date": behave_fixtures.enable_auto_end_date,
    "fixture.enable_full_refresh": behave_fixtures.enable_full_refresh,
    "fixture.disable_union": behave_fixtures.disable_union,
    "fixture.disable_payload": behave_fixtures.disable_payload
}

fixtures_registry = {
    "fixture.staging":
        {"snowflake": fixtures_staging.staging_snowflake,
         "bigquery": fixtures_staging.staging_bigquery,
         "sqlserver": fixtures_staging.staging_sqlserver,
         "databricks": ''},

    "fixture.staging_escaped":
        {"snowflake": fixtures_staging.staging_escaped_snowflake,
         "bigquery": fixtures_staging.staging_escaped_bigquery,
         "sqlserver": fixtures_staging.staging_escaped_sqlserver,
         "databricks": ''},

    "fixture.staging_null_columns":
        {"snowflake": fixtures_staging.staging_null_columns_snowflake,
         "bigquery": fixtures_staging.staging_null_columns_bigquery,
         "sqlserver": fixtures_staging.staging_null_columns_sqlserver,
         "databricks": ''},

    "fixture.single_source_hub":
        {"snowflake": fixtures_hub.single_source_hub_snowflake,
         "bigquery": fixtures_hub.single_source_hub_bigquery,
         "sqlserver": fixtures_hub.single_source_hub_sqlserver,
         "databricks": fixtures_hub.single_source_hub_databricks},

    "fixture.single_source_comp_pk_hub":
        {"snowflake": fixtures_hub.single_source_comp_pk_hub_snowflake,
         "bigquery": fixtures_hub.single_source_comp_pk_hub_bigquery,
         "sqlserver": fixtures_hub.single_source_comp_pk_hub_sqlserver,
         "databricks": ''},

    "fixture.single_source_comp_pk_nk_hub":
        {"snowflake": fixtures_hub.single_source_comp_pk_nk_hub_snowflake,
         "bigquery": fixtures_hub.single_source_comp_pk_nk_hub_bigquery,
         "sqlserver": fixtures_hub.single_source_comp_pk_nk_hub_sqlserver,
         "databricks": ''},

    "fixture.multi_source_hub":
        {"snowflake": fixtures_hub.multi_source_hub_snowflake,
         "bigquery": fixtures_hub.multi_source_hub_bigquery,
         "sqlserver": fixtures_hub.multi_source_hub_sqlserver,
         "databricks": fixtures_hub.multi_source_hub_databricks},

    "fixture.multi_source_comp_pk_hub":
        {"snowflake": fixtures_hub.multi_source_comp_pk_hub_snowflake,
         "bigquery": fixtures_hub.multi_source_comp_pk_hub_bigquery,
         "sqlserver": fixtures_hub.multi_source_comp_pk_hub_sqlserver,
         "databricks": ''},

    "fixture.single_source_link":
        {"snowflake": fixtures_link.single_source_link_snowflake,
         "bigquery": fixtures_link.single_source_link_bigquery,
         "sqlserver": fixtures_link.single_source_link_sqlserver,
         "databricks": fixtures_link.single_source_link_databricks},

    "fixture.single_source_comp_pk_link":
        {"snowflake": fixtures_link.single_source_comp_pk_link_snowflake,
         "bigquery": fixtures_link.single_source_comp_pk_link_bigquery,
         "sqlserver": fixtures_link.single_source_comp_pk_link_sqlserver,
         "databricks": ''},

    "fixture.multi_source_link":
        {"snowflake": fixtures_link.multi_source_link_snowflake,
         "bigquery": fixtures_link.multi_source_link_bigquery,
         "sqlserver": fixtures_link.multi_source_link_sqlserver,
         "databricks": ''},

    "fixture.t_link":
        {"snowflake": fixtures_t_link.t_link_snowflake,
         "bigquery": fixtures_t_link.t_link_bigquery,
         "sqlserver": fixtures_t_link.t_link_sqlserver,
         "databricks": ''},

    "fixture.t_link_comp_pk":
        {"snowflake": fixtures_t_link.t_link_comp_pk,
         "bigquery": fixtures_t_link.t_link_comp_pk_bigquery,
         "sqlserver": fixtures_t_link.t_link_comp_pk_sqlserver,
         "databricks": ''},

    "fixture.satellite":
        {"snowflake": fixtures_sat.satellite_snowflake,
         "bigquery": fixtures_sat.satellite_bigquery,
         "sqlserver": fixtures_sat.satellite_sqlserver,
         "databricks": ''},

    "fixture.satellite_cycle":
        {"snowflake": fixtures_sat.satellite_cycle_snowflake,
         "bigquery": fixtures_sat.satellite_cycle_bigquery,
         "sqlserver": fixtures_sat.satellite_cycle_sqlserver,
         "databricks": ''},

    "fixture.eff_satellite":
        {"snowflake": fixtures_eff_sat.eff_satellite_snowflake,
         "bigquery": fixtures_eff_sat.eff_satellite_bigquery,
         "sqlserver": fixtures_eff_sat.eff_satellite_sqlserver,
         "databricks": ''},

    "fixture.eff_satellite_datetime":
        {"snowflake": fixtures_eff_sat.eff_satellite_datetime_snowflake,
         "bigquery": fixtures_eff_sat.eff_satellite_datetime_bigquery,
         "sqlserver": fixtures_eff_sat.eff_satellite_datetime_sqlserver,
         "databricks": ''},

    "fixture.eff_satellite_auto_end_dating":
        {"snowflake": fixtures_eff_sat.eff_satellite_auto_end_dating_snowflake,
         "bigquery": fixtures_eff_sat.eff_satellite_auto_end_dating_bigquery,
         "sqlserver": fixtures_eff_sat.eff_satellite_auto_end_dating_sqlserver,
         "databricks": ''},

    "fixture.eff_satellite_multipart":
        {"snowflake": fixtures_eff_sat.eff_satellite_multipart_snowflake,
         "bigquery": fixtures_eff_sat.eff_satellite_multipart_bigquery,
         "sqlserver": fixtures_eff_sat.eff_satellite_multipart_sqlserver,
         "databricks": ''},

    "fixture.multi_active_satellite":
        {"snowflake": fixtures_ma_sat.multi_active_satellite_snowflake,
         "bigquery": fixtures_ma_sat.multi_active_satellite_bigquery,
         "sqlserver": fixtures_ma_sat.multi_active_satellite_sqlserver,
         "databricks": ''},

    "fixture.multi_active_satellite_cycle":
        {"snowflake": fixtures_ma_sat.multi_active_satellite_cycle_snowflake,
         "bigquery": fixtures_ma_sat.multi_active_satellite_cycle_bigquery,
         "sqlserver": fixtures_ma_sat.multi_active_satellite_cycle_sqlserver,
         "databricks": ''},

    "fixture.xts":
        {"snowflake": fixtures_xts.xts_snowflake,
         "bigquery": fixtures_xts.xts_bigquery,
         "sqlserver": fixtures_xts.xts_sqlserver,
         "databricks": ''},

    "fixture.pit":
        {"snowflake": fixtures_pit.pit_snowflake,
         "bigquery": fixtures_pit.pit_bigquery,
         "sqlserver": fixtures_pit.pit_sqlserver,
         "databricks": ''},

    "fixture.pit_one_sat":
        {"snowflake": fixtures_pit.pit_one_sat_snowflake,
         "bigquery": fixtures_pit.pit_one_sat_bigquery,
         "sqlserver": fixtures_pit.pit_one_sat_sqlserver,
         "databricks": ''},

    "fixture.pit_two_sats":
        {"snowflake": fixtures_pit.pit_two_sats_snowflake,
         "bigquery": fixtures_pit.pit_two_sats_bigquery,
         "sqlserver": fixtures_pit.pit_two_sats_sqlserver,
         "databricks": ''},

    "fixture.bridge":
        {"snowflake": fixtures_bridge.bridge_snowflake,
         "bigquery": fixtures_bridge.bridge_bigquery,
         "sqlserver": fixtures_bridge.bridge_sqlserver,
         "databricks": ''},

    "fixture.cycle":
        {"snowflake": fixtures_cycle.cycle_snowflake,
         "bigquery": fixtures_cycle.cycle_bigquery,
         "sqlserver": fixtures_cycle.cycle_sqlserver,
         "databricks": ''},

    "fixture.cycle_custom_null_key":
        {"snowflake": fixtures_cycle.cycle_custom_null_key_snowflake,
         "bigquery": fixtures_cycle.cycle_custom_null_key_bigquery,
         "sqlserver": fixtures_cycle.cycle_custom_null_key_sqlserver,
         "databricks": ''},

}

fixture_registry_snowflake = {k: v['snowflake'] for k, v in fixtures_registry.items()}
fixture_registry_bigquery = {k: v['bigquery'] for k, v in fixtures_registry.items()}
fixture_registry_sqlserver = {k: v['sqlserver'] for k, v in fixtures_registry.items()}
fixture_registry_databricks = {k: v['databricks'] for k, v in fixtures_registry.items()}

fixture_lookup = {
    'snowflake': fixture_registry_utils | fixture_registry_snowflake,
    'bigquery': fixture_registry_utils | fixture_registry_bigquery,
    'sqlserver': fixture_registry_utils | fixture_registry_sqlserver,
    'databricks': fixture_registry_utils | fixture_registry_databricks,
}


def before_all(context):
    """
    Set up the full test environment and add objects to the context for use in steps
    """

    # Setup context
    context.config.setup_logging()

    # Env setup
    env_utils.setup_environment()

    # Delete temp YAML files
    dbtvault_generator.clean_test_schema_file()

    # Backup YAML prior to run
    dbtvault_generator.backup_project_yml()


def before_feature(context, feature):
    decide_to_run(feature.tags, feature, 'Feature')


def before_scenario(context, scenario):
    do_run = decide_to_run(scenario.effective_tags, scenario, 'Scenario')

    if do_run:
        behave_helpers.replace_test_schema()

        behave_helpers.clean_seeds()
        behave_helpers.clean_models()
        behave_helpers.clean_target()

        dbtvault_generator.clean_test_schema_file()


def before_tag(context, tag):
    tgt = env_utils.platform()

    if tgt in env_utils.AVAILABLE_PLATFORMS:
        fixtures = fixture_lookup[tgt]
        if tag.startswith("fixture."):
            return use_fixture_by_tag(tag, context, fixtures)
    else:
        raise ValueError(f"Target must be set to one of: {', '.join(env_utils.AVAILABLE_PLATFORMS)}")


def after_all(context):
    """
    Force Restore of dbt_project.yml
    """

    dbtvault_generator.restore_project_yml()


def decide_to_run(tags, obj, obj_type):
    platforms = set(env_utils.AVAILABLE_PLATFORMS)
    obj_tags = set([t.lower() for t in tags])

    if 'skip' in obj_tags:
        obj.skip(f"{obj_type} skipped due to @skip tag.")

    valid_tags = list(platforms.intersection(obj_tags))
    valid_tags_with_not = {f"not_{plt}" for plt in platforms}.intersection(obj_tags)

    # Find platforms which have the platform name x from each string not_x
    do_not_run_on = [s for s in platforms if any(s in tag for tag in valid_tags_with_not)]

    if not env_utils.platform() in valid_tags:
        if len(valid_tags) > 0:
            obj.skip(
                f"{obj_type} skipped. This {obj_type} will only run on {', '.join([t.upper() for t in valid_tags])}")
            return False

    if len(do_not_run_on) > 0:

        only_run_on = set(platforms).difference(set(do_not_run_on))

        if env_utils.platform() in do_not_run_on:
            obj.skip(
                f"{obj_type} skipped. This {obj_type} will only run on {', '.join(only_run_on)}")
            return False

    return True
