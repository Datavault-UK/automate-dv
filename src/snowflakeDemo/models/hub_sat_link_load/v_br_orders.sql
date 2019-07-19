{{ config(materialized='view', schema='VLT', enabled=true) }}

select
  a.LINEITEM_PK
, b.LINEITEM_ORDER_PK
, b.ORDER_PK
, {{var("date")}} as LOADDATE
from {{ref('hub_lineitem')}} as a
left join {{ref('link_lineitem_orders')}} as b on a.LINEITEM_PK=b.LINEITEM_PK
left join {{ref('hub_orders')}} as c on b.ORDER_PK=c.ORDER_PK