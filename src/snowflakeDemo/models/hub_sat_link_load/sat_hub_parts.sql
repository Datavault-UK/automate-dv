{{config(materialized='incremental', schema='VLT', enabled=true)}}

{% set sat_columns = 'CAST(stg.PART_HASHDIFF AS BINARY(16)) AS PART_HASHDIFF, CAST(stg.PART_PK AS BINARY(16)) AS PART_PK, CAST(stg.PART_NAME AS VARCHAR(55)) AS PART_NAME, CAST(stg.MFGR AS VARCHAR(25)) AS MFGR, CAST(stg.PART_BRAND AS VARCHAR(10)) AS PART_BRAND, CAST(stg.PART_TYPE AS VARCHAR(25)) AS PART_TYPE, CAST(stg.PART_SIZE AS NUMBER(38,0)) AS PART_SIZE, CAST(stg.PART_CONTAINER AS VARCHAR(10)) AS PART_CONTAINER, CAST(stg.PART_RETAILPRICE AS NUMBER(12,2)) AS PART_RETAILPRICE, CAST(stg.PART_COMMENT AS VARCHAR(23)) AS PART_COMMENT, CAST(stg.LOADDATE AS DATE) AS LOADDATE, CAST(stg.EFFECTIVE_FROM AS DATE) AS EFFECTIVE_FROM, CAST(stg.SOURCE AS VARCHAR(4)) AS SOURCE' %}
{% set stg_columns1 = 'b.PART_HASHDIFF, b.PART_PK, b.PART_NAME, b.MFGR, b.PART_BRAND, b.PART_TYPE, b.PART_SIZE, b.PART_CONTAINER, b.PART_RETAILPRICE, b.PART_COMMENT, b.LOADDATE, b.EFFECTIVE_FROM, b.SOURCE' %}
{% set stg_columns2 = 'a.PART_HASHDIFF, a.PART_PK, a.PART_NAME, a.MFGR, a.PART_BRAND, a.PART_TYPE, a.PART_SIZE, a.PART_CONTAINER, a.PART_RETAILPRICE, a.PART_COMMENT, a.LOADDATE, a.EFFECTIVE_FROM, a.SOURCE' %}
{% set sat_pk = 'PART_HASHDIFF' %}
{% set stg_name = 'v_stg_tpch_data' %}

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