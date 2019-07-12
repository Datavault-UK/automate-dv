{{config(materialized='incremental', schema='VLT', enabled=true)}}

{% set sat_columns = 'CAST(stg.REGION_HASHDIFF AS BINARY(16)) AS REGION_HASHDIFF, CAST(stg.REGION_PK AS BINARY(16)) AS REGION_PK, CAST(stg.REGION_NAME AS VARCHAR(25)) AS REGION_NAME, CAST(stg.REGION_COMMENT AS VARCHAR(152)) AS REGION_COMMENT, CAST(stg.LOADDATE AS DATE) AS LOADDATE, CAST(stg.EFFECTIVE_FROM AS DATE) AS EFFECTIVE_FROM, CAST(stg.SOURCE AS VARCHAR(4)) AS SOURCE' %}
{% set stg_columns1 = 'b.REGION_HASHDIFF, b.REGION_PK, b.REGION_NAME, b.REGION_COMMENT, b.LOADDATE, b.EFFECTIVE_FROM, b.SOURCE' %}
{% set stg_columns2 = 'a.REGION_HASHDIFF, a.REGION_PK, a.REGION_NAME, a.REGION_COMMENT, a.LOADDATE, a.EFFECTIVE_FROM, a.SOURCE' %}
{% set sat_pk = 'REGION_HASHDIFF' %}
{% set stg_name = 'v_nation_region' %}

{{ sat_template(sat_columns, stg_columns1, sat_pk)}}

{% if is_incremental() %}

(select
 {{stg_columns2}}
from {{ref(stg_name)}} as a
left join {{this}} as c on a.{{sat_pk}}=c.{{sat_pk}} and c.{{sat_pk}} is null) as b) as stg
where stg.{{sat_pk}} not in (select {{sat_pk}} from {{this}}) and stg.LATEST is null

{% else %}

{{ref(stg_name)}} as b) as stg where stg.LATEST is null

{% endif %}