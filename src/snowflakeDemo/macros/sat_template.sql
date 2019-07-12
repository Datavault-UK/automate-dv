{% macro sat_template(sat_columns, stg_columns1, sat_pk) %}

select
 {{sat_columns}}
from (
select distinct
 {{stg_columns1}},
 lead(b.LOADDATE, 1) over(partition by b.{{sat_pk}} order by b.LOADDATE) as LATEST
from

{% endmacro %}