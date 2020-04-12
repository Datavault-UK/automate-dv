import os
from unittest import TestCase

from tests.unit.dbt_test_utils import *


class TestStageMacro(TestCase):

    @classmethod
    def setUpClass(cls) -> None:

        macro_type = 'staging'

        cls.dbt_test = DBTTestUtils(model_directory=f'{macro_type}/stage')

        os.chdir(TESTS_DBT_ROOT)

    def setUp(self) -> None:

        self.dbt_test.clean_target()

    # STAGE

    def test_stage_correctly_generates_SQL(self):

        self.fail()
