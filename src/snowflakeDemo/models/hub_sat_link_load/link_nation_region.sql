{{ config(schema='VLT', materialized='incremental', enabled=false, unique_key='NATION_REGION_PK') }}

SELECT DISTINCT
  stg.NATION_REGION_PK,
  stg.NATION_PK,
  stg.REGION_PK,
  stg.LOADDATE,
  stg.SOURCE
FROM (
SELECT
  a.NATION_REGION_PK,
  a.NATION_PK,
  a.REGION_PK,
  a.LOADDATE,
  LAG(a.LOADDATE, 1) OVER(PARTITION BY a.NATION_REGION_PK ORDER BY a.LOADDATE) AS FIRST_SEEN,
  a.SOURCE
FROM {{ ref('v_stg_tpch_data') }} AS a) AS stg

{% if is_incremental %}

WHERE stg.NATION_REGION_PK NOT IN (SELECT NATION_REGION_PK FROM {{this}}) AND stg.FIRST_SEEN IS NULL

{% else %}

WHERE stg.FIRST_SEEN IS NULL

{% endif %}

LIMIT 10