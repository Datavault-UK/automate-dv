{# Copied from dbtvault feat/bigquery branch #}
{%- macro bigquery__hash(columns, alias, is_hashdiff) -%}

{%- set concat_string = '||' -%}
{%- set null_placeholder_string = "^^" -%}

{%- set hash = var('hash', 'MD5') -%}

{#- Select hashing algorithm -#}

{%- if hash == 'MD5' -%}
    {%- set hash_alg = 'MD5' -%}
{%- elif hash == 'SHA' -%}
    {%- set hash_alg = 'SHA256' -%}
{%- endif -%}

{%- set standardise = "NULLIF(UPPER(TRIM(CAST([EXPRESSION] AS STRING))), '')" %}

{#- Alpha sort columns before hashing if a hashdiff -#}
{%- if is_hashdiff and dbtvault.is_list(columns) -%}
    {%- set columns = columns|sort -%}
{%- endif -%}

{#- If single column to hash -#}
{%- if columns is string -%}
    {%- set column_str = dbtvault.as_constant(columns) -%}
    {{- "CAST(UPPER(TO_HEX({}({}))) AS STRING) AS {}".format(hash_alg, standardise | replace('[EXPRESSION]', column_str), alias) | indent(4) -}}

{#- Else a list of columns to hash -#}
{%- else -%}
 {%- set all_null = [] -%}
    {%- if is_hashdiff -%}
        {{- "UPPER(TO_HEX({}(CONCAT(".format(hash_alg) | indent(4) -}}

    {%- else -%}
        {{- "UPPER(TO_HEX({}(NULLIF(CONCAT(".format(hash_alg) | indent(4) -}}
    {%- endif -%}

    {%- for column in columns -%}

        {%- do all_null.append(null_placeholder_string) -%}

        {%- set column_str = dbtvault.as_constant(column) -%}
        {{- "\nIFNULL({}, '{}')".format(standardise | replace('[EXPRESSION]', column_str), null_placeholder_string) | indent(4) -}}
        {{- ",'{}',".format(concat_string) if not loop.last -}}
        {%- if loop.last -%}

            {% if is_hashdiff %}
                {{- "\n)))) AS {}".format(alias) -}}
            {%- else -%}
                {{- "\n), '{}')))) AS {}".format(all_null | join(""), alias) -}}
            {%- endif -%}
        {%- else -%}

            {%- do all_null.append(concat_string) -%}
        {%- endif -%}

    {%- endfor -%}

{%- endif -%}

{%- endmacro -%}