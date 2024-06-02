/*
 * Copyright (c) Business Thinking Ltd. 2019-2024
 * This software includes code developed by the AutomateDV (f.k.a dbtvault) Team at Business Thinking Ltd. Trading as Datavault
 */

{%- macro type_binary(for_dbt_compare) -%}
  {{- return(adapter.dispatch('type_binary', 'automate_dv')(for_dbt_compare=for_dbt_compare)) -}}
{%- endmacro -%}

{%- macro default__type_binary(for_dbt_compare=false) -%}

    {%- if for_dbt_compare -%}
        BINARY
    {%- else -%}
        {%- set selected_hash = var('hash', 'MD5') | lower -%}

        {%- if selected_hash == 'md5' -%}
            BINARY(16)
        {%- elif selected_hash == 'sha' -%}
            BINARY(32)
        {%- elif selected_hash == 'sha1' -%}
            BINARY(20)
        {%- else -%}
            BINARY(16)
        {%- endif -%}
    {%- endif -%}
{%- endmacro -%}

{%- macro bigquery__type_binary(for_dbt_compare=false) -%}
  {%- set enable_native_hashes = var('enable_native_hashes', false) -%}

  {%- if not enable_native_hashes -%}
    STRING
  {%- else -%}
    BYTES
  {%- endif -%}
{%- endmacro -%}

{%- macro postgres__type_binary(for_dbt_compare=false) -%}
    BYTEA
{%- endmacro -%}

{%- macro databricks__type_binary(for_dbt_compare=false) -%}
  {%- set enable_native_hashes = var('enable_native_hashes', false) -%}

  {%- if not enable_native_hashes -%}
    STRING
  {%- else -%}
    BINARY
  {%- endif -%}
{%- endmacro -%}