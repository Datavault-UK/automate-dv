from behave import *
import os
from definitions import DBT_ROOT
from pandas import DataFrame

use_step_matcher("parse")

# ============== Create Staging =================


@given("there is an empty TEST_STG_CUSTOMER table")
def step_impl(context):
    context.testdata.create_schema("DV_PROTOTYPE_DB", "SRC_TEST_STG")
    context.testdata.drop_and_create("DV_PROTOTYPE_DB", "SRC_TEST_STG", "test_stg_customer",
                                     ["CUSTOMER_ID VARCHAR(38)", "CUSTOMER_NAME VARCHAR(60)", "CUSTOMER_DOB DATE",
                                      "LOAD_DATE DATE", "EFFECTIVE_FROM DATE"], materialise="table")


@step("there is an empty TEST_STG_BOOKING table")
def step_impl(context):
    context.testdata.create_schema("DV_PROTOTYPE_DB", "SRC_TEST_STG")
    context.testdata.drop_and_create("DV_PROTOTYPE_DB", "SRC_TEST_STG", "test_stg_booking",
                                     ["BOOKING_REF NUMBER(38,0)", "CUSTOMER_ID VARCHAR(38)", "PRICE DOUBLE",
                                      "DEPARTURE_DATE DATE", "DESTINATION VARCHAR(3)", "PHONE VARCHAR(15)",
                                      "NATIONALITY VARCHAR(30)"], materialise="table")


# ============ Load empty tables ================


@step("the vault is empty")
def step_impl(context):
    os.chdir(DBT_ROOT)

    os.system("dbt run --full-refresh --models snow_vault.features.load_cycles.*")

# ================ Data inserts =================


@when('the TEST_STG_CUSTOMER table has data inserted into it for day {day_number}')
def step_impl(context, day_number):
    context.testdata.create_schema("DV_PROTOTYPE_DB", "SRC_TEST_STG")
    context.testdata.drop_and_create("DV_PROTOTYPE_DB", "SRC_TEST_STG", "test_stg_customer",
                                     ["CUSTOMER_ID VARCHAR(38)", "CUSTOMER_NAME VARCHAR(60)", "CUSTOMER_DOB DATE",
                                      "LOADDATE DATE", "EFFECTIVE_FROM DATE"], materialise="table")

    context.testdata.insert_data_from_ct(context.table, "test_stg_customer", "SRC_TEST_STG")


@step('the TEST_STG_BOOKING table has data inserted into it for day {day_number}')
def step_impl(context, day_number):
    context.testdata.create_schema("DV_PROTOTYPE_DB", "SRC_TEST_STG")
    context.testdata.drop_and_create("DV_PROTOTYPE_DB", "SRC_TEST_STG", "test_stg_booking",
                                     ["BOOKING_REF VARCHAR(38)", "CUSTOMER_ID VARCHAR(38)", "PRICE DOUBLE",
                                      "DEPARTURE_DATE DATE", "DESTINATION VARCHAR(3)", "PHONE VARCHAR(15)",
                                      "NATIONALITY VARCHAR(30)"], materialise="table")
    context.testdata.insert_data_from_ct(context.table, "test_stg_booking", "SRC_TEST_STG")


@step('the vault is loaded for day {day_number}')
def step_impl(context, day_number):
    os.chdir(DBT_ROOT)

    os.system("dbt run --models snow_vault.features.load_cycles.*")


# ============== Check loaded data ==============


@then("we expect the TEST_HUB_CUSTOMER table to contain")
def step_impl(context):

    sql = "SELECT CAST(CUSTOMER_PK AS VARCHAR(32)) AS CUSTOMER_PK, " \
          "CUSTOMER_ID, LOADDATE FROM DV_PROTOTYPE_DB.SRC_TEST_VLT.test_hub_customer " \
          "AS hub ORDER BY hub.CUSTOMER_ID ASC;"

    table_df = context.testdata.context_table_to_df(context.table)
    result_df = DataFrame(context.testdata.general_sql_statement_to_df(sql), dtype=str)

    table_df['CUSTOMER_PK'] = table_df['CUSTOMER_PK'].str.upper()

    # Ignore SOURCE column
    table_df.drop(['SOURCE'], 1, inplace=True)

    if result_df.equals(table_df):
        assert True
    else:
        assert False


@step("we expect the TEST_HUB_BOOKING table to contain")
def step_impl(context):

    sql = "SELECT CAST(BOOKING_PK AS VARCHAR(32)) AS BOOKING_PK, " \
          "BOOKING_REF, LOADDATE FROM DV_PROTOTYPE_DB.SRC_TEST_VLT.test_hub_booking " \
          "AS hub ORDER BY hub.BOOKING_REF;"

    table_df = context.testdata.context_table_to_df(context.table)
    result_df = DataFrame(context.testdata.general_sql_statement_to_df(sql), dtype=str)

    table_df['BOOKING_PK'] = table_df['BOOKING_PK'].str.upper()

    # Ignore SOURCE column
    table_df.drop(['SOURCE'], 1, inplace=True)

    if result_df.equals(table_df):
        assert True
    else:
        assert False


@step("we expect the TEST_LINK_CUSTOMER_BOOKING table to contain")
def step_impl(context):

    sql = "SELECT CAST(CUSTOMER_BOOKING_PK AS VARCHAR(32)) AS CUSTOMER_BOOKING_PK, " \
          "CAST(CUSTOMER_PK AS VARCHAR(32)) AS CUSTOMER_PK, " \
          "CAST(BOOKING_PK AS VARCHAR(32)) AS BOOKING_PK, " \
          "LOADDATE, SOURCE FROM DV_PROTOTYPE_DB.SRC_TEST_VLT.test_link_customer_booking "

    table_df = context.testdata.context_table_to_df(context.table)
    result_df = DataFrame(context.testdata.general_sql_statement_to_df(sql), dtype=str)

    table_df['CUSTOMER_BOOKING_PK'] = table_df['CUSTOMER_BOOKING_PK'].str.upper()
    table_df['CUSTOMER_PK'] = table_df['CUSTOMER_PK'].str.upper()
    table_df['BOOKING_PK'] = table_df['BOOKING_PK'].str.upper()

    if result_df.equals(table_df):
        assert True
    else:
        assert False


@step("we expect the TEST_SAT_CUST_CUSTOMER_DETAILS table to contain")
def step_impl(context):

    sql = "SELECT CAST(CUSTOMER_PK AS VARCHAR(32)) AS CUSTOMER_PK, " \
          "CAST(HASHDIFF AS VARCHAR(32)) AS HASHDIFF, " \
          "NAME, DOB, EFFECTIVE_FROM, LOADDATE FROM " \
          "DV_PROTOTYPE_DB.SRC_TEST_VLT.test_sat_cust_customer_details " \
          "AS sat ORDER BY sat.NAME;"

    table_df = context.testdata.context_table_to_df(context.table)
    result_df = DataFrame(context.testdata.general_sql_statement_to_df(sql), dtype=str)

    table_df['CUSTOMER_PK'] = table_df['CUSTOMER_PK'].str.upper()
    table_df['HASHDIFF'] = table_df['HASHDIFF'].str.upper()

    # Ignore SOURCE column
    table_df.drop(['SOURCE'], 1, inplace=True)

    if result_df.equals(table_df):
        assert True
    else:
        assert False


@step("we expect the TEST_SAT_BOOK_CUSTOMER_DETAILS table to contain")
def step_impl(context):

    sql = "SELECT CAST(BOOKING_PK AS VARCHAR(32)) AS BOOKING_PK, " \
          "CAST(HASHDIFF AS VARCHAR(32)) AS HASHDIFF, " \
          "PRICE, DEPARTURE_DATE, DESTINATION, EFFECTIVE_FROM, LOADDATE FROM " \
          "DV_PROTOTYPE_DB.SRC_TEST_VLT.test_sat_book_customer_details " \
          "AS sat ORDER BY sat.BOOKING_PK;"

    table_df = context.testdata.context_table_to_df(context.table)
    result_df = DataFrame(context.testdata.general_sql_statement_to_df(sql), dtype=str)

    table_df['BOOKING_PK'] = table_df['BOOKING_PK'].str.upper()
    table_df['HASHDIFF'] = table_df['HASHDIFF'].str.upper()

    table_df.sort_values('BOOKING_PK', inplace=True)
    table_df.reset_index(drop=True, inplace=True)

    # Ignore SOURCE column
    table_df.drop(['SOURCE'], 1, inplace=True)

    if result_df.equals(table_df):
        assert True
    else:
        assert False


@step("we expect the TEST_SAT_BOOK_BOOKING_DETAILS table to contain")
def step_impl(context):

    sql = "SELECT CAST(CUSTOMER_PK AS VARCHAR(32)) AS CUSTOMER_PK, " \
          "CAST(HASHDIFF AS VARCHAR(32)) AS HASHDIFF, " \
          "PHONE, NATIONALITY, EFFECTIVE_FROM, LOADDATE FROM " \
          "DV_PROTOTYPE_DB.SRC_TEST_VLT.test_sat_book_booking_details " \
          "AS sat ORDER BY sat.CUSTOMER_PK;"

    table_df = context.testdata.context_table_to_df(context.table)
    result_df = DataFrame(context.testdata.general_sql_statement_to_df(sql), dtype=str)

    table_df['CUSTOMER_PK'] = table_df['CUSTOMER_PK'].str.upper()
    table_df['HASHDIFF'] = table_df['HASHDIFF'].str.upper()

    # Ignore SOURCE column
    table_df.drop(['SOURCE'], 1, inplace=True)

    table_df.sort_values('CUSTOMER_PK', inplace=True)
    table_df.reset_index(drop=True, inplace=True)

    if result_df.equals(table_df):
        assert True
    else:
        assert False
