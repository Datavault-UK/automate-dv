WITH stage AS (
    SELECT *
    FROM [DATABASE_NAME].[SCHEMA_NAME].raw_source
),

derived_columns AS (
    SELECT *

    FROM stage
),

hashed_columns AS (
    SELECT *

    FROM derived_columns
),

ranked_columns AS (

    SELECT

    RANK() OVER (PARTITION BY CUSTOMER_ID ORDER BY LOADDATE) AS DBTVAULT_RANK,
    RANK() OVER (PARTITION BY CUSTOMER_ID ORDER BY LOADDATE) AS SAT_LOAD_RANK

    FROM hashed_columns

)

SELECT * FROM ranked_columns