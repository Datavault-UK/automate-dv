{{config(materialized='incremental', schema='VLT', enabled=true)}}

{% set sat_columns = 'stg.CUSTOMER_HASHDIFF, stg.CUSTOMER_PK, stg.CUSTOMER_NAME, stg.CUSTOMER_PHONE, stg.LOADDATE, stg.EFFECTIVE_FROM, stg.SOURCE' %}
{% set stg_columns1 = 'b.CUSTOMER_HASHDIFF, b.CUSTOMER_PK, b.CUSTOMER_NAME, b.CUSTOMER_PHONE, b.LOADDATE, b.EFFECTIVE_FROM, b.SOURCE' %}
{% set stg_columns2 = 'a.CUSTOMER_HASHDIFF, a.CUSTOMER_PK, a.CUSTOMER_NAME, a.CUSTOMER_PHONE, a.LOADDATE, a.EFFECTIVE_FROM, a.SOURCE' %}
{% set sat_pk = 'CUSTOMER_HASHDIFF' %}
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