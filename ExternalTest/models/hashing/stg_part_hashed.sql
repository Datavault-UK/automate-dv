{{ config(materialized='table', schema='STG', tags=['static', 'incremental'], enabled=true) }}

select
{{ snow_vault.md5_binary('SUPPLIERKEY', 'SUPP_PK') }},
{{ snow_vault.md5_binary('PARTKEY', 'PART_PK') }},
 *, {{var('date')}} AS LOADDATE, {{var('date')}} AS EFFECTIVE_FROM, 'TPCH' AS SOURCE FROM DV_PROTOTYPE_DB.SRC_STG.V_SRC_STG_INVENTORY



