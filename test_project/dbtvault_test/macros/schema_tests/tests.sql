{%- macro test_assert_data_equal_to_expected(model, unique_id, compare_columns, expected_seed) -%}

WITH actual_data as (
    SELECT * FROM {{ model }}
),
expected_data as (
    SELECT * FROM {{ ref(expected_seed) }}
),
compare as (
    SELECT a.*
    FROM actual_data AS a
    FULL OUTER JOIN expected_data AS b
    {%- for column in compare_columns -%}
    {%- if loop.first %}
    ON (a.{{ column }}::VARCHAR = b.{{ column }}::VARCHAR
    {%- else %}
    AND a.{{ column }}::VARCHAR = b.{{ column }}::VARCHAR
    {{- ')' if loop.last -}}
    {%- endif -%}
    {%- endfor %}
    WHERE a.{{ unique_id }} IS NULL
    OR b.{{ unique_id }} IS NULL
),
compare_order_actual_data as (
    -- For manual debugging, SELECT * FROM compare_order_actual_data
    SELECT {{ compare_columns | join(", ") }}
    FROM actual_data
    ORDER BY {{ compare_columns | join(", ") }}
),
compare_order_expected_data as (
    -- For manual debugging, SELECT * FROM compare_order_expected_data
    SELECT {{ compare_columns | join(", ") }}
    FROM expected_data
    ORDER BY {{ compare_columns | join(", ") }}
)
SELECT COUNT(*) AS differences FROM compare
{%- endmacro -%}