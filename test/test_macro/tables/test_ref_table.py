#  Copyright (c) Business Thinking Ltd. 2019-2023
#  This software includes code developed by the AutomateDV (f.k.a dbtvault) Team at Business Thinking Ltd. Trading as Datavault

# import pytest
#
# import test
import os

from test import dbt_runner, macro_test_helpers
from dbt.cli.main import dbtRunner
#
# macro_name = "ref_table"
#
# os.chdir(test.TEST_PROJECT_ROOT)
# dbt_init = dbtRunner()
#
# @pytest.mark.single_source_ref_table
# def test_ref_table_macro_correctly_generates_sql_for_single_source(request, generate_model):
#     generate_model()
#
#     dbt_result = dbt_runner.run_dbt_models(dbt_init, mode='run',
#                                          model_names=[request.node.name],
#                                          full_refresh=True)
#
#     actual_sql = macro_test_helpers.retrieve_compiled_model(request.node.name)
#     expected_sql = macro_test_helpers.retrieve_expected_sql(request)
#
#     assert dbt_result is True
#     assert actual_sql == expected_sql
#
#
# @pytest.mark.single_source_ref_table
# def test_ref_table_macro_correctly_generates_sql_for_incremental_single_source(request, generate_model):
#     generate_model()
#     dbt_logs_first_run = dbt_runner.run_dbt_models(dbt_init, mode='run',
#                                                    model_names=[request.node.name],
#                                                    full_refresh=True)
#
#     dbt_logs_inc_run = dbt_runner.run_dbt_models(dbt_init, model_names=[request.node.name])
#     actual_sql = macro_test_helpers.retrieve_compiled_model(request.node.name)
#     expected_sql = macro_test_helpers.retrieve_expected_sql(request)
#
#     assert macro_test_helpers.is_successful_run(dbt_logs_first_run)
#     assert macro_test_helpers.is_successful_run(dbt_logs_inc_run)
#     assert actual_sql == expected_sql
