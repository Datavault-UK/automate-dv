import json
import os
from glob import  glob
from datetime import date, timedelta
from pathlib import Path
from definitions import TESTS_ROOT, DBT_ROOT, DEMO_ROOT
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
    json_file = open(DEMO_ROOT / 'target/run_results.json')
    json_data = json.loads(json_file.read())

    return json_data['results']


def get_models(path) -> list:
    """
    Get all model names, to test.
        :param path: Root path to model directory
        :return: List of path strings
    """

    return [Path(y).stem for x in os.walk(path) for y in glob(os.path.join(x[0], '*.sql'))]


td = TestData("{}/features/helpers/credentials.json".format(TESTS_ROOT))

# Configure dates

start_date = date(1992, 1, 8)
end_date = date(1992, 1, 12)
delta = end_date - start_date
date_range = [(start_date + timedelta(days=d)).isoformat() for d in range(delta.days + 1)]

# Metadata

model_path = "{}/models/load".format(DEMO_ROOT)

model_names = get_models(model_path)

#model_names = ['sat_order_lineitem']

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

count_source = "SELECT COUNT(*) AS COUNT FROM DV_PROTOTYPE_DB.DEMO_RAW.RAW_ORDERS"

count_hash_orders = "SELECT COUNT(*) AS COUNT FROM DV_PROTOTYPE_DB.DEMO_STG.V_STG_ORDERS"
count_hash_inv = "SELECT COUNT(*) AS COUNT FROM DV_PROTOTYPE_DB.DEMO_STG.V_STG_INVENTORY"

count_target = "SELECT COUNT(*) AS COUNT FROM DV_PROTOTYPE_DB.DEMO_VLT.{}"

# Clear schemas

td.drop_schema("DV_PROTOTYPE_DB", "DEMO_RAW")
td.drop_schema("DV_PROTOTYPE_DB", "DEMO_VLT")
td.drop_schema("DV_PROTOTYPE_DB", "DEMO_STG")

# Start load

for model_name in model_names:

    total_time = 0

    for count, day in enumerate(date_range):

        load_num = count + 1
        load_str = 'Load_' + str(load_num)

        # Drop source_system
        if count > 0:
            td.drop_table("DV_PROTOTYPE_DB", "DEMO_RAW", "RAW_ORDERS", materialise="view")

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
        os.chdir(DEMO_ROOT)

        dbt_command = 'dbt run --vars "{{\\"date\\": \\"TO_DATE(\'{}\')\\"}}" --models +{}'.format(day,
                                                                                                   model_name)

        os.system(dbt_command)

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
        hash_record_count_orders = int(td.general_sql_statement_to_df(count_hash_orders)['COUNT'][0])
        results[model_name][load_str]['orders_hash_layer_count_total'] = hash_record_count_orders

        # hash_record_count_inv = int(td.general_sql_statement_to_df(count_hash_inv)['COUNT'][0])
        # results[model_name][load_str]['inv_hash_layer_count_total'] = hash_record_count_inv

        # Count records in target
        sql = count_target.format(model_name)
        target_record_count = int(td.general_sql_statement_to_df(sql)['COUNT'][0])
        results[model_name][load_str]['target_count_after_load'] = target_record_count

        write_results(results)

    results[model_name]['average_time_taken'] = round(total_time / len(date_range), 2)

    write_results(results)
