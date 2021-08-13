import pytest

import dbtvault_harness_utils

macro_name = "hash_columns"


def pytest_configure():
    pytest.metadata_dict = dict()


@pytest.mark.macro
def test_hash_columns_correctly_generates_hashed_columns_for_single_columns(request):
    var_dict = {
        "columns": {
            "BOOKING_PK": "BOOKING_REF",
            "CUSTOMER_PK": "CUSTOMER_ID",
            "CUSTOMER_BOOKING_PK": [
                "CUSTOMER_ID",
                "BOOKING_REF"
            ],
            "BOOK_CUSTOMER_HASHDIFF": {
                "is_hashdiff": True,
                "columns": [
                    "PHONE",
                    "NATIONALITY",
                    "CUSTOMER_ID"
                ]
            },
            "BOOK_BOOKING_HASHDIFF": {
                "is_hashdiff": True,
                "columns": [
                    "BOOKING_REF",
                    "BOOKING_DATE",
                    "DEPARTURE_DATE"
                    "PRICE",
                    "DESTINATION"
                ]
            }
        }
    }

    dbt_logs = dbtvault_harness_utils.run_dbt_models(model_names=[request.node.name],
                                                     args=var_dict)

    actual_sql = dbtvault_harness_utils.retrieve_compiled_model(request.node.name)
    expected_sql = dbtvault_harness_utils.retrieve_expected_sql(request)

    assert dbtvault_harness_utils.is_successful_run(dbt_logs)
    assert expected_sql == actual_sql
#
#     def test_hash_columns_correctly_generates_hashed_columns_for_composite_columns_hashdiff(self):
#
#         process_logs = self.dbt_test_utils.run_dbt_models(model_names=[self.current_test_name])
#         actual_sql = self.dbt_test_utils.retrieve_compiled_model(self.current_test_name)
#         expected_sql = self.dbt_test_utils.retrieve_expected_sql(self.current_test_name)
#
#         assert 'Done' in process_logs
#         assert 'SQL compilation error' not in process_logs
#         self.assertEqual(expected_sql, actual_sql)
#
#     def test_hash_columns_correctly_generates_hashed_columns_for_composite_columns_non_hashdiff(self):
#
#         process_logs = self.dbt_test_utils.run_dbt_models(model_names=[self.current_test_name])
#         actual_sql = self.dbt_test_utils.retrieve_compiled_model(self.current_test_name)
#         expected_sql = self.dbt_test_utils.retrieve_expected_sql(self.current_test_name)
#
#         assert 'Done' in process_logs
#         assert 'SQL compilation error' not in process_logs
#         self.assertEqual(expected_sql, actual_sql)
#
#     def test_hash_columns_correctly_generates_hashed_columns_for_multiple_composite_columns_hashdiff(self):
#
#         process_logs = self.dbt_test_utils.run_dbt_models(model_names=[self.current_test_name])
#         actual_sql = self.dbt_test_utils.retrieve_compiled_model(self.current_test_name)
#         expected_sql = self.dbt_test_utils.retrieve_expected_sql(self.current_test_name)
#
#         assert 'Done' in process_logs
#         assert 'SQL compilation error' not in process_logs
#         self.assertEqual(expected_sql, actual_sql)
#
#     def test_hash_columns_correctly_generates_unsorted_hashed_columns_for_composite_columns_mapping(self):
#
#         process_logs = self.dbt_test_utils.run_dbt_models(model_names=[self.current_test_name])
#         actual_sql = self.dbt_test_utils.retrieve_compiled_model(self.current_test_name)
#         expected_sql = self.dbt_test_utils.retrieve_expected_sql(self.current_test_name)
#
#         assert 'Done' in process_logs
#         assert 'SQL compilation error' not in process_logs
#         self.assertEqual(expected_sql, actual_sql)
#
#     def test_hash_columns_correctly_generates_sql_from_yaml(self):
#         process_logs = self.dbt_test_utils.run_dbt_models(model_names=[self.current_test_name])
#         expected_sql = self.dbt_test_utils.retrieve_expected_sql(self.current_test_name)
#         actual_sql = self.dbt_test_utils.retrieve_compiled_model(self.current_test_name)
#
#         assert 'Done' in process_logs
#         assert 'SQL compilation error' not in process_logs
#         self.assertEqual(expected_sql, actual_sql)
#
#     def test_hash_columns_correctly_generates_sql_with_constants_from_yaml(self):
#         process_logs = self.dbt_test_utils.run_dbt_models(model_names=[self.current_test_name])
#         expected_sql = self.dbt_test_utils.retrieve_expected_sql(self.current_test_name)
#         actual_sql = self.dbt_test_utils.retrieve_compiled_model(self.current_test_name)
#
#         assert 'Done' in process_logs
#         assert 'SQL compilation error' not in process_logs
#         self.assertEqual(expected_sql, actual_sql)
#
#     def test_hash_columns_raises_warning_if_mapping_without_hashdiff(self):
#         process_logs = self.dbt_test_utils.run_dbt_models(model_names=[self.current_test_name])
#         expected_sql = self.dbt_test_utils.retrieve_expected_sql(self.current_test_name)
#         actual_sql = self.dbt_test_utils.retrieve_compiled_model(self.current_test_name)
#         warning_message = "You provided a list of columns under a 'columns' key, " \
#                           "but did not provide the 'is_hashdiff' flag. Use list syntax for PKs."
#
#         assert warning_message in process_logs
#         self.assertEqual(expected_sql, actual_sql)
