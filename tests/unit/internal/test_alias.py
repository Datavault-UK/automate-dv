import pytest


@pytest.mark.usefixtures('dbt_test_utils')
class TestAliasMacro:

    def test_alias_single_correctly_generates_sql(self):
        model = 'test_alias_single'
        var_dict = {'source_column': {"source_column": "CUSTOMER_HASHDIFF", "alias": "HASHDIFF"}, 'prefix': 'c'}

        process_logs = self.dbt_test_utils.run_dbt_model(model=model, model_vars=var_dict)
        actual_sql = self.dbt_test_utils.retrieve_compiled_model(model)
        expected_sql = self.dbt_test_utils.retrieve_expected_sql(self.current_test_name)

        assert 'Done' in process_logs
        assert expected_sql == actual_sql

    def test_alias_single_with_incorrect_column_format_in_metadata_raises_error(self):
        model = 'test_alias_single'
        var_dict = {'source_column': {}, 'prefix': 'c'}

        process_logs = self.dbt_test_utils.run_dbt_model(model=model, model_vars=var_dict)

        assert model in process_logs
        assert 'Invalid alias configuration:' in process_logs

    def test_alias_single_with_missing_column_metadata_raises_error(self):
        model = 'test_alias_single'
        var_dict = {'source_column': '', 'prefix': 'c'}

        process_logs = self.dbt_test_utils.run_dbt_model(model=model, model_vars=var_dict)

        assert model in process_logs
        assert 'Invalid alias configuration:' in process_logs

    def test_alias_single_with_undefined_column_metadata_raises_error(self):
        model = 'test_alias_single_undefined_columns'
        var_dict = {'prefix': 'c'}

        process_logs = self.dbt_test_utils.run_dbt_model(model=model, model_vars=var_dict)

        assert model in process_logs
        assert 'Invalid alias configuration:' in process_logs

    def test_alias_all_correctly_generates_sql_for_full_alias_list_with_prefix(self):
        model = 'test_alias_all'

        columns = [{"source_column": "CUSTOMER_HASHDIFF", "alias": "HASHDIFF"},
                   {"source_column": "ORDER_HASHDIFF", "alias": "HASHDIFF"},
                   {"source_column": "BOOKING_HASHDIFF", "alias": "HASHDIFF"}]
        var_dict = {'columns': columns, 'prefix': 'c'}

        process_logs = self.dbt_test_utils.run_dbt_model(model=model, model_vars=var_dict)
        expected_sql = self.dbt_test_utils.retrieve_expected_sql(self.current_test_name)
        actual_sql = self.dbt_test_utils.retrieve_compiled_model(model)

        assert 'Done.' in process_logs
        assert expected_sql == actual_sql

    def test_alias_all_correctly_generates_sql_for_partial_alias_list_with_prefix(self):
        model = 'test_alias_all'

        columns = [{"source_column": "CUSTOMER_HASHDIFF", "alias": "HASHDIFF"}, "ORDER_HASHDIFF",
                   {"source_column": "BOOKING_HASHDIFF", "alias": "HASHDIFF"}]
        var_dict = {'columns': columns, 'prefix': 'c'}

        process_logs = self.dbt_test_utils.run_dbt_model(model=model, model_vars=var_dict)
        expected_sql = self.dbt_test_utils.retrieve_expected_sql(self.current_test_name)
        actual_sql = self.dbt_test_utils.retrieve_compiled_model(model)

        assert 'Done.' in process_logs
        assert expected_sql == actual_sql

    def test_alias_all_correctly_generates_sql_for_full_alias_list_without_prefix(self):
        model = 'test_alias_all_without_prefix'

        columns = [{"source_column": "CUSTOMER_HASHDIFF", "alias": "HASHDIFF"},
                   {"source_column": "ORDER_HASHDIFF", "alias": "HASHDIFF"},
                   {"source_column": "BOOKING_HASHDIFF", "alias": "HASHDIFF"}]

        var_dict = {'columns': columns}
        process_logs = self.dbt_test_utils.run_dbt_model(model=model, model_vars=var_dict)
        expected_sql = self.dbt_test_utils.retrieve_expected_sql(self.current_test_name)
        actual_sql = self.dbt_test_utils.retrieve_compiled_model(model)

        assert 'Done.' in process_logs
        assert expected_sql == actual_sql

    def test_alias_all_correctly_generates_sql_for_partial_alias_list_without_prefix(self):
        model = 'test_alias_all_without_prefix'

        columns = [{"source_column": "CUSTOMER_HASHDIFF", "alias": "HASHDIFF"}, "ORDER_HASHDIFF",
                   {"source_column": "BOOKING_HASHDIFF", "alias": "HASHDIFF"}]
        var_dict = {'columns': columns}

        process_logs = self.dbt_test_utils.run_dbt_model(model=model, model_vars=var_dict)
        expected_sql = self.dbt_test_utils.retrieve_expected_sql(self.current_test_name)
        actual_sql = self.dbt_test_utils.retrieve_compiled_model(model)

        assert 'Done.' in process_logs
        assert expected_sql == actual_sql
