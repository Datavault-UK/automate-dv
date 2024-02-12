WITH source_data AS (
    SELECT DISTINCT
        a.DATE_PK, a.YEAR, a.MONTH, a.DAY, a.DAY_OF_WEEK, a.LOAD_DATE, a.RECORD_SOURCE
    FROM [DATABASE_NAME].[SCHEMA_NAME].raw_source_ref_table AS a
    WHERE a.DATE_PK IS NOT NULL
),

records_to_insert AS (
    SELECT
        a.DATE_PK, a.YEAR, a.MONTH, a.DAY, a.DAY_OF_WEEK, a.LOAD_DATE, a.RECORD_SOURCE
    FROM source_data AS a
)

SELECT * FROM records_to_insert