WITH source_data AS (SELECT a.CUSTOMER_PK, a.HASHDIFF, a.EFFECTIVE_FROM, a.LOAD_DATE, a.RECORD_SOURCE
                     FROM [DATABASE_NAME].[SCHEMA_NAME].raw_source_sat AS a
WHERE a.CUSTOMER_PK IS NOT NULL
    )
    , first_record_in_set AS (
SELECT
    sd.CUSTOMER_PK, sd.HASHDIFF, sd.EFFECTIVE_FROM, sd.LOAD_DATE, sd.RECORD_SOURCE, RANK() OVER (
    PARTITION BY sd.CUSTOMER_PK
    ORDER BY sd.LOAD_DATE ASC
    ) as asc_rank
FROM source_data as sd
    QUALIFY asc_rank = 1
    ), unique_source_records AS (
SELECT DISTINCT
    sd.CUSTOMER_PK, sd.HASHDIFF, sd.EFFECTIVE_FROM, sd.LOAD_DATE, sd.RECORD_SOURCE
FROM source_data as sd
    QUALIFY sd.HASHDIFF != LAG(sd.HASHDIFF) OVER (
    PARTITION BY sd.CUSTOMER_PK
    ORDER BY sd.LOAD_DATE ASC)
    ), records_to_insert AS (
SELECT frin.CUSTOMER_PK, frin.HASHDIFF, frin.EFFECTIVE_FROM, frin.LOAD_DATE, frin.RECORD_SOURCE
FROM first_record_in_set AS frin
UNION
SELECT usr.CUSTOMER_PK, usr.HASHDIFF, usr.EFFECTIVE_FROM, usr.LOAD_DATE, usr.RECORD_SOURCE
FROM unique_source_records as usr
    )

SELECT *
FROM records_to_insert