from unittest import TestCase

from tests.unit.dbt_test_utils import DBTTestUtils


class TestAliasMacro(TestCase):

    @classmethod
    def setUpClass(cls) -> None:

        cls.dbt_test = DBTTestUtils()

    def setUp(self) -> None:

        self.dbt_test.clean_target()

    def test_alias_single_correctly_generates_SQL(self):

        model = 'test_alias_single'

        column = {"source_column": "CUSTOMER_HASHDIFF", "alias": "HASHDIFF"}

        var_dict = {'source_column': column, 'prefix': 'c'}

        process_logs = self.dbt_test.run_model(model=model, model_vars=var_dict)

        self.assertIn('Done', process_logs)

        actual_sql = self.dbt_test.retrieve_compiled_model(model)

        expected_sql = 'c.CUSTOMER_HASHDIFF AS HASHDIFF'

        self.assertEqual(actual_sql, expected_sql)

    # def test_alias_single_with_incorrect_column_format_in_metadata_raises_error(self):
    #
    #     model = 'test_alias_single'
    #
    #     var_dict = {'source_column': {}, 'prefix': 'c'}
    #
    #     command = f"dbt compile --models {model} --vars '{var_dict}'"
    #
    #     process = subprocess.Popen(command, shell=True, universal_newlines=True,
    #                                stdout=subprocess.PIPE,
    #                                stderr=subprocess.STDOUT)
    #
    #     process.wait()
    #
    #     with process.stdout:
    #
    #         with self.assertLogs(logger=self.logger, level=logging.INFO) as cm:
    #             self.log_process_output(process.stdout)
    #
    #             output = "\n".join(cm.output)
    #
    #             self.assertIn(model, output)
    #
    #             self.assertIn('Invalid alias configuration:',
    #                           output)
    #
    # def test_alias_single_with_missing_column_metadata_raises_error(self):
    #
    #     model = 'test_alias_single'
    #
    #     var_dict = {'source_column': '', 'prefix': 'c'}
    #
    #     command = f"dbt compile --models {model} --vars '{var_dict}'"
    #
    #     process = subprocess.Popen(command, shell=True,
    #                                universal_newlines=True,
    #                                stdout=subprocess.PIPE,
    #                                stderr=subprocess.STDOUT)
    #
    #     process.wait()
    #
    #     with process.stdout:
    #
    #         with self.assertLogs(logger=self.logger, level=logging.INFO) as cm:
    #             self.log_process_output(process.stdout)
    #
    #             output = "\n".join(cm.output)
    #
    #             self.assertIn(model, output)
    #
    #             self.assertIn('Invalid alias configuration:',
    #                           "\n".join(cm.output))
    #
    # def test_alias_all_correctly_generates_SQL_for_full_alias_list_with_prefix(self):
    #
    #     model = 'test_alias_all'
    #
    #     columns = [{"source_column": "CUSTOMER_HASHDIFF", "alias": "HASHDIFF"},
    #                {"source_column": "ORDER_HASHDIFF", "alias": "HASHDIFF"},
    #                {"source_column": "BOOKING_HASHDIFF", "alias": "HASHDIFF"}]
    #
    #     var_dict = {'columns': columns, 'prefix': 'c'}
    #
    #     command = f"""dbt compile --models {model} --vars "{var_dict}" """
    #
    #     process = subprocess.Popen(command,
    #                                shell=True,
    #                                universal_newlines=True,
    #                                stdout=subprocess.PIPE,
    #                                stderr=subprocess.PIPE)
    #
    #     process.wait()
    #
    #     with process.stdout:
    #
    #         with self.assertLogs(logger=self.logger, level=logging.INFO) as cm:
    #             self.log_process_output(process.stdout)
    #
    #         output = "\n".join(cm.output)
    #
    #         self.assertIn('Done.', output)
    #
    #     with open(self.compiled_model_path / f'{model}.sql') as f:
    #
    #         expected_sql = 'c.CUSTOMER_HASHDIFF AS HASHDIFF, ' \
    #                        'c.ORDER_HASHDIFF AS HASHDIFF, ' \
    #                        'c.BOOKING_HASHDIFF AS HASHDIFF'
    #
    #         self.assertEqual(expected_sql, f.readline())
    #
    # def test_alias_all_correctly_generates_SQL_for_partial_alias_list_with_prefix(self):
    #
    #     model = 'test_alias_all'
    #
    #     columns = [{"source_column": "CUSTOMER_HASHDIFF", "alias": "HASHDIFF"},
    #                "ORDER_HASHDIFF",
    #                {"source_column": "BOOKING_HASHDIFF", "alias": "HASHDIFF"}]
    #
    #     var_dict = {'columns': columns, 'prefix': 'c'}
    #
    #     command = f"""dbt compile --models {model} --vars "{var_dict}" """
    #
    #     process = subprocess.Popen(command,
    #                                shell=True,
    #                                universal_newlines=True,
    #                                stdout=subprocess.PIPE,
    #                                stderr=subprocess.PIPE)
    #
    #     process.wait()
    #
    #     with process.stdout:
    #
    #         with self.assertLogs(logger=self.logger, level=logging.INFO) as cm:
    #             self.log_process_output(process.stdout)
    #
    #         output = "\n".join(cm.output)
    #
    #         self.assertIn('Done.', output)
    #
    #     with open(self.compiled_model_path / f'{model}.sql') as f:
    #
    #         expected_sql = 'c.CUSTOMER_HASHDIFF AS HASHDIFF, ' \
    #                        'c.ORDER_HASHDIFF, ' \
    #                        'c.BOOKING_HASHDIFF AS HASHDIFF'
    #
    #         self.assertEqual(expected_sql, f.readline())
    #
    # def test_alias_all_correctly_generates_SQL_for_full_alias_list_without_prefix(self):
    #
    #     model = 'test_alias_all_without_prefix'
    #
    #     columns = [{"source_column": "CUSTOMER_HASHDIFF", "alias": "HASHDIFF"},
    #                {"source_column": "ORDER_HASHDIFF", "alias": "HASHDIFF"},
    #                {"source_column": "BOOKING_HASHDIFF", "alias": "HASHDIFF"}]
    #
    #     var_dict = {'columns': columns}
    #
    #     command = f"""dbt compile --models {model} --vars "{var_dict}" """
    #
    #     process = subprocess.Popen(command,
    #                                shell=True,
    #                                universal_newlines=True,
    #                                stdout=subprocess.PIPE,
    #                                stderr=subprocess.PIPE)
    #
    #     process.wait()
    #
    #     with process.stdout:
    #
    #         with self.assertLogs(logger=self.logger, level=logging.INFO) as cm:
    #             self.log_process_output(process.stdout)
    #
    #         output = "\n".join(cm.output)
    #
    #         self.assertIn('Done.', output)
    #
    #     with open(self.compiled_model_path / f'{model}.sql') as f:
    #
    #         expected_sql = 'CUSTOMER_HASHDIFF AS HASHDIFF, ' \
    #                        'ORDER_HASHDIFF AS HASHDIFF, ' \
    #                        'BOOKING_HASHDIFF AS HASHDIFF'
    #
    #         self.assertEqual(expected_sql, f.readline())
    #
    # def test_alias_all_correctly_generates_SQL_for_partial_alias_list_without_prefix(self):
    #
    #     model = 'test_alias_all_without_prefix'
    #
    #     columns = [{"source_column": "CUSTOMER_HASHDIFF", "alias": "HASHDIFF"},
    #                "ORDER_HASHDIFF",
    #                {"source_column": "BOOKING_HASHDIFF", "alias": "HASHDIFF"}]
    #
    #     var_dict = {'columns': columns}
    #
    #     command = f"""dbt compile --models {model} --vars "{var_dict}" """
    #
    #     process = subprocess.Popen(command,
    #                                shell=True,
    #                                universal_newlines=True,
    #                                stdout=subprocess.PIPE,
    #                                stderr=subprocess.PIPE)
    #
    #     process.wait()
    #
    #     with process.stdout:
    #
    #         with self.assertLogs(logger=self.logger, level=logging.INFO) as cm:
    #             self.log_process_output(process.stdout)
    #
    #         output = "\n".join(cm.output)
    #
    #         self.assertIn('Done.', output)
    #
    #     with open(self.compiled_model_path / f'{model}.sql') as f:
    #
    #         expected_sql = 'CUSTOMER_HASHDIFF AS HASHDIFF, ' \
    #                        'ORDER_HASHDIFF, ' \
    #                        'BOOKING_HASHDIFF AS HASHDIFF'
    #
    #         self.assertEqual(expected_sql, f.readline())
