from behave import *

use_step_matcher("re")


@given("there is an empty TEST_STG_CUSTOMER table")
def step_impl(context):
    """
    :type context: behave.runner.Context
    """
    raise NotImplementedError(u'STEP: Given there is an empty TEST_STG_CUSTOMER table')


@step("there is an empty TEST_STG_BOOKING table")
def step_impl(context):
    """
    :type context: behave.runner.Context
    """
    raise NotImplementedError(u'STEP: And there is an empty TEST_STG_BOOKING table')


@step("there is an empty TEST_HUB_BOOKING table")
def step_impl(context):
    """
    :type context: behave.runner.Context
    """
    raise NotImplementedError(u'STEP: And there is an empty TEST_HUB_BOOKING table')


@step("there is an empty TEST_LINK_CUSTOMER_BOOKING table")
def step_impl(context):
    """
    :type context: behave.runner.Context
    """
    raise NotImplementedError(u'STEP: And there is an empty TEST_LINK_CUSTOMER_BOOKING table')


@step("there is an empty TEST_SAT_CUST_CUSTOMER_DETAILS table")
def step_impl(context):
    """
    :type context: behave.runner.Context
    """
    raise NotImplementedError(u'STEP: And there is an empty TEST_SAT_CUST_CUSTOMER_DETAILS table')


@step("there is an empty TEST_SAT_BOOK_CUSTOMER_DETAILS table")
def step_impl(context):
    """
    :type context: behave.runner.Context
    """
    raise NotImplementedError(u'STEP: And there is an empty TEST_SAT_BOOK_CUSTOMER_DETAILS table')


@step("there is an empty TEST_SAT_BOOK_BOOKING_DETAILS table")
def step_impl(context):
    """
    :type context: behave.runner.Context
    """
    raise NotImplementedError(u'STEP: And there is an empty TEST_SAT_BOOK_BOOKING_DETAILS table')


@when("the TEST_STG_CUSTOMER table receives a feed for day 1")
def step_impl(context):
    """
    :type context: behave.runner.Context
    """
    raise NotImplementedError(
        u'STEP: When the TEST_STG_CUSTOMER table receives a feed for day 1 | CUSTOMER_ID | CUSTOMER_NAME | '
        u'CUSTOMER_DOB | LOAD_DATE | EFFECTIVE_FROM | | 1001 | Albert | 01 / 01 / 2000 | 2019 - 05 - 04 | 2019 - 05 - '
        u'03 | | 1002 | Beth | 03 / 04 / 2001 | 2019 - 05 - 04 | 2019 - 05 - 03 | ')


@step("the TEST_STG_BOOKING table receives a feed for day 1")
def step_impl(context):
    """
    :type context: behave.runner.Context
    """
    raise NotImplementedError(
        u'STEP: And the TEST_STG_BOOKING table receives a feed for day 1 | BOOKING_REF | CUSTOMER_ID | PRICE | '
        u'DEPARTURE_DATE | DESTINATION | PHONE | NATIONALITY | ')


@step("the vault is loaded for day 1")
def step_impl(context):
    """
    :type context: behave.runner.Context
    """
    raise NotImplementedError(u'STEP: And the vault is loaded for day 1')


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