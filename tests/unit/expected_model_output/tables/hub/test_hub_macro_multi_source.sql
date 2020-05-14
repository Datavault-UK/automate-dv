WITH STG_1 AS (
    SELECT DISTINCT
    a.TEST_COLUMN_2, a.TEST_COLUMN_3, a.TEST_COLUMN_4, a.TEST_COLUMN_5
    FROM (
        SELECT TEST_COLUMN_2, TEST_COLUMN_3, TEST_COLUMN_4, TEST_COLUMN_5,
        ROW_NUMBER() OVER(
            PARTITION BY TEST_COLUMN_2 
            ORDER BY TEST_COLUMN_4 ASC) 
        AS RN
        FROM DBT_VAULT.TEST.raw_source
    ) AS a
    WHERE RN = 1
),
STG_2 AS (
    SELECT DISTINCT
    a.TEST_COLUMN_2, a.TEST_COLUMN_3, a.TEST_COLUMN_4, a.TEST_COLUMN_5
    FROM (
        SELECT TEST_COLUMN_2, TEST_COLUMN_3, TEST_COLUMN_4, TEST_COLUMN_5,
        ROW_NUMBER() OVER(
            PARTITION BY TEST_COLUMN_2 
            ORDER BY TEST_COLUMN_4 ASC) 
        AS RN
        FROM DBT_VAULT.TEST.raw_source_2
    ) AS a
    WHERE RN = 1
),
STG AS (
    SELECT DISTINCT
    b.TEST_COLUMN_2, b.TEST_COLUMN_3, b.TEST_COLUMN_4, b.TEST_COLUMN_5
    FROM (
            SELECT *,
            ROW_NUMBER() OVER(
                PARTITION BY TEST_COLUMN_2 
                ORDER BY TEST_COLUMN_4, TEST_COLUMN_5 ASC) 
            AS RN
            FROM (
                SELECT * 
                FROM STG_1
                UNION
                SELECT * 
                FROM STG_2
            )
        WHERE TEST_COLUMN_2 <> MD5_BINARY('^^')
        AND TEST_COLUMN_2<>MD5_BINARY('')
    ) AS b
    WHERE RN = 1
)

SELECT c.* FROM STG AS c