{{ config(materialized='view', schema='VLT', enabled=false) }}

select
  a.LINEITEM_PK
, a.LINENUMBER
, b.LINEITEM_ORDER_PK
, b.ORDER_PK
, c.ORDERKEY
, d.ORDER_CUSTOMER_PK
, d.CUSTOMER_PK
, e.CUSTOMERKEY
, f.CUSTOMERKEY_NATION_PK
, f.CUSTOMER_NATIONKEY_PK as NATION_PK
, g.NATIONKEY
, h.NATION_REGION_PK
, h.REGION_PK
, i.REGIONKEY
, {{var("date")}} as LOADDATE
from {{ref('hub_lineitem')}} as a
left join {{ref('link_lineitem_orders')}} as b on a.LINEITEM_PK=b.LINEITEM_PK
left join {{ref('hub_orders')}} as c on b.ORDER_PK=c.ORDER_PK
left join {{ref('link_orders_customer')}} as d on c.ORDER_PK=d.ORDER_PK
left join {{ref('hub_customer')}} as e on d.CUSTOMER_PK=e.CUSTOMER_PK
left join {{ref('link_customer_nation')}} as f on e.CUSTOMER_PK=f.CUSTOMER_PK
left join {{ref('hub_nation')}} as g on f.CUSTOMER_NATIONKEY_PK=g.NATION_PK
left join {{ref('link_nation_region')}} as h on g.NATION_PK=h.NATION_PK
left join {{ref('hub_region')}} as i on h.REGION_PK=i.REGION_PK