{%- macro max_datetime() -%}

    {{- return(adapter.dispatch('max_datetime', 'dbtvault')()) -}}

{%- endmacro %}

{%- macro default__max_datetime() %}

    {% do return('9999-12-31 23:59:59.999999') %}

{% endmacro -%}

{%- macro sqlserver__max_datetime() %}

{# TODO Change to '9999-12-31 23:59:59.9999999' during DATETIME2 redevelopment #}
    {% do return('9999-12-31 23:59:59.996') %}

{% endmacro -%}

{%- macro bigquery__max_datetime() %}

{# TODO Should this be '9999-12-31 23:59:59.999999' ? #}
    {% do return('9999-12-31 23:59:59.996') %}

{% endmacro -%}