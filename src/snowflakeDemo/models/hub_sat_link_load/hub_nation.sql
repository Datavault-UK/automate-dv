{{ config(schema='VLT', materialized='incremental', unique_key='NATION_PK', enabled=false,
post_hook='DROP VIEW IF EXISTS {{ref("v_nation")}}') }}

SELECT DISTINCT
  stg.NATION_PK,
	stg.CUSTOMER_NATIONKEY AS NATIONKEY,
	stg.LOADDATE,
	stg.SOURCE
FROM (
SELECT
  a.NATION_PK,
	a.CUSTOMER_NATIONKEY,
	a.LOADDATE,
	LAG(a.LOADDATE, 1) OVER(PARTITION BY a.NATION_PK ORDER BY a.LOADDATE) AS FIRST_SEEN,
	a.SOURCE
FROM {{ref('v_stg_tpch_data')}} AS a) AS stg

{% if is_incremental() %}

WHERE stg.NATION_PK NOT IN (SELECT NATION_PK FROM {{this}}) AND stg.FIRST_SEEN IS NULL

{% else %}

WHERE stg.FIRST_SEEN IS NULL

{% endif %}

LIMIT 10

SELECT DISTINCT
	v.NATION_PK,
	v.NATIONKEY,
	v.LOADDATE,
	v.SOURCE
FROM {{ref('v_nation')}} AS v

{% if is_incremental() %}

WHERE v.NATION_PK NOT IN (SELECT NATION_PK FROM {{this}}) AND v.FIRST_SEEN IS NULL

{% else %}

WHERE v.FIRST_SEEN IS NULL

{% endif %}

LIMIT 10