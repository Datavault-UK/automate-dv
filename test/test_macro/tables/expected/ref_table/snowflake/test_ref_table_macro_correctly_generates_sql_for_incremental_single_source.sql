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
    LEFT JOIN [DATABASE_NAME].[SCHEMA_NAME].test_ref_table_macro_correctly_generates_sql_for_incremental_single_source AS d
    ON a."CUSTOMER_PK" = d."CUSTOMER_PK"
    WHERE d."CUSTOMER_PK" IS NULL
)

SELECT * FROM non_historized