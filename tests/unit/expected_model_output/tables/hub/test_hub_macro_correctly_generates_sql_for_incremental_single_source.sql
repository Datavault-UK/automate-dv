WITH STG AS (
    SELECT DISTINCT
    a.CUSTOMER_PK, a.CUSTOMER_ID, a.LOADDATE, a.RECORD_SOURCE
    FROM (
        SELECT b.*,
        ROW_NUMBER() OVER(
            PARTITION BY b.CUSTOMER_PK
            ORDER BY b.LOADDATE, b.RECORD_SOURCE ASC
        ) AS RN
        FROM DBT_VAULT.TEST.raw_source AS b
        WHERE b.CUSTOMER_PK IS NOT NULL
    ) AS a
    WHERE RN = 1
)

SELECT c.* FROM STG AS c
LEFT JOIN DBT_VAULT.TEST.test_hub_macro_correctly_generates_sql_for_incremental_single_source AS d 
ON c.CUSTOMER_PK = d.CUSTOMER_PK
WHERE d.CUSTOMER_PK IS NULL