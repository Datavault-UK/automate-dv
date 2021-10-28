WITH row_rank_1 AS (
    SELECT CUSTOMER_PK, ORDER_FK, BOOKING_FK, LOAD_DATE, RECORD_SOURCE,
           ROW_NUMBER() OVER(
               PARTITION BY CUSTOMER_PK
               ORDER BY LOAD_DATE
           ) AS row_number
    FROM [DATABASE_NAME].[SCHEMA_NAME].raw_source
    WHERE CUSTOMER_PK IS NOT NULL
    AND ORDER_FK IS NOT NULL
    AND BOOKING_FK IS NOT NULL
    QUALIFY row_number = 1
),

records_to_insert AS (
    SELECT a.CUSTOMER_PK, a.ORDER_FK, a.BOOKING_FK, a.LOAD_DATE, a.RECORD_SOURCE
    FROM row_rank_1 AS a
)

SELECT * FROM records_to_insert