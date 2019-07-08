{% macro hub_template_increment(hub_columns, stg_columns1,  stg_columns2, hub_pk, stg_name) %}

 select
 {{hub_columns}}
 from (
 select
 {{stg_columns1}}, 
lead(b.LOADDATE, 1) over(partition by {{hub_pk}} order by b.loaddate) as LATEST
 from (
 select
 {{stg_columns2}}
 from {{ref(stg_name)}} as a
 left join {{this}} as c on a.{{hub_pk}}=c.{{hub_pk}} and c.{{hub_pk}} is null) as b) as stg
 where stg.{{hub_pk}} not in (select {{hub_pk}} from {{this}}) and stg.LATEST is null

{% endmacro %}