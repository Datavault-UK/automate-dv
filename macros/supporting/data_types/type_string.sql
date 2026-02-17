/*
 * Copyright (c) Business Thinking Ltd. 2019-2026
 * This software includes code developed by the AutomateDV (f.k.a dbtvault) Team at Business Thinking Ltd. Trading as Datavault
 */

{%- macro type_string() -%}
  {{- return(adapter.dispatch('type_string', 'automate_dv')()) -}}
{%- endmacro -%}

{%- macro default__type_string() -%}
    VARCHAR
{%- endmacro -%}

{%- macro bigquery__type_string() -%}
    STRING
{%- endmacro -%}

{%- macro sqlserver__type_string() -%}
    VARCHAR
{%- endmacro -%}

{%- macro databricks__type_string() -%}
    STRING
{%- endmacro -%}

{%- macro spark__type_string(is_hash=false, char_length=255) -%}
    {%- if is_hash -%}
        {%- if var('hash', 'MD5') | lower == 'md5' -%}
            VARCHAR(16)
        {%- elif var('hash', 'MD5') | lower == 'sha' -%}
            VARCHAR(32)
        {%- elif var('hash', 'MD5') | lower == 'sha1' -%}
            VARCHAR(20)
        {%- endif -%}
    {%- else -%}
        VARCHAR({{ char_length }})
    {%- endif -%}
{%- endmacro -%}
