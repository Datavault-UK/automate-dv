{{ config(materialized='view', schema='STAR', enabled=true, tags=['static', 'incremental']) }}

select
  a.ORDER_PK
, a.CUSTOMER_PK
, a.PART_PK
, a.SUPPLIER_PK
, a.INVENTORY_PK
, c.ORDERDATE
, b.SHIPDATE
, b.COMMITDATE
, b.RECEIPTDATE
, b.QUANTITY
, b.EXTENDEDPRICE
, b.DISCOUNT
, b.TAX
, c.TOTALPRICE
, d.SUPPLYCOST
, e.PART_RETAILPRICE
from {{ref('v_br_lineitem')}} as a
inner join (select LEAD(LOADDATE, 1) OVER(PARTITION BY LINEITEM_PK ORDER BY LOADDATE) AS LATEST, *
from {{ref('sat_hub_lineitem')}}) as b on a.LINEITEM_PK=b.LINEITEM_PK and b.LATEST IS NULL
inner join (select LEAD(LOADDATE, 1) OVER(PARTITION BY ORDER_PK ORDER BY LOADDATE) AS LATEST, *
from {{ref('sat_hub_orders')}}) as c on a.ORDER_PK=c.ORDER_PK and c.LATEST IS NULL
inner join (select LEAD(LOADDATE, 1) OVER(PARTITION BY INVENTORY_PK ORDER BY LOADDATE) AS LATEST, *
from {{ref('sat_link_inventory')}}) as d on a.INVENTORY_PK=d.INVENTORY_PK and d.LATEST IS NULL
inner join (select LEAD(LOADDATE, 1) OVER(PARTITION BY PART_PK ORDER BY LOADDATE) AS LATEST, *
from {{ref('sat_hub_parts')}}) as e on a.PART_PK=e.PART_PK and e.LATEST IS NULL
