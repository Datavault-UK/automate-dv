WITH stage AS (
    SELECT *

    FROM [DATABASE_NAME].[SCHEMA_NAME].raw_source
),

derived_columns AS (
    SElECT

    'STG_BOOKING' AS SOURCE,
    LOAD_DATETIME AS EFFECTIVE_FROM

    FROM stage
),

hashed_columns AS (
    SELECT *

    FROM derived_columns
)

SELECT * FROM hashed_columns