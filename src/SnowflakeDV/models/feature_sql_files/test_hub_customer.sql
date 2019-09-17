{{- config(materialized='incremental', schema='test_vlt', enabled=true, tags='feature') -}}

SELECT DISTINCT
                CAST(CUSTOMER_PK AS BINARY(16)) AS CUSTOMER_PK,
                CAST(CUSTOMERKEY AS NUMBER(38,0)) AS CUSTOMERKEY,
                CAST(LOADDATE AS DATE) AS LOADDATE,
                CAST(SOURCE AS VARCHAR(4)) AS SOURCE
FROM (
    SELECT a.CUSTOMER_PK, a.CUSTOMERKEY, a.LOADDATE, a.SOURCE
      ,LAG(a.SOURCE, 1)
      OVER(PARTITION by a.CUSTOMER_PK
      ORDER BY a.CUSTOMER_PK) AS FIRST_SOURCE
      FROM DV_PROTOTYPE_DB.SRC_TEST_STG.STG_CUSTOMER AS a
      LEFT JOIN {{ this }} AS tgt_a
      ON a.CUSTOMER_PK = tgt_a.CUSTOMER_PK
      AND tgt_a.CUSTOMER_PK IS NULL
 ) AS stg
{% if is_incremental() -%}
WHERE stg.CUSTOMER_PK NOT IN (SELECT CUSTOMER_PK FROM DV_PROTOTYPE_DB.SRC_VLT.hub_customer)
AND FIRST_SOURCE IS NULL
{% else -%}
WHERE FIRST_SOURCE IS NULL
{%- endif -%}