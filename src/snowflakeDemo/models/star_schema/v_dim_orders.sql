{{config(materialized='view', schema='STAR', enabled=true, tags=['static', 'incremental'])}}

select
  a.ORDER_PK AS DIM_ORDER_PK
, b.ORDERKEY
, c.ORDERSTATUS
, c.ORDERPRIORITY
, c.CLERK
, c.SHIPPRIORITY
, c.LOADDATE
from {{ref('v_br_lineitem')}} as a
inner join (select LEAD(LOADDATE, 1) OVER(PARTITION BY ORDER_PK ORDER BY LOADDATE) as LATEST, *
from {{ref('hub_orders')}}) as b on a.ORDER_PK=b.ORDER_PK and b.LATEST is null
inner join (select LEAD(LOADDATE, 1) OVER(PARTITION BY ORDER_PK ORDER BY LOADDATE) as LATEST, *
from {{ref('sat_hub_orders')}}) as c on c.ORDER_PK=b.ORDER_PK and c.LATEST is null