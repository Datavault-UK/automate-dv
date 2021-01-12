WITH stage AS (
    SELECT *

    FROM [DATABASE_NAME].[SCHEMA_NAME].raw_source
),

derived_columns AS (
    SElECT *

    FROM stage
),

hashed_columns AS (
    SELECT *

    FROM derived_columns
)

SELECT * FROM hashed_columns