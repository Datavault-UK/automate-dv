{% macro hub_template_general(hub_columns, stg_columns1, hub_pk) %}

 select
 {{hub_columns}}
 from (
 select
 {{stg_columns1}},
lead(b.LOADDATE, 1) over(partition by {{hub_pk}} order by b.loaddate) as LATEST
 from


{% endmacro %}