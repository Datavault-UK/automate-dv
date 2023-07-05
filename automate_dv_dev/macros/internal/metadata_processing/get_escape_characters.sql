/*
 * Copyright (c) Business Thinking Ltd. 2019-2023
 * This software includes code developed by the AutomateDV (f.k.a dbtvault) Team at Business Thinking Ltd. Trading as Datavault
 */

{% macro get_escape_characters() -%}

    {%- set default_escape_char_left, default_escape_char_right = adapter.dispatch('get_escape_characters', 'automate_dv')() -%}

    {%- if ((var('escape_char_left', default_escape_char_left) == '') and (var('escape_char_right', default_escape_char_right) == '')) -%}
        {%- set warning_message = 'Invalid escape_char_left and escape_char_right value provided. ' +
                                  'Using platform defaults ({}{})'.format(default_escape_char_left, default_escape_char_right) -%}
        {%- set escape_chars = (default_escape_char_left, default_escape_char_right) -%}

    {%- elif var('escape_char_left', default_escape_char_left) == '' -%}
        {%- set warning_message = 'Invalid escape_char_left value provided. Using platform default ({})'.format(default_escape_char_left) -%}
        {%- set escape_chars = (default_escape_char_left, var('escape_char_right', default_escape_char_right)) -%}

    {%- elif var('escape_char_right', default_escape_char_right) == '' -%}
        {%- set warning_message = 'Invalid escape_char_right value provided. Using platform default ({})'.format(default_escape_char_right) -%}
        {%- set escape_chars = (var('escape_char_left', default_escape_char_left), default_escape_char_right) -%}

    {%- else -%}
       {%- set escape_chars = (var('escape_char_left', default_escape_char_left), var('escape_char_right', default_escape_char_right)) -%}
    {%- endif -%}

    {%- if execute and warning_message -%}
        {%- do exceptions.warn(warning_message) -%}
    {%- endif -%}

    {%- do return(escape_chars) -%}

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
