{{ config(materialized='view', schema='STAR', enabled=true, tags=['static', 'incremental']) }}

select
  a.SUPPLIER_PK as DIM_SUPPLIER_PK
, b.SUPPLIERKEY
, c.SUPPLIER_NAME
, c.SUPPLIER_ADDRESS
, c.SUPPLIER_PHONE
, c.SUPPLIER_ACCTBAL
, c.LOADDATE
from {{ref('v_br_lineitem')}} as a
inner join (select LEAD(LOADDATE, 1) OVER(PARTITION BY SUPPLIER_PK ORDER BY LOADDATE) as LATEST, *
from {{ref('hub_supplier')}}) as b on a.SUPPLIER_PK=b.SUPPLIER_PK and b.LATEST is null
inner join (select LEAD(LOADDATE, 1) OVER(PARTITION BY SUPPLIER_PK ORDER BY LOADDATE) as LATEST, *
from {{ref('sat_hub_supplier')}}) as c on b.SUPPLIER_PK=c.SUPPLIER_PK and c.LATEST is null