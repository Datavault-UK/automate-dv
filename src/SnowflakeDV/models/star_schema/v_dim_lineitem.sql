{{ config(materialized='view', schema='STAR', enabled=true, tags=['static', 'incremental']) }}

select
  a.LINEITEM_PK
, b.LINENUMBER
, c.LINESTATUS
, c.RETURNFLAG
, c.SHIPINSTRUCT
, c.SHIPMODE
, c.LOADDATE
from {{ref('v_br_lineitem')}} as a
inner join (select LEAD(LOADDATE, 1) OVER(PARTITION BY LINEITEM_PK ORDER BY LOADDATE) as LATEST, *
from {{ref('hub_lineitem')}}) as b on a.LINEITEM_PK=b.LINEITEM_PK and b.LATEST is null
inner join (select LEAD(LOADDATE, 1) OVER(PARTITION BY LINEITEM_PK ORDER BY LOADDATE) as LATEST, *
from {{ref('sat_hub_lineitem')}}) as c on a.LINEITEM_PK=c.LINEITEM_PK and c.LATEST is null