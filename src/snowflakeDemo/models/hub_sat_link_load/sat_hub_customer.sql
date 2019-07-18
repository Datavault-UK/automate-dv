{{config(materialized='incremental', schema='VLT', enabled=true, tags=['static', 'increment'])}}

{% set sat_columns = 'CAST(stg.CUSTOMER_HASHDIFF AS BINARY(16)) AS CUSTOMER_HASHDIFF, CAST(stg.CUSTOMER_PK AS BINARY(16)) AS CUSTOMER_PK, CAST(stg.CUSTOMER_NAME AS VARCHAR(25)) AS CUSTOMER_NAME, CAST(stg.CUSTOMER_ADDRESS AS VARCHAR(40)) AS CUSTOMER_ADDRESS, CAST(stg.CUSTOMER_PHONE AS VARCHAR(15)) AS CUSTOMER_PHONE, CAST(stg.CUSTOMER_ACCBAL AS NUMBER(12,2)) AS CUSTOMER_ACCBAL, CAST(stg.CUSTOMER_MKTSEGMENT AS VARCHAR(10)) AS CUSTOMER_MKTSEGMENT, CAST(stg.CUSTOMER_COMMENT AS VARCHAR(117)) AS CUSTOMER_COMMENT, CAST(stg.LOADDATE AS DATE) AS LOADDATE, CAST(stg.EFFECTIVE_FROM AS DATE) AS EFFECTIVE_FROM, CAST(stg.SOURCE AS VARCHAR(4)) AS SOURCE' %}
{% set stg_columns1 = 'b.CUSTOMER_HASHDIFF, b.CUSTOMER_PK, b.CUSTOMER_NAME, b.CUSTOMER_ADDRESS, b.CUSTOMER_PHONE, b.CUSTOMER_ACCBAL, b.CUSTOMER_MKTSEGMENT, b.CUSTOMER_COMMENT, b.LOADDATE, b.EFFECTIVE_FROM, b.SOURCE' %}
{% set stg_columns2 = 'a.CUSTOMER_HASHDIFF, a.CUSTOMER_PK, a.CUSTOMER_NAME, a.CUSTOMER_ADDRESS, a.CUSTOMER_PHONE, a.CUSTOMER_ACCBAL, a.CUSTOMER_MKTSEGMENT, a.CUSTOMER_COMMENT, a.LOADDATE, a.EFFECTIVE_FROM, a.SOURCE' %}
{% set sat_pk = 'CUSTOMER_HASHDIFF' %}
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