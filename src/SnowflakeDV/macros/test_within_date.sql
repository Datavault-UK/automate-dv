{% macro test_within_date(model, date_column, max_date) %}

with validation as (
  select
    {{ date_column }} as date_col
  from {{ model }}
)

select
  count(v.date_col) as date_count
from validation as v
where v.date_col > {{ max_date }}

{% endmacro %}