WITH source_data AS (
    SELECT a.CUSTOMER_PK, a.HASHDIFF, a.TEST_COLUMN_1, a.TEST_COLUMN_2, a.TEST_COLUMN_3, a.TEST_COLUMN_4, a.TEST_COLUMN_5, a.TEST_COLUMN_6, a.TEST_COLUMN_7, a.TEST_COLUMN_8, a.TEST_COLUMN_9, a.EFFECTIVE_FROM, a.LOAD_DATE, a.RECORD_SOURCE
    FROM [DATABASE_NAME].[SCHEMA_NAME].raw_source_sat AS a
    WHERE a.CUSTOMER_PK IS NOT NULL
),

latest_records AS (
    SELECT current_records.CUSTOMER_PK, current_records.HASHDIFF, current_records.TEST_COLUMN_1, current_records.TEST_COLUMN_2, current_records.TEST_COLUMN_3, current_records.TEST_COLUMN_4, current_records.TEST_COLUMN_5, current_records.TEST_COLUMN_6, current_records.TEST_COLUMN_7, current_records.TEST_COLUMN_8, current_records.TEST_COLUMN_9, current_records.EFFECTIVE_FROM, current_records.LOAD_DATE, current_records.RECORD_SOURCE,
        ROW_NUMBER() OVER (
           PARTITION BY current_records.CUSTOMER_PK
           ORDER BY current_records.LOAD_DATE DESC
        ) AS rank_num
    FROM [DATABASE_NAME].[SCHEMA_NAME].test_sat_correctly_generates_sql_when_no_columns_added_all_excluded_incremental AS current_records
    JOIN (
        SELECT DISTINCT source_data.CUSTOMER_PK
        FROM source_data
    ) AS source_records
        ON source_records.CUSTOMER_PK = current_records.CUSTOMER_PK
    QUALIFY rank_num = 1
),

first_record_in_set AS (
    SELECT
    sd.CUSTOMER_PK, sd.HASHDIFF, sd.TEST_COLUMN_1, sd.TEST_COLUMN_2, sd.TEST_COLUMN_3, sd.TEST_COLUMN_4, sd.TEST_COLUMN_5, sd.TEST_COLUMN_6, sd.TEST_COLUMN_7, sd.TEST_COLUMN_8, sd.TEST_COLUMN_9, sd.EFFECTIVE_FROM, sd.LOAD_DATE, sd.RECORD_SOURCE,
    ROW_NUMBER() OVER (
            PARTITION BY sd.CUSTOMER_PK
            ORDER BY sd.LOAD_DATE ASC
    ) AS asc_rank
    FROM source_data AS sd
    QUALIFY asc_rank = 1
),

unique_source_records AS (
    SELECT DISTINCT
        sd.CUSTOMER_PK, sd.HASHDIFF, sd.TEST_COLUMN_1, sd.TEST_COLUMN_2, sd.TEST_COLUMN_3, sd.TEST_COLUMN_4, sd.TEST_COLUMN_5, sd.TEST_COLUMN_6, sd.TEST_COLUMN_7, sd.TEST_COLUMN_8, sd.TEST_COLUMN_9, sd.EFFECTIVE_FROM, sd.LOAD_DATE, sd.RECORD_SOURCE
    FROM source_data AS sd
    QUALIFY sd.HASHDIFF != LAG(sd.HASHDIFF) OVER (
        PARTITION BY sd.CUSTOMER_PK
        ORDER BY sd.LOAD_DATE ASC
    )
),

records_to_insert AS (
    SELECT frin.CUSTOMER_PK, frin.HASHDIFF, frin.TEST_COLUMN_1, frin.TEST_COLUMN_2, frin.TEST_COLUMN_3, frin.TEST_COLUMN_4, frin.TEST_COLUMN_5, frin.TEST_COLUMN_6, frin.TEST_COLUMN_7, frin.TEST_COLUMN_8, frin.TEST_COLUMN_9, frin.EFFECTIVE_FROM, frin.LOAD_DATE, frin.RECORD_SOURCE
    FROM first_record_in_set AS frin
    LEFT JOIN latest_records lr
        ON lr.CUSTOMER_PK = frin.CUSTOMER_PK
        AND lr.HASHDIFF = frin.HASHDIFF
        WHERE lr.HASHDIFF IS NULL
    UNION
    SELECT usr.CUSTOMER_PK, usr.HASHDIFF, usr.TEST_COLUMN_1, usr.TEST_COLUMN_2, usr.TEST_COLUMN_3, usr.TEST_COLUMN_4, usr.TEST_COLUMN_5, usr.TEST_COLUMN_6, usr.TEST_COLUMN_7, usr.TEST_COLUMN_8, usr.TEST_COLUMN_9, usr.EFFECTIVE_FROM, usr.LOAD_DATE, usr.RECORD_SOURCE
    FROM unique_source_records AS usr
)

SELECT * FROM records_to_insert