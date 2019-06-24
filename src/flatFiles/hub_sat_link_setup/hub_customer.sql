{{ config(schema='VLT', materialized="table") }}

select
  stg.CUSTOMER_PK as CUSTOMER_PK,
	stg.CUSTOMERKEY as CUSTOMERKEY,
	stg.LOADDATE as LOADDATE,
	stg.SOURCE as SOURCE
from DV_PROTOTYPE_DB.STG.V_STG_CUSTOMER AS stg
where 1 = 0