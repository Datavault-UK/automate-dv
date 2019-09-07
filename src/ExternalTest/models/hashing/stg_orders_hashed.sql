{{ config(materialized='table', schema='STG', tags=['static', 'incremental'], enabled=true) }}

select
{{ snow_vault.md5_binary('ORDERKEY', 'ORDER_PK') }},
{{ snow_vault.md5_binary('PARTKEY', 'PART_PK') }},
{{ snow_vault.md5_binary('SUPPLIERKEY', 'SUPPLIER_PK') }},
{{ snow_vault.md5_binary('LINENUMBER', 'LINEITEM_PK') }},
{{ snow_vault.md5_binary(['PARTKEY', 'SUPPLIERKEY'], 'INVENTORY_PK') }},
{{ snow_vault.md5_binary(['LINENUMBER', 'PARTKEY', 'SUPPLIERKEY'], 'INVENTORY_ALLOCATION_PK') }},
{{ snow_vault.md5_binary(['COMMITDATE', 'DISCOUNT', 'EXTENDEDPRICE', 'LINESTATUS', 'LINE_COMMENT', 'QUANTITY', 'RECEIPTDATE', 'RETURNFLAG', 'SHIPDATE', 'SHIPINSTRUCT', 'SHIPMODE', 'TAX'], 'LINEITEM_HASHDIFF') }},
{{ snow_vault.md5_binary(['LINENUMBER', 'ORDERKEY'], 'LINEITEM_ORDER_PK') }},
{{ snow_vault.md5_binary(['CLERK', 'ORDERDATE', 'ORDERPRIORITY', 'ORDERSTATUS', 'ORDER_COMMENT', 'SHIPPRIORITY', 'TOTALPRICE'], 'ORDER_HASHDIFF') }},
{{ snow_vault.md5_binary(['CUSTOMERKEY', 'ORDERKEY'], 'ORDER_CUSTOMER_PK') }},
{{ snow_vault.md5_binary('CUSTOMERKEY', 'CUSTOMER_PK') }},
{{ snow_vault.md5_binary(['CUSTOMERKEY', 'CUSTOMER_NATIONKEY'], 'LINK_CUSTOMER_NATION_PK') }},
{{ snow_vault.md5_binary(['CUSTOMER_ACCBAL', 'CUSTOMER_ADDRESS', 'CUSTOMER_COMMENT', 'CUSTOMER_MKTSEGMENT', 'CUSTOMER_NAME', 'CUSTOMER_PHONE'], 'CUSTOMER_HASHDIFF') }},
{{ snow_vault.md5_binary('CUSTOMER_NATIONKEY', 'CUSTOMER_NATION_PK') }},
{{ snow_vault.md5_binary(['CUSTOMER_NATION_COMMENT', 'CUSTOMER_NATION_NAME'], 'CUSTOMER_NATION_HASHDIFF') }},
{{ snow_vault.md5_binary('CUSTOMER_REGIONKEY', 'CUSTOMER_REGION_PK') }},
{{ snow_vault.md5_binary(['CUSTOMER_NATIONKEY', 'CUSTOMER_REGIONKEY'], 'CUSTOMER_NATION_REGION_PK') }},
{{ snow_vault.md5_binary(['CUSTOMER_REGION_COMMENT', 'CUSTOMER_REGION_NAME'], 'CUSTOMER_REGION_HASHDIFF') }},
 *, {{var('date')}} AS LOADDATE, {{var('date')}} AS EFFECTIVE_FROM, 'TPCH' AS SOURCE FROM DV_PROTOTYPE_DB.SRC_STG.V_SRC_STG_ORDERS


