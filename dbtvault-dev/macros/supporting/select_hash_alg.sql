{%- macro select_hash_alg(hash=hash) -%}

{%- if hash | lower == 'md5' -%}
    {%- do return(dbtvault.hash_alg_md5()) -%}
{%- elif hash | lower == 'sha' -%}
    {%- do return(dbtvault.hash_alg_sha256()) -%}
{%- else -%}
    {%- do return(dbtvault.hash_alg_md5()) -%}
{%- endif -%}

{%- endmacro %}


{%- macro hash_alg_md5() -%}

    {{- adapter.dispatch('hash_alg_md5', 'dbtvault')() -}}

{%- endmacro %}

{% macro default__hash_alg_md5() -%}

    {% do return('MD5_BINARY') %}

{% endmacro %}

{%- macro hash_alg_sha256() -%}

    {{- adapter.dispatch('hash_alg_sha256', 'dbtvault')() -}}

{%- endmacro %}

{% macro default__hash_alg_sha256() -%}

    {% do return('SHA2_BINARY') %}

{% endmacro %}
