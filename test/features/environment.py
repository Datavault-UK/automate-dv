from behave.fixture import use_fixture_by_tag

import dbtvault_generator
import dbtvault_harness_utils
import test
from test.features.behave_fixtures import *
from test.features.bridge import fixtures_bridge
from test.features.cycle import fixtures_cycle
from test.features.eff_sats import fixtures_eff_sat
from test.features.hubs import fixtures_hub
from test.features.links import fixtures_link
from test.features.ma_sats import fixtures_ma_sat
from test.features.sats_with_oos import fixtures_oos_sat
from test.features.pit import fixtures_pit
from test.features.sats import fixtures_sat
from test.features.staging import fixtures_staging
from test.features.t_links import fixtures_t_link
from test.features.xts import fixtures_xts

fixture_registry_utils = {
    "fixture.enable_sha": enable_sha,
    "fixture.enable_auto_end_date": enable_auto_end_date,
    "fixture.enable_full_refresh": enable_full_refresh,
    "fixture.disable_union": disable_union,
    "fixture.disable_payload": disable_payload
}

fixtures_registry = {
    "fixture.staging":
        {"snowflake": fixtures_staging.staging,
         "bigquery": fixtures_staging.staging_bigquery,
         "sqlserver": fixtures_staging.staging_sqlserver},

    "fixture.single_source_hub":
        {"snowflake": fixtures_hub.single_source_hub,
         "bigquery": fixtures_hub.single_source_hub_bigquery,
         "sqlserver": fixtures_hub.single_source_hub_sqlserver},

    "fixture.multi_source_hub":
        {"snowflake": fixtures_hub.multi_source_hub,
         "bigquery": fixtures_hub.multi_source_hub_bigquery,
         "sqlserver": fixtures_hub.multi_source_hub_sqlserver},

    "fixture.single_source_link":
        {"snowflake": fixtures_link.single_source_link,
         "bigquery": fixtures_link.single_source_link_bigquery,
         "sqlserver": fixtures_link.single_source_link_sqlserver},

    "fixture.multi_source_link":
        {"snowflake": fixtures_link.multi_source_link,
         "bigquery": fixtures_link.multi_source_link_bigquery,
         "sqlserver": fixtures_link.multi_source_link_sqlserver},

    "fixture.t_link":
        {"snowflake": fixtures_t_link.t_link,
         "bigquery": fixtures_t_link.t_link_bigquery,
         "sqlserver": fixtures_t_link.t_link_sqlserver},

    "fixture.satellite":
        {"snowflake": fixtures_sat.satellite,
         "bigquery": fixtures_sat.satellite_bigquery,
         "sqlserver": fixtures_sat.satellite_sqlserver},

    "fixture.satellite_cycle":
        {"snowflake": fixtures_sat.satellite_cycle,
         "bigquery": fixtures_sat.satellite_cycle_bigquery,
         "sqlserver": fixtures_sat.satellite_cycle_sqlserver},

    "fixture.eff_satellite":
        {"snowflake": fixtures_eff_sat.eff_satellite,
         "bigquery": fixtures_eff_sat.eff_satellite_bigquery,
         "sqlserver": fixtures_eff_sat.eff_satellite_sqlserver},

    "fixture.eff_satellite_testing_auto_end_dating":
        {"snowflake": fixtures_eff_sat.eff_satellite_testing_auto_end_dating,
         "bigquery": fixtures_eff_sat.eff_satellite_testing_auto_end_dating_bigquery,
         "sqlserver": fixtures_eff_sat.eff_satellite_testing_auto_end_dating_sqlserver},

    "fixture.eff_satellite_multipart":
        {"snowflake": fixtures_eff_sat.eff_satellite_multipart,
         "bigquery": fixtures_eff_sat.eff_satellite_multipart_bigquery,
         "sqlserver": fixtures_eff_sat.eff_satellite_multipart_sqlserver},

    "fixture.out_of_sequence_satellite":
        {"snowflake": fixtures_oos_sat.out_of_sequence_satellite,
         "bigquery": "",
         "sqlserver": fixtures_oos_sat.out_of_sequence_satellite_sqlserver},

    "fixture.multi_active_satellite":
        {"snowflake": fixtures_ma_sat.multi_active_satellite,
         "bigquery": fixtures_ma_sat.multi_active_satellite_bigquery,
         "sqlserver": fixtures_ma_sat.multi_active_satellite_sqlserver},

    "fixture.multi_active_satellite_cycle":
        {"snowflake": fixtures_ma_sat.multi_active_satellite_cycle,
         "bigquery": fixtures_ma_sat.multi_active_satellite_cycle_bigquery,
         "sqlserver": fixtures_ma_sat.multi_active_satellite_cycle_sqlserver},

    "fixture.xts":
        {"snowflake": fixtures_xts.xts,
         "bigquery": fixtures_xts.xts_bigquery,
         "sqlserver": fixtures_xts.xts_sqlserver},

    "fixture.pit":
        {"snowflake": fixtures_pit.pit,
         "bigquery": fixtures_pit.pit_bigquery,
         "sqlserver": fixtures_pit.pit_sqlserver},

    "fixture.pit_one_sat":
        {"snowflake": fixtures_pit.pit_one_sat,
         "bigquery": fixtures_pit.pit_one_sat_bigquery,
         "sqlserver": fixtures_pit.pit_one_sat_sqlserver},

    "fixture.pit_two_sats":
        {"snowflake": fixtures_pit.pit_two_sats,
         "bigquery": fixtures_pit.pit_two_sats_bigquery,
         "sqlserver": fixtures_pit.pit_two_sats_sqlserver},

    "fixture.bridge":
        {"snowflake": fixtures_bridge.bridge,
         "bigquery": fixtures_bridge.bridge_bigquery,
         "sqlserver": fixtures_bridge.bridge_sqlserver},

    "fixture.cycle":
        {"snowflake": fixtures_cycle.cycle,
         "bigquery": fixtures_cycle.cycle_bigquery,
         "sqlserver": fixtures_cycle.cycle_sqlserver},

}

fixture_registry_snowflake = {k: v['snowflake'] for k, v in fixtures_registry.items()}
fixture_registry_bigquery = {k: v['bigquery'] for k, v in fixtures_registry.items()}
fixture_registry_sqlserver = {k: v['sqlserver'] for k, v in fixtures_registry.items()}

fixture_lookup = {
    'snowflake': fixture_registry_utils | fixture_registry_snowflake,
    'bigquery': fixture_registry_utils | fixture_registry_bigquery,
    'sqlserver': fixture_registry_utils | fixture_registry_sqlserver
}


def before_all(context):
    """
    Set up the full test environment and add objects to the context for use in steps
    """

    # Setup context
    context.config.setup_logging()

    # Env setup
    dbtvault_harness_utils.setup_environment()

    # Clean dbt folders and generated files
    dbtvault_harness_utils.clean_csv()
    dbtvault_harness_utils.clean_models()
    dbtvault_harness_utils.clean_target()

    # Restore modified YAML to starting state
    dbtvault_generator.clean_test_schema_file()

    # Backup YAML prior to run
    dbtvault_generator.backup_project_yml()

    dbtvault_harness_utils.create_dummy_model()

    dbtvault_harness_utils.replace_test_schema()


def after_all(context):
    """
    Force Restore of dbt_project.yml
    """

    dbtvault_generator.restore_project_yml()


def before_scenario(context, scenario):
    dbtvault_harness_utils.create_dummy_model()
    dbtvault_harness_utils.replace_test_schema()

    dbtvault_harness_utils.clean_csv()
    dbtvault_harness_utils.clean_models()
    dbtvault_harness_utils.clean_target()

    dbtvault_generator.clean_test_schema_file()


def before_tag(context, tag):
    tgt = dbtvault_harness_utils.platform()

    if tgt in test.AVAILABLE_PLATFORMS:
        fixtures = fixture_lookup[tgt]
        if tag.startswith("fixture."):
            return use_fixture_by_tag(tag, context, fixtures)
    else:
        raise ValueError(f"Target must be set to one of: {', '.join(test.AVAILABLE_PLATFORMS)}")
