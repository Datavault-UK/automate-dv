/*
 * Copyright (c) Business Thinking Ltd. 2019-2023
 * This software includes code developed by the AutomateDV (f.k.a dbtvault) Team at Business Thinking Ltd. Trading as Datavault
 */

{%- macro select_hash_alg(hash) -%}

    {%- set available_hash_algorithms = ['md5', 'sha', 'sha1'] -%}

    {%- if execute and hash | lower not in available_hash_algorithms %}
        {%- do exceptions.warn("Configured hash ('{}') not recognised. Must be one of: {} (case insensitive). Defaulting to MD5 hashing.".format(hash | lower, available_hash_algorithms | join(', '))) -%}
    {%- endif -%}

    {%- if hash | lower == 'md5' -%}
        {%- do return(automate_dv.hash_alg_md5()) -%}
    {%- elif hash | lower == 'sha' -%}
        {%- do return(automate_dv.hash_alg_sha256()) -%}
    {%- elif hash | lower == 'sha1' -%}
        {%- do return(automate_dv.hash_alg_sha1()) -%}
    {%- else -%}
        {%- do return(automate_dv.hash_alg_md5()) -%}
    {%- endif -%}

{%- endmacro %}

{#- MD5 -#}

{%- macro hash_alg_md5() -%}

    {{- adapter.dispatch('hash_alg_md5', 'automate_dv')() -}}

{%- endmacro %}

{% macro default__hash_alg_md5() -%}

    {% do return(automate_dv.cast_binary('MD5_BINARY([HASH_STRING_PLACEHOLDER])', quote=false)) %}

{% endmacro %}

{% macro bigquery__hash_alg_md5() -%}

    {% do return(automate_dv.cast_binary('UPPER(TO_HEX(MD5([HASH_STRING_PLACEHOLDER])))', quote=false)) %}

{% endmacro %}

{% macro sqlserver__hash_alg_md5() -%}

    {% do return(automate_dv.cast_binary("HASHBYTES('MD5', [HASH_STRING_PLACEHOLDER])", quote=false)) %}

{% endmacro %}

{% macro postgres__hash_alg_md5() -%}

    {% do return("DECODE(MD5([HASH_STRING_PLACEHOLDER]), 'hex')") %}

{% endmacro %}

{% macro databricks__hash_alg_md5() -%}

    {% do return(automate_dv.cast_binary('UPPER(MD5([HASH_STRING_PLACEHOLDER]))', quote=false)) %}

{% endmacro %}


{#- SHA256 -#}


{%- macro hash_alg_sha256() -%}

    {{- adapter.dispatch('hash_alg_sha256', 'automate_dv')() -}}

{%- endmacro %}

{% macro default__hash_alg_sha256() -%}

    {% do return(automate_dv.cast_binary('SHA2_BINARY([HASH_STRING_PLACEHOLDER])', quote=false)) %}

{% endmacro %}

{% macro bigquery__hash_alg_sha256() -%}

    {% do return(automate_dv.cast_binary('UPPER(TO_HEX(SHA256([HASH_STRING_PLACEHOLDER])))', quote=false)) %}

{% endmacro %}

{% macro sqlserver__hash_alg_sha256() -%}

    {% do return(automate_dv.cast_binary("HASHBYTES('SHA2_256', [HASH_STRING_PLACEHOLDER])", quote=false)) %}

{% endmacro %}

{% macro postgres__hash_alg_sha256() -%}
    {#- * MD5 is simple function call to md5(val) -#}
    {#- * SHA256 needs input cast to BYTEA and then its BYTEA result encoded as hex text output -#}
    {#- e.g. ENCODE(SHA256(CAST(val AS BYTEA)), 'hex') -#}
    {#- Ref: https://www.postgresql.org/docs/11/functions-binarystring.html  -#}

    {% do return("SHA256(CAST([HASH_STRING_PLACEHOLDER] AS BYTEA))")  %}

{% endmacro %}

{% macro databricks__hash_alg_sha256() -%}

    {% do return('UPPER(SHA2([HASH_STRING_PLACEHOLDER], 256))') %}

{% endmacro %}

{#- SHA1 -#}

{%- macro hash_alg_sha1() -%}

    {{- adapter.dispatch('hash_alg_sha1', 'automate_dv')() -}}

{%- endmacro %}

{% macro default__hash_alg_sha1() -%}

    {% do return(automate_dv.cast_binary('SHA1_BINARY([HASH_STRING_PLACEHOLDER])', quote=false)) %}

{% endmacro %}

{% macro bigquery__hash_alg_sha1() -%}

    {% do return(automate_dv.cast_binary('UPPER(TO_HEX(SHA1([HASH_STRING_PLACEHOLDER])))', quote=false)) %}

{% endmacro %}

{% macro sqlserver__hash_alg_sha1() -%}

    {% do return(automate_dv.cast_binary("HASHBYTES('SHA1', [HASH_STRING_PLACEHOLDER])", quote=false)) %}

{% endmacro %}

{% macro postgres__hash_alg_sha1() -%}

    {%- do exceptions.warn("Configured hash (SHA-1) is not supported on Postgres.
    Defaulting to hash 'MD5', alternatively configure your hash as 'SHA' for SHA256 hashing.") -%}
    {{ automate_dv.hash_alg_md5() }}

{% endmacro %}

{% macro databricks__hash_alg_sha1() -%}

    {% do return('UPPER(SHA1([HASH_STRING_PLACEHOLDER]))') %}

{% endmacro %}
