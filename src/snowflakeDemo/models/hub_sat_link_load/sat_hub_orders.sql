{{config(materialized='incremental', schema='VLT', enabled=true, tags=['static', 'increment'])}}

{% set sat_columns = 'CAST(stg.ORDER_HASHDIFF AS BINARY(16)) AS ORDER_HASHDIFF, CAST(stg.ORDER_PK AS BINARY(16)) AS ORDER_PK, CAST(stg.ORDERSTATUS AS VARCHAR(1)) AS ORDERSTATUS, CAST(stg.TOTALPRICE AS NUMBER(12,2)) AS TOTALPRICE, CAST(stg.ORDERDATE AS DATE) AS ORDERDATE, CAST(stg.ORDERPRIORITY AS VARCHAR(15)) AS ORDERPRIORITY, CAST(stg.CLERK AS VARCHAR(15)) AS CLERK, CAST(stg.SHIPPRIORITY AS NUMBER(38,0)) AS SHIPPRIORITY, CAST(stg.ORDER_COMMENT AS VARCHAR(79)) AS ORDER_COMMENT, CAST(stg.LOADDATE AS DATE) AS LOADDATE, CAST(stg.EFFECTIVE_FROM AS DATE) AS EFFECTIVE_FROM, CAST(stg.SOURCE AS VARCHAR(4)) AS SOURCE' %}
{% set stg_columns1 = 'b.ORDER_HASHDIFF, b.ORDER_PK, b.ORDERSTATUS, b.TOTALPRICE, b.ORDERDATE, b.ORDERPRIORITY, b.CLERK, b.SHIPPRIORITY, b.ORDER_COMMENT, b.LOADDATE, b.EFFECTIVE_FROM, b.SOURCE' %}
{% set stg_columns2 = 'a.ORDER_HASHDIFF, a.ORDER_PK, a.ORDERSTATUS, a.TOTALPRICE, a.ORDERDATE, a.ORDERPRIORITY, a.CLERK, a.SHIPPRIORITY, a.ORDER_COMMENT, a.LOADDATE, a.EFFECTIVE_FROM, a.SOURCE' %}
{% set sat_pk = 'ORDER_HASHDIFF' %}
{% set stg_name = 'v_stg_orders' %}

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