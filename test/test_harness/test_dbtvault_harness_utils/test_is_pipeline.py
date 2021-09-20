import os
from unittest.mock import patch

from test import dbtvault_harness_utils


@patch.dict(os.environ, {'PIPELINE_JOB': 'test_job', 'PIPELINE_BRANCH': 'test'}, clear=True)
def test_is_pipeline_true():
    assert dbtvault_harness_utils.is_pipeline()


@patch.dict(os.environ, {'PIPELINE_JOB': '0'}, clear=True)
def test_is_pipeline_false_some_environment():
    assert not dbtvault_harness_utils.is_pipeline()


def test_is_pipeline_false_no_environment():
    assert not dbtvault_harness_utils.is_pipeline()
