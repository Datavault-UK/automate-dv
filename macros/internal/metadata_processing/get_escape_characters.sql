/*
 * Copyright (c) Business Thinking Ltd. 2019-2023
 * This software includes code developed by the dbtvault Team at Business Thinking Ltd. Trading as Datavault
 */

{% macro get_escape_characters() -%}

    {%- set escape_char_left, escape_char_right = adapter.dispatch('get_escape_characters', 'dbtvault')() -%}

    {%- do return((var('escape_char_left', escape_char_left), var('escape_char_right', escape_char_right))) -%}

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
