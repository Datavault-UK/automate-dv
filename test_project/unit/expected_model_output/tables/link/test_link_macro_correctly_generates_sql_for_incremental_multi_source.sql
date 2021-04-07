WITH row_rank_1 AS (
    SELECT CUSTOMER_PK, ORDER_FK, BOOKING_FK, LOADDATE, RECORD_SOURCE
    FROM [DATABASE_NAME].[SCHEMA_NAME].raw_source
),

row_rank_2 AS (
    SELECT CUSTOMER_PK, ORDER_FK, BOOKING_FK, LOADDATE, RECORD_SOURCE
    FROM [DATABASE_NAME].[SCHEMA_NAME].raw_source_2
),

stage_union AS (
    SELECT * FROM row_rank_1
    UNION ALL
    SELECT * FROM row_rank_2
),

row_rank_union AS (
    SELECT *,
           ROW_NUMBER() OVER(
               PARTITION BY CUSTOMER_PK
               ORDER BY LOADDATE, RECORD_SOURCE ASC
           ) AS row_rank_number
    FROM stage_union
    WHERE CUSTOMER_PK IS NOT NULL
    AND ORDER_FK IS NOT NULL
    AND BOOKING_FK IS NOT NULL
    QUALIFY row_rank_number = 1
),

records_to_insert AS (
    SELECT a.CUSTOMER_PK, a.ORDER_FK, a.BOOKING_FK, a.LOADDATE, a.RECORD_SOURCE
    FROM row_rank_union AS a
    LEFT JOIN [DATABASE_NAME].[SCHEMA_NAME].test_link_macro_correctly_generates_sql_for_incremental_multi_source AS d
    ON a.CUSTOMER_PK = d.CUSTOMER_PK
    WHERE d.CUSTOMER_PK IS NULL
)

SELECT * FROM records_to_insert