WITH stage AS (
    SELECT *
    FROM [DATABASE_NAME].[SCHEMA_NAME].raw_source_table
),


derived_columns AS (
    SElECT
    'STG_BOOKING' AS SOURCE,
    LOADDATE AS EFFECTIVE_FROM
    FROM stage
),

hashed_columns AS (
    SELECT *
    FROM derived_stage
)

SELECT * FROM hashed_columns