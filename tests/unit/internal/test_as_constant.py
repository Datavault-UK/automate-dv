from tests.utils.dbt_test_utils import *

macro_folder = 'internal'
dbt_test = DBTTestUtils(model_directory=f'{macro_folder}/as_constant')
os.chdir(TESTS_DBT_ROOT)


def setup_function():
    dbt_test.clean_target()


def test_as_constant_single_correctly_generates_string():
    model = 'test_as_constant'
    expected_file_name = 'test_as_constant_single_correctly_generates_string'

    var_dict = {'column_str': '!STG_BOOKING'}
    process_logs = dbt_test.run_dbt_model(model=model, model_vars=var_dict)
    actual_sql = dbt_test.retrieve_compiled_model(model)
    expected_sql = dbt_test.retrieve_expected_sql(expected_file_name)

    assert 'Done' in process_logs
    assert actual_sql == expected_sql
