{%- macro test_assert_data_equal_to_expected(model, unique_id, compare_columns, expected_seed) -%}
WITH actual_data as (
    SELECT * FROM {{ model }}
),
expected_data as (
    SELECT * FROM {{ ref(expected_seed) }}
),
compare as (
    select count(1) AS differences
    FROM actual_data AS a
    FULL OUTER JOIN expected_data AS b
    USING ({{ compare_columns|join(', ') }})
    WHERE a.{{ unique_id }} IS NULL
    OR b.{{ unique_id }} IS NULL
)
select * from compare
{%- endmacro -%}