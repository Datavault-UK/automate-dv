from behave import *
from pandas import DataFrame
from pandas import Timestamp

use_step_matcher("parse")


# ===== Empty TRANSACTIONAL LINK loads from staging data =====

@given("there is an empty vault.TLINK_PARTY_PAYMENT table")
def step_impl(context):
    context.testdata.drop_and_create("TLINK_PARTY_PAYMENT",
                                     ["PARTY_PAYMENT_HASH CHAR(32)", "PARTY_HASH CHAR(32)", "BOOKING_HASH CHAR(32)",
                                      "LOAD_DATETIME DATETIME", "SOURCE_SYSTEM INT(2)",
                                      "PAYMENT_AMOUNT CHAR(15)", "PAYMENT_DATETIME DATETIME",
                                      "PRIMARY KEY (PARTY_PAYMENT_HASH)"], "VAULT")


@step("there are records in the stg.STG_PARTY_PAYMENT table")
def step_impl(context):
    context.testdata.drop_and_create("STG_PARTY_PAYMENT",
                                     ["PARTY_PAYMENT_HASH CHAR(32)", "PARTY_HASH CHAR(32)", "BOOKING_HASH CHAR(32)",
                                      "LOAD_DATETIME DATETIME", "SOURCE_SYSTEM INT(2)",
                                      "PAYMENT_AMOUNT CHAR(15)", "PAYMENT_DATETIME DATETIME"], "STAGE")

    context.testdata.insert_data_from_ct(context.table, "STG_PARTY_PAYMENT", "STAGE")


@step("there is no waterlevel record for stg.STG_PARTY_PAYMENT")
def step_impl(context):
    context.testdata.drop_and_create("WATERLEVEL",
                                     ["TABLE_NAME VARCHAR(255)", "LOAD_DATETIME DATETIME", "PRIMARY KEY (TABLE_NAME)"],
                                     "WATERLEVEL")


@step("there is metadata mapping stg.STG_PARTY_PAYMENT to vault.TLINK_PARTY_PAYMENT")
def step_impl(context):
    table = context.testdata.context_table_to_dict(context.table)

    meta_dict = {
        "Summary": {
            'src_base': 'stg.STG_PARTY_PAYMENT', 'timestamp': 'load_datetime', 'src_col': 'source_system',
            'src_system': 'stage', 'tgt_system': 'vault'}, "TRANSACTIONAL_LINKS": {"TLINK_PARTY_PAYMENT": table}}

    context.testdata.config_file_from_dict(meta_dict, "Load1.data")


# ===== Transactional Link duplicate feed is ignored =====

@step("there are overlapping records in the stg.STG_PARTY_PAYMENT table")
def step_impl(context):
    context.testdata.drop_and_create("STG_PARTY_PAYMENT",
                                     ["PARTY_PAYMENT_HASH CHAR(32)", "PARTY_HASH CHAR(32)", "BOOKING_HASH CHAR(32)",
                                      "LOAD_DATETIME DATETIME", "SOURCE_SYSTEM INT(2)",
                                      "PAYMENT_AMOUNT CHAR(15)", "PAYMENT_DATETIME DATETIME"], "STAGE")

    context.testdata.insert_data_from_ct(context.table, "STG_PARTY_PAYMENT", "STAGE")

    # All values converted to strings because the context table's values are all strings.
    actual_data = DataFrame(context.testdata.get_table_data("STG_PARTY_PAYMENT", "STAGE"), dtype=str)
    actual_data = actual_data.sort_values(by=['PARTY_PAYMENT_HASH'])
    actual_data = actual_data.reset_index(drop=True)

    expected_data = context.testdata.context_table_to_df(context.table)
    expected_data = expected_data.sort_values(by=['PARTY_PAYMENT_HASH'])
    expected_data = expected_data.reset_index(drop=True)

    if actual_data.equals(expected_data):
        assert True
    else:
        assert False


# ===== SHARED STEPS
# ===== Empty TRANSACTIONAL LINK loads from staging data =====
# ===== Transactional Link duplicate feed is ignored     =====
# ===== Add records to Transactional Link                =====

@then("there should be no change to the records in vault.TLINK_PARTY_PAYMENT table")
@then("the records in STG_PARTY_PAYMENT should have been inserted into vault.TLINK_PARTY_PAYMENT")
@then("records should be added to the records in vault.TLINK_PARTY_PAYMENT table")
def step_impl(context):
    # All values converted to strings because the context table's values are all strings.
    actual_data = DataFrame(context.testdata.get_table_data("TLINK_PARTY_PAYMENT", "VAULT"), dtype=str)
    actual_data = actual_data.sort_values(by=['PARTY_PAYMENT_HASH'])
    actual_data = actual_data.reset_index(drop=True)

    expected_data = context.testdata.context_table_to_df(context.table)
    expected_data = expected_data.sort_values(by=['PARTY_PAYMENT_HASH'])
    expected_data = expected_data.reset_index(drop=True)

    if actual_data.equals(expected_data):
        assert True
    else:
        assert False


# ===== Transactional Link duplicate feed is ignored =====
# ===== Add records to Transactional Link            =====
@given("there are records in the vault.TLINK_PARTY_PAYMENT table")
def step_impl(context):
    context.testdata.drop_and_create("TLINK_PARTY_PAYMENT",
                                     ["PARTY_PAYMENT_HASH CHAR(32)", "PARTY_HASH CHAR(32)", "BOOKING_HASH CHAR(32)",
                                      "LOAD_DATETIME DATETIME", "SOURCE_SYSTEM INT(2)",
                                      "PAYMENT_AMOUNT CHAR(15)", "PAYMENT_DATETIME DATETIME",
                                      "PRIMARY KEY (PARTY_PAYMENT_HASH)"], "VAULT")

    context.testdata.insert_data_from_ct(context.table, "TLINK_PARTY_PAYMENT", "VAULT")


# Generic waterlevel setting step.
@step('the waterlevel record for "{table_name}" is "{timestamp}"')
def step_impl(context, table_name, timestamp):
    time_st = Timestamp(timestamp)

    context.testdata.set_waterlevel_for_table(table_name, time_st)

    actual_waterlevel = context.testdata.get_waterlevel_for_table(table_name)

    expected_waterlevel = time_st

    if expected_waterlevel == actual_waterlevel:
        assert True
    else:
        assert False
