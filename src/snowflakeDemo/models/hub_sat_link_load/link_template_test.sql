{{config(materialized='incremental', schema='VLT', enabled=true)}}

{% set link_columns = 'stg.CUSTOMERKEY_NATION_PK, stg.CUSTOMER_PK, stg.NATION_PK, stg.LOADDATE, stg.SOURCE' %}
{% set stg_columns1 = 'b.CUSTOMERKEY_NATION_PK, b.CUSTOMER_PK, b.CUSTOMER_NATIONKEY_PK as NATION_PK, b.LOADDATE, b.SOURCE' %}
{% set stg_columns2 = 'a.CUSTOMERKEY_NATION_PK, a.CUSTOMER_PK, a.CUSTOMER_NATIONKEY_PK, a.LOADDATE, a.SOURCE' %}
{% set link_pk = 'CUSTOMERKEY_NATION_PK' %}
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