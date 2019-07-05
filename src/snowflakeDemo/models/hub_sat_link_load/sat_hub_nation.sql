{{config(materialized='incremental', schema='VLT', enabled=false)}}

SELECT
  v.NATION_HASHDIFF,
  v.NATION_NAME,
  v.NATION_COMMENT,
  v.LOADDATE,
  v.EFFECTIVE_FROM,
  v.SOURCE
FROM {{ref('v_nation')}} AS v

{% if is_incremental() %}

WHERE v.NATION_HASHDIFF NOT IN (SELECT NATION_HASHDIFF FROM {{this}}) AND v.LATEST IS NULL

{% else %}

WHERE v.LATEST IS NULL

{% endif %}

LIMIT 10