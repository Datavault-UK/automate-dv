{% macro standard(change_case=UPPER) %}
    {{ return(adapter.dispatch('standard', 'dbtvault')(change_case)) }}
{% endmacro %}

{%- macro default__standard(change_case='UPPER') -%}
    {% if change_case == 'UPPER' %}
        {{ return("NULLIF(UPPER(TRIM(CAST([EXPRESSION] AS VARCHAR))), '')") }}
    {% else %}
        {{ return("NULLIF(TRIM(CAST([EXPRESSION] AS VARCHAR)), '')") }}
    {% endif %}
{%- endmacro -%}