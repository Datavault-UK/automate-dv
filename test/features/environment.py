from behave.fixture import use_fixture_by_tag

from test.features.bridge import fixtures_bridge
from test.features.cycle import fixtures_cycle
from test.features.eff_sats import fixtures_eff_sat
from test.features.fixtures import *
from test.features.hubs import fixtures_hub
from test.features.links import fixtures_link
from test.features.ma_sats import fixtures_ma_sat
from test.features.pit import fixtures_pit
from test.features.sats import fixtures_sat
from test.features.staging import fixtures_staging
from test.features.xts import fixtures_xts
from test_utils import dbtvault_generator, dbtvault_harness_utils

fixture_registry_utils = {
    "fixture.set_workdir": set_workdir,
    "fixture.enable_sha": enable_sha,
    "fixture.enable_auto_end_date": enable_auto_end_date,
    "fixture.enable_full_refresh": enable_full_refresh,
    "fixture.disable_union": disable_union,
    "fixture.disable_payload": disable_payload
}

fixture_registry_snowflake = {
    "fixture.staging": fixtures_staging.staging,
    "fixture.single_source_hub": fixtures_hub.single_source_hub,
    "fixture.multi_source_hub": fixtures_hub.multi_source_hub,
    "fixture.single_source_link": fixtures_link.single_source_link,
    "fixture.multi_source_link": fixtures_link.multi_source_link,
    "fixture.t_link": fixtures_link.t_link,
    "fixture.satellite": fixtures_sat.satellite,
    "fixture.satellite_cycle": fixtures_sat.satellite_cycle,
    "fixture.eff_satellite": fixtures_eff_sat.eff_satellite,
    "fixture.eff_satellite_testing_auto_end_dating": fixtures_eff_sat.eff_satellite_testing_auto_end_dating,
    "fixture.eff_satellite_multipart": fixtures_eff_sat.eff_satellite_multipart,
    "fixture.multi_active_satellite": fixtures_ma_sat.multi_active_satellite,
    "fixture.multi_active_satellite_cycle": fixtures_ma_sat.multi_active_satellite_cycle,
    "fixture.xts": fixtures_xts.xts,
    "fixture.pit": fixtures_pit.pit,
    "fixture.pit_one_sat": fixtures_pit.pit_one_sat,
    "fixture.pit_two_sats": fixtures_pit.pit_two_sats,
    "fixture.bridge": fixtures_bridge.bridge,
    "fixture.cycle": fixtures_cycle,
}

fixture_registry_bigquery = {

}

fixture_registry_sqlserver = {

}

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

    # Clean dbt folders and generated files
    dbtvault_harness_utils.clean_csv()
    dbtvault_harness_utils.clean_models()
    dbtvault_harness_utils.clean_target()

    # Restore modified YAML to starting state
    dbtvault_generator.clean_test_schema_file()

    # Backup YAML prior to run
    dbtvault_generator.backup_project_yml()

    # Env setup
    os.chdir(test.TESTS_DBT_ROOT)
    os.environ['TARGET'] = dbtvault_harness_utils.target()

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
    dbtvault_generator.restore_project_yml()


def before_tag(context, tag):
    tgt = dbtvault_harness_utils.target()

    if tgt in test.AVAILABLE_TARGETS:
        fixtures = fixture_lookup[tgt]
        if tag.startswith("fixture."):
            return use_fixture_by_tag(tag, context, fixtures)
    else:
        raise ValueError(f"Target must be set to one of: {', '.join(test.AVAILABLE_TARGETS)}")
