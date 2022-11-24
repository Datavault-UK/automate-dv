WITH source_data AS (
    SELECT a."CUSTOMER_PK", a."HASHDIFF", a."EFFECTIVE_FROM", a."LOAD_DATE", a."RECORD_SOURCE"
    FROM [DATABASE_NAME].[SCHEMA_NAME].raw_source_sat AS a
    WHERE a."CUSTOMER_PK" IS NOT NULL
),

records_to_insert AS (
    SELECT DISTINCT stage."CUSTOMER_PK", stage."HASHDIFF", stage."EFFECTIVE_FROM", stage."LOAD_DATE", stage."RECORD_SOURCE"
    FROM source_data AS stage
)

SELECT * FROM records_to_insert