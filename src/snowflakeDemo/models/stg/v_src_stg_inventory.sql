{{ config(materilaized='view', schema='STG', tags='static', enabled=true) }}

select
 a.*
from {{ref('v_src_inventory')}} as a
