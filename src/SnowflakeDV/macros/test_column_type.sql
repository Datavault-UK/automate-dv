{% macro test_column_type(model, table_name, column_name, type)%}

with validation as (
  select
    data_type
  from DV_PROTOTYPE_DB.INFORMATION_SCHEMA.COLUMNS
  where TABLE_NAME = '{{ table_name }}' and COLUMN_NAME = '{{ column_name }}'
)

select
  count(v.data_type)
from validation as v
where v.data_type <> '{{ type }}'

{% endmacro %}