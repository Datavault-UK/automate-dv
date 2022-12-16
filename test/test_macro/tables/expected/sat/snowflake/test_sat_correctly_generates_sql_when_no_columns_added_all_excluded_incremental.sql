WITH source_data AS (
    SELECT a.CUSTOMER_PK, a.HASHDIFF, a.TEST_COLUMN_1, a.TEST_COLUMN_2, a.TEST_COLUMN_3, a.TEST_COLUMN_4, a.TEST_COLUMN_5, a.TEST_COLUMN_6, a.TEST_COLUMN_7, a.TEST_COLUMN_8, a.TEST_COLUMN_9, a.EFFECTIVE_FROM, a.LOAD_DATE, a.RECORD_SOURCE
    FROM [DATABASE_NAME].[SCHEMA_NAME].raw_source_sat AS a
    WHERE a.CUSTOMER_PK IS NOT NULL
),

latest_records AS (
    SELECT a.CUSTOMER_PK, a.HASHDIFF, a.LOAD_DATE
    FROM (
        SELECT current_records.CUSTOMER_PK, current_records.HASHDIFF, current_records.LOAD_DATE,
            RANK() OVER (
               PARTITION BY current_records.CUSTOMER_PK
               ORDER BY current_records.LOAD_DATE DESC
            ) AS rank
        FROM [DATABASE_NAME].[SCHEMA_NAME].test_sat_correctly_generates_sql_when_no_columns_added_all_excluded_incremental AS current_records
            JOIN (
                SELECT DISTINCT source_data.CUSTOMER_PK
                FROM source_data
            ) AS source_records
                ON current_records.CUSTOMER_PK = source_records.CUSTOMER_PK
    ) AS a
    WHERE a.rank = 1
),

records_to_insert AS (
    SELECT DISTINCT stage.CUSTOMER_PK, stage.HASHDIFF, stage.TEST_COLUMN_1, stage.TEST_COLUMN_2, stage.TEST_COLUMN_3, stage.TEST_COLUMN_4, stage.TEST_COLUMN_5, stage.TEST_COLUMN_6, stage.TEST_COLUMN_7, stage.TEST_COLUMN_8, stage.TEST_COLUMN_9, stage.EFFECTIVE_FROM, stage.LOAD_DATE, stage.RECORD_SOURCE
    FROM source_data AS stage
    LEFT JOIN latest_records
    ON latest_records.CUSTOMER_PK = stage.CUSTOMER_PK
        AND latest_records.HASHDIFF = stage.HASHDIFF
    WHERE latest_records.HASHDIFF IS NULL
)

SELECT * FROM records_to_insert