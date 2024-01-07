import pytest

import test
import os

from test import dbt_runner, macro_test_helpers
from dbt.cli.main import dbtRunner

macro_name = "expand_column_list"

os.chdir(test.TEST_PROJECT_ROOT)
dbt_init = dbtRunner()


@pytest.mark.macro
def test_expand_column_list_correctly_generates_list_with_nesting(request, generate_model):
    var_dict = {'columns': ['CUSTOMER_PK', ['ORDER_FK', 'BOOKING_FK']]}

    generate_model()

    dbt_logs = dbt_runner.run_dbt_models(model_names=[request.node.name],
                                         args=var_dict)

    actual_sql = macro_test_helpers.retrieve_compiled_model(request.node.name)
    expected_sql = macro_test_helpers.retrieve_expected_sql(request)

    assert dbt_logs
    assert actual_sql == expected_sql


@pytest.mark.macro
def test_expand_column_list_correctly_generates_list_with_extra_nesting(request, generate_model):
    var_dict = {'columns': ['CUSTOMER_PK', ['ORDER_FK', ['BOOKING_FK', 'TEST_COLUMN']]]}

    generate_model()

    dbt_logs = dbt_runner.run_dbt_models(model_names=[request.node.name],
                                         args=var_dict)

    actual_sql = macro_test_helpers.retrieve_compiled_model(request.node.name)
    expected_sql = macro_test_helpers.retrieve_expected_sql(request)

    assert dbt_logs
    assert actual_sql == expected_sql


@pytest.mark.macro
def test_expand_column_list_correctly_generates_list_with_no_nesting(request, generate_model):
    var_dict = {'columns': ['CUSTOMER_PK', 'ORDER_FK', 'BOOKING_FK']}

    generate_model()

    dbt_logs = dbt_runner.run_dbt_models(model_names=[request.node.name],
                                         args=var_dict)

    actual_sql = macro_test_helpers.retrieve_compiled_model(request.node.name)
    expected_sql = macro_test_helpers.retrieve_expected_sql(request)

    assert dbt_logs
    assert actual_sql == expected_sql
