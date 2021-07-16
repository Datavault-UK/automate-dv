{%- test assert_data_equal_to_expected(model, unique_id, compare_columns, expected_seed) -%}

{%- set source_columns = adapter.get_columns_in_relation(model) -%}
{%- set source_columns_list = [] -%}
{%- set compare_columns_processed = [] -%}
{%- set columns_processed = [] -%}
{%- set source_columns_processed = [] -%}

{%- for compare_col in compare_columns -%}

    {%- do compare_columns_processed.append("CAST({} AS STRING) AS {}".format(compare_col, compare_col)) -%}
    {%- do columns_processed.append(compare_col) -%}

{%- endfor %}

{%- for source_col in source_columns -%}

    {%- do source_columns_list.append(source_col.column) -%}
    {%- do source_columns_processed.append("CAST({} AS STRING) AS {}".format(source_col.column, source_col.column)) -%}
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
    SELECT CAST(CUSTOMER_ID AS STRING) AS CUSTOMER_ID, (UPPER(TO_HEX(CUSTOMER_PK))) AS CUSTOMER_PK, CAST(LOAD_DATE AS STRING) AS LOAD_DATE, CAST(SOURCE AS STRING) AS SOURCE
    FROM actual_data
    ORDER BY CUSTOMER_ID, CUSTOMER_PK, LOAD_DATE, SOURCE
),
order_expected_data AS (
    SELECT CAST(CUSTOMER_ID AS STRING) AS CUSTOMER_ID, CAST(CUSTOMER_PK AS STRING) AS CUSTOMER_PK, CAST(LOAD_DATE AS STRING) AS LOAD_DATE, CAST(SOURCE AS STRING) AS SOURCE
    FROM expected_data
    ORDER BY CUSTOMER_ID, CUSTOMER_PK, LOAD_DATE, SOURCE
),
compare_e_to_a AS (
    SELECT e.* FROM order_expected_data AS e
    LEFT OUTER JOIN order_actual_data AS a
    ON a.CUSTOMER_PK = e.CUSTOMER_PK
    WHERE a.CUSTOMER_PK IS NULL
),
compare_a_to_e AS (
    SELECT a.* FROM order_actual_data AS a
    LEFT OUTER JOIN order_expected_data AS e
    ON e.CUSTOMER_PK = a.CUSTOMER_PK
    WHERE e.CUSTOMER_PK IS NULL
),
duplicates_actual AS (
    SELECT CUSTOMER_ID, CUSTOMER_PK, LOAD_DATE, SOURCE, COUNT(*) AS COUNT
    FROM order_actual_data
    GROUP BY CUSTOMER_ID, CUSTOMER_PK, LOAD_DATE, SOURCE
    HAVING COUNT(*) > 1
),
duplicates_expected AS (
    SELECT CUSTOMER_ID, CUSTOMER_PK, LOAD_DATE, SOURCE, COUNT(*) AS COUNT
    FROM order_expected_data
    GROUP BY CUSTOMER_ID, CUSTOMER_PK, LOAD_DATE, SOURCE
    HAVING COUNT(*) > 1
),
duplicates_not_in_actual AS (
    SELECT CUSTOMER_ID, CUSTOMER_PK, LOAD_DATE, SOURCE
    FROM duplicates_expected
    WHERE CUSTOMER_PK NOT IN (SELECT CUSTOMER_PK FROM duplicates_actual)
),
duplicates_not_in_expected AS (
    SELECT CUSTOMER_ID, CUSTOMER_PK, LOAD_DATE, SOURCE
    FROM duplicates_actual
    WHERE CUSTOMER_PK NOT IN (SELECT CUSTOMER_PK FROM duplicates_expected)
)
,
compare AS (
    SELECT a.CUSTOMER_PK, a.CUSTOMER_ID, a.LOAD_DATE, a.SOURCE, 'E_TO_A' AS ERROR_SOURCE FROM compare_e_to_a AS a
    UNION ALL
    SELECT b.CUSTOMER_PK, b.CUSTOMER_ID, b.LOAD_DATE, b.SOURCE, 'A_TO_E' AS ERROR_SOURCE FROM compare_a_to_e AS b
    UNION ALL
    SELECT c.CUSTOMER_PK, c.CUSTOMER_ID, c.LOAD_DATE, c.SOURCE, 'DUPES_NOT_IN_A' AS ERROR_SOURCE FROM duplicates_not_in_actual AS c
    UNION ALL
    SELECT d.CUSTOMER_PK, d.CUSTOMER_ID, d.LOAD_DATE, d.SOURCE, 'DUPES_NOT_IN_E' AS ERROR_SOURCE FROM duplicates_not_in_expected AS d
)

-- For manual debugging
/*SELECT * FROM order_actual_data
// SELECT * FROM order_expected_data */
-- SELECT * FROM compare_e_to_a
/* SELECT * FROM compare_a_to_e
// SELECT * FROM duplicates_actual
// SELECT * FROM duplicates_expected
// SELECT * FROM duplicates_not_in_actual
// SELECT * FROM duplicates_not_in_expected
// SELECT * FROM compare */

SELECT * FROM compare
{%- endtest -%}