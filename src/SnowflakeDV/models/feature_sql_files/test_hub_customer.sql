{{config(materialized='incremental', schema='test_vlt', enabled=false, tags='feature')}}

SELECT CUSTOMER_PK, CUSTOMERKEY, LOADDATE, SOURCE
 FROM (
  SELECT DISTINCT b.CUSTOMER_PK, b.CUSTOMERKEY, b.LOADDATE, b.SOURCE
  FROM (
    SELECT a.CUSTOMER_PK, a.CUSTOMERKEY, a.LOADDATE, a.SOURCE
    FROM DV_PROTOTYPE_DB.SRC_TEST_STG.STG_CUSTOMER AS a
    LEFT JOIN {{ this }} AS c
    ON a.CUSTOMER_PK = c.CUSTOMER_PK
    AND c.CUSTOMER_PK IS NULL)
 AS b)
AS stg
where stg.CUSTOMER_PK not in (select CUSTOMER_PK from {{ this }})
