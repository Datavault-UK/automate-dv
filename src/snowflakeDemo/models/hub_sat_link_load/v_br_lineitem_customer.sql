{{ config(materialized='view', schema='VLT', enabled=true) }}

select
  i.LINEITEM_PK
, j.LINEITEM_ORDER_PK
, b.ORDER_PK
, b.ORDERKEY
, c.ORDER_CUSTOMER_PK
, c.CUSTOMER_PK
, d.CUSTOMERKEY
, e.LINK_CUSTOMER_NATION_PK
, e.CUSTOMER_NATION_PK as NATION_PK
, f.NATIONKEY
, g.NATION_REGION_PK
, g.REGION_PK
, h.REGIONKEY
, {{var("date")}} as LOADDATE
from {{ref('hub_lineitem')}} as i
left join {{ref('link_lineitem_orders')}} as j on i.LINEITEM_PK=j.LINEITEM_PK
left join {{ref('hub_orders')}} as b on j.ORDER_PK=b.ORDER_PK
left join {{ref('link_orders_customer')}} as c on b.ORDER_PK=c.ORDER_PK
left join {{ref('hub_customer')}} as d on c.CUSTOMER_PK=d.CUSTOMER_PK
left join {{ref('link_customer_nation')}} as e on d.CUSTOMER_PK=e.CUSTOMER_PK
left join {{ref('hub_nation')}} as f on e.CUSTOMER_NATION_PK=f.NATION_PK
left join {{ref('link_nation_region')}} as g on f.NATION_PK=g.NATION_PK
left join {{ref('hub_region')}} as h on g.REGION_PK=h.REGION_PK