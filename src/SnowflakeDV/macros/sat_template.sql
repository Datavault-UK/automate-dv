{% macro sat_template(sat_columns, stg_columns, sat_pk) %}

select
 {{sat_columns}}
from (
select distinct
 {{stg_columns}},
 lead(b.LOADDATE, 1) over(partition by b.{{sat_pk}} order by b.LOADDATE) as LATEST
from

{% endmacro %}