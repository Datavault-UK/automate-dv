{{config(materialized='incremental', schema='VLT', enabled=true, tags=['static', 'incremental'])}}

{{ hub_template({{ var('hub_sat_link_load:hub:hub_columns') }},
{{ var('hub_sat_link_load:hub:stg_columns1') }},
{{ var('hub_sat_link_load:hub:hub_pk') }}) }}

{% if is_incremental() %}

(select
 {{ var('hub_sat_link_load:hub:stg_columns2') }}
from {{ var('hub_sat_link_load:hub:stg_name') }} as a
left join {{this}} as c on a.{{ var('hub_sat_link_load:hub:hub_pk') }}=c.{{ var('hub_sat_link_load:hub:hub_pk') }} and c.{{ var('hub_sat_link_load:hub:hub_pk') }} is null) as b) as stg
where stg.{{ var('hub_sat_link_load:hub:hub_pk') }} not in (select {{ var('hub_sat_link_load:hub:hub_pk') }} from {{this}}) and stg.FIRST_SEEN is null

{% else %}

{{ var('hub_sat_link_load:hub:stg_name') }} as b) as stg where stg.FIRST_SEEN is null

{% endif %}