{{config(materialized='incremental', schema='VLT', enabled=true, tags=['static', 'increment'])}}

{% set link_columns = 'CAST(stg.LINK_CUSTOMER_NATION_PK AS BINARY(16)) AS LINK_CUSTOMER_NATION_PK, CAST(stg.CUSTOMER_PK AS BINARY(16)) AS CUSTOMER_PK, CAST(stg.CUSTOMER_NATION_PK AS BINARY(16)) AS CUSTOMER_NATION_PK, CAST(stg.LOADDATE AS DATE) AS LOADDATE, CAST(stg.SOURCE AS VARCHAR) AS SOURCE' %}
{% set stg_columns1 = 'b.LINK_CUSTOMER_NATION_PK, b.CUSTOMER_PK, b.CUSTOMER_NATION_PK, b.LOADDATE, b.SOURCE' %}
{% set stg_columns2 = 'a.LINK_CUSTOMER_NATION_PK, a.CUSTOMER_PK, a.CUSTOMER_NATION_PK, a.LOADDATE, a.SOURCE' %}
{% set link_pk = 'CUSTOMER_NATION_PK' %}
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