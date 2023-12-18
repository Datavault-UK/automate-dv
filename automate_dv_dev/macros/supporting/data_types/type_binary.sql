/*
 * Copyright (c) Business Thinking Ltd. 2019-2023
 * This software includes code developed by the AutomateDV (f.k.a dbtvault) Team at Business Thinking Ltd. Trading as Datavault
 */

{%- macro type_binary() -%}
  {{- return(adapter.dispatch('type_binary', 'automate_dv')()) -}}
{%- endmacro -%}

{%- macro default__type_binary() -%}
    {%- if var('hash', 'MD5') | lower == 'md5' -%}
        BINARY(16)
    {%- elif var('hash', 'MD5') | lower == 'sha' -%}
        BINARY(32)
    {%- elif var('hash', 'MD5') | lower == 'sha1' -%}
        BINARY(20)
    {%- else -%}
        BINARY(16)
    {%- endif -%}
{%- endmacro -%}

{%- macro bigquery__type_binary() -%}
    STRING
{%- endmacro -%}

{%- macro postgres__type_binary() -%}
    BYTEA
{%- endmacro -%}

{%- macro databricks__type_binary() -%}
    STRING
{%- endmacro -%}