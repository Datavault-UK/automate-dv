{{config(materialized='incremental', schema='VLT', enabled=true, tags=['static', 'incremental'])}}

{{ sat_template({{ var('hub_sat_link_load:link:sat_columns') }},
{{ var('hub_sat_link_load:link:stg_columns1') }},
{{ var('hub_sat_link_load:link:link_pk')) }}

{% if is_incremental() %}

(select
 {{ var('hub_sat_link_load:link:stg_columns2') }}
from {{ var('hub_sat_link_load:link:stg_name') }} as a
left join {{this}} as c on a.{{link_pk}}=c.{{ var('hub_sat_link_load:link:link_pk')) }} and c.{{ var('hub_sat_link_load:link:link_pk')) }} is null) as b) as stg
where stg.{{ var('hub_sat_link_load:link:link_pk')) }} not in (select {{ var('hub_sat_link_load:link:link_pk')) }} from {{this}}) and stg.FIRST_SEEN is null

{% else %}

{{ var('hub_sat_link_load:link:stg_name') }} as b) as stg where stg.FIRST_SEEN is null

{% endif %}