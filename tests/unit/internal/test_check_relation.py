from unittest import TestCase

from tests.utils.dbt_test_utils import *


class TestCheckRelation(TestCase):

    @classmethod
    def setUpClass(cls) -> None:

        macro_type = 'internal'

        cls.dbt_test = DBTTestUtils(model_directory=f'{macro_type}/check_relation')

        os.chdir(TESTS_DBT_ROOT)

    def setUp(self) -> None:

        self.dbt_test.clean_target()

    def test_check_relation_returns_true_for_ref(self):

        model = 'test_check_relation_returns_true_for_ref'

        process_logs = self.dbt_test.run_dbt_model(model=model)

        self.assertIn('True', process_logs)
        self.assertIn('Done', process_logs)

    def test_check_relation_returns_true_for_source(self):

        model = 'test_check_relation_returns_true_for_source'

        process_logs = self.dbt_test.run_dbt_model(model=model)

        self.assertIn('True', process_logs)
        self.assertIn('Done', process_logs)

    def test_check_relation_returns_false_for_non_relation(self):

        model = 'test_check_relation_returns_false_for_non_relation'

        process_logs = self.dbt_test.run_dbt_model(model=model)

        self.assertIn('False', process_logs)
        self.assertIn('Done', process_logs)
