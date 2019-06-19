from behave import *

from pandas import DataFrame

use_step_matcher("parse")


# ===== Empty Link loads de-duplicated staging data =====

@given("there is an empty vault.LINK_PARTY_BOOKING table")
def step_impl(context):
    context.testdata.drop_and_create("LINK_PARTY_BOOKING",
                                     ["PARTY_BOOKING_HASH CHAR(32)", "PARTY_HASH CHAR(32)", "BOOKING_HASH CHAR(32)",
                                      "LOAD_DATETIME DATETIME", "SOURCE_SYSTEM INT(2)",
                                      "PRIMARY KEY (PARTY_BOOKING_HASH)"], "VAULT")


@step("there are records in the stg.STG_PARTY_BOOKING table")
def step_impl(context):
    context.testdata.drop_and_create("STG_PARTY_BOOKING",
                                     ["PARTY_BOOKING_HASH CHAR(32)", "PARTY_HASH CHAR(32)", "BOOKING_HASH CHAR(32)",
                                      "LOAD_DATETIME DATETIME", "SOURCE_SYSTEM INT(2)"], "STAGE")

    context.testdata.insert_data_from_ct(context.table, "STG_PARTY_BOOKING", "STAGE")


@step("there is no waterlevel record for stg.STG_PARTY_BOOKING")
def step_impl(context):
    context.testdata.drop_and_create("WATERLEVEL",
                                     ["TABLE_NAME VARCHAR(255)", "LOAD_DATETIME DATETIME", "PRIMARY KEY (TABLE_NAME)"],
                                     "WATERLEVEL")


# ===== Link already covers records =====

@given("there are records in the vault.LINK_PARTY_BOOKING table")
def step_impl(context):
    context.testdata.drop_and_create("LINK_PARTY_BOOKING",
                                     ["PARTY_BOOKING_HASH CHAR(32)", "PARTY_HASH CHAR(32)", "BOOKING_HASH CHAR(32)",
                                      "LOAD_DATETIME DATETIME", "SOURCE_SYSTEM INT(2)",
                                      "PRIMARY KEY (PARTY_BOOKING_HASH)"], "VAULT")

    context.testdata.insert_data_from_ct(context.table, "LINK_PARTY_BOOKING", "VAULT")

    context.inserted_data = context.table


@step("there are overlapping records in the stg.STG_PARTY_BOOKING table")
@step("there are overlapping and new records in the stg.STG_PARTY_BOOKING table")
def step_impl(context):
    context.testdata.drop_and_create("STG_PARTY_BOOKING",
                                     ["PARTY_BOOKING_HASH CHAR(32)", "PARTY_HASH CHAR(32)", "BOOKING_HASH CHAR(32)",
                                      "LOAD_DATETIME DATETIME", "SOURCE_SYSTEM INT(2)"], "STAGE")

    context.testdata.insert_data_from_ct(context.table, "STG_PARTY_BOOKING", "STAGE")


@then("there should be no change to the records in vault.LINK_PARTY_BOOKING")
def step_impl(context):
    # All values converted to strings because the context table's values are all strings.
    actual_data = DataFrame(context.testdata.get_table_data("LINK_PARTY_BOOKING", "VAULT"), dtype=str)
    actual_data = actual_data.sort_values(by=['PARTY_BOOKING_HASH'])
    actual_data = actual_data.reset_index(drop=True)

    expected_data = context.testdata.context_table_to_df(context.inserted_data)
    expected_data = expected_data.sort_values(by=['PARTY_BOOKING_HASH'])
    expected_data = expected_data.reset_index(drop=True)

    if actual_data.equals(expected_data):
        assert True
    else:
        assert False


# ===== Multiple foreign keys are mapped =====

@given("there are records in the vault.LINK_PARTY_BOOKING table "
       "with an added country_code_hash column")
def step_impl(context):
    context.testdata.drop_and_create("LINK_PARTY_BOOKING",
                                     ["PARTY_BOOKING_HASH CHAR(32)", "PARTY_HASH CHAR(32)", "BOOKING_HASH CHAR(32)",
                                      "COUNTRY_CODE_HASH CHAR(32)", "LOAD_DATETIME DATETIME", "SOURCE_SYSTEM INT(2)",
                                      "PRIMARY KEY (PARTY_BOOKING_HASH)"], "VAULT")

    context.testdata.insert_data_from_ct(context.table, "LINK_PARTY_BOOKING", "VAULT")


@step("there are overlapping and new records in the stg.STG_PARTY_BOOKING table "
      "with an added country_code_hash column")
def step_impl(context):
    context.testdata.drop_and_create("STG_PARTY_BOOKING",
                                     ["PARTY_BOOKING_HASH CHAR(32)", "PARTY_HASH CHAR(32)", "BOOKING_HASH CHAR(32)",
                                      "COUNTRY_CODE_HASH CHAR(32)", "LOAD_DATETIME DATETIME", "SOURCE_SYSTEM INT(2)"],
                                     "STAGE")
    context.testdata.insert_data_from_ct(context.table, "STG_PARTY_BOOKING", "STAGE")


# ===== Foreign keys include a fixed-value column =====

@given("there are records in the vault.LINK_PARTY_BOOKING table "
       "with an added country code column")
def step_impl(context):
    context.testdata.drop_and_create("LINK_PARTY_BOOKING",
                                     ["PARTY_BOOKING_HASH CHAR(32)", "PARTY_HASH CHAR(32)", "BOOKING_HASH CHAR(32)",
                                      "COUNTRY_CODE CHAR(5)", "LOAD_DATETIME DATETIME", "SOURCE_SYSTEM INT(2)",
                                      "PRIMARY KEY (PARTY_BOOKING_HASH)"], "VAULT")

    context.testdata.insert_data_from_ct(context.table, "LINK_PARTY_BOOKING", "VAULT")


@step("there are overlapping and new records in the stg.STG_PARTY_BOOKING table "
      "with an added country code column")
def step_impl(context):
    context.testdata.drop_and_create("STG_PARTY_BOOKING",
                                     ["PARTY_BOOKING_HASH CHAR(32)", "PARTY_HASH CHAR(32)", "BOOKING_HASH CHAR(32)",
                                      "COUNTRY_CODE CHAR(5)", "LOAD_DATETIME DATETIME", "SOURCE_SYSTEM INT(2)"],
                                     "STAGE")
    context.testdata.insert_data_from_ct(context.table, "STG_PARTY_BOOKING", "STAGE")


# ===== Shared steps =====

# Empty Link loads de-duplicated staging data
# Link already covers records
# New records for Link
# Multiple foreign keys are mapped
@step("there is metadata mapping stg.STG_PARTY_BOOKING to vault.LINK_PARTY_BOOKING")
# Foreign keys include a fixed-value column
@step("there is metadata mapping stg.STG_PARTY_BOOKING to vault.LINK_PARTY_BOOKING "
      "with a fixed value foreign key column")
# Step for optional_links.feature
@step("there is metadata mapping stg.STG_PARTY_BOOKING_view to vault.LINK_PARTY_BOOKING")
def step_impl(context):
    table = context.testdata.context_table_to_dict(context.table)

    meta_dict = {
        "Summary": {
            'src_base': 'stg.STG_PARTY_BOOKING',
            'timestamp': 'load_datetime',
            'src_col': 'source_system',
            'src_system': 'stage',
            'tgt_system': 'vault'},
        "LINKS": {"LINK_PARTY_BOOKING": table}}

    context.testdata.config_file_from_dict(meta_dict, "Load1.data")


# Empty Link loads de-duplicated staging data
@then("the records in stg.STG_PARTY_BOOKING should have been inserted into vault.LINK_PARTY_BOOKING")
# New records for Link
# Multiple foreign keys are mapped
# Foreign keys include a fixed-value column
@then("the vault.LINK_PARTY_BOOKING table should include the new records")
def step_impl(context):
    # All values converted to strings because the context table's values are all strings.
    actual_data = DataFrame(context.testdata.get_table_data("LINK_PARTY_BOOKING", "VAULT"), dtype=str)
    actual_data = actual_data.sort_values(by=['PARTY_BOOKING_HASH'])
    actual_data = actual_data.reset_index(drop=True)

    expected_data = context.testdata.context_table_to_df(context.table)
    expected_data = expected_data.sort_values(by=['PARTY_BOOKING_HASH'])
    expected_data = expected_data.reset_index(drop=True)

    if actual_data.equals(expected_data):
        assert True
    else:
        assert False
