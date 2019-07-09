{% macro link_template(link_columns, stg_columns1, link_pk) %}

select
 {{link_columns}}
from (
select
 {{stg_columns1}},
 lag(b.LOADDATE, 1) over(partition by {{link_pk}} order by b.LOADDATE) as FIRST_SEEN
from

{% endmacro %}