import json
import os
from datetime import date, timedelta

from definitions import TESTS_ROOT, DBT_ROOT
from perftest.TestData import TestData


def write_results(results_dict):
    """
    Write out the results dict to json
    :param results_dict: Results
    :type results_dict: dict
    """

    # Write out results to a json file
    filename = DBT_ROOT / 'perftest/output/performance.json'
    os.makedirs(os.path.dirname(filename), exist_ok=True)
    with open(filename, 'w') as f:
        json.dump(results_dict, f, indent=4)


def read_results():
    """
    Get the results file output by dbt and return
    """
    json_file = open(DBT_ROOT / 'target/run_results.json')
    json_data = json.loads(json_file.read())

    return json_data['results']


td = TestData("{}/features/helpers/credentials.json".format(TESTS_ROOT))

# Configure dates

start_date = date(1992, 1, 8)
end_date = date(1992, 1, 12)
delta = end_date - start_date
date_range = [(start_date + timedelta(days=d)).isoformat() for d in range(delta.days + 1)]

# Metadata

model_names = ["hub_customer_p", 'link_customer_nation_p', 'sat_customer_details_p', 'sat_order_customer_details_p',
               'sat_order_orders_details_p']

source_system = "SF10"

db = "SNOWFLAKE_SAMPLE_DATA"
schema = 'TPCH_{}'.format(source_system)
table = 'ORDERS'
date_col = 'O_ORDERDATE'
key = "O_CUSTKEY"

# Configure output dict

results = dict()

results['db'] = db
results['schema'] = schema
results['table'] = table
results['start'] = str(start_date)
results['end'] = str(end_date)

for model in model_names:
    results[model] = dict()
    for dt in range(0, len(date_range)):
        results[model]["Load_" + str(dt + 1)] = dict()

# SQL templates

unique_for_ldts = "SELECT COUNT(DISTINCT {}) AS COUNT " \
                  "FROM {}.{}.{} " \
                  "WHERE {} " \
                  "between TO_DATE('{}') and TO_DATE('{}')"

join_distinct_count_today = "SELECT COUNT(DISTINCT b.{key}) AS COUNT " \
                            "FROM {db}.{schema}.{table} as b " \
                            "LEFT JOIN {db}.{schema}.LINEITEM as a " \
                            "ON a.L_ORDERKEY = b.O_ORDERKEY " \
                            "WHERE b.O_ORDERDATE = TO_DATE('{day}') " \
                            "OR a.L_SHIPDATE = TO_DATE('{day}') " \
                            "OR a.L_COMMITDATE = TO_DATE('{day}') " \
                            "OR a.L_RECEIPTDATE = TO_DATE('{day}')"

join_total_count_since_start = "SELECT COUNT(*) AS COUNT " \
                               "FROM {db}.{schema}.{table} as b " \
                               "LEFT JOIN {db}.{schema}.LINEITEM as a " \
                               "ON a.L_ORDERKEY = b.O_ORDERKEY " \
                               "WHERE b.O_ORDERDATE BETWEEN TO_DATE('{start}') AND TO_DATE('{day}') " \
                               "OR a.L_SHIPDATE BETWEEN TO_DATE('{start}') AND TO_DATE('{day}') " \
                               "OR a.L_COMMITDATE BETWEEN TO_DATE('{start}') AND TO_DATE('{day}') " \
                               "OR a.L_RECEIPTDATE BETWEEN TO_DATE('{start}') AND TO_DATE('{day}')"

join_distinct_count_since_start = "SELECT COUNT(DISTINCT b.{key}) AS COUNT " \
                                  "FROM {db}.{schema}.{table} as b " \
                                  "LEFT JOIN {db}.{schema}.LINEITEM as a " \
                                  "ON a.L_ORDERKEY = b.O_ORDERKEY " \
                                  "WHERE b.O_ORDERDATE BETWEEN TO_DATE('{start}') AND TO_DATE('{day}') " \
                                  "OR a.L_SHIPDATE BETWEEN TO_DATE('{start}') AND TO_DATE('{day}') " \
                                  "OR a.L_COMMITDATE BETWEEN TO_DATE('{start}') AND TO_DATE('{day}') " \
                                  "OR a.L_RECEIPTDATE BETWEEN TO_DATE('{start}') AND TO_DATE('{day}')"

count_source = "SELECT COUNT(*) AS COUNT FROM DV_PROTOTYPE_DB.SRC.SOURCE_SYSTEM"

count_hash = "SELECT COUNT(*) AS COUNT FROM DV_PROTOTYPE_DB.SRC_STG.V_STG_ORDERS_HASHED_P"

count_target = "SELECT COUNT(*) AS COUNT FROM DV_PROTOTYPE_DB.SRC_VLT.{}"

# Configure target tables

hub_cols = ["CUSTOMER_PK BINARY(16)", "CUSTOMER_ID NUMBER(38,0)", "LOADDATE DATE", "SOURCE VARCHAR(4)"]

link_cols = ["CUSTOMER_NATION_PK BINARY(16)", "CUSTOMER_FK BINARY(16)", "NATION_FK BINARY(16)", "LOADDATE DATE",
             "SOURCE VARCHAR(4)"]

sat_cd_cols = ["CUSTOMER_PK BINARY(16)", "HASHDIFF BINARY(16)", "NAME VARCHAR(25)", "PHONE VARCHAR(15)",
               "ADDRESS VARCHAR(40)", "EFFECTIVE_FROM DATE", "LOADDATE DATE", "SOURCE VARCHAR(4)"]

sat_oc_cols = ["CUSTOMER_PK BINARY(16)", "HASHDIFF BINARY(16)", "CUSTOMER_NATION_NAME VARCHAR(25)",
               "CUSTOMER_NAME VARCHAR(25)", "CUSTOMER_PHONE VARCHAR(15)", "CUSTOMER_ADDRESS VARCHAR(40)",
               "EFFECTIVE_FROM DATE", "LOADDATE DATE", "SOURCE VARCHAR(4)"]

sat_od_cols = ["ORDER_PK BINARY(16)", "HASHDIFF BINARY(16)", "ORDERDATE DATE", "ORDERPRIORITY VARCHAR(15)",
               "TOTALPRICE NUMBER(12,2)", "CLERK VARCHAR(15)", "ORDERSTATUS VARCHAR(1)", "LOADDATE DATE",
               "EFFECTIVE_FROM DATE", "SOURCE VARCHAR(4)"]

# Clear tables before running

td.drop_and_create("DV_PROTOTYPE_DB", "SRC_VLT", 'HUB_CUSTOMER_P', hub_cols)
td.drop_and_create("DV_PROTOTYPE_DB", "SRC_VLT", 'LINK_CUSTOMER_NATION_P', link_cols)
td.drop_and_create("DV_PROTOTYPE_DB", "SRC_VLT", 'SAT_CUSTOMER_DETAILS_P', sat_cd_cols)
td.drop_and_create("DV_PROTOTYPE_DB", "SRC_VLT", 'SAT_ORDER_CUSTOMER_DETAILS_P', sat_oc_cols)
td.drop_and_create("DV_PROTOTYPE_DB", "SRC_VLT", 'SAT_ORDER_ORDERS_DETAILS_P', sat_od_cols)

# Start load

for model_name in model_names:

    total_time = 0

    for count, day in enumerate(date_range):

        load_num = count + 1
        load_str = 'Load_' + str(load_num)

        # Drop source_system
        td.drop_table("DV_PROTOTYPE_DB", "SRC", "SOURCE_SYSTEM", materialise="table")

        # Count unique records for day from first load to current load
        sql = join_distinct_count_since_start.format(db=db, schema=schema, table=table,
                                                     key=key, start=date_range[0], day=day)
        count_uldts = int(td.general_sql_statement_to_df(sql)['COUNT'][0])
        results[model_name][load_str]['tpch_unique_records_to_date'] = count_uldts

        # Count of total records for day
        sql = join_distinct_count_today.format(db=db, schema=schema, table=table,
                                               key=key, start=date_range[0], day=day)
        current_ldts_count = int(td.general_sql_statement_to_df(sql)['COUNT'][0])
        results[model_name][load_str]['tpch_unique_records_to_load_today'] = current_ldts_count

        # Count the records which should be loaded
        sql = join_total_count_since_start.format(db=db, schema=schema, table=table,
                                                  start=date_range[0], day=day)
        to_load = int(td.general_sql_statement_to_df(sql)['COUNT'][0])
        results[model_name][load_str]['tpch_total_load_since_start'] = to_load

        # Run dbt
        os.chdir(DBT_ROOT)

        os.system('dbt run --vars "{{\\"date\\": \\"TO_DATE(\'{}\')\\", \\"src\\": \\"{}\\"}}" --models +{}'.format(day,
                                                                                                                    source_system,
                                                                                                                    model_name))
        # Get results
        run_results = read_results()

        # Add additional fields to results
        for model_results in run_results:

            if model_results['node']['name'] == model_name:
                time_taken = round(model_results['execution_time'], 2)
                results[model_name][load_str]['time_taken'] = time_taken
                total_time += model_results['execution_time']
                status = model_results['status'].split(" ")
                if status[0] == "SUCCESS":
                    results[model_name][load_str]['dbt_records_loaded_today'] = int(status[1])

        # Count records in source
        source_record_count = int(td.general_sql_statement_to_df(count_source)['COUNT'][0])
        results[model_name][load_str]['raw_stage_count_total'] = source_record_count

        # Count records in hashing layer
        hash_record_count = int(td.general_sql_statement_to_df(count_hash)['COUNT'][0])
        results[model_name][load_str]['hash_layer_count_total'] = hash_record_count

        # Count records in target
        sql = count_target.format(model_name)
        target_record_count = int(td.general_sql_statement_to_df(sql)['COUNT'][0])
        results[model_name][load_str]['target_count_after_load'] = target_record_count

        write_results(results)

    results[model_name]['average_time_taken'] = round(total_time / len(date_range), 2)

    write_results(results)
