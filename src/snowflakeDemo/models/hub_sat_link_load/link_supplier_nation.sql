{{config(materialized='incremental', schema='VLT', enabled=true, tags='static')}}

{% set link_columns = 'CAST(stg.LINK_SUPPLIER_NATION_PK AS BINARY(16)) AS LINK_SUPPLIER_NATION_PK, CAST(stg.SUPPLIER_PK AS BINARY(16)) AS SUPPLIER_PK, CAST(stg.SUPPLIER_NATION_KEY_PK AS BINARY(16)) AS SUPPLIER_NATION_KEY_PK, CAST(stg.LOADDATE AS DATE) AS LOADDATE, CAST(stg.SOURCE AS VARCHAR(4)) AS SOURCE' %}
{% set stg_columns1 = 'b.LINK_SUPPLIER_NATION_PK, b.SUPPLIER_PK, b.SUPPLIER_NATION_KEY_PK, b.LOADDATE, b.SOURCE' %}
{% set stg_columns2 = 'a.LINK_SUPPLIER_NATION_PK, a.SUPPLIER_PK, a.SUPPLIER_NATION_KEY_PK, a.LOADDATE, a.SOURCE' %}
{% set link_pk = 'LINK_SUPPLIER_NATION_PK' %}
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