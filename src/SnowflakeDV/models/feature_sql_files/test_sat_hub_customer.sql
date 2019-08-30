{{config(materialized='incremental', schema='TEST_VLT', enabled=false, tags='feature')}}

select
  stg.HASHDIFF,
  stg.CUSTOMER_PK,
  stg.CUSTOMER_NAME,
  stg.CUSTOMER_PHONE,
  stg.LOADDATE,
  stg.EFFECTIVE_FROM,
  stg.SOURCE
from (
select distinct
  b.HASHDIFF,
  b.CUSTOMER_PK,
  b.CUSTOMER_NAME,
  b.CUSTOMER_PHONE,
  b.LOADDATE,
  lead(b.LOADDATE, 1) over(partition by b.HASHDIFF order by b.LOADDATE) as LATEST,
  b.EFFECTIVE_FROM,
  b.SOURCE
from

{% if is_incremental() %}

(
select
  a.HASHDIFF,
  a.CUSTOMER_PK,
  a.CUSTOMER_NAME,
  a.CUSTOMER_PHONE,
  a.LOADDATE,
  a.EFFECTIVE_FROM,
  a.SOURCE
from DV_PROTOTYPE_DB.SRC_TEST_STG.STG_CUSTOMER as a
left join {{this}} as c on a.HASHDIFF=c.HASHDIFF and c.HASHDIFF is null
) as b) as stg
where stg.HASHDIFF not in (select HASHDIFF from {{this}}) and stg.LATEST is null

{% else %}

DV_PROTOTYPE_DB.SRC_TEST_STG.STG_CUSTOMER as b) as stg
where stg.LATEST is null

{% endif %}