{{config(materialized='incremental', schema='test_vlt', enabled=true, tags='feature')}}

select
  stg.CUSTOMER_PK,
  stg.CUSTOMERKEY,
  stg.LOADDATE,
  stg.SOURCE
from (
select distinct
  b.CUSTOMER_PK,
  b.CUSTOMERKEY,
  b.LOADDATE,
  lag(b.LOADDATE, 1) over(partition by b.CUSTOMERKEY order by b.loaddate) as FIRST_SEEN,
  b.SOURCE
from

{% if is_incremental() %}

(
select
  a.CUSTOMER_PK,
  a.CUSTOMERKEY,
  a.LOADDATE,
  a.SOURCE
from DV_PROTOTYPE_DB.SRC_TEST_STG.STG_CUSTOMER as a
left join {{this}} as c on a.CUSTOMER_PK=c.CUSTOMER_PK and c.CUSTOMER_PK is null) as b) as stg
where stg.CUSTOMER_PK not in (select CUSTOMER_PK from {{this}}) and stg.FIRST_SEEN is null

{% else %}

DV_PROTOTYPE_DB.SRC_TEST_STG.STG_CUSTOMER as b) as stg where stg.FIRST_SEEN is null

{% endif %}

order by stg.CUSTOMERKEY