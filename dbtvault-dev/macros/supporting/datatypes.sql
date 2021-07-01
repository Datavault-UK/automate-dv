{%- macro type_timestamp() -%}
  {{ return(adapter.dispatch('type_timestamp', packages = dbtvault.get_dbtvault_namespaces())()) }}
{%- endmacro -%}

{% macro default__type_timestamp() %}
    {{ dbt_utils.type_timestamp() }}
{% endmacro %}

{% macro sqlserver__type_timestamp() %}
    datetime
{% endmacro %}
