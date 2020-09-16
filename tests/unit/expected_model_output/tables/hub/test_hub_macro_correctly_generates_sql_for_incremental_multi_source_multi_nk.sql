WITH rank_1 AS (
    SELECT CUSTOMER_PK, CUSTOMER_ID, CUSTOMER_NAME, LOADDATE, RECORD_SOURCE,
           ROW_NUMBER() OVER(
               PARTITION BY CUSTOMER_PK
               ORDER BY LOADDATE ASC
           ) AS row_number
    FROM [DATABASE_NAME].[SCHEMA_NAME].raw_source
),
stage_1 AS (
    SELECT DISTINCT CUSTOMER_PK, CUSTOMER_ID, CUSTOMER_NAME, LOADDATE, RECORD_SOURCE
    FROM rank_1
    WHERE row_number = 1
),
rank_2 AS (
    SELECT CUSTOMER_PK, CUSTOMER_ID, CUSTOMER_NAME, LOADDATE, RECORD_SOURCE,
           ROW_NUMBER() OVER(
               PARTITION BY CUSTOMER_PK
               ORDER BY LOADDATE ASC
           ) AS row_number
    FROM [DATABASE_NAME].[SCHEMA_NAME].raw_source_2
),
stage_2 AS (
    SELECT DISTINCT CUSTOMER_PK, CUSTOMER_ID, CUSTOMER_NAME, LOADDATE, RECORD_SOURCE
    FROM rank_2
    WHERE row_number = 1
),
stage_union AS (
    SELECT * FROM stage_1
    UNION ALL
    SELECT * FROM stage_2
),
rank_union AS (
    SELECT *,
           ROW_NUMBER() OVER(
               PARTITION BY CUSTOMER_PK
               ORDER BY LOADDATE, RECORD_SOURCE ASC
           ) AS row_number
    FROM stage_union
    WHERE CUSTOMER_PK IS NOT NULL
),
stage AS (
    SELECT DISTINCT CUSTOMER_PK, CUSTOMER_ID, CUSTOMER_NAME, LOADDATE, RECORD_SOURCE
    FROM rank_union
    WHERE row_number = 1
),
records_to_insert AS (
    SELECT stage.* FROM stage
    LEFT JOIN [DATABASE_NAME].[SCHEMA_NAME].test_hub_macro_correctly_generates_sql_for_incremental_multi_source_multi_nk AS d
    ON stage.CUSTOMER_PK = d.CUSTOMER_PK
    WHERE d.CUSTOMER_PK IS NULL)

SELECT * FROM records_to_insert