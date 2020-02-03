import os
DATABASE = "DBT_VAULT"
STG_SCHEMA = "TEST_STG"
VLT_SCHEMA = "TEST_VLT"
MODE = os.environ.get('MODE', 'current')
