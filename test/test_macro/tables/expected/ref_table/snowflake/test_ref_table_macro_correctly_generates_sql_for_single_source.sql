WITH to_insert AS (
    SELECT DISTINCT
    a."CUSTOMER_PK", a."LOAD_DATE", a."RECORD_SOURCE"
    FROM [DATABASE_NAME].[SCHEMA_NAME].raw_source_sat AS a
    WHERE a."CUSTOMER_PK" IS NOT NULL
),

non_historized AS (
    SELECT
    a."CUSTOMER_PK", a."LOAD_DATE", a."RECORD_SOURCE"
    FROM to_insert AS a
)

SELECT * FROM non_historized