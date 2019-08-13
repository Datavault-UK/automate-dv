{{ config(materialized='view', schema='STAR', enabled=true, tags=['static', 'incremental']) }}

select
  a.CUSTOMER_PK
, b.CUSTOMERKEY
, c.CUSTOMER_NAME
, c.CUSTOMER_ADDRESS
, c.CUSTOMER_PHONE
, c.CUSTOMER_ACCBAL
, c.CUSTOMER_MKTSEGMENT
, c.LOADDATE
from {{ref('v_br_lineitem')}} as a
inner join (select LEAD(LOADDATE, 1) OVER(PARTITION BY CUSTOMER_PK ORDER BY LOADDATE) as LATEST, *
from {{ref('hub_customer')}}) as b on a.CUSTOMER_PK=b.CUSTOMER_PK and b.LATEST is null
inner join (select LEAD(LOADDATE, 1) OVER(PARTITION BY CUSTOMER_PK ORDER BY LOADDATE) as LATEST, *
from {{ref('sat_hub_customer')}}) as c on b.CUSTOMER_PK=c.CUSTOMER_PK and c.LATEST is null