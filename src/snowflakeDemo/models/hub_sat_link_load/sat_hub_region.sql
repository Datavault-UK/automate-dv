{{config(materialized='incremental', schema='VLT', enabled=false)}}

SELECT
  v.REGION_HASHDIFF,
  v.REGION_NAME,
  v.REGION_COMMENT,
  v.LOADDATE,
  v.EFFECTIVE_FROM,
  v.SOURCE
FROM {{ref('v_region')}}

{% if is_incremental() %}

WHERE v.REGION_HASHDIFF NOT IN (SELECT REGION_HASHDIFF FROM {{this}}) AND v.LATEST IS NULL

{% else %}

WHERE v.LATEST IS NULL

{% endif %}

LIMIT 10