/*
 * Copyright (c) Business Thinking Ltd. 2019-2023
 * This software includes code developed by the AutomateDV (f.k.a dbtvault) Team at Business Thinking Ltd. Trading as Datavault
 */

{% macro get_escape_characters() -%}

    {%- set escape_char_left, escape_char_right = adapter.dispatch('get_escape_characters', 'dbtvault')() -%}

    {%- if ((var('escape_char_left', escape_char_left) == '') and (var('escape_char_right', escape_char_right) == '')) -%}
        {%- do return((escape_char_left, escape_char_right)) -%}
    {%- elif var('escape_char_left', escape_char_left) == '' -%}
        {%- do return((escape_char_left, var('escape_char_right', escape_char_right))) -%}
    {%- elif var('escape_char_right', escape_char_right) == '' -%}
        {%- do return((var('escape_char_left', escape_char_left), escape_char_right)) -%}
    {%- else -%}
        {%- do return((var('escape_char_left', escape_char_left), var('escape_char_right', escape_char_right))) -%}
    {%- endif -%}

{%- endmacro %}

{%- macro snowflake__get_escape_characters() %}
    {%- do return (('"', '"')) -%}
{%- endmacro %}

{%- macro bigquery__get_escape_characters() %}
    {%- do return (('`', '`')) -%}
{%- endmacro %}

{%- macro sqlserver__get_escape_characters() %}
    {%- do return (('"', '"')) -%}
{%- endmacro %}

{%- macro databricks__get_escape_characters() %}
    {%- do return (('`', '`')) -%}
{%- endmacro %}

{%- macro postgres__get_escape_characters() %}
    {%- do return (('"', '"')) -%}
{%- endmacro %}
