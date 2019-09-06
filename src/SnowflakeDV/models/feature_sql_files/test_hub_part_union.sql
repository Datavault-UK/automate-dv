{{config(materialized='incremental', schema='test_vlt', enabled=false, tags='feature')}}

SELECT
                CAST(PART_PK AS BINARY(16)) AS PART_PK,
                CAST(PARTKEY AS NUMBER(38,0)) AS PARTKEY,
                CAST(LOADDATE AS DATE) AS LOADDATE,
                CAST(SOURCE AS VARCHAR(4)) AS SOURCE


 FROM (
  SELECT DISTINCT PART_PK, PARTKEY, SOURCE, LOADDATE, FIRST_SOURCE
  FROM
    (SELECT DISTINCT a.PART_PK, a.PARTKEY, a.SOURCE, a.LOADDATE,
                     lag(a.SOURCE, 1) over(partition by a.PART_PK order by a.PART_PK) as FIRST_SOURCE
    FROM DV_PROTOTYPE_DB.SRC_TEST_STG.STG_PART AS a
    LEFT JOIN {{ this }} AS c
    ON a.PART_PK = c.PART_PK
    AND c.PART_PK IS NULL) AS b)
AS stg
WHERE stg.PART_PK NOT IN (SELECT PART_PK FROM {{ this }})
AND FIRST_SOURCE IS NULL
ORDER BY PARTKEY