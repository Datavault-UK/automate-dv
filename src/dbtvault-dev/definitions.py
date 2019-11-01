"""
A file containing project constants
"""

from pathlib import PurePath, Path

DBT_ROOT = PurePath(__file__).parent
PROJECT_ROOT = PurePath(__file__).parents[2]
TESTS_ROOT = "{}/tests".format(PROJECT_ROOT)
DEMO_ROOT = Path("{}/src/snowflakeDemo".format(PROJECT_ROOT))
