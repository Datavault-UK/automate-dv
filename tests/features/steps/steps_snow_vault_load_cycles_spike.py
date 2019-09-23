import os

from behave import *

from definitions import DBT_ROOT

use_step_matcher("parse")


# ============ Extra Load steps ================


@step("the TEST_SAT_CUST_CUSTOMER table is empty")
def step_impl(context):
    os.chdir(DBT_ROOT)

    os.system("dbt run --full-refresh --models +test_sat_cust_customer_details+")


@step('the TEST_SAT_CUST_CUSTOMER is loaded for day {day_number}')
def step_impl(context, day_number):
    os.chdir(DBT_ROOT)

    os.system("dbt run --models +test_sat_cust_customer_details")