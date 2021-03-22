{%- macro test_assert_data_equal_to_expected(model, unique_id, compare_columns, expected_seed) -%}

{%- set source_columns = adapter.get_columns_in_relation(model) -%}
{%- set source_columns_list = [] -%}
{%- set compare_columns_processed = [] -%}
{%- set columns_processed = [] -%}
{%- set source_columns_processed = [] -%}

{%- for compare_col in compare_columns -%}

    {%- do compare_columns_processed.append("{}::VARCHAR AS {}".format(compare_col, compare_col)) -%}
    {%- do columns_processed.append(compare_col) -%}

{%- endfor %}

{%- for source_col in source_columns -%}

    {%- do source_columns_list.append(source_col.column) -%}
    {%- do source_columns_processed.append("{}::VARCHAR AS {}".format(source_col.column, source_col.column)) -%}
{%- endfor %}

{%- set compare_columns_string = compare_columns_processed | sort | join(", ") -%}
{%- set source_columns_string = compare_columns_processed | sort | join(", ") -%}
{%- set columns_string = columns_processed | sort | join(", ") -%}

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
compare AS (
    SELECT {{ columns_string }}, 'E_TO_A' AS "ERROR_SOURCE" FROM compare_e_to_a
    UNION ALL
    SELECT {{ columns_string }}, 'A_TO_E' AS "ERROR_SOURCE" FROM compare_a_to_e
    UNION ALL
    SELECT {{ columns_string }}, 'MISSING_DUPLICATE' AS "ERROR_SOURCE" FROM duplicates_not_in_actual
)

-- For manual debugging
// SELECT * FROM order_actual_data
// SELECT * FROM order_expected_data
// SELECT * FROM compare_e_to_a
// SELECT * FROM compare_a_to_e
// SELECT * FROM duplicates_actual
// SELECT * FROM duplicates_expected
// SELECT * FROM duplicates_not_in_actual
// SELECT * FROM compare

SELECT COUNT(*) AS differences FROM compare
{%- endmacro -%}