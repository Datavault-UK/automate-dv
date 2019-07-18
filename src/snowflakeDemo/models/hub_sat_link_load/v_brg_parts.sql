{{ config(materialized='view', schema='VLT', enabled=false)}}

select
  a.LINEITEM_PK
, b.LINEITEM_PART_SUPPLIER_PK
, b.PART_PK
,
from {{ref('hub_lineitem')}} as a
left join {{ref('link_lineitem_part_supplier')}} as b on a.LINEITEM_PK=b.LINEITEM_PK
left join {{ref('hub_parts')}} as c on b.PART_PK=c.PART_PK