{{- config(materialized='incremental', schema='test_vlt', enabled=true, tags='feature') -}}

SELECT DISTINCT
                CAST(PART_PK AS BINARY(16)) AS PART_PK,
                CAST(PARTKEY AS NUMBER(38,0)) AS PARTKEY,
                CAST(LOADDATE AS DATE) AS LOADDATE,
                CAST(SOURCE AS VARCHAR(4)) AS SOURCE
FROM (
    SELECT PART_PK, PARTKEY, LOADDATE, SOURCE
    ,LAG(SOURCE, 1)
    OVER(PARTITION by PART_PK
    ORDER BY PART_PK) AS FIRST_SOURCE
    FROM (
      SELECT a.PART_PK, a.PARTKEY, a.LOADDATE, a.SOURCE
      FROM SRC_TEST_STG.STG_PART AS a
      LEFT JOIN {{ this }} AS tgt_a
      ON a.PART_PK = tgt_a.PART_PK
      AND tgt_a.PART_PK IS NULL
      UNION
      SELECT b.PART_PK, b.PARTKEY, b.LOADDATE, b.SOURCE
      FROM SRC_TEST_STG.STG_PARTSUPP AS b
      LEFT JOIN {{ this }} AS tgt_b
      ON b.PART_PK = tgt_b.PART_PK
      AND tgt_b.PART_PK IS NULL
      UNION
      SELECT c.PART_PK, c.PARTKEY, c.LOADDATE, c.SOURCE
      FROM SRC_TEST_STG.STG_LINEITEM AS c
      LEFT JOIN {{ this }} AS tgt_c
      ON c.PART_PK = tgt_c.PART_PK
      AND tgt_c.PART_PK IS NULL) as src
 ) AS stg
{% if is_incremental() -%}
WHERE stg.PART_PK NOT IN (SELECT PART_PK FROM {{ this }})
AND FIRST_SOURCE IS NULL
{% else -%}
WHERE FIRST_SOURCE IS NULL
{%- endif -%}