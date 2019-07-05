{{ config(schema='VLT', materialized='incremental', enabled=true, unique_key='CUSTOMERKEY_NATION_PK') }}

SELECT DISTINCT
  stg.CUSTOMERKEY_NATION_PK,
  stg.CUSTOMER_PK,
  stg.NATION_PK,
  stg.LOADDATE,
  stg.SOURCE
FROM (
SELECT
  a.CUSTOMERKEY_NATION_PK,
  a.CUSTOMER_PK,
  a.CUSTOMER_NATIONKEY_PK AS NATION_PK,
  a.LOADDATE,
  LAG(a.LOADDATE, 1) OVER(PARTITION BY a.CUSTOMERKEY_NATION_PK ORDER BY a.LOADDATE) AS FIRST_SEEN,
  a.SOURCE
FROM {{ref('v_stg_tpch_data')}} AS a) AS stg

{% if is_incremental() %}

WHERE stg.CUSTOMERKEY_NATION_PK NOT IN (SELECT CUSTOMERKEY_NATION_PK FROM {{this}}) AND stg.FIRST_SEEN IS NULL

{% else %}

WHERE stg.FIRST_SEEN IS NULL

{% endif %}

LIMIT 10