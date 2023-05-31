/*
 * Copyright (c) Business Thinking Ltd. 2019-2023
 * This software includes code developed by the AutomateDV (f.k.a dbtvault) Team at Business Thinking Ltd. Trading as Datavault
 */

{%- macro cast_binary(column_str, alias=none, quote=true) -%}
    {{ return(adapter.dispatch('cast_binary', 'automate_dv')(column_str=column_str, alias=alias, quote=quote)) }}
{%- endmacro -%}


{%- macro default__cast_binary(column_str, alias=none, quote=true) -%}

    {%- if quote -%}
        CAST('{{ column_str }}' AS {{ automate_dv.type_binary() }})
    {%- else -%}
        CAST({{ column_str }} AS {{ automate_dv.type_binary() }})
    {%- endif -%}

    {%- if alias %} AS {{ alias }} {%- endif -%}

{%- endmacro -%}


{%- macro sqlserver__cast_binary(column_str, alias=none, quote=true) -%}

    {%- if quote -%}
        CONVERT({{ automate_dv.type_binary() }}, '{{ column_str }}', 2)
    {%- else -%}
        CONVERT({{ automate_dv.type_binary() }}, {{ column_str }}, 2)
    {%- endif -%}

    {% if alias %} AS {{ alias }} {%- endif %}

{%- endmacro -%}

{%- macro bigquery__cast_binary(column_str, alias=none, quote=true) -%}

    {{ automate_dv.default__cast_binary(column_str=column_str, alias=alias, quote=quote) }}

{%- endmacro -%}
