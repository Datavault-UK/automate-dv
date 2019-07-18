{{config(materialized='incremental', schema='VLT', enabled=true, tags=['static', 'increment'])}}

{% set link_columns = 'CAST(stg.ORDER_CUSTOMER_PK AS BINARY(16)) AS ORDER_CUSTOMER_PK, CAST(stg.ORDER_PK AS BINARY(16)) AS ORDER_PK, CAST(stg.CUSTOMER_PK AS BINARY(16)) AS CUSTOMER_PK, CAST(stg.LOADDATE AS DATE) AS LOADDATE, CAST(stg.SOURCE AS VARCHAR(4)) AS SOURCE' %}
{% set stg_columns1 = 'b.ORDER_CUSTOMER_PK, b.ORDER_PK, b.CUSTOMER_PK, b.LOADDATE, b.SOURCE' %}
{% set stg_columns2 = 'a.ORDER_CUSTOMER_PK, a.ORDER_PK, a.CUSTOMER_PK, a.LOADDATE, a.SOURCE' %}
{% set link_pk = 'ORDER_CUSTOMER_PK' %}
{% set stg_name = 'v_stg_orders' %}

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