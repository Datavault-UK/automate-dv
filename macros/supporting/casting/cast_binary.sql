/*
 * Copyright (c) Business Thinking Ltd. 2019-2023
 * This software includes code developed by the dbtvault Team at Business Thinking Ltd. Trading as Datavault
 */

{%- macro cast_binary(column_str, alias=none, quote=true) -%}
    {{ return(adapter.dispatch('cast_binary', 'dbtvault')(column_str=column_str, alias=alias, quote=quote)) }}
{%- endmacro -%}


{%- macro default__cast_binary(column_str, alias=none, quote=true) -%}

    {%- if quote -%}
        CAST('{{ column_str }}' AS {{ dbtvault.type_binary() }})
    {%- else -%}
        CAST({{ column_str }} AS {{ dbtvault.type_binary() }})
    {%- endif -%}

    {%- if alias %} AS {{ alias }} {%- endif -%}

{%- endmacro -%}


{%- macro sqlserver__cast_binary(column_str, alias=none, quote=true) -%}

    {%- if quote -%}
        CONVERT({{ dbtvault.type_binary() }}, '{{ column_str }}', 2)
    {%- else -%}
        CONVERT({{ dbtvault.type_binary() }}, {{ column_str }}, 2)
    {%- endif -%}

    {% if alias %} AS {{ alias }} {%- endif %}

{%- endmacro -%}

{%- macro bigquery__cast_binary(column_str, alias=none, quote=true) -%}

    {{ dbtvault.default__cast_binary(column_str=column_str, alias=alias, quote=quote) }}

{%- endmacro -%}
