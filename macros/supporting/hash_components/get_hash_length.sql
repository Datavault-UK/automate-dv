/*
 * Copyright (c) Business Thinking Ltd. 2019-2023
 * This software includes code developed by the AutomateDV (f.k.a dbtvault) Team at Business Thinking Ltd. Trading as Datavault
 */

{%- macro get_hash_length(hash) -%}

    {%- if hash | lower == 'md5' -%}
        {%- do return(32) -%}
    {%- elif hash | lower == 'sha' -%}
        {%- do return(64) -%}
    {%- elif hash | lower == 'sha1' -%}
        {%- do return(40) -%}
    {%- else -%}
        {%- do return(32) -%}
    {%- endif -%}

{%- endmacro %}