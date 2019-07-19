{{config(materialized='incremental', schema='VLT', enabled=true, tags=['static', 'incremental'])}}

{% set sat_columns = 'CAST(stg.LINEITEM_HASHDIFF AS BINARY(16)) AS LINEITEM_HASHDIFF, CAST(stg.LINEITEM_PK AS BINARY(16)) AS LINEITEM_PK, CAST(stg.COMMITDATE AS DATE) AS COMMITDATE, CAST(stg.DISCOUNT AS NUMBER(12,2)) AS DISCOUNT, CAST(stg.EXTENDEDPRICE AS NUMBER(12,2)) AS EXTENDEDPRICE, CAST(stg.LINE_COMMENT AS VARCHAR(44)) AS LINE_COMMENT, CAST(stg.LINESTATUS AS VARCHAR(1)) AS LINESTATUS, CAST(stg.QUANTITY AS NUMBER(12,2)) AS QUANTITY, CAST(stg.RECEIPTDATE AS DATE) AS RECEIPTDATE, CAST(stg.RETURNFLAG AS VARCHAR(1)) AS RETURNFLAG, CAST(stg.SHIPDATE AS DATE) AS SHIPDATE, CAST(stg.SHIPINSTRUCT AS VARCHAR(25)) AS SHIPINSTRUCT, CAST(stg.SHIPMODE AS VARCHAR(10)) AS SHIPMODE, CAST(stg.TAX AS NUMBER(12,2)) AS TAX, CAST(stg.LOADDATE AS DATE) AS LOADDATE, CAST(stg.EFFECTIVE_FROM AS DATE) AS EFFECTIVE_FROM, CAST(stg.SOURCE AS VARCHAR(4)) AS SOURCE' %}
{% set stg_columns1 = 'b.LINEITEM_HASHDIFF, b.LINEITEM_PK, b.COMMITDATE, b.DISCOUNT, b.EXTENDEDPRICE, b.LINE_COMMENT, b.LINESTATUS, b.QUANTITY, b.RECEIPTDATE, b.RETURNFLAG, b.SHIPDATE, b.SHIPINSTRUCT, b.SHIPMODE, b.TAX, b.LOADDATE, b.EFFECTIVE_FROM, b.SOURCE' %}
{% set stg_columns2 = 'a.LINEITEM_HASHDIFF, a.LINEITEM_PK, a.COMMITDATE, a.DISCOUNT, a.EXTENDEDPRICE, a.LINE_COMMENT, a.LINESTATUS, a.QUANTITY, a.RECEIPTDATE, a.RETURNFLAG, a.SHIPDATE, a.SHIPINSTRUCT, a.SHIPMODE, a.TAX, a.LOADDATE, a.EFFECTIVE_FROM, a.SOURCE' %}
{% set sat_pk = 'LINEITEM_HASHDIFF' %}
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