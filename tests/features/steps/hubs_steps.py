from behave import *

from tests.dbt_test_utils import TESTS_DBT_ROOT

use_step_matcher("parse")


@given("the {model_name} table does not exist")
def drop_table(context, model_name):
    print(model_name)


@given("the {model_name} table contains data")
def create_csv(context, model_name):

    context.dbt_test_utils.context_table_to_df(table=context.table,
                                               context=context,
                                               model_name=model_name)
    print(model_name)


@when("I load the {model_name} table")
def step_impl(context, model_name):

    print(model_name)


@then("the {model_name} table should contain expected data")
def step_impl(context, model_name):

    context.dbt_test_utils.context_table_to_df(table=context.table,
                                               context=context,
                                               model_name=f'{model_name}_expected')
    print(model_name)
