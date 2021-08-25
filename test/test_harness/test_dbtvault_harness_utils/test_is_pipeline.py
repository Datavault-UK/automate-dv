import os
from unittest.mock import patch

import dbtvault_harness_utils


@patch.dict(os.environ, {'CIRCLE_NODE_INDEX': '0', 'CIRCLE_JOB': 'test_job', 'CIRCLE_BRANCH': 'test'})
def test_is_pipeline_true():
    assert dbtvault_harness_utils.is_pipeline()


@patch.dict(os.environ, {'CIRCLE_NODE_INDEX': '0'})
def test_is_pipeline_false_some_environment():
    assert not dbtvault_harness_utils.is_pipeline()


def test_is_pipeline_false_no_environment():
    assert not dbtvault_harness_utils.is_pipeline()
