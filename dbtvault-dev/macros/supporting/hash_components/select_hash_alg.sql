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

    {% do return('MD5_BINARY([PLACEHOLDER])') %}

{% endmacro %}

{% macro bigquery__hash_alg_md5() -%}

    {% do return('MD5([PLACEHOLDER])') %}

{% endmacro %}

{% macro postgres__hash_alg_md5() -%}

    {% do return('UPPER(MD5([PLACEHOLDER]))') %}

{% endmacro %}

{% macro databricks__hash_alg_md5() -%}

    {% do return('UPPER(MD5([PLACEHOLDER]))') %}

{% endmacro %}


{#- SHA256 -#}


{%- macro hash_alg_sha256() -%}

    {{- adapter.dispatch('hash_alg_sha256', 'dbtvault')() -}}

{%- endmacro %}

{% macro default__hash_alg_sha256() -%}

    {% do return('SHA2_BINARY') %}

{% endmacro %}

{% macro databricks__hash_alg_sha256() -%}

    {% do return('SHA2') %}

{% endmacro %}
