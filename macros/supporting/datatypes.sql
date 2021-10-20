{%- macro type_timestamp() -%}
  {{ return(adapter.dispatch('type_timestamp', 'dbtvault')()) }}
{%- endmacro -%}

{% macro default__type_timestamp() %}
    {{ dbt_utils.type_timestamp() }}
{% endmacro %}