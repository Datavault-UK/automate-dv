{# string  -------------------------------------------------     #}

{%- macro type_string() -%}
  {{ adapter.dispatch('type_string', packages=['dbtvault_bq'])() }}
{%- endmacro -%}

{% macro default__type_string() %}
    {%- if execute -%}
        {{ exceptions.raise_compiler_error("The 'type_string' macro does not support your database engine. Supported Databases: Snowflake, Bigquery") }}
    {%- endif -%}
{% endmacro %}

{%- macro bigquery__type_string() -%}
    STRING
{%- endmacro -%}

{% macro snowflake__type_string() %}
    VARCHAR
{% endmacro %}
