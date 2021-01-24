WITH row_rank_1 AS (
    SELECT CUSTOMER_PK, ORDER_FK, BOOKING_FK, LOADDATE, RECORD_SOURCE,
           ROW_NUMBER() OVER(
               PARTITION BY CUSTOMER_PK
               ORDER BY LOADDATE ASC
           ) AS row_number
    FROM DBTVAULT_DEV.TEST_ALEX_HIGGS.raw_source
),
stage_1 AS (
    SELECT DISTINCT CUSTOMER_PK, ORDER_FK, BOOKING_FK, LOADDATE, RECORD_SOURCE
    FROM row_rank_1
    WHERE row_number = 1
),
stage_union AS (
    SELECT * FROM stage_1
),
row_rank_union AS (
    SELECT *,
           ROW_NUMBER() OVER(
               PARTITION BY CUSTOMER_PK
               ORDER BY LOADDATE, RECORD_SOURCE ASC
           ) AS row_number
    FROM stage_union
    WHERE ORDER_FK IS NOT NULL
    AND BOOKING_FK IS NOT NULL
),
stage AS (
    SELECT DISTINCT CUSTOMER_PK, ORDER_FK, BOOKING_FK, LOADDATE, RECORD_SOURCE
    FROM row_rank_union
    WHERE row_number = 1
),
records_to_insert AS (
    SELECT stage.* FROM stage
)

SELECT * FROM records_to_insert