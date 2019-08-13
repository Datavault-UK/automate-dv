{{ config(materialized='view', schema='STAR', enabled=true, tags=['static', 'incremental']) }}

select
  a.INVENTORY_PK
, b.PARTKEY
, c.SUPPLIERKEY
, d.AVAILQTY
, d.LOADDATE
from {{ref('v_br_lineitem')}} as a
inner join (select LEAD(LOADDATE, 1) OVER(PARTITION BY PART_PK ORDER BY LOADDATE) as LATEST, *
from {{ref('hub_parts')}}) as b on a.PART_PK=b.PART_PK and b.LATEST is null
inner join (select LEAD(LOADDATE, 1) OVER(PARTITION BY SUPPLIER_PK ORDER BY LOADDATE) as LATEST, *
from {{ref('hub_supplier')}}) as c on a.SUPPLIER_PK=c.SUPPLIER_PK and c.LATEST is null
inner join (select LEAD(LOADDATE, 1) OVER(PARTITION BY INVENTORY_PK ORDER BY LOADDATE) as LATEST, *
from {{ref('sat_link_inventory')}}) as d on a.INVENTORY_PK=d.INVENTORY_PK and d.LATEST is null