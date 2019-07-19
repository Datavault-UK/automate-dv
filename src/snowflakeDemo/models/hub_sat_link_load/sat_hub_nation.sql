{{config(materialized='incremental', schema='VLT', enabled=true, tags='static')}}

{% set sat_columns = 'CAST(stg.NATION_HASHDIFF AS BINARY(16)) AS NATION_HASHDIFF, CAST(stg.NATION_PK AS BINARY(16)) AS NATION_PK, CAST(stg.NATION_NAME AS VARCHAR(25)) AS NATION_NAME, CAST(stg.NATION_COMMENT AS VARCHAR(152)) AS NATION_COMMENT, CAST(stg.LOADDATE AS DATE) AS LOADDATE, CAST(stg.EFFECTIVE_FROM AS DATE) AS EFFECTIVE_FROM, CAST(stg.SOURCE AS VARCHAR(4)) AS SOURCE' %}
{% set stg_columns1 = 'b.NATION_HASHDIFF, b.NATION_PK, b.NATION_NAME, b.NATION_COMMENT, b.LOADDATE, b.EFFECTIVE_FROM, b.SOURCE' %}
{% set stg_columns2 = 'a.NATION_HASHDIFF, a.NATION_PK, a.NATION_NAME, a.NATION_COMMENT, a.LOADDATE, a.EFFECTIVE_FROM, a.SOURCE' %}
{% set sat_pk = 'NATION_HASHDIFF' %}
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