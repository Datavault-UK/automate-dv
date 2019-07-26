{{config(materialized='incremental', schema ='VLT', enabled=true, tags='static')}}

{% set link_columns = 'CAST(stg.INVENTORY_PK AS BINARY(16)) AS INVENTORY_PK, 
CAST(stg.SUPPLIER_PK AS BINARY(16)) AS SUPPLIER_PK, 
CAST(stg.PART_PK AS BINARY(16)) AS PART_PK, 
CAST(stg.LOADDATE AS DATE) AS LOADDATE, 
CAST(stg.SOURCE AS VARCHAR(4)) AS SOURCE' %}
{% set stg_columns1 = 'b.INVENTORY_PK, 
b.SUPPLIER_PK, 
b.PART_PK, 
b.LOADDATE, 
b.SOURCE' %}
{% set stg_columns2 = 'a.INVENTORY_PK, 
a.SUPPLIER_PK, 
a.PART_PK, 
a.LOADDATE, 
a.SOURCE' %}
{% set link_pk = 'INVENTORY_PK' %}
{% set stg_name = 'v_stg_inventory' %}

{{ link_template(link_columns, stg_columns1, link_pk)}}

{% if is_incremental() %}

(select
 {{stg_columns2}}
from {{ref(stg_name)}} as a
left join {{this}} as c on a.{{link_pk}}=c.{{link_pk}} and c.{{link_pk}} is null) as b) as stg
where stg.{{link_pk}} not in (select {{link_pk}} from {{this}}) and stg.FIRST_SEEN is null

{% else %}

{{ref(stg_name)}} as b) as stg where stg.FIRST_SEEN is null

{% endif %}