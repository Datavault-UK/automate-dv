WITH source_data AS (
    SELECT a."CUSTOMER_PK", a."HASHDIFF", a."TEST_COLUMN_1", a."TEST_COLUMN_2", a."TEST_COLUMN_3", a."TEST_COLUMN_6", a."TEST_COLUMN_7", a."TEST_COLUMN_8", a."TEST_COLUMN_9", a."EFFECTIVE_FROM", a."LOAD_DATE", a."RECORD_SOURCE"
    FROM [DATABASE_NAME].[SCHEMA_NAME].raw_source_sat AS a
    WHERE a."CUSTOMER_PK" IS NOT NULL
),

records_to_insert AS (
    SELECT DISTINCT stage."CUSTOMER_PK", stage."HASHDIFF", stage."TEST_COLUMN_1", stage."TEST_COLUMN_2", stage."TEST_COLUMN_3", stage."TEST_COLUMN_6", stage."TEST_COLUMN_7", stage."TEST_COLUMN_8", stage."TEST_COLUMN_9", stage."EFFECTIVE_FROM", stage."LOAD_DATE", stage."RECORD_SOURCE"
    FROM source_data AS stage
)

SELECT * FROM records_to_insert