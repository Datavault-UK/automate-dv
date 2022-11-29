{%- macro select_hash_alg(hash=hash) -%}

    {%- if hash | lower == 'md5' -%}
        {%- do return(dbtvault.hash_alg_md5()) -%}
    {%- elif hash | lower == 'sha' -%}
        {%- do return(dbtvault.hash_alg_sha256()) -%}
    {%- else -%}
        {%- do return(dbtvault.hash_alg_md5()) -%}
    {%- endif -%}

{%- endmacro %}

{#- MD5 -#}

{%- macro hash_alg_md5() -%}

    {{- adapter.dispatch('hash_alg_md5', 'dbtvault')() -}}

{%- endmacro %}

{% macro default__hash_alg_md5() -%}

    {% do return(dbtvault.cast_binary('MD5_BINARY([PLACEHOLDER])', quote=false)) %}

{% endmacro %}

{% macro bigquery__hash_alg_md5() -%}

    {% do return(dbtvault.cast_binary('MD5([PLACEHOLDER])', quote=false)) %}

{% endmacro %}

{% macro sqlserver__hash_alg_md5() -%}

    {% do return(dbtvault.cast_binary("HASHBYTES('MD5', [PLACEHOLDER])", quote=false)) %}

{% endmacro %}

{% macro postgres__hash_alg_md5() -%}

    {% do return(dbtvault.cast_binary('UPPER(MD5([PLACEHOLDER]))', quote=false)) %}

{% endmacro %}

{% macro databricks__hash_alg_md5() -%}

    {% do return(dbtvault.cast_binary('UPPER(MD5([PLACEHOLDER]))', quote=false)) %}

{% endmacro %}


{#- SHA256 -#}


{%- macro hash_alg_sha256() -%}

    {{- adapter.dispatch('hash_alg_sha256', 'dbtvault')() -}}

{%- endmacro %}

{% macro default__hash_alg_sha256() -%}

    {% do return(dbtvault.cast_binary('SHA2_BINARY([PLACEHOLDER])', quote=false)) %}

{% endmacro %}

{% macro sqlserver__hash_alg_sha256() -%}

    {% do return(dbtvault.cast_binary("HASHBYTES('SHA2_256', [PLACEHOLDER])", quote=false)) %}

{% endmacro %}

{% macro postgres__hash_alg_sha256() -%}
    {#- * MD5 is simple function call to md5(val) -#}
    {#- * SHA256 needs input cast to BYTEA and then its BYTEA result encoded as hex text output -#}
    {#-   e.g. ENCODE(SHA256(CAST(val AS BYTEA)), 'hex') -#}
    {#- Ref: https://www.postgresql.org/docs/11/functions-binarystring.html  -#}

    {% do return("UPPER(ENCODE(SHA256(CAST([PLACEHOLDER] AS {})), 'hex'))".format(dbtvault.type_binary())) %}

{% endmacro %}

{% macro databricks__hash_alg_sha256() -%}

    {% do return('UPPER(SHA2([PLACEHOLDER], 256))') %}

{% endmacro %}
