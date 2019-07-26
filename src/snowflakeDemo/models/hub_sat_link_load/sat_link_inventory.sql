{{config(materialized='incremental', schema='VLT', enabled=true, tags='static')}}

{% set sat_columns = 'CAST(stg.INVENTORY_HASHDIFF AS BINARY(16)) AS INVENTORY_HASHDIFF, 
CAST(stg.INVENTORY_PK AS BINARY(16)) AS INVENTORY_PK, 
CAST(stg.AVAILQTY AS NUMBER(38,0)) AS AVAILQTY, 
CAST(stg.SUPPLYCOST AS NUMBER(12,2)) AS SUPPLYCOST, 
CAST(stg.PART_SUPPLY_COMMENT AS VARCHAR(199)) AS PART_SUPPLY_COMMENT, 
CAST(stg.LOADDATE AS DATE) AS LOADDATE, 
CAST(stg.EFFECTIVE_FROM AS DATE) AS EFFECTIVE_FROM, 
CAST(stg.SOURCE AS VARCHAR(4)) AS SOURCE' %}
{% set stg_columns1 = 'b.INVENTORY_HASHDIFF, 
b.INVENTORY_PK, 
b.AVAILQTY, 
b.SUPPLYCOST, 
b.PART_SUPPLY_COMMENT, 
b.LOADDATE, 
b.EFFECTIVE_FROM, 
b.SOURCE' %}
{% set stg_columns2 = 'a.INVENTORY_HASHDIFF, 
a.INVENTORY_PK, 
a.AVAILQTY, 
a.SUPPLYCOST, 
a.PART_SUPPLY_COMMENT, 
a.LOADDATE, 
a.EFFECTIVE_FROM, 
a.SOURCE' %}
{% set sat_pk = 'INVENTORY_HASHDIFF' %}
{% set stg_name = 'v_stg_inventory' %}

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