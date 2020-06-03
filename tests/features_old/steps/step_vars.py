import os
DATABASE = os.getenv('SNOWFLAKE_DB_DATABASE')
STG_SCHEMA = "TEST_STG"
VLT_SCHEMA = "TEST_VLT"
MODE = os.environ.get('MODE', 'current')
