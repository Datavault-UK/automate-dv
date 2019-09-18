from behave import *
import os
from definitions import DBT_ROOT

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


# ================ Data inserts =================


@when('the TEST_STG_CUSTOMER table has data inserted into it for day {day_number}')
def step_impl(context, day_number):
    context.testdata.create_schema("DV_PROTOTYPE_DB", "SRC_TEST_STG")
    context.testdata.drop_and_create("DV_PROTOTYPE_DB", "SRC_TEST_STG", "test_stg_customer",
                                     ["CUSTOMER_ID VARCHAR(38)", "CUSTOMER_NAME VARCHAR(60)", "CUSTOMER_DOB DATE",
                                      "LOAD_DATE DATE", "EFFECTIVE_FROM DATE"], materialise="table")

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
    """
    :type context: behave.runner.Context
    """
    raise NotImplementedError(
        u'STEP: Then we expect the TEST_HUB_CUSTOMER table to contain | CUSTOMER_PK | CUSTOMER_ID | SOURCE | '
        u'LOAD_DATE | | md5(\'1001\') | 1001        | *      | 04/05/2019 | | md5(\'1002\') | 1002        | *      | '
        u'04/05/2019 |')


@step("we expect the TEST_HUB_BOOKING table to contain")
def step_impl(context):
    """
    :type context: behave.runner.Context
    """
    raise NotImplementedError(
        u'STEP: And we expect the TEST_HUB_BOOKING table to contain | CUSTOMER_PK | CUSTOMER_ID | SOURCE | LOAD_DATE '
        u'| | md5(\'1001\') | 1001        | *      | 04/05/2019 | | md5(\'1002\') | 1002        | *      | 04/05/2019 '
        u'|')


@step("we expect the TEST_LINK_CUSTOMER_BOOKING table to contain")
def step_impl(context):
    """
    :type context: behave.runner.Context
    """
    raise NotImplementedError(
        u'STEP: And we expect the TEST_LINK_CUSTOMER_BOOKING table to contain | CUSTOMER_PK | CUSTOMER_ID | SOURCE | '
        u'LOAD_DATE | | md5(\'1001\') | 1001        | *      | 04/05/2019 | | md5(\'1002\') | 1002        | *      | '
        u'04/05/2019 |')


@step("we expect the TEST_SAT_CUST_CUSTOMER_DETAILS table to contain")
def step_impl(context):
    """
    :type context: behave.runner.Context
    """
    raise NotImplementedError(
        u'STEP: And we expect the TEST_SAT_CUST_CUSTOMER_DETAILS table to contain | CUSTOMER_PK | CUSTOMER_ID | '
        u'SOURCE | LOAD_DATE | | md5(\'1001\') | 1001        | *      | 04/05/2019 | | md5(\'1002\') | 1002        | '
        u'*      | 04/05/2019 |')


@step("we expect the TEST_SAT_BOOK_CUSTOMER_DETAILS table to contain")
def step_impl(context):
    """
    :type context: behave.runner.Context
    """
    raise NotImplementedError(
        u'STEP: And we expect the TEST_SAT_BOOK_CUSTOMER_DETAILS table to contain | CUSTOMER_PK | CUSTOMER_ID | '
        u'SOURCE | LOAD_DATE | | md5(\'1001\') | 1001        | *      | 04/05/2019 | | md5(\'1002\') | 1002        | '
        u'*      | 04/05/2019 |')


@step("we expect the TEST_SAT_BOOK_BOOKING_DETAILS table to contain")
def step_impl(context):
    """
    :type context: behave.runner.Context
    """
    raise NotImplementedError(
        u'STEP: And we expect the TEST_SAT_BOOK_BOOKING_DETAILS table to contain | CUSTOMER_PK | CUSTOMER_ID | SOURCE '
        u'| LOAD_DATE | | md5(\'1001\') | 1001        | *      | 04/05/2019 | | md5(\'1002\') | 1002        | *      '
        u'| 04/05/2019 |')
