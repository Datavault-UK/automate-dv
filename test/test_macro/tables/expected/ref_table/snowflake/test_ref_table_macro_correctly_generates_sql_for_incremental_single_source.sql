WITH to_insert AS (
    SELECT DISTINCT
        a.DATE_PK, a.YEAR, a.MONTH, a.DAY, a.DAY_OF_WEEK, a.LOAD_DATE, a.RECORD_SOURCE
    FROM [DATABASE_NAME].[SCHEMA_NAME].raw_source_ref_table AS a
    WHERE a.DATE_PK IS NOT NULL
),

non_historized AS (
    SELECT
        a.DATE_PK, a.YEAR, a.MONTH, a.DAY, a.DAY_OF_WEEK, a.LOAD_DATE, a.RECORD_SOURCE
    FROM to_insert AS a
    LEFT JOIN [DATABASE_NAME].[SCHEMA_NAME].test_ref_table_macro_correctly_generates_sql_for_incremental_single_source AS d
        ON a.DATE_PK = d.DATE_PK
        WHERE d.DATE_PK IS NULL
)

SELECT * FROM non_historized