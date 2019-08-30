{{config(materialized='incremental', schema='TEST_VLT', enabled=true, tags='feature')}}

select
  stg.CUSTOMER_NATION_PK,
  stg.CUSTOMER_PK,
  stg.NATION_PK,
  stg.LOADDATE,
  stg.SOURCE
from (
select distinct
  b.CUSTOMER_NATION_PK,
  b.CUSTOMER_PK,
  b.NATION_PK,
  b.LOADDATE,
  lag(b.LOADDATE, 1) over(partition by b.CUSTOMER_NATION_PK order by b.LOADDATE) as FIRST_SEEN,
  b.SOURCE
from

{% if is_incremental() %}

(
select
  a.CUSTOMER_NATION_PK,
  a.CUSTOMER_PK,
  a.NATION_PK,
  a.LOADDATE,
  a.SOURCE
from DV_PROTOTYPE_DB.SRC_TEST_STG.STG_CUSTOMER as a
left join {{this}} as c on a.CUSTOMER_NATION_PK=c.CUSTOMER_NATION_PK and c.CUSTOMER_NATION_PK is null
order by a.CUSTOMERKEY) as b) as stg
where stg.CUSTOMER_NATION_PK not in (select CUSTOMER_NATION_PK from {{this}}) and stg.FIRST_SEEN is null

{% else %}

DV_PROTOTYPE_DB.SRC_TEST_STG.STG_CUSTOMER as b) as stg where stg.FIRST_SEEN is null

{% endif %}