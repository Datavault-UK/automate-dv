/*
 * Copyright (c) Business Thinking Ltd. 2019-2023
 * This software includes code developed by the AutomateDV (f.k.a dbtvault) Team at Business Thinking Ltd. Trading as Datavault
 */

{%- macro escape_column_name(column) -%}

    {{- adapter.dispatch('escape_column_name', 'automate_dv')(column=column) -}}

{%- endmacro %}

{%- macro default__escape_column_name(column) -%}

    {# Do not escape a constant (single quoted) value #}
    {%- if column | first == "'" and column | last == "'" -%}
        {%- set escaped_column_name = column -%}
    {%- else -%}
        {%- set escape_char_left, escape_char_right = automate_dv.get_escape_characters() -%}

        {%- set escaped_column_name = escape_char_left ~ column | replace(escape_char_left, '') | replace(escape_char_right, '') | trim ~ escape_char_right -%}
    {%- endif -%}

    {%- do return(escaped_column_name) -%}

{%- endmacro -%}