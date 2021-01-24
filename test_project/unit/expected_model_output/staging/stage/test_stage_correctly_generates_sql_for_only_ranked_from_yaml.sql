WITH source_data AS (

    SELECT *

    FROM [DATABASE_NAME].[SCHEMA_NAME].raw_source
),

ranked_columns AS (

    SELECT *,

    RANK() OVER (PARTITION BY CUSTOMER_ID ORDER BY LOADDATE) AS DBTVAULT_RANK,
    RANK() OVER (PARTITION BY CUSTOMER_ID ORDER BY LOADDATE) AS SAT_LOAD_RANK

    FROM source_data
),

columns_to_select AS (

    SELECT

    DBTVAULT_RANK,
    SAT_LOAD_RANK

    FROM ranked_columns
)

SELECT * FROM columns_to_select