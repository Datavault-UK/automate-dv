{%- macro hash(columns=none, alias=none, is_hashdiff=false) -%}

    {% if is_hashdiff is none %}
        {%- set is_hashdiff = false -%}
    {% endif %}

    {{- adapter.dispatch('hash', 'dbtvault')(columns=columns, alias=alias, is_hashdiff=is_hashdiff) -}}

{%- endmacro %}

{%- macro default__hash(columns, alias, is_hashdiff) -%}

{%- set concat_string = '||' -%}
{%- set null_placeholder_string = "^^" -%}

{%- set hash = var('hash', 'MD5') -%}

{#- Select hashing algorithm -#}
{%- if target.type == 'bigquery' -%}
    {%- if hash == 'MD5' -%}
        {%- set hash_alg = 'MD5' -%}
    {%- elif hash == 'SHA' -%}
        {%- set hash_alg = 'SHA256' -%}
    {%- endif -%}
    {%- set standardise = "NULLIF(UPPER(TRIM(CAST([EXPRESSION] AS STRING))), '')" %}
{%- elif target.type == 'snowflake' -%}
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
{%- endif -%}



{#- Alpha sort columns before hashing if a hashdiff -#}
{%- if is_hashdiff and dbtvault.is_list(columns) -%}
    {%- set columns = columns|sort -%}
{%- endif -%}

{#- If single column to hash -#}
{%- if target.type == 'bigquery' -%}
    {%- if columns is string -%}
        {%- set column_str = dbtvault.as_constant(columns) -%}
        {{- "CAST(UPPER(TO_HEX({}({}))) AS STRING) AS {}".format(hash_alg, standardise | replace('[EXPRESSION]', column_str), alias) | indent(4) -}}

    {#- Else a list of columns to hash -#}
    {%- else -%}
     {%- set all_null = [] -%}
        {%- if is_hashdiff -%}
            {{- "UPPER(TO_HEX({}(UPPER({})".format(hash_alg, dbtvault.concat_ws(list_to_concat, concat_string)) | indent(4) -}}
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

{%- elif target.type == 'snowflake' -%}
    {%- if columns is string -%}
        {%- set column_str = dbtvault.as_constant(columns) -%}
        {{- "CAST(({}({})) AS BINARY({})) AS {}".format(hash_alg, standardise | replace('[EXPRESSION]', column_str), hash_size, alias) | indent(4) -}}

    {#- Else a list of columns to hash -#}
    {%- else -%}
        {%- set all_null = [] -%}

        {%- if is_hashdiff -%}
            {{- "CAST({}(CONCAT_WS('{}',".format(hash_alg, concat_string) | indent(4) -}}
        {%- else -%}
            {{- "UPPER(TO_HEX({}(NULLIF(CONCAT(".format(hash_alg) | indent(4) -}}
        {%- endif -%}

        {%- for column in columns -%}

            {%- do all_null.append(null_placeholder_string) -%}

            {%- set column_str = dbtvault.as_constant(column) -%}
            {{- "\nIFNULL({}, '{}')".format(standardise | replace('[EXPRESSION]', column_str), null_placeholder_string) | indent(4) -}}
            {{- ",'{}',
            ".format(concat_string) if not loop.last -}}

            {%- if loop.last -%}

                {% if is_hashdiff %}
                    {{- "\n)) AS BINARY({})) AS {}".format(hash_size, alias) -}}
                {%- else -%}

                    {{- "\n), '{}')) AS BINARY({})) AS {}".format(all_null | join(""), hash_size, alias) -}}
                {%- endif -%}
            {%- else -%}

                {%- do all_null.append(concat_string) -%}

            {%- endif -%}

        {%- endfor -%}

    {%- endif -%}

{%- endif -%}

{%- endmacro -%}