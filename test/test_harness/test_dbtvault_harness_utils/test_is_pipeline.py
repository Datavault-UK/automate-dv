import os
from unittest.mock import patch

from env import env_utils


@patch.dict(os.environ, {'PIPELINE_JOB': 'test_job', 'PIPELINE_BRANCH': 'test'}, clear=True)
def test_is_pipeline_true():
    assert env_utils.is_pipeline()


@patch.dict(os.environ, {'PIPELINE_JOB': '0'}, clear=True)
def test_is_pipeline_false_some_environment():
    assert not env_utils.is_pipeline()


def test_is_pipeline_false_no_environment():
    assert not env_utils.is_pipeline()
