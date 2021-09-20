import os
from unittest.mock import patch

from test import dbtvault_harness_utils


@patch.dict(os.environ, {'PIPELINE_NODE_INDEX': '0', 'PIPELINE_JOB': 'test_job', 'PIPELINE_BRANCH': 'test'})
def test_is_pipeline_true():
    assert dbtvault_harness_utils.is_pipeline()


@patch.dict(os.environ, {'PIPELINE_NODE_INDEX': '0'})
def test_is_pipeline_false_some_environment():
    assert not dbtvault_harness_utils.is_pipeline()


def test_is_pipeline_false_no_environment():
    assert not dbtvault_harness_utils.is_pipeline()
