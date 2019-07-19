{{ config(materialized='view', schema='VLT', enabled=true) }}

select
  a.LINEITEM_PK
, b.ORDER_PK
, e.CUSTOMER_PK
, c.SUPPLIER_PK
, c.PART_PK
, i.INVENTORY_PK
, {{var("date")}} as LOADDATE
from {{ref('hub_lineitem')}} as a
left join {{ref('link_lineitem_orders')}} as b on a.LINEITEM_PK=b.LINEITEM_PK
left join {{ref('link_inventory_allocation')}} as c on a.LINEITEM_PK=c.LINEITEM_PK
left join {{ref('hub_orders')}} as d on b.ORDER_PK=d.ORDER_PK
left join {{ref('link_orders_customer')}} as e on d.ORDER_PK=e.ORDER_PK
left join {{ref('hub_customer')}} as f on e.CUSTOMER_PK=f.CUSTOMER_PK
left join {{ref('hub_supplier')}} as g on c.SUPPLIER_PK=g.SUPPLIER_PK
left join {{ref('hub_parts')}} as h on c.PART_PK=h.PART_PK
left join {{ref('link_inventory')}} as i on g.SUPPLIER_PK=i.SUPPLIER_PK