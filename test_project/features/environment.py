from behave.fixture import use_fixture_by_tag


from test_project.features.bigquery_fixtures import single_source_hub_bigquery, multi_source_hub_bigquery, \
                                                    single_source_link_bigquery, multi_source_link_bigquery, \
                                                    satellite_bigquery, satellite_cycle_bigquery, \
                                                    t_link_bigquery

from test_project.features.fixtures import *
from test_project.test_utils.dbt_test_utils import *

fixture_registry = {
    "fixture.set_workdir": set_workdir,
    "fixture.staging": staging,
    "fixture.single_source_hub": single_source_hub,
    "fixture.single_source_hub_bigquery": single_source_hub_bigquery,
    "fixture.sha": sha,
    "fixture.multi_source_hub": multi_source_hub,
    "fixture.multi_source_hub_bigquery": multi_source_hub_bigquery,
    "fixture.single_source_link": single_source_link,
    "fixture.single_source_link_bigquery": single_source_link_bigquery,
    "fixture.multi_source_link": multi_source_link,
    "fixture.multi_source_link_bigquery": multi_source_link_bigquery,
    "fixture.satellite": satellite,
    "fixture.satellite_bigquery": satellite_bigquery,
    "fixture.satellite_cycle": satellite_cycle,
    "fixture.satellite_cycle_bigquery": satellite_cycle_bigquery,
    "fixture.eff_satellite": eff_satellite,
    "fixture.eff_satellite_testing_auto_end_dating": eff_satellite_testing_auto_end_dating,
    "fixture.eff_satellite_multipart": eff_satellite_multipart,
    "fixture.t_link": t_link,
    "fixture.t_link_bigquery": t_link_bigquery,
    "fixture.xts": xts,
    "fixture.multi_active_satellite": multi_active_satellite,
    "fixture.multi_active_satellite_cycle": multi_active_satellite_cycle,
    "fixture.pit": pit,
    "fixture.pit_one_sat": pit_one_sat,
    "fixture.pit_two_sats": pit_two_sats,
    "fixture.bridge": bridge,
    "fixture.cycle": cycle,
    "fixture.enable_auto_end_date": enable_auto_end_date,
    "fixture.enable_full_refresh": enable_full_refresh,
    "fixture.disable_union": disable_union,
    "fixture.disable_payload": disable_payload
}


def before_all(context):
    """
    Set up the full test environment and add objects to the context for use in steps
    """

    dbt_test_utils = DBTTestUtils()

    # Setup context
    context.config.setup_logging()
    context.dbt_test_utils = dbt_test_utils

    # Clean dbt folders and generated files
    DBTTestUtils.clean_csv()
    DBTTestUtils.clean_models()
    DBTTestUtils.clean_target()

    # Restore modified YAML to starting state
    DBTVAULTGenerator.clean_test_schema_file()

    # Backup YAML prior to run
    DBTVAULTGenerator.backup_project_yml()

    os.chdir(TESTS_DBT_ROOT)

    context.dbt_test_utils.create_dummy_model()

    context.dbt_test_utils.replace_test_schema()


def after_all(context):
    """
    Force Restore of dbt_project.yml
    """

    DBTVAULTGenerator.restore_project_yml()


def before_scenario(context, scenario):
    context.dbt_test_utils.create_dummy_model()
    context.dbt_test_utils.replace_test_schema()

    DBTTestUtils.clean_csv()
    DBTTestUtils.clean_models()
    DBTTestUtils.clean_target()

    DBTVAULTGenerator.clean_test_schema_file()
    DBTVAULTGenerator.restore_project_yml()


def before_tag(context, tag):
    if tag.startswith("fixture."):
        return use_fixture_by_tag(tag, context, fixture_registry)
