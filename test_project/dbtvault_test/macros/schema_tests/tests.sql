{%- test assert_data_equal_to_expected(model, unique_id, compare_columns, expected_seed) -%}

{%- set source_columns = adapter.get_columns_in_relation(model) -%}

{%- set source_columns_list = [] -%}
{%- set compare_columns_processed = [] -%}
{%- set columns_processed = [] -%}
{%- set source_columns_processed = [] -%}

{%- do log(("columns " ~ source_columns), True) -%}
{%- for compare_col in compare_columns -%}
    {%- if target.type == 'bigquery' -%}
        {%- do compare_columns_processed.append("CAST({} AS STRING) AS {}".format(compare_col, compare_col)) -%}
    {%- elif target.type == 'snowflake' -%}
        {%- do compare_columns_processed.append("{}::VARCHAR AS {}".format(compare_col, compare_col)) -%}
    {%- endif -%}
    {%- do columns_processed.append(compare_col) -%}

{%- endfor %}

{%- for source_col in source_columns -%}
    {%- do source_columns_list.append(source_col.column) -%}
    {%- if target.type == 'bigquery' -%}
        {%- if source_col.data_type == 'BYTES' -%}
            {%- do log("this is bytes" ~source_col, true) -%}
            {%- do source_columns_processed.append("UPPER(TO_HEX({})) AS {}".format(source_col.name, source_col.name)) -%}
        {%- else -%}
            {%- do source_columns_processed.append("CAST({} AS STRING) AS {}".format(source_col.name, source_col.name)) -%}
        {%- endif -%}
    {%- elif target.type == 'snowflake' -%}
        {%- do source_columns_processed.append("{}::VARCHAR AS {}".format(source_col.name, source_col.name)) -%}
    {%- endif -%}
{%- endfor %}

{%- set compare_columns_string = compare_columns_processed | sort | join(", ") -%}
{%- set source_columns_string = source_columns_processed | sort | join(", ") -%}
{%- set columns_string = columns_processed | sort | join(", ") -%}

WITH actual_data AS (
    SELECT * FROM {{ model }}
),
expected_data AS (
    SELECT * FROM {{ ref(expected_seed) }}
),
order_actual_data AS (
    SELECT DISTINCT {{ source_columns_string }}
    FROM actual_data
    ORDER BY {{ source_columns_list | sort | join(", ") }}
),
order_expected_data AS (
    SELECT DISTINCT {{ compare_columns_string }}
    FROM expected_data
    ORDER BY {{ compare_columns | sort | join(", ") }}
),
compare_e_to_a AS (
    SELECT * FROM order_expected_data
    EXCEPT DISTINCT
    SELECT * FROM order_actual_data
),

compare_a_to_e AS (
    SELECT * FROM order_actual_data
    EXCEPT DISTINCT
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
)
,
compare AS (
    SELECT {{ columns_string }}, 'E_TO_A' AS ERROR_SOURCE FROM compare_e_to_a AS a
    UNION ALL
    SELECT {{ columns_string }}, 'A_TO_E' AS ERROR_SOURCE FROM compare_a_to_e AS b
    UNION ALL
    SELECT {{ columns_string }}, 'DUPES_NOT_IN_A' AS ERROR_SOURCE FROM duplicates_not_in_actual AS c
    UNION ALL
    SELECT {{ columns_string }}, 'DUPES_NOT_IN_E' AS ERROR_SOURCE FROM duplicates_not_in_expected AS d
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
{%- endtest -%}