{{config(materialized='incremental', schema='VLT', enabled=true, tags='static')}}

{% set sat_columns = 'CAST(stg.SUPPLIER_HASHDIFF AS BINARY(16)) AS SUPPLIER_HASHDIFF, 
CAST(stg.SUPPLIER_PK AS BINARY(16)) AS SUPPLIER_PK, 
CAST(stg.SUPPLIER_NAME AS VARCHAR(25)) AS SUPPLIER_NAME, 
CAST(stg.SUPPLIER_ADDRESS AS VARCHAR(40)) AS SUPPLIER_ADDRESS, 
CAST(stg.SUPPLIER_PHONE AS VARCHAR(15)) AS SUPPLIER_PHONE, 
CAST(stg.SUPPLIER_ACCTBAL AS NUMBER(12,2)) AS SUPPLIER_ACCTBAL, 
CAST(stg.SUPPLIER_COMMENT AS VARCHAR(101)) AS SUPPLIER_COMMENT, 
CAST(stg.LOADDATE AS DATE) AS LOADDATE, 
CAST(stg.EFFECTIVE_FROM AS DATE) AS EFFECTIVE_FROM, 
CAST(stg.SOURCE AS VARCHAR(4)) AS SOURCE' %}
{% set stg_columns1 = 'b.SUPPLIER_HASHDIFF, 
b.SUPPLIER_PK, 
b.SUPPLIER_NAME, 
b.SUPPLIER_ADDRESS, 
b.SUPPLIER_PHONE, 
b.SUPPLIER_ACCTBAL, 
b.SUPPLIER_COMMENT, 
b.LOADDATE, 
b.EFFECTIVE_FROM, 
b.SOURCE' %}
{% set stg_columns2 = 'a.SUPPLIER_HASHDIFF, 
a.SUPPLIER_PK, 
a.SUPPLIER_NAME, 
a.SUPPLIER_ADDRESS, 
a.SUPPLIER_PHONE, 
a.SUPPLIER_ACCTBAL, 
a.SUPPLIER_COMMENT, 
a.LOADDATE, 
a.EFFECTIVE_FROM, 
a.SOURCE' %}
{% set sat_pk = 'SUPPLIER_HASHDIFF' %}
{% set stg_name = 'v_stg_inventory' %}

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