{% macro current_timestamp() -%}
  {{ return(adapter.dispatch('current_timestamp', packages = dbtvault.get_dbtvault_namespaces())()) }}
{%- endmacro %}

{% macro default__current_timestamp() %}
    current_timestamp::{{dbt_utils.type_timestamp()}}
{% endmacro %}

{% macro redshift__current_timestamp() %}
    getdate()
{% endmacro %}

{% macro bigquery__current_timestamp() %}
    current_timestamp
{% endmacro %}

{% macro sqlserver__current_timestamp() %}
    getdate()
{% endmacro %}


{% macro current_timestamp_in_utc() -%}
  {{ return(adapter.dispatch('current_timestamp_in_utc', packages = dbtvault.get_dbtvault_namespaces())()) }}
{%- endmacro %}

{% macro default__current_timestamp_in_utc() %}
    {{dbtvault.current_timestamp()}}
{% endmacro %}

{% macro snowflake__current_timestamp_in_utc() %}
    convert_timezone('UTC', {{dbtvault.current_timestamp()}})::{{dbt_utils.type_timestamp()}}
{% endmacro %}

{% macro postgres__current_timestamp_in_utc() %}
    (current_timestamp at time zone 'utc')::{{dbt_utils.type_timestamp()}}
{% endmacro %}

{% macro sqlserver__current_timestamp_in_utc() %}
    {{dbtvault.current_timestamp()}}
{% endmacro %}