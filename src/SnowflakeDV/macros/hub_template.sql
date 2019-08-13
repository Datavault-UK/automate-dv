{% macro hub_template(hub_columns, stg_columns_b, hub_pk) %}

 select
{{hub_columns}}
 from (
 select distinct
 {{stg_columns_b}},
lag(b.LOADDATE, 1) over(partition by {{hub_pk}} order by b.loaddate) as FIRST_SEEN
 from

{% endmacro %}