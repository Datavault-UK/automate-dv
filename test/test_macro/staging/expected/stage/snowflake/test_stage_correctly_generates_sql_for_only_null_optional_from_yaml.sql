WITH source_data AS (SELECT BOOKING_FK,
                            ORDER_FK,
                            CUSTOMER_PK,
                            CUSTOMER_ID,
                            LOAD_DATE,
                            RECORD_SOURCE,
                            CUSTOMER_DOB,
                            CUSTOMER_NAME,
                            NATIONALITY,
                            PHONE,
                            TEST_COLUMN_2,
                            TEST_COLUMN_3,
                            TEST_COLUMN_4,
                            TEST_COLUMN_5,
                            TEST_COLUMN_6,
                            TEST_COLUMN_7,
                            TEST_COLUMN_8,
                            TEST_COLUMN_9,
                            BOOKING_DATE

                     FROM
   [DATABASE_NAME].[SCHEMA_NAME].raw_source
    )
   , null_columns AS (

SELECT
    BOOKING_FK, ORDER_FK, CUSTOMER_PK, CUSTOMER_ID, LOAD_DATE, RECORD_SOURCE, CUSTOMER_NAME, NATIONALITY, PHONE, TEST_COLUMN_2, TEST_COLUMN_3, TEST_COLUMN_4, TEST_COLUMN_5, TEST_COLUMN_6, TEST_COLUMN_7, TEST_COLUMN_8, TEST_COLUMN_9, BOOKING_DATE, CUSTOMER_DOB AS CUSTOMER_DOB_ORIGINAL, IFNULL(CUSTOMER_DOB, '-2') AS CUSTOMER_DOB

FROM source_data
    ), columns_to_select AS (

SELECT
    CUSTOMER_DOB, CUSTOMER_DOB_ORIGINAL

FROM null_columns
    )

SELECT *
FROM columns_to_select