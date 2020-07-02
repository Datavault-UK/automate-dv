{%- macro test_assert_data_equal_to_expected(model, unique_id, compare_columns, expected_seed) -%}
{%- set compare_columns_cast -%}
{%- for col in compare_columns -%}
    {{ col }}::VARCHAR AS {{ col }}{% if not loop.last %}, {% endif %}
{%- endfor -%}
{%- endset -%}

WITH actual_data as (
    SELECT {{ compare_columns_cast }} FROM {{ model }}
),
expected_data as (
    SELECT {{ compare_columns_cast }} FROM {{ ref(expected_seed) }}
),
compare as (
    SELECT * FROM actual_data AS a
    EXCEPT
    SELECT * FROM expected_data AS b
)
select COUNT(*) as differences from compare
{%- endmacro -%}