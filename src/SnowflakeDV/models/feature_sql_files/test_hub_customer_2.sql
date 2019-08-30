{{config(materialized='incremental', schema='test_vlt', enabled=true, tags='feature')}}

SELECT CUSTOMER_PK, CUSTOMERKEY, LOADDATE, SOURCE
 FROM (
  SELECT DISTINCT b.CUSTOMER_PK, b.CUSTOMERKEY, b.LOADDATE, b.SOURCE
  FROM (
    SELECT a.CUSTOMER_PK, a.CUSTOMERKEY, a.LOADDATE, a.SOURCE
    FROM DV_PROTOTYPE_DB.SRC_STG.stg_orders_hashed AS a
    LEFT JOIN DV_PROTOTYPE_DB.SRC_VLT.hub_customer AS c
    ON a.CUSTOMER_PK = c.CUSTOMER_PK
    AND c.CUSTOMER_PK IS NULL)
 AS b)
AS stg
