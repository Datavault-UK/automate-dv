{{ config(enabled=false, materialized='incremental', unique_key='REGION_PK', schema='VLT',
post_hook='DROP VIEW IF EXISTS {{ref("v_region")}}' }}

SELECT DISTINCT
  stg.REGION_PK,
  stg.CUSTOMER_REGIONKEY AS REGIONKEY,
  stg.LOADDATE,
  stg.SOURCE
FROM (
SELECT
  a.REGION_PK,
  a.CUSTOMER_REGIONKEY,
  a.LOADDATE,
  LAG(a.LOADDATE, 1) OVER(PARTITION BY a.REGION_PK ORDER BY a.LOADDATE) AS FIRST_SEEN,
  a.SOURCE
FROM {{ ref('v_stg_tpch_data') }} AS a) AS stg

{% if is_incremental() %}

WHERE stg.REGION_PK NOT IN (SELECT REGION_PK FROM {{this}}) AND stg.FIRST_SEEN IS NULL

{% else %}

WHERE stg.FIRST_SEEN IS NULL

{% endif %}

LIMIT 10

SELECT
  v.REGION_PK,
  v.REGIONKEY,
  v.LOADDATE,
  v.SOURCE
FROM {{ref('v_region')}} AS v

{% if is_incremental() %}

WHERE v.REGION_PK NOT IN (SELECT REGION_PK FROM {{this}}) AND v.FIRST_SEEN IS NULL

{% else %}

WHERE v.FIRST_SEEN IS NULL

{% endif %}

LIMIT 10

