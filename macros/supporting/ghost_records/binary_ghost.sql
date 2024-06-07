/*
 * Copyright (c) Business Thinking Ltd. 2019-2024
 * This software includes code developed by the AutomateDV (f.k.a dbtvault) Team at Business Thinking Ltd. Trading as Datavault
 */

{%- macro binary_ghost(alias, hash) -%}
    {%- set hash = hash | lower -%}

    {{ adapter.dispatch('binary_ghost', 'automate_dv')(alias=alias, hash=hash) }}
{%- endmacro -%}

{%- macro default__binary_ghost(alias, hash) -%}

    {%- if hash == 'md5' -%}
        {%- set zero_string_size = 32 %}
    {%- elif hash == 'sha' -%}
        {%- set zero_string_size = 64 %}
    {%- elif hash == 'sha1' -%}
        {%- set zero_string_size = 40 %}
    {%- else -%}
        {%- set zero_string_size = 32 %}
    {%- endif -%}

    {%- set zero_string = modules.itertools.repeat('0', zero_string_size) | join ('') -%}

    {{- automate_dv.cast_binary(column_str=zero_string, alias=alias, quote=true) -}}

{%- endmacro -%}

{%- macro bigquery__binary_ghost(alias, hash) -%}

    {%- if hash == 'md5' -%}
        {%- set zero_string_size = 32 %}
    {%- elif hash == 'sha' -%}
        {%- set zero_string_size = 64 %}
    {%- elif hash == 'sha1' -%}
        {%- set zero_string_size = 40 %}
    {%- else -%}
        {%- set zero_string_size = 32 %}
    {%- endif -%}

    {%- set enable_native_hashes = var('enable_native_hashes', false) -%}
    {%- set zero_string = modules.itertools.repeat('0', zero_string_size) | join ('') -%}

    {%- if enable_native_hashes -%}
        {%- set column_str = "FROM_HEX('{}')".format(zero_string) -%}
    {%- else -%}
        {%- set column_str = zero_string -%}
    {%- endif -%}

    {{- automate_dv.cast_binary(column_str=column_str, alias=alias, quote=false if enable_native_hashes else true) -}}

{%- endmacro -%}

{%- macro sqlserver__binary_ghost(alias, hash) -%}
    {%- if hash == 'md5' -%}
        {%- set zero_string_size = 16 %}
    {%- elif hash == 'sha' -%}
        {%- set zero_string_size = 32 %}
    {%- elif hash == 'sha1' -%}
        {%- set zero_string_size = 20 %}
    {%- else -%}
        {%- set zero_string_size = 16 %}
    {%- endif -%}

    CAST(REPLICATE(CAST(CAST('0' AS tinyint) AS BINARY({{ zero_string_size }})), {{ zero_string_size }}) AS BINARY({{ zero_string_size }}))

    {%- if alias %} AS {{ alias }} {%- endif -%}
{%- endmacro -%}
