{{ config(materialized='view', tag='bridge', schema='VLT', enabled=false)}}

select
  a.LINEITEM_PK
, b.LINEITEM_PART_SUPPLIER_PK
, b.SUPPLIER_PK
, d.SUPPLIERKEY_NATION_PK
, d.SUPPLIER_NATION_PK
, f.NATION_REGION_PK
, f.REGION_PK
, {{var("date")}} as LOADDATE
from {{ref('hub_lineitem')}} as a
left join {{ref('link_lineitem_part_supplier')}} as b ON a.LINEITEM_PK=b.LINEITEM_PK and a.PART_PK=b.PART_PK
left join {{ref('hub_supplier')}} as c ON b.SUPPLIER_PK=c.SUPPLIER_PK
left join {{ref('link_supplier_nation')}} as d ON c.SUPPLIER_PK=d.SUPPLIER_PK
left join {{ref('hub_nation')}} as e ON d.SUPPLIER_NATION_PK=e.NATION_PK
left join {{ref('link_nation_region')}} as f ON e.NATION_PK=f.NATION_PK
left join {{ref('hub_region')}} as g ON f.REGION_PK=g.REGION_PK