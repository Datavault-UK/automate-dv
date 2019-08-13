{{ config(materialized='view', schema='STG', tags='static', enabled=true) }}

select
 {{ md5_binary('PARTKEY', 'PART_PK') }}, 
{{ md5_binary('SUPPLIERKEY', 'SUPPLIER_PK') }}, 
{{ md5_binary('SUPPLIER_NATION_KEY', 'SUPPLIER_NATION_KEY_PK') }}, 
{{ md5_binary('SUPPLIER_REGION_KEY', 'SUPPLIER_REGION_KEY_PK') }}, 
{{ md5_binary_concat(['PARTKEY', 'SUPPLIERKEY'], 'INVENTORY_PK') }}, 
{{ md5_binary_concat(['SUPPLIER_NATION_KEY', 'SUPPLIER_REGION_KEY'], 'LINK_SUPPLIER_NATION_REGION_PK') }}, 
{{ md5_binary_concat(['SUPPLIERKEY', 'SUPPLIER_NATION_KEY'], 'LINK_SUPPLIER_NATION_PK') }}, 
{{ md5_binary_concat(['AVAILQTY', 'PART_SUPPLY_COMMENT', 'SUPPLYCOST'], 'INVENTORY_HASHDIFF') }}, 
{{ md5_binary_concat(['PART_BRAND', 'PART_COMMENT', 'PART_CONTAINER', 'PART_MFGR', 'PART_NAME', 'PART_RETAILPRICE', 'PART_SIZE', 'PART_TYPE'], 'PART_HASHDIFF') }}, 
{{ md5_binary_concat(['SUPPLIER_ACCTBAL', 'SUPPLIER_ADDRESS', 'SUPPLIER_COMMENT', 'SUPPLIER_NAME', 'SUPPLIER_PHONE'], 'SUPPLIER_HASHDIFF') }}, 
{{ md5_binary_concat(['SUPPLIER_NATION_COMMENT', 'SUPPLIER_NATION_NAME'], 'SUPPLIER_NATION_HASHDIFF') }}, 
{{ md5_binary_concat(['SUPPLIER_REGION_COMMENT', 'SUPPLIER_REGION_NAME'], 'SUPPLIER_REGION_HASHDIFF') }},
 *, {{var('date')}} AS LOADDATE, {{var('date')}} AS EFFECTIVE_FROM, 'TPCH' AS SOURCE FROM {{ref('v_src_stg_inventory')}}