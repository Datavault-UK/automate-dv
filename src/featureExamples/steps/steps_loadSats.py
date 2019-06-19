from behave import *
from numpy import NaN
from pandas import DataFrame

use_step_matcher("parse")


# ===== Empty SATELLITE loads de-duplicated staging data =====

@given("there is an empty vault.SAT_PARTY_DETAILS table")
def step_impl(context):
    context.testdata.drop_and_create("SAT_PARTY_DETAILS",
                                     ["PARTY_HASH CHAR(32)", "LOAD_DATETIME DATETIME", "SOURCE_SYSTEM INT(2)",
                                      "PARTY_NAME VARCHAR(50)", "PARTY_DOB DATE", "HASH_DIFF CHAR(32)",
                                      "EFFECTIVE_FROM DATETIME", "EFFECTIVE_TO DATETIME, "
                                                                 "PRIMARY KEY (PARTY_HASH, LOAD_DATETIME), "
                                                                 "CONSTRAINT PARTY_DETAILS_uk UNIQUE (PARTY_HASH, "
                                                                 "HASH_DIFF, EFFECTIVE_TO)"], "VAULT")


@step("there are records in the stg.STG_PARTY_DETAILS table")
def step_impl(context):
    context.testdata.drop_and_create("STG_PARTY_DETAILS",
                                     ["PARTY_HASH CHAR(32)", "LOAD_DATETIME DATETIME", "SOURCE_SYSTEM INT(2)",
                                      "PARTY_NAME VARCHAR(50)", "PARTY_DOB DATE", "HASH_DIFF CHAR(32)",
                                      "EFFECTIVE_FROM DATETIME", "EFFECTIVE_TO DATETIME"], "STAGE")

    context.testdata.insert_data_from_ct(context.table, "STG_PARTY_DETAILS", "STAGE")


@step("there is metadata mapping stg.STG_PARTY_DETAILS to vault.SAT_PARTY_DETAILS")
def step_impl(context):
    table = context.testdata.context_table_to_dict(context.table)

    meta_dict = {
        "Summary": {
            'src_base': 'stg.STG_PARTY_DETAILS', 'timestamp': 'load_datetime', 'src_col': 'source_system',
            'src_system': 'stage', 'tgt_system': 'vault'}, "SATS": {"SAT_PARTY_DETAILS": table}}

    context.testdata.config_file_from_dict(meta_dict, "Load1.data")


@then("the records in stg.STG_PARTY_DETAILS should have been inserted into vault.SAT_PARTY_DETAILS")
def step_impl(context):
    # All values converted to strings because the context table's values are all strings.
    actual_data = DataFrame(context.testdata.get_table_data("SAT_PARTY_DETAILS", "VAULT"), dtype=str).replace('None',
                                                                                                              NaN)
    actual_data = actual_data.sort_values(by=['PARTY_HASH'])
    actual_data = actual_data.reset_index(drop=True)

    expected_data = context.testdata.context_table_to_df(context.table)
    expected_data = expected_data.sort_values(by=['PARTY_HASH'])
    expected_data = expected_data.reset_index(drop=True)

    if actual_data.equals(expected_data):
        assert True
    else:
        assert False


# ===== SATELLITE has no new data to add from staging data =====

@given("there are records in the vault.SAT_PARTY_DETAILS table")
def step_impl(context):
    context.testdata.drop_and_create("SAT_PARTY_DETAILS",
                                     ["PARTY_HASH CHAR(32)", "LOAD_DATETIME DATETIME", "SOURCE_SYSTEM INT(2)",
                                      "PARTY_NAME VARCHAR(50)", "PARTY_DOB DATE", "HASH_DIFF CHAR(32)",
                                      "EFFECTIVE_FROM DATETIME", "EFFECTIVE_TO DATETIME, "
                                                                 "PRIMARY KEY (PARTY_HASH, LOAD_DATETIME), "
                                                                 "CONSTRAINT PARTY_DETAILS_uk UNIQUE (PARTY_HASH, "
                                                                 "HASH_DIFF, EFFECTIVE_TO)"], "VAULT")

    context.testdata.insert_data_from_ct(context.table, "SAT_PARTY_DETAILS", "VAULT")

    context.inserted_data = context.table


@then("the records in vault.SAT_PARTY_DETAILS should not have changed")
def step_impl(context):
    # All values converted to strings because the context table's values are all strings.
    actual_data = DataFrame(context.testdata.get_table_data("SAT_PARTY_DETAILS", "VAULT"), dtype=str).replace('None',
                                                                                                              NaN)
    actual_data = actual_data.sort_values(by=['PARTY_HASH'])
    actual_data = actual_data.reset_index(drop=True)

    expected_data = context.testdata.context_table_to_df(context.inserted_data)
    expected_data = expected_data.sort_values(by=['PARTY_HASH'])
    expected_data = expected_data.reset_index(drop=True)

    if actual_data.equals(expected_data):
        assert True
    else:
        assert False


# ===== SATELLITE is updated with staging data            =====
# ===== SATELLITE has deleted record that is resurrected  =====
@then("the records in vault.SAT_PARTY_DETAILS should load new and changed data and end date older data")
def step_impl(context):
    # All values converted to strings because the context table's values are all strings.
    actual_data = DataFrame(context.testdata.get_table_data("SAT_PARTY_DETAILS", "VAULT"), dtype=str).replace('None',
                                                                                                              NaN)
    actual_data = actual_data.sort_values(by=['PARTY_HASH'])
    actual_data = actual_data.reset_index(drop=True)

    expected_data = context.testdata.context_table_to_df(context.table)
    expected_data = expected_data.sort_values(by=['PARTY_HASH'])
    expected_data = expected_data.reset_index(drop=True)

    if actual_data.equals(expected_data):
        assert True
    else:
        assert False
