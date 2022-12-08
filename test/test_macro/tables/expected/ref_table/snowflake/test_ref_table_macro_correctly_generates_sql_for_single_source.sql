WITH to_insert AS (
    SELECT DISTINCT
    a."DATE_PK", a."YEAR", a."MONTH", a."DAY", a."DAY_OF_WEEK", a."LOAD_DATE", a."SOURCE"
    FROM [DATABASE_NAME].[SCHEMA_NAME].raw_source_ref_table AS a
    WHERE a."DATE_PK" IS NOT NULL
),

non_historized AS (
    SELECT
    a."DATE_PK", a."YEAR", a."MONTH", a."DAY", a."DAY_OF_WEEK", a."LOAD_DATE", a."SOURCE"
    FROM to_insert AS a
)

SELECT * FROM non_historized