{% macro current_timestamp() -%}
  {{ return(adapter.dispatch('current_timestamp', 'dbtvault')()) }}
{%- endmacro %}

{% macro default__current_timestamp() %}
    {{ dbt_utils.current_timestamp() }}
{% endmacro %}

{% macro sqlserver__current_timestamp() %}
    sysdatetime()
{% endmacro %}

{% macro current_timestamp_in_utc() -%}
  {{ return(adapter.dispatch('current_timestamp_in_utc', 'dbtvault')()) }}
{%- endmacro %}

{% macro default__current_timestamp_in_utc() %}
    {{dbt_utils.current_timestamp_in_utc()}}
{% endmacro %}

{% macro sqlserver__current_timestamp_in_utc() %}
    sysutcdatetime()
{% endmacro %}