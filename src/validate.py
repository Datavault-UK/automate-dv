#!/usr/bin/env python
import snowflake.connector
import json

with open("./configs/credentials.json", "r") as read_file:
    credentials = json.load(read_file)

# Gets the version
ctx = snowflake.connector.connect(user=credentials["user"],
                                  password=credentials["password"],
                                  account=credentials["account_name"])
cs = ctx.cursor()
try:
    cs.execute("SELECT current_version()")
    one_row = cs.fetchone()
    print(one_row[0])
finally:
    cs.close()
ctx.close()
