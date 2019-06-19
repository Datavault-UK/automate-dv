from behave import *

from pandas import DataFrame, Timestamp

use_step_matcher("parse")


# ===== Empty Hub loads de-duplicated staging data =====
# Some steps shared by other scenarios.

@given("there is an empty vault.HUB_PARTY table")
def step_impl(context):
    context.testdata.drop_and_create("HUB_PARTY",
                                     ["PARTY_HASH CHAR(32)", "LOAD_DATETIME DATETIME", "SOURCE_SYSTEM INT(2)",
                                      "PARTY_REFERENCE INT(4), PRIMARY KEY (PARTY_HASH)"], "VAULT")


@step("there is no waterlevel record for stg.STG_PARTY")
def step_impl(context):
    context.testdata.drop_and_create("WATERLEVEL",
                                     ["TABLE_NAME VARCHAR(255)", "LOAD_DATETIME DATETIME", "PRIMARY KEY (TABLE_NAME)"],
                                     "WATERLEVEL")


@step("there are records in the stg.STG_PARTY table")
def step_impl(context):
    context.testdata.drop_and_create("STG_PARTY",
                                     ["PARTY_HASH CHAR(32)", "LOAD_DATETIME DATETIME", "SOURCE_SYSTEM INT(2)",
                                      "PARTY_REFERENCE INT(4)"], "STAGE")

    context.testdata.insert_data_from_ct(context.table, "STG_PARTY", "STAGE")


@step("there is metadata mapping stg.STG_PARTY to vault.HUB_PARTY")
def step_impl(context):
    table = context.testdata.context_table_to_dict(context.table)

    meta_dict = {
        "Summary": {
            'src_base': 'stg.STG_PARTY',
            'timestamp': 'load_datetime',
            'src_col': 'source_system',
            'src_system': 'stage',
            'tgt_system': 'vault'},
        "HUBS": {"HUB_PARTY": table}}

    context.testdata.config_file_from_dict(meta_dict, "Load1.data")


# ===== Hub already covers staged records =====

@step("there are records in the vault.HUB_PARTY table")
def step_impl(context):
    context.testdata.drop_and_create("HUB_PARTY",
                                     ["PARTY_HASH CHAR(32)", "LOAD_DATETIME DATETIME", "SOURCE_SYSTEM INT(2)",
                                      "PARTY_REFERENCE INT(4)", "PRIMARY KEY (PARTY_HASH)"], "VAULT")

    context.testdata.insert_data_from_ct(context.table, "HUB_PARTY", "VAULT")

    context.inserted_data = context.table


@then("there should be no change to the records in vault.HUB_PARTY")
def step_impl(context):
    # All values converted to strings because the context table's values are all strings.
    actual_data = DataFrame(context.testdata.get_table_data("HUB_PARTY", "VAULT"), dtype=str)
    actual_data = actual_data.sort_values(by=['PARTY_REFERENCE'])
    actual_data = actual_data.reset_index(drop=True)

    # Uses the value of the inserted data to check
    # that the current data is the same as that inserted, i.e. No change
    expected_data = context.testdata.context_table_to_df(context.inserted_data)

    if actual_data.equals(expected_data):
        assert True
    else:
        assert False

# ===== New records in staging for Hub =====


@step("there are overlapping and new records in the stg.STG_PARTY table")
def step_impl(context):
    context.testdata.drop_and_create("STG_PARTY",
                                     ["PARTY_HASH CHAR(32)", "LOAD_DATETIME DATETIME", "SOURCE_SYSTEM INT(2)",
                                      "PARTY_REFERENCE INT(4)"], "STAGE")

    context.testdata.insert_data_from_ct(context.table, "STG_PARTY", "STAGE")


# ===== Multi-column natural key =====

@step("there are records in the stg.STG_PARTY table with an added country code column")
def step_impl(context):
    context.testdata.drop_and_create("STG_PARTY",
                                     ["PARTY_HASH CHAR(32)", "LOAD_DATETIME DATETIME", "SOURCE_SYSTEM INT(2)",
                                      "PARTY_REFERENCE INT(4), COUNTRY_CODE CHAR(2)"], "STAGE")

    context.testdata.insert_data_from_ct(context.table, "STG_PARTY", "STAGE")


@given("there is an empty vault.HUB_PARTY table with an added country code column")
def step_impl(context):
    context.testdata.drop_and_create("HUB_PARTY",
                                     ["PARTY_HASH CHAR(32)", "LOAD_DATETIME DATETIME", "SOURCE_SYSTEM INT(2)",
                                      "PARTY_REFERENCE INT(4), "
                                      "COUNTRY_CODE CHAR(2), PRIMARY KEY (PARTY_HASH)"], "VAULT")


# ===== Shared steps =====

# Empty Hub loads de-duplicated staging data
@then("the records in stg.STG_PARTY should have been inserted into vault.HUB_PARTY")
# New records in staging for Hub
@then("the vault.HUB_PARTY table should include the new records")
# Hub loads the earliest instance of a record
@then("the vault.HUB_PARTY table should include the earliest unique records")
# Multi-column natural key
@then("the vault.HUB_PARTY table should include all the natural key columns")
def step_impl(context):
    # All values converted to strings because the context table's values are all strings.
    actual_data = DataFrame(context.testdata.get_table_data("HUB_PARTY", "VAULT"), dtype=str)
    actual_data = actual_data.sort_values(by=['PARTY_REFERENCE'])
    actual_data = actual_data.reset_index(drop=True)

    expected_data = context.testdata.context_table_to_df(context.table)

    if actual_data.equals(expected_data):
        assert True
    else:
        assert False
