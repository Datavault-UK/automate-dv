{{ config(materialized='view', schema='VLT', enabled=true) }}

select
  a.LINEITEM_PK
, b.PART_PK
, b.SUPPLIER_PK
, b.INVENTORY_ALLOCATION_PK
, e.SUPPLIER_NATION_KEY_PK
, e.LINK_SUPPLIER_NATION_PK
, g.REGION_PK
, g.NATION_REGION_PK
, {{var("date")}} as LOADDATE
from {{ref('hub_lineitem')}} as a
left join {{ref('link_inventory_allocation')}} as b on a.LINEITEM_PK=b.LINEITEM_PK
left join {{ref('hub_parts')}} as c on b.PART_PK=c.PART_PK
left join {{ref('hub_supplier')}} as d on b.SUPPLIER_PK=d.SUPPLIER_PK
left join {{ref('link_supplier_nation')}} as e on d.SUPPLIER_PK=e.SUPPLIER_PK
left join {{ref('hub_nation')}} as f on e.SUPPLIER_NATION_KEY_PK=f.NATION_PK
left join {{ref('link_nation_region')}} as g on f.NATION_PK=g.NATION_PK
left join {{ref('hub_region')}} as h on g.REGION_PK=h.REGION_PK