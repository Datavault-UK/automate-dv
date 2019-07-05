{{config(schema='VLT', materialized='incremental', unique_key='CUSTOMER_PK', enabled=false)}}

SELECT DISTINCT stg.CUSTOMER_PK, stg.CUSTOMERKEY, stg.LOADDATE, stg.SOURCE 
FROM (
SELECT a.CUSTOMER_PK, a.CUSTOMERKEY, a.LOADDATE, a.SOURCE, LAG(a.LOADDATE, 1) OVER(PARTITION BY a.CUSTOMER_PK ORDER BY a.LOADDATE) AS FIRST_SEEN 
FROM {{ref('v_stg_tpch_data')}} AS a) AS stg
{% if is_incremental() %}
WHERE stg.CUSTOMER_PK NOT IN (SELECT CUSTOMER_PK FROM {{this}}) AND stg.FIRST_SEEN IS NULL
{% else %}
WHERE stg.FIRST_SEEN IS NULL
{% endif %}
LIMIT 10