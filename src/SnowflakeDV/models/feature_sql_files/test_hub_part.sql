{{- config(materialized='incremental', schema='test_vlt', enabled=true, tags='feature') -}}

SELECT
                CAST(PART_PK AS BINARY(16)) AS PART_PK,
                CAST(PARTKEY AS NUMBER(38,0)) AS PARTKEY,
                CAST(LOADDATE AS DATE) AS LOADDATE,
                CAST(SOURCE AS VARCHAR(4)) AS SOURCE
 FROM (
    SELECT DISTINCT PART_PK, PARTKEY, LOADDATE, SOURCE,
           LAG(SOURCE, 1)
           OVER(PARTITION BY PART_PK
           ORDER BY PART_PK) AS FIRST_SOURCE
    FROM (
        SELECT DISTINCT a.PART_PK, a.PARTKEY, a.SOURCE, a.LOADDATE
        FROM DV_PROTOTYPE_DB.SRC_TEST_STG.STG_LINEITEM AS a
        LEFT JOIN {{ this }} AS tgt_a
        ON a.PART_PK = tgt_a.PART_PK
        AND tgt_a.PART_PK IS NULL
        UNION
        SELECT DISTINCT a.PART_PK, a.PARTKEY, a.SOURCE, a.LOADDATE
        FROM DV_PROTOTYPE_DB.SRC_TEST_STG.STG_PART AS b
        LEFT JOIN {{ this }} AS tgt_b
        ON b.PART_PK = tgt_b.PART_PK
        AND tgt_b.PART_PK IS NULL
        UNION
        SELECT DISTINCT a.PART_PK, a.PARTKEY, a.SOURCE, a.LOADDATE
        FROM DV_PROTOTYPE_DB.SRC_TEST_STG.STG_PARTSUPP AS c
        LEFT JOIN {{ this }} AS tgt_c
        ON c.PART_PK = tgt_c.PART_PK
        AND tgt_c.PART_PK IS NULL
        )
 AS src)
AS stg
WHERE FIRST_SOURCE IS NULL