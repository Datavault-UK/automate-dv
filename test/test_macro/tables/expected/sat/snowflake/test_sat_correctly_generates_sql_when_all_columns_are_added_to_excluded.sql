WITH source_data AS (
    SELECT a.CUSTOMER_PK, a.HASHDIFF, a.EFFECTIVE_FROM, a.LOAD_DATE, a.RECORD_SOURCE
    FROM AUTOMATE_DV_DEV.TEST_AAKASH_DATTA.raw_source_sat AS a
    WHERE a.CUSTOMER_PK IS NOT NULL
),


first_record_in_set AS (
    SELECT
    sd.CUSTOMER_PK, sd.HASHDIFF, sd.EFFECTIVE_FROM, sd.LOAD_DATE, sd.RECORD_SOURCE
    , ROW_NUMBER() OVER(PARTITION BY CUSTOMER_PK ORDER BY LOAD_DATE ASC) as asc_row_number
    FROM source_data as sd
    QUALIFY asc_row_number = 1
),

unique_source_records AS (
    SELECT DISTINCT
        sd.CUSTOMER_PK, sd.HASHDIFF, sd.EFFECTIVE_FROM, sd.LOAD_DATE, sd.RECORD_SOURCE
    FROM source_data as sd
    QUALIFY HASHDIFF != LAG(HASHDIFF) OVER(PARTITION BY CUSTOMER_PK ORDER BY LOAD_DATE ASC)
),

records_to_insert AS (
        SELECT frin.CUSTOMER_PK, frin.HASHDIFF, frin.EFFECTIVE_FROM, frin.LOAD_DATE, frin.RECORD_SOURCE
        FROM first_record_in_set AS frin
        UNION
        SELECT usr.CUSTOMER_PK, usr.HASHDIFF, usr.EFFECTIVE_FROM, usr.LOAD_DATE, usr.RECORD_SOURCE
        FROM unique_source_records as usr
)

SELECT * FROM records_to_insert