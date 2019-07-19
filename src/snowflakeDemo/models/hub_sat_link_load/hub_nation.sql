{{config(materialized='incremental', schema='VLT', enabled=true, tags='static')}}

{% set hub_columns = 'CAST(stg.NATION_PK AS BINARY(16)) AS NATION_PK, CAST(stg.NATIONKEY AS NUMBER(38,0)) AS NATIONKEY, CAST(stg.LOADDATE AS DATE) AS LOADDATE, CAST(stg.SOURCE AS VARCHAR) AS SOURCE' %}
{% set stg_columns1 = 'b.NATION_PK, b.NATIONKEY, b.LOADDATE, b.SOURCE' %}
{% set stg_columns2 = 'a.NATION_PK, a.NATIONKEY, a.LOADDATE, a.SOURCE' %}
{% set hub_pk = 'NATION_PK' %}
{% set stg_name = 'v_nation_region' %}

{{ hub_template(hub_columns, stg_columns1, hub_pk) }}

{% if is_incremental() %}

(select
 {{stg_columns2}} 
from {{ref(stg_name)}} as a 
left join {{this}} as c on a.{{hub_pk}}=c.{{hub_pk}} and c.{{hub_pk}} is null) as b) as stg 
where stg.{{hub_pk}} not in (select {{hub_pk}} from {{this}}) and stg.FIRST_SEEN is null

{% else %}

{{ref(stg_name)}} as b) as stg where stg.FIRST_SEEN is null

{% endif %}