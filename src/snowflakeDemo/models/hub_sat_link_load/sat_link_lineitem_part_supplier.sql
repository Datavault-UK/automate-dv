{{config(materialized='incremental', schema='VLT', enabled=true)}}

{% set sat_columns = 'CAST(stg.PARTSUPP_HASHDIFF AS BINARY(16)) AS PARTSUPP_HASHDIFF, CAST(stg.LINEITEM_PART_SUPPLIER_PK AS BINARY(16)) AS LINEITEM_PART_SUPPLIER_PK, CAST(stg.AVAILQTY AS NUMBER(38,0)) AS AVAILQTY, CAST(stg.SUPPLYCOST AS NUMBER(12,2)) AS SUPPLYCOST, CAST(stg.PARTSUPPLY_COMMENT AS VARCHAR(199)) AS PARTSUPPLY_COMMENT, CAST(stg.LOADDATE AS DATE) AS LOADDATE, CAST(stg.EFFECTIVE_FROM AS DATE) AS EFFECTIVE_FROM, CAST(stg.SOURCE AS VARCHAR(4)) AS SOURCE' %}
{% set stg_columns1 = 'b.PARTSUPP_HASHDIFF, b.LINEITEM_PART_SUPPLIER_PK, b.AVAILQTY, b.SUPPLYCOST, b.PARTSUPPLY_COMMENT, b.LOADDATE, b.EFFECTIVE_FROM, b.SOURCE' %}
{% set stg_columns2 = 'a.PARTSUPP_HASHDIFF, a.LINEITEM_PART_SUPPLIER_PK, a.AVAILQTY, a.SUPPLYCOST, a.PARTSUPPLY_COMMENT, a.LOADDATE, a.EFFECTIVE_FROM, a.SOURCE' %}
{% set sat_pk = 'PARTSUPP_HASHDIFF' %}
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