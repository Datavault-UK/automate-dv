WITH source_data AS (
    SELECT a.CUSTOMER_PK, a.HASHDIFF, a.TEST_COLUMN_1, a.TEST_COLUMN_2, a.EFFECTIVE_FROM, a.LOAD_DATE, a.RECORD_SOURCE
    FROM [DATABASE_NAME].[SCHEMA_NAME].raw_source_sat AS a
    WHERE a.CUSTOMER_PK IS NOT NULL
),

latest_records AS (
    SELECT current_records.CUSTOMER_PK, current_records.HASHDIFF, current_records.TEST_COLUMN_1, current_records.TEST_COLUMN_2, current_records.EFFECTIVE_FROM, current_records.LOAD_DATE, current_records.RECORD_SOURCE,
        ROW_NUMBER() OVER (
           PARTITION BY current_records.CUSTOMER_PK
           ORDER BY current_records.LOAD_DATE DESC
        ) AS rank_num
    FROM [DATABASE_NAME].[SCHEMA_NAME].test_sat_correctly_generates_sql_for_apply_source_filter_true AS current_records
    JOIN (
        SELECT DISTINCT source_data.CUSTOMER_PK
        FROM source_data
    ) AS source_records
        ON source_records.CUSTOMER_PK = current_records.CUSTOMER_PK
    QUALIFY rank_num = 1
),

valid_stg AS (
    SELECT s.CUSTOMER_PK, s.HASHDIFF, s.TEST_COLUMN_1, s.TEST_COLUMN_2, s.EFFECTIVE_FROM, s.LOAD_DATE, s.RECORD_SOURCE
    FROM source_data AS s
    LEFT JOIN latest_records AS sat
        ON s.CUSTOMER_PK = sat.CUSTOMER_PK
        WHERE sat.CUSTOMER_PK IS NULL
        OR s.LOAD_DATE > (
            SELECT MAX(LOAD_DATE) FROM latest_records AS sat
            WHERE sat.CUSTOMER_PK = s.CUSTOMER_PK
        )
),

first_record_in_set AS (
    SELECT
    sd.CUSTOMER_PK, sd.HASHDIFF, sd.TEST_COLUMN_1, sd.TEST_COLUMN_2, sd.EFFECTIVE_FROM, sd.LOAD_DATE, sd.RECORD_SOURCE,
    ROW_NUMBER() OVER (
            PARTITION BY sd.CUSTOMER_PK
            ORDER BY sd.LOAD_DATE ASC
    ) AS asc_rank
    FROM valid_stg AS sd
    QUALIFY asc_rank = 1
),

unique_source_records AS (
    SELECT DISTINCT
        sd.CUSTOMER_PK, sd.HASHDIFF, sd.TEST_COLUMN_1, sd.TEST_COLUMN_2, sd.EFFECTIVE_FROM, sd.LOAD_DATE, sd.RECORD_SOURCE
    FROM valid_stg AS sd
    QUALIFY sd.HASHDIFF != LAG(sd.HASHDIFF) OVER (
        PARTITION BY sd.CUSTOMER_PK
        ORDER BY sd.LOAD_DATE ASC
    )
),

records_to_insert AS (
    SELECT frin.CUSTOMER_PK, frin.HASHDIFF, frin.TEST_COLUMN_1, frin.TEST_COLUMN_2, frin.EFFECTIVE_FROM, frin.LOAD_DATE, frin.RECORD_SOURCE
    FROM first_record_in_set AS frin
    LEFT JOIN latest_records lr
        ON lr.CUSTOMER_PK = frin.CUSTOMER_PK
        AND lr.HASHDIFF = frin.HASHDIFF
        WHERE lr.HASHDIFF IS NULL
    UNION
    SELECT usr.CUSTOMER_PK, usr.HASHDIFF, usr.TEST_COLUMN_1, usr.TEST_COLUMN_2, usr.EFFECTIVE_FROM, usr.LOAD_DATE, usr.RECORD_SOURCE
    FROM unique_source_records AS usr
)

SELECT * FROM records_to_insert