{{config(materialized='incremental', schema='VLT', enabled=true, tags=['static', 'increment'])}}

{% set hub_columns = 'CAST(stg.ORDER_PK AS BINARY(16)) AS ORDER_PK, CAST(stg.ORDERKEY AS NUMBER(38,0)) AS ORDERKEY, CAST(stg.LOADDATE AS DATE) AS LOADDATE, CAST(stg.SOURCE AS VARCHAR(4)) AS SOURCE' %}
{% set stg_columns1 = 'b.ORDER_PK, b.ORDERKEY, b.LOADDATE, b.SOURCE' %}
{% set stg_columns2 = 'a.ORDER_PK, a.ORDERKEY, a.LOADDATE, a.SOURCE' %}
{% set hub_pk = 'ORDER_PK' %}
{% set stg_name = 'v_stg_orders' %}

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