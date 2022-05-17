{%- test expect_tables_to_match(model, unique_id, compare_columns, expected_seed) -%}

    {%- set macro = adapter.dispatch('test_expect_tables_to_match', 'dbtvault_test') -%}

    {{ macro(model, unique_id, compare_columns, expected_seed) }}

{%- endtest -%}

{%- macro default__test_expect_tables_to_match(model, unique_id, compare_columns, expected_seed) -%}

{%- set source_columns = adapter.get_columns_in_relation(model) -%}
{%- set source_columns_list = [] -%}
{%- set compare_columns_processed = [] -%}
{%- set columns_processed = [] -%}
{%- set source_columns_processed = [] -%}

{%- for compare_col in compare_columns -%}

    {%- do compare_columns_processed.append("{}::VARCHAR AS {}".format(dbtvault.escape_column_names(compare_col), dbtvault.escape_column_names(compare_col))) -%}
    {%- do columns_processed.append(dbtvault.escape_column_names(compare_col)) -%}

{%- endfor %}

{%- for source_col in source_columns -%}

    {%- do source_columns_list.append(dbtvault.escape_column_names(source_col.column)) -%}
    {%- do source_columns_processed.append("{}::VARCHAR AS {}".format(dbtvault.escape_column_names(source_col.column), dbtvault.escape_column_names(source_col.column))) -%}
{%- endfor %}

{%- set compare_columns_string = compare_columns_processed | sort | join(", ") -%}
{%- set source_columns_string = source_columns_processed | sort | join(", ") -%}
{%- set columns_string = columns_processed | sort | join(", ") -%}
{%  set compare_columns = dbtvault.escape_column_names(compare_columns) %}

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
// SELECT * FROM order_actual_data
// SELECT * FROM order_expected_data
// SELECT * FROM compare_e_to_a
// SELECT * FROM compare_a_to_e
// SELECT * FROM duplicates_actual
// SELECT * FROM duplicates_expected
// SELECT * FROM duplicates_not_in_actual
// SELECT * FROM duplicates_not_in_expected
// SELECT * FROM compare

SELECT * FROM compare
{%- endmacro -%}

{%- macro bigquery__test_expect_tables_to_match(model, unique_id, compare_columns, expected_seed) -%}

{%- set source_columns = adapter.get_columns_in_relation(model) -%}
{%- set source_columns_list = [] -%}
{%- set compare_columns_processed = [] -%}
{%- set columns_processed = [] -%}
{%- set source_columns_processed = [] -%}

{%- for compare_col in compare_columns -%}

    {%- do compare_columns_processed.append("CAST({} AS STRING) AS {}".format(dbtvault.escape_column_names(compare_col), dbtvault.escape_column_names(compare_col))) -%}
    {%- do columns_processed.append(dbtvault.escape_column_names(compare_col)) -%}

{%- endfor %}

{%- for source_col in source_columns -%}
    {%- do source_columns_list.append(dbtvault.escape_column_names(source_col.column)) -%}

    {%- if source_col.data_type == 'BYTES' -%}
        {%- do source_columns_processed.append("UPPER(TO_HEX({})) AS {}".format(dbtvault.escape_column_names(source_col.name), dbtvault.escape_column_names(source_col.name))) -%}
    {%- else -%}
        {%- do source_columns_processed.append("CAST({} AS STRING) AS {}".format(dbtvault.escape_column_names(source_col.name), dbtvault.escape_column_names(source_col.name))) -%}
    {%- endif -%}

{%- endfor %}

{%- set compare_columns_string = compare_columns_processed | sort | join(", ") -%}
{%- set source_columns_string = source_columns_processed | sort | join(", ") -%}
{%- set columns_string = columns_processed | sort | join(", ") -%}
{%  set compare_columns = dbtvault.escape_column_names(compare_columns) %}

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
    SELECT {{ columns_string }},
           'E_TO_A' AS ERROR_SOURCE,
           'EXPECTED RECORD NOT IN ACTUAL' AS MESSAGE
    FROM compare_e_to_a
    UNION ALL
    SELECT {{ columns_string }},
           'A_TO_E' AS ERROR_SOURCE,
           'ACTUAL RECORD NOT IN EXPECTED' AS MESSAGE
    FROM compare_a_to_e
    UNION ALL
    SELECT {{ columns_string }},
           'DUPES_NOT_IN_A' AS ERROR_SOURCE,
           'DUPLICATE RECORDS WE DID EXPECT BUT ARE NOT PRESENT IN ACTUAL' AS MESSAGE
    FROM duplicates_not_in_actual
    UNION ALL
    SELECT {{ columns_string }},
           'DUPES_NOT_IN_E' AS ERROR_SOURCE,
           'DUPLICATE RECORDS WE DID NOT EXPECT AND ARE PRESENT IN ACTUAL' AS MESSAGE
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

{%- macro sqlserver__test_expect_tables_to_match(model, unique_id, compare_columns, expected_seed) -%}

{%- set source_columns = adapter.get_columns_in_relation(model) -%}
{%- set source_columns_list = [] -%}
{%- set compare_columns_processed = [] -%}
{%- set columns_processed = [] -%}
{%- set source_columns_processed = [] -%}
{%- set expected_columns = adapter.get_columns_in_relation(ref(expected_seed)) -%}

{%- for expected_col in expected_columns -%}

    {%- set compare_col = expected_col.column -%}
    {%- set compare_col_data_type = expected_col.data_type -%}

    {%  if compare_col in compare_columns %}
        {%- do columns_processed.append(dbtvault.escape_column_names(compare_col)) -%}

        {% if compare_col_data_type[0:6] == 'binary' %}
            {%- do compare_columns_processed.append("CONVERT(VARCHAR(MAX), {}, 2) AS {}".format(dbtvault.escape_column_names(compare_col), dbtvault.escape_column_names(compare_col))) -%}
        {% elif compare_col_data_type[0:8] == 'datetime' %}
            {%- do compare_columns_processed.append("CONVERT(VARCHAR(50), {}, 121) AS {}".format(dbtvault.escape_column_names(compare_col), dbtvault.escape_column_names(compare_col))) -%}
        {% else %}
            {%- do compare_columns_processed.append("CONVERT(VARCHAR(MAX), {}) AS {}".format(dbtvault.escape_column_names(compare_col), dbtvault.escape_column_names(compare_col))) -%}
        {% endif %}
    {% endif %}

{%- endfor %}

{%- for source_col in source_columns -%}

    {%- do source_columns_list.append(dbtvault.escape_column_names(source_col.column)) -%}

    {% if source_col.data_type[0:6] == 'binary' %}
        {%- do source_columns_processed.append("CONVERT(VARCHAR(MAX), {}, 2) AS {}".format(dbtvault.escape_column_names(source_col.column), dbtvault.escape_column_names(source_col.column))) -%}
    {% elif source_col.data_type[0:8] == 'datetime' %}
        {%- do source_columns_processed.append("CONVERT(VARCHAR(50), {}, 121) AS {}".format(dbtvault.escape_column_names(source_col.column), dbtvault.escape_column_names(source_col.column))) -%}
    {% else %}
        {%- do source_columns_processed.append("CONVERT(VARCHAR(MAX), {}) AS {}".format(dbtvault.escape_column_names(source_col.column), dbtvault.escape_column_names(source_col.column))) -%}
    {% endif %}

{%- endfor %}

{%- set compare_columns_string = compare_columns_processed | sort | join(", ") -%}
{%- set source_columns_string = source_columns_processed | sort | join(", ") -%}
{%- set columns_string = columns_processed | sort | join(", ") -%}

    SELECT {{ columns_string }},
           'E_TO_A' AS "ERROR_SOURCE",
           'EXPECTED RECORD NOT IN ACTUAL' AS "MESSAGE"
        FROM (
        SELECT * FROM (
            SELECT {{ compare_columns_string }}
            FROM {{ ref(expected_seed) }}
        ) AS expected_data
        EXCEPT
        SELECT * FROM (
            SELECT {{ source_columns_string }}
            FROM {{ model }}
        ) AS actual_data
    ) AS compare_e_to_a

    UNION ALL

    SELECT {{ columns_string }},
           'A_TO_E' AS "ERROR_SOURCE",
           'ACTUAL RECORD NOT IN EXPECTED' AS "MESSAGE"
        FROM (
        SELECT * FROM (
            SELECT {{ source_columns_string }}
            FROM {{ model }}
        ) AS actual_data
        EXCEPT
        SELECT * FROM (
            SELECT {{ compare_columns_string }}
            FROM {{ ref(expected_seed) }}
        ) AS expected_data
    ) AS compare_a_to_e

    UNION ALL

    SELECT {{ columns_string }},
           'DUPES_NOT_IN_A' AS "ERROR_SOURCE",
           'DUPLICATE RECORDS WE DID EXPECT BUT ARE NOT PRESENT IN ACTUAL' AS "MESSAGE"
        FROM (
        SELECT {{ columns_string }}
        FROM (
            SELECT {{ columns_string }}, COUNT(*) AS COUNT
            FROM (
                SELECT {{ compare_columns_string }}
                FROM {{ ref(expected_seed) }}
            ) AS expected_data
            GROUP BY {{ columns_string }}
            HAVING COUNT(*) > 1
        ) AS duplicates_expected
        WHERE {{ unique_id }} NOT IN (SELECT {{ unique_id }} FROM (
            SELECT {{ columns_string }}, COUNT(*) AS COUNT
            FROM (
                SELECT {{ source_columns_string }}
                FROM {{ model }}
            ) AS actual_data
            GROUP BY {{ columns_string }}
            HAVING COUNT(*) > 1
        ) AS duplicates_actual)
    ) AS duplicates_not_in_actual

    UNION ALL

    SELECT {{ columns_string }},
           'DUPES_NOT_IN_E' AS "ERROR_SOURCE",
           'DUPLICATE RECORDS WE DID NOT EXPECT AND ARE PRESENT IN ACTUAL' AS "MESSAGE"
    FROM (
        SELECT {{ columns_string }}
        FROM (
        SELECT {{ columns_string }}, COUNT (*) AS COUNT
        FROM (
            SELECT {{ source_columns_string }}
            FROM {{ model }}
        ) AS actual_data
        GROUP BY {{ columns_string }}
        HAVING COUNT(*) > 1
        ) AS duplicates_actual
        WHERE {{ unique_id }} NOT IN (SELECT {{ unique_id }} FROM (
            SELECT {{ columns_string }}, COUNT(*) AS COUNT
            FROM (
                SELECT {{ compare_columns_string }}
                FROM {{ ref(expected_seed) }}
            ) AS expected_data
            GROUP BY {{ columns_string }}
            HAVING COUNT(*) > 1
        ) AS duplicates_expected)
    ) AS duplicates_not_in_expected

{%- endmacro -%}