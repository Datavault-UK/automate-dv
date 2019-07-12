{{config(materialized='incremental', schema='VLT', enabled=true)}}

{% set link_columns = 'CAST(stg.LINEITEM_ORDER_PK AS BINARY(16)) AS LINEITEM_ORDER_PK, CAST(stg.LINEITEM_PK AS BINARY(16)) AS LINEITEM_PK, CAST(stg.ORDER_PK AS BINARY(16)) AS ORDER_PK, CAST(stg.LOADDATE AS DATE) AS LOADDATE, CAST(stg.SOURCE AS VARCHAR(4)) AS SOURCE' %}
{% set stg_columns1 = 'b.LINEITEM_ORDER_PK, b.LINEITEM_PK, b.ORDER_PK, b.LOADDATE, b.SOURCE' %}
{% set stg_columns2 = 'a.LINEITEM_ORDER_PK, a.LINEITEM_PK, a.ORDER_PK, a.LOADDATE, a.SOURCE' %}
{% set link_pk = 'LINEITEM_ORDER_PK' %}
{% set stg_name = 'v_stg_tpch_data' %}

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