{%- macro test_assert_data_equal_to_expected(model, unique_id, compare_columns, expected_seed) -%}

{%- set compare_columns_processed = [] -%}

{%- for compare_col in compare_columns -%}

    {%- do compare_columns_processed.append("{}::VARCHAR AS {}".format(compare_col, compare_col)) -%}

{%- endfor %}

{%- set compare_columns_string = compare_columns_processed | join(", ") -%}

WITH actual_data as (
    SELECT * FROM {{ model }}
),
expected_data as (
    SELECT * FROM {{ ref(expected_seed) }}
),
compare_order_actual_data as (
    SELECT {{ compare_columns_string }}
    FROM actual_data
    ORDER BY {{ compare_columns | join(", ") }}
),
compare_order_expected_data as (
    SELECT {{ compare_columns_string }}
    FROM expected_data
    ORDER BY {{ compare_columns | join(", ") }}
),
compare as (
    SELECT * FROM compare_order_actual_data
    EXCEPT
    SELECT * FROM compare_order_expected_data
)
-- For manual debugging
// SELECT * FROM compare_order_expected_data
// SELECT * FROM compare_order_actual_data
SELECT COUNT(*) AS differences FROM compare
{%- endmacro -%}