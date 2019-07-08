{% macro test_macro(rand_column, stg_name) %}

select
  {{rand_column}}
from {{ref(stg_name)}} as stg

{% endmacro %}