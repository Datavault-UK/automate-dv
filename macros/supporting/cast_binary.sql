{%- macro cast_binary(column_str, alias=none) -%}
    {{ return(adapter.dispatch('cast_binary', 'dbtvault')(column_str=column_str, alias=alias)) }}
{%- endmacro -%}


{%- macro default__cast_binary(column_str, alias=none) -%}

    CAST('{{ column_str }}' AS {{ dbtvault.type_binary() }}) {% if alias %} AS {{ alias }} {%- endif %}

{%- endmacro -%}


{%- macro sqlserver__cast_binary(column_str, alias=none) -%}

    CONVERT({{ dbtvault.type_binary() }}, '{{ column_str }}', 2) {% if alias %} AS {{ alias }} {%- endif %}

{%- endmacro -%}

{%- macro bigquery__cast_binary(column_str, alias=none) -%}

    {{ dbtvault.default__cast_binary(column_str=column_str, alias=alias) }}

{%- endmacro -%}
