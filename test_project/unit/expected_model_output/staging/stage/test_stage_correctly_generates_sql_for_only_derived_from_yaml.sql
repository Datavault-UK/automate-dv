WITH stage AS (
    SELECT *
    FROM [DATABASE_NAME].[SCHEMA_NAME].raw_source
),

derived_columns AS (
    SELECT

    'STG_BOOKING' AS SOURCE,
    LOADDATE AS EFFECTIVE_FROM

    FROM stage
),

hashed_columns AS (
    SELECT *

    FROM derived_columns
),

ranked_columns AS (

    SELECT *

    FROM hashed_columns

)

SELECT * FROM ranked_columns