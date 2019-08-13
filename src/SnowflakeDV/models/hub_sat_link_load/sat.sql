{{config(materialized='incremental', schema='VLT', enabled=true, tags='static')}}

{{ sat_template({{ var('hub_sat_link_load:sat:sat_columns') }},
{{ var('hub_sat_link_load:sat:stg_columns1') }},
{{ var('hub_sat_link_load:sat:sat_pk') }}) }}

{% if is_incremental() %}

(select
 {{ var('hub_sat_link_load:sat:stg_columns2') }}
from {{ var('hub_sat_link_load:sat:stg_name') }} as a
left join {{this}} as c on a.{{ var('hub_sat_link_load:sat:sat_pk') }}=c.{{ var('hub_sat_link_load:sat:sat_pk') }} and c.{{ var('hub_sat_link_load:sat:sat_pk') }} is null) as b) as stg
where stg.{{ var('hub_sat_link_load:sat:sat_pk') }} not in (select {{ var('hub_sat_link_load:sat:sat_pk') }} from {{this}}) and stg.LATEST is null

{% else %}

{{ var('hub_sat_link_load:sat:stg_name') }} as b) as stg where stg.LATEST is null

{% endif %}