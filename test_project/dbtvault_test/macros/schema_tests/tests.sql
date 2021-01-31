{%- macro test_assert_data_equal_to_expected(model, unique_id, compare_columns, expected_seed) -%}

{%- set source_columns = adapter.get_columns_in_relation(model) -%}
{%- set source_columns_list = [] -%}
{%- set compare_columns_processed = [] -%}
{%- set source_columns_processed = [] -%}

{%- for compare_col in compare_columns -%}

    {%- do compare_columns_processed.append("{}::VARCHAR AS {}".format(compare_col, compare_col)) -%}

{%- endfor %}

{%- for source_col in source_columns -%}

    {%- do source_columns_list.append(source_col.column) -%}
    {%- do source_columns_processed.append("{}::VARCHAR AS {}".format(source_col.column, source_col.column)) -%}
{%- endfor %}

{%- set compare_columns_string = compare_columns_processed | sort | join(", ") -%}
{%- set source_columns_string = source_columns_processed | sort | join(", ") -%}

WITH actual_data as (
    SELECT * FROM {{ model }}
),
expected_data as (
    SELECT * FROM {{ ref(expected_seed) }}
),
compare_order_actual_data as (
    SELECT {{ source_columns_string }}
    FROM actual_data
    ORDER BY {{ source_columns_list | sort | join(", ") }}
),
compare_order_expected_data as (
    SELECT {{ compare_columns_string }}
    FROM expected_data
    ORDER BY {{ compare_columns | sort | join(", ") }}
),
compare as (
    SELECT * FROM compare_order_expected_data
    EXCEPT
    SELECT * FROM compare_order_actual_data
)
-- For manual debugging
// SELECT * FROM compare_order_expected_data
// SELECT * FROM compare_order_actual_data
// SELECT * FROM compare
SELECT COUNT(*) AS differences FROM compare
{%- endmacro -%}