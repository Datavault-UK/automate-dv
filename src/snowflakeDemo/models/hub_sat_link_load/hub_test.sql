{{config(materialized='incremental', schema='VLT', enabled=true)}}

{% set hub_columns = 'stg.CUSTOMER_PK, stg.CUSTOMERKEY, stg.LOADDATE, stg.SOURCE' %}
{% set stg_columns1 = 'b.CUSTOMER_PK, b.CUSTOMERKEY, b.LOADDATE, b.SOURCE' %}
{% set stg_columns2 = 'a.CUSTOMER_PK, a.CUSTOMERKEY, a.LOADDATE, a.SOURCE' %}
{% set hub_pk = 'CUSTOMER_PK' %}
{% set stg_name = 'v_stg_tpch_data' %}

{{ hub_template(hub_columns, stg_columns1, hub_pk) }}

{% if is_incremental() %}

(select
 {{stg_columns2}} 
from {{ref(stg_name)}} as a 
left join {{this}} as c on a.{{hub_pk}}=c.{{hub_pk}} and c.{{hub_pk}} is null) as b) as stg 
where stg.{{hub_pk}} not in (select {{hub_pk}} from {{this}}) and stg.FIRST_SEEN is null

{% else %}

{{ref(stg_name)}} as b) as stg where stg.FIRST_SEEN is null

{% endif %}