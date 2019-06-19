from behave import *

use_step_matcher("parse")


# ===== Multiple foreign keys are mapped =====
@step("there is a view for the stg.STG_PARTY_BOOKING table with added country_code_hash column")
def step_impl(context):
    context.testdata.create_non_null_view_from_table("stg.STG_PARTY_BOOKING",
                                                     ['BOOKING_HASH', 'PARTY_HASH', 'COUNTRY_CODE_HASH'], "STAGE")


# ===== Foreign keys include a fixed-value column =====
@step("there is a view for the stg.STG_PARTY_BOOKING table with added country code column")
def step_impl(context):
    context.testdata.create_non_null_view_from_table("stg.STG_PARTY_BOOKING",
                                                     ['BOOKING_HASH', 'PARTY_HASH', 'COUNTRY_CODE'], "STAGE")


# ===== Shared steps =====

# Empty Link loads de-duplicated staging data
# Link already covers record
# New records for Link
@step("there is a view for the stg.STG_PARTY_BOOKING table")
def step_impl(context):
    context.testdata.create_non_null_view_from_table("stg.STG_PARTY_BOOKING", ['BOOKING_HASH', 'PARTY_HASH'], "STAGE")

