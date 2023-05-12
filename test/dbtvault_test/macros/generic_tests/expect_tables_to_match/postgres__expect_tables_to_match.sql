/*
 *  Copyright (c) Business Thinking Ltd. 2019-2022
 *  This software includes code developed by the dbtvault Team at Business Thinking Ltd. Trading as Datavault
 */

{# Same as default except we do not use escaping #}
{%- macro postgres__test_expect_tables_to_match(model, unique_id, compare_columns, expected_seed) -%}

{%- set source_columns = adapter.get_columns_in_relation(model) -%}
{%- set expected_columns = adapter.get_columns_in_relation(ref(expected_seed)) -%}
{%- set source_columns_list = [] -%}
{%- set compare_columns_processed = [] -%}
{%- set columns_processed = [] -%}
{%- set source_columns_processed = [] -%}
{%- set bytea_columns = [] -%}

{%- for expected_col in expected_columns -%}
    {%- if expected_col.column|lower|string in compare_columns|map('lower')|list|string -%}
        {%- if expected_col.dtype == 'bytea' -%}
            {%- do bytea_columns.append(expected_col.column|lower) -%}
        {%- endif -%}
    {%- endif -%}
{%- endfor -%}

{%- for compare_col in compare_columns | sort -%}
    {%- do compare_columns_processed.append("{}::VARCHAR AS {}".format(compare_col, compare_col)) -%}
    {%- do columns_processed.append(compare_col) -%}
{%- endfor %}

{%- set source_column_names = [] -%}
{%- for source_col in source_columns -%}
    {%- do source_column_names.append(source_col.column) -%}
{%- endfor -%}

{%- for source_col in source_column_names | sort -%}
    {%- if source_col|string not in bytea_columns -%}
        {%- do source_columns_list.append(source_col) -%}
        {%- do source_columns_processed.append("{}::VARCHAR AS {}".format(source_col, source_col)) -%}
    {%- elif source_col|string in bytea_columns -%}
        {%- do source_columns_list.append(source_col) -%}
        {%- do source_columns_processed.append("(UPPER(ENCODE({}, 'hex'))::BYTEA)::VARCHAR AS {}".format(source_col, source_col)) -%}
    {%- else -%}
        {%- do source_columns_list.append(source_col) -%}
        {%- do source_columns_processed.append("{}::VARCHAR AS {}".format(source_col, source_col)) -%}
    {%- endif -%}
{%- endfor %}

{%- set compare_columns_string = compare_columns_processed | join(", ") -%}
{%- set source_columns_string = source_columns_processed | join(", ") -%}

{# Unquote the columns  string list #}
{#{%- set columns_string = columns_processed | join(", ") -%}#}
{%- set columns_string = columns_processed | join(", ") -%}


{# POSTGRES#}
{# unique_id usage must be quoted #}
{%  set unique_id_quoted = dbtvault.escape_column_name(unique_id) %}

WITH actual_data AS (
    SELECT * FROM {{ model }}
),
expected_data AS (
    SELECT * FROM {{ ref(expected_seed) }}
),
order_actual_data AS (
    SELECT {{ source_columns_string }}
    FROM actual_data
    ORDER BY {{ source_columns_list | sort | join(", ") }}
),
order_expected_data AS (
    SELECT {{ compare_columns_string }}
    FROM expected_data
    ORDER BY {{ compare_columns | sort | join(", ") }}
),
compare_e_to_a AS (
    SELECT * FROM order_expected_data
    EXCEPT
    SELECT * FROM order_actual_data
),
compare_a_to_e AS (
    SELECT * FROM order_actual_data
    EXCEPT
    SELECT * FROM order_expected_data
),
duplicates_actual AS (
    SELECT {{ columns_string }}, COUNT(*) AS COUNT
    FROM order_actual_data
    GROUP BY {{ columns_string }}
    HAVING COUNT(*) > 1
),
duplicates_expected AS (
    SELECT {{ columns_string }}, COUNT(*) AS COUNT
    FROM order_expected_data
    GROUP BY {{ columns_string }}
    HAVING COUNT(*) > 1
),
duplicates_not_in_actual AS (
    SELECT {{ columns_string }}
    FROM duplicates_expected
    WHERE {{ unique_id }} NOT IN (SELECT {{ unique_id }} FROM duplicates_actual)
),
duplicates_not_in_expected AS (
    SELECT {{ columns_string }}
    FROM duplicates_actual
    WHERE {{ unique_id }} NOT IN (SELECT {{ unique_id }} FROM duplicates_expected)
),
compare AS (
    SELECT {{ columns_string }},
           'E_TO_A' AS "ERROR_SOURCE",
           'EXPECTED RECORD NOT IN ACTUAL' AS "MESSAGE"
    FROM compare_e_to_a
    UNION ALL
    SELECT {{ columns_string }},
           'A_TO_E' AS "ERROR_SOURCE",
           'ACTUAL RECORD NOT IN EXPECTED' AS "MESSAGE"
    FROM compare_a_to_e
    UNION ALL
    SELECT {{ columns_string }},
           'DUPES_NOT_IN_A' AS "ERROR_SOURCE",
           'DUPLICATE RECORDS WE DID EXPECT BUT ARE NOT PRESENT IN ACTUAL' AS "MESSAGE"
    FROM duplicates_not_in_actual
    UNION ALL
    SELECT {{ columns_string }},
           'DUPES_NOT_IN_E' AS "ERROR_SOURCE",
           'DUPLICATE RECORDS WE DID NOT EXPECT AND ARE PRESENT IN ACTUAL' AS "MESSAGE"
    FROM duplicates_not_in_expected
)

-- For manual debugging
-- SELECT * FROM order_actual_data
-- SELECT * FROM order_expected_data
-- SELECT * FROM compare_e_to_a
-- SELECT * FROM compare_a_to_e
-- SELECT * FROM duplicates_actual
-- SELECT * FROM duplicates_expected
-- SELECT * FROM duplicates_not_in_actual
-- SELECT * FROM duplicates_not_in_expected
-- SELECT * FROM compare

SELECT * FROM compare
{%- endmacro -%}
