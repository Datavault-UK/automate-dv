/*
 * Copyright (c) Business Thinking Ltd. 2019-2024
 * This software includes code developed by the AutomateDV (f.k.a dbtvault) Team at Business Thinking Ltd. Trading as Datavault
 */

{%- macro get_hash_string_length(hash) -%}

    {%- set enable_native_hashes = var('enable_native_hashes', false) -%}

    {%- if hash | lower == 'md5' -%}
        {%- set hash_length = 32 -%}
    {%- elif hash | lower == 'sha' -%}
        {%- set hash_length = 64 -%}
    {%- elif hash | lower == 'sha1' -%}
        {%- set hash_length = 40 -%}
    {%- else -%}
        {%- set hash_length = 32 -%}
    {%- endif -%}

    {%- do return(hash_length) -%}

{%- endmacro %}