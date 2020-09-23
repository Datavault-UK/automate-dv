{%- macro hash(columns=none, alias=none, is_hashdiff=false) -%}

    {% if is_hashdiff is none %}
        {%- set is_hashdiff = false -%}
    {% endif %}

    {{- adapter.dispatch('hash', packages = ['dbtvault'])(columns=columns, alias=alias, is_hashdiff=is_hashdiff) -}}

{%- endmacro %}

{%- macro snowflake__hash(columns, alias, is_hashdiff) -%}

{%- set hash = var('hash', 'MD5') -%}

{#- Select hashing algorithm -#}
{%- if hash == 'MD5' -%}
    {%- set hash_alg = 'MD5_BINARY' -%}
    {%- set hash_size = 16 -%}
{%- elif hash == 'SHA' -%}
    {%- set hash_alg = 'SHA2_BINARY' -%}
    {%- set hash_size = 32 -%}
{%- else -%}
    {%- set hash_alg = 'MD5_BINARY' -%}
    {%- set hash_size = 16 -%}
{%- endif -%}

{%- set standardise = "NULLIF(UPPER(TRIM(CAST([EXPRESSION] AS VARCHAR))), '')" %}

{#- Alpha sort columns before hashing if a hashdiff -#}
{%- if is_hashdiff and columns is iterable and columns is not string -%}
    {%- set columns = columns|sort -%}
{%- endif -%}

{#- If single column to hash -#}
{%- if columns is string -%}
    {%- set column_str = dbtvault.as_constant(columns) -%}
    CAST(({{ hash_alg }}({{ standardise | replace('[EXPRESSION]', column_str) }})) AS BINARY({{ hash_size }})) AS {{ alias }}

{#- Else a list of columns to hash -#}
{%- else -%}

CAST({{ hash_alg }}(CONCAT(

{%- for column in columns %}

{%- set column_str = dbtvault.as_constant(column) -%}

{%- if not loop.last %}
    IFNULL({{ standardise | replace('[EXPRESSION]', column_str) }}, '^^'), '||',
{%- else %}
    IFNULL({{ standardise | replace('[EXPRESSION]', column_str) }}, '^^') ))
AS BINARY({{ hash_size }})) AS {{ alias }}
{%- endif -%}

{%- endfor -%}
{%- endif -%}

{%- endmacro -%}

