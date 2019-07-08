{% macro hub_template_first_run(hub_columns, stg_columns1, hub_pk, stg_name) %}

 select
{{hub_columns}}
 from (
 select
 {{stg_columns1}}, 
lead(b.LOADDATE, 1) over(partition by {{hub_pk}} order by b.loaddate) as LATEST
 from {{ref(stg_name)}} as b) as stg where stg.LATEST is null

 {% endmacro %}