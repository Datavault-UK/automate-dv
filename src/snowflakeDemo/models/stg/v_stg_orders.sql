{{ config(materialized='view', schema='STG', tags=['static', 'incremental'], enabled=true) }}

select
 {{ md5_binary('ORDERKEY', 'ORDER_PK') }}, 
{{ md5_binary('PARTKEY', 'PART_PK') }}, 
{{ md5_binary('SUPPLIERKEY', 'SUPPLIER_PK') }}, 
{{ md5_binary('LINENUMBER', 'LINEITEM_PK') }}, 
{{ md5_binary_concat(['PARTKEY', 'SUPPLIERKEY'], 'INVENTORY_PK') }}, 
{{ md5_binary_concat(['LINENUMBER', 'PARTKEY', 'SUPPLIERKEY'], 'INVENTORY_ALLOCATION_PK') }}, 
{{ md5_binary_concat(['COMMITDATE', 'DISCOUNT', 'EXTENDEDPRICE', 'LINESTATUS', 'LINE_COMMENT', 'QUANTITY', 'RECEIPTDATE', 'RETURNFLAG', 'SHIPDATE', 'SHIPINSTRUCT', 'SHIPMODE', 'TAX'], 'LINEITEM_HASHDIFF') }}, 
{{ md5_binary_concat(['LINENUMBER', 'ORDERKEY'], 'LINEITEM_ORDER_PK') }}, 
{{ md5_binary_concat(['CLERK', 'ORDERDATE', 'ORDERPRIORITY', 'ORDERSTATUS', 'ORDER_COMMENT', 'SHIPPRIORITY', 'TOTALPRICE'], 'ORDER_HASHDIFF') }}, 
{{ md5_binary_concat(['CUSTOMERKEY', 'ORDERKEY'], 'ORDER_CUSTOMER_PK') }}, 
{{ md5_binary('CUSTOMERKEY', 'CUSTOMER_PK') }}, 
{{ md5_binary_concat(['CUSTOMERKEY', 'CUSTOMER_NATIONKEY'], 'LINK_CUSTOMER_NATION_PK') }}, 
{{ md5_binary_concat(['CUSTOMER_ACCBAL', 'CUSTOMER_ADDRESS', 'CUSTOMER_COMMENT', 'CUSTOMER_MKTSEGMENT', 'CUSTOMER_NAME', 'CUSTOMER_PHONE'], 'CUSTOMER_HASHDIFF') }}, 
{{ md5_binary('CUSTOMER_NATIONKEY', 'CUSTOMER_NATION_PK') }}, 
{{ md5_binary_concat(['CUSTOMER_NATION_COMMENT', 'CUSTOMER_NATION_NAME'], 'CUSTOMER_NATION_HASHDIFF') }}, 
{{ md5_binary('CUSTOMER_REGIONKEY', 'CUSTOMER_REGION_PK') }}, 
{{ md5_binary_concat(['CUSTOMER_NATIONKEY', 'CUSTOMER_REGIONKEY'], 'CUSTOMER_NATION_REGION_PK') }}, 
{{ md5_binary_concat(['CUSTOMER_REGION_COMMENT', 'CUSTOMER_REGION_NAME'], 'CUSTOMER_REGION_HASHDIFF') }},
 *, {{var('date')}} AS LOADDATE, {{var('date')}} AS EFFECTIVE_FROM, 'TPCH' AS SOURCE FROM {{ref('v_src_stg_orders')}}