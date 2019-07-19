{{ config(materialized='view', schema='STG', enabled=true, tags=['static', 'incremental']) }}

SELECT
  a.*
FROM {{ref('source_system')}} AS a
ORDER BY a.ORDERKEY
limit 20


