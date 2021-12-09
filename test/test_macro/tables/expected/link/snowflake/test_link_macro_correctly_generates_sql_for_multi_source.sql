WITH row_rank_1 AS (
    SELECT rr.CUSTOMER_PK, rr.ORDER_FK, rr.BOOKING_FK, rr.LOAD_DATE, rr.RECORD_SOURCE,
           ROW_NUMBER() OVER(
               PARTITION BY rr.CUSTOMER_PK
               ORDER BY rr.LOAD_DATE
           ) AS row_number
    FROM [DATABASE_NAME].[SCHEMA_NAME].raw_source AS rr
    QUALIFY row_number = 1
),

row_rank_2 AS (
    SELECT rr.CUSTOMER_PK, rr.ORDER_FK, rr.BOOKING_FK, rr.LOAD_DATE, rr.RECORD_SOURCE,
           ROW_NUMBER() OVER(
               PARTITION BY rr.CUSTOMER_PK
               ORDER BY rr.LOAD_DATE
           ) AS row_number
    FROM [DATABASE_NAME].[SCHEMA_NAME].raw_source_2 AS rr
    QUALIFY row_number = 1
),

stage_union AS (
    SELECT * FROM row_rank_1
    UNION ALL
    SELECT * FROM row_rank_2
),

row_rank_union AS (
    SELECT ru.*,
           ROW_NUMBER() OVER(
               PARTITION BY ru.CUSTOMER_PK
               ORDER BY ru.LOAD_DATE, ru.RECORD_SOURCE ASC
           ) AS row_rank_number
    FROM stage_union AS ru
    WHERE ru.CUSTOMER_PK IS NOT NULL
    AND ru.ORDER_FK IS NOT NULL
    AND ru.BOOKING_FK IS NOT NULL
    QUALIFY row_rank_number = 1
),

records_to_insert AS (
    SELECT a.CUSTOMER_PK, a.ORDER_FK, a.BOOKING_FK, a.LOAD_DATE, a.RECORD_SOURCE
    FROM row_rank_union AS a
)

SELECT * FROM records_to_insert