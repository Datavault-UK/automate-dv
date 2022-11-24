{%- macro hash(columns=none, alias=none, is_hashdiff=false) -%}

    {%- if is_hashdiff is none -%}
        {%- set is_hashdiff = false -%}
    {%- endif -%}

    {{- adapter.dispatch('hash', 'dbtvault')(columns=columns, alias=alias, is_hashdiff=is_hashdiff) -}}

{%- endmacro %}

{%- macro default__hash(columns, alias, is_hashdiff) -%}

{%- set hash = var('hash', 'md5') -%}
{%- set concat_string = var('concat_string', '||') -%}
{%- set null_placeholder_string = var('null_placeholder_string', '^^') -%}

{%- set hash_alg = dbtvault.select_hash_alg(hash) -%}

{%- set standardise = "NULLIF(UPPER(TRIM(CAST([EXPRESSION] AS {}))), '')".format(dbtvault.type_string()) %}

{#- Alpha sort columns before hashing if a hashdiff -#}
{%- if is_hashdiff and dbtvault.is_list(columns) -%}
    {%- set columns = columns|sort -%}
{%- endif -%}

{#- If single column to hash -#}
{%- if columns is string -%}
    {%- set column_str = dbtvault.as_constant(columns) -%}
    {%- set escaped_column_str = dbtvault.escape_column_names(column_str) -%}

    CAST(({{ hash_alg }}({{ standardise | replace('[EXPRESSION]', escaped_column_str) }})) AS {{ dbtvault.type_binary() }}) AS {{ dbtvault.escape_column_names(alias) | indent(4) }}

{#- Else a list of columns to hash -#}
{%- else -%}
    {%- set all_null = [] -%}
    {%- set processed_columns = [] -%}

    {%- for column in columns -%}
        {%- set column_str = dbtvault.as_constant(column) -%}
        {%- set escaped_column_str = dbtvault.escape_column_names(column_str) -%}

        {%- set column_expression -%}
            IFNULL({{ standardise | replace('[EXPRESSION]', escaped_column_str) }}, '{{ null_placeholder_string}}')
        {%- endset -%}

        {%- do all_null.append(null_placeholder_string) -%}
        {%- do processed_columns.append(column_expression) -%}

    {% endfor -%}

    {% if not is_hashdiff -%}

    {%- set hashed_column -%}

    CAST({{ hash_alg }}(NULLIF(
     {{ dbtvault.concat_ws(processed_columns, separator=concat_string) -}} {{ ', ' -}}
       '{{ all_null | join(concat_string) }}')) AS {{ dbtvault.type_binary() }}{{ '\n' }}
     {{- '' -}}) AS {{ dbtvault.escape_column_names(alias) }}

    {%- endset -%}

    {%- else -%}

    {%- set hashed_column -%}

    CAST({{ hash_alg }}(
     {{ dbtvault.concat_ws(processed_columns, separator=concat_string) -}}
       ) AS {{ dbtvault.type_binary() }}{{ '\n' }}
     {{- '' -}}) AS {{ dbtvault.escape_column_names(alias) }}

    {%- endset -%}

    {%- endif -%}

    {{ hashed_column }}

{%- endif -%}

{%- endmacro -%}

{%- macro bigquery__hash(columns, alias, is_hashdiff) -%}

    {{ dbtvault.default__hash(columns=columns, alias=alias, is_hashdiff=is_hashdiff) }}

{%- endmacro -%}

{%- macro sqlserver__hash(columns, alias, is_hashdiff) -%}

    {{ dbtvault.default__hash(columns=columns, alias=alias, is_hashdiff=is_hashdiff) }}

{%- endmacro -%}


{%- macro postgres__hash(columns, alias, is_hashdiff) -%}

{%- set hash = var('hash', 'MD5') -%}
{%- set concat_string = var('concat_string', '||') -%}
{%- set null_placeholder_string = var('null_placeholder_string', '^^') -%}

{#- Select hashing algorithm -#}
{%- if hash == 'MD5' -%}
    {%- set hash_alg = 'MD5' -%}
{%- elif hash == 'SHA' -%}
    {%- set hash_alg = 'SHA256' -%}
{%- else -%}
    {%- set hash_alg = 'MD5' -%}
{%- endif -%}

{#- Select hashing expression (left and right sides) -#}
{#- * MD5 is simple function call to md5(val) -#}
{#- * SHA256 needs input cast to BYTEA and then its BYTEA result encoded as hex text output -#}
{#-   e.g. ENCODE(SHA256(CAST(val AS BYTEA)), 'hex') -#}
{#- Ref: https://www.postgresql.org/docs/11/functions-binarystring.html  -#}
{%- if hash_alg == 'MD5' -%}
    {%- set hash_expr_left = 'MD5(' -%}
    {%- set hash_expr_right = ')' -%}
{%- elif hash_alg == 'SHA256' -%}
    {%- set hash_expr_left = 'ENCODE(SHA256(CAST(' -%}
    {%- set hash_expr_right = " AS BYTEA)), 'hex')" -%}
{%- endif -%}

{%- set standardise = "NULLIF(UPPER(TRIM(CAST([EXPRESSION] AS VARCHAR))), '')" -%}

{#- Alpha sort columns before hashing if a hashdiff -#}
{%- if is_hashdiff and dbtvault.is_list(columns) -%}
    {%- set columns = columns|sort -%}
{%- endif -%}

{#- If single column to hash -#}
{%- if columns is string -%}
    {%- set column_str = dbtvault.as_constant(columns) -%}
    {%- if dbtvault.is_expression(column_str) -%}
        {%- set escaped_column_str = column_str -%}
    {%- else -%}
        {%- set escaped_column_str = dbtvault.escape_column_names(column_str) -%}
    {%- endif -%}

    {{- "CAST(UPPER({}{}{}) AS BYTEA) AS {}".format(hash_expr_left, standardise | replace('[EXPRESSION]', escaped_column_str), hash_expr_right, dbtvault.escape_column_names(alias)) | indent(4) -}}

{#- Else a list of columns to hash -#}
{%- else -%}
    {%- set all_null = [] -%}

    {%- if is_hashdiff -%}
        {{- "CAST(UPPER({}CONCAT_WS('{}',".format(hash_expr_left, concat_string) | indent(4) -}}
    {%- else -%}
        {{- "CAST(UPPER({}NULLIF(CONCAT_WS('{}',".format(hash_expr_left, concat_string) | indent(4) -}}
    {%- endif -%}

    {%- for column in columns -%}

        {%- do all_null.append(null_placeholder_string) -%}

        {%- set column_str = dbtvault.as_constant(column) -%}
        {%- if dbtvault.is_expression(column_str) -%}
            {%- set escaped_column_str = column_str -%}
        {%- else -%}
            {%- set escaped_column_str = dbtvault.escape_column_names(column_str) -%}
        {%- endif -%}

        {{- "\nCOALESCE({}, '{}')".format(standardise | replace('[EXPRESSION]', escaped_column_str), null_placeholder_string) | indent(4) -}}
        {{- "," if not loop.last -}}

        {%- if loop.last -%}

            {% if is_hashdiff %}
                {{- "\n){}) AS BYTEA) AS {}".format(hash_expr_right, dbtvault.escape_column_names(alias)) -}}
            {%- else -%}
                {{- "\n), '{}'){}) AS BYTEA) AS {}".format(all_null | join(""), hash_expr_right, dbtvault.escape_column_names(alias)) -}}
            {%- endif -%}
        {%- else -%}

            {%- do all_null.append(concat_string) -%}

        {%- endif -%}
    {%- endfor -%}

{%- endif -%}

{%- endmacro -%}

{%- macro databricks__hash(columns, alias, is_hashdiff) -%}

{%- set hash = var('hash', 'MD5') -%}
{%- set concat_string = var('concat_string', '||') -%}
{%- set null_placeholder_string = var('null_placeholder_string', '^^') -%}

{#- Select hashing algorithm -#}
{%- if hash == 'MD5' -%}
    {%- set hash_alg = 'MD5' -%}
{%- elif hash == 'SHA' -%}
    {%- set hash_alg = 'SHA2' -%}
    {%- set bit_length = 256 -%}
{%- else -%}
    {%- set hash_alg = 'MD5' -%}
{%- endif -%}

{%- set standardise = "NULLIF(UPPER(TRIM(CAST([EXPRESSION] AS STRING))), '')" %}

{#- Alpha sort columns before hashing if a hashdiff -#}
{%- if is_hashdiff and dbtvault.is_list(columns) -%}
    {%- set columns = columns|sort -%}
{%- endif -%}

{#- If single column to hash -#}
{%- if columns is string -%}
    {%- set column_str = dbtvault.as_constant(columns) -%}
    {%- if dbtvault.is_expression(column_str) -%}
        {%- set escaped_column_str = column_str -%}
    {%- else -%}
        {%- set escaped_column_str = dbtvault.escape_column_names(column_str) -%}
    {%- endif -%}

    {%- if hash_alg == "MD5" %}
        {{- "UPPER(MD5({})) AS {}".format(standardise | replace('[EXPRESSION]', escaped_column_str), dbtvault.escape_column_names(alias)) | indent(4) -}}
    {%- else %}
        {{- "UPPER(SHA2({}, {})) AS {}".format(standardise | replace('[EXPRESSION]', escaped_column_str), bit_length, dbtvault.escape_column_names(alias)) | indent(4) -}}
    {%- endif %}

{#- Else a list of columns to hash -#}
{%- else -%}
    {%- set all_null = [] -%}

    {%- if is_hashdiff -%}
        {%- if hash_alg == "MD5" %}
            {{- "UPPER(MD5(CONCAT_WS('{}',".format(concat_string) | indent(4) -}}
        {%- else %}
            {{- "UPPER(SHA2(CONCAT_WS('{}',".format(concat_string) | indent(4) -}}
        {%- endif %}

    {%- else -%}
        {%- if hash_alg == "MD5" %}
            {{- "UPPER(MD5(NULLIF(CONCAT_WS('{}',".format(concat_string) | indent(4) -}}
        {%- else %}
            {{- "UPPER(SHA2(NULLIF(CONCAT_WS('{}',".format(concat_string) | indent(4) -}}
        {%- endif %}
    {%- endif -%}

    {%- for column in columns -%}

        {%- do all_null.append(null_placeholder_string) -%}

        {%- set column_str = dbtvault.as_constant(column) -%}
        {%- if dbtvault.is_expression(column_str) -%}
            {%- set escaped_column_str = column_str -%}
        {%- else -%}
            {%- set escaped_column_str = dbtvault.escape_column_names(column_str) -%}
        {%- endif -%}
        {{- "\nIFNULL({}, '{}')".format(standardise | replace('[EXPRESSION]', escaped_column_str), null_placeholder_string) | indent(4) -}}
        {{- "," if not loop.last -}}

        {%- if loop.last -%}

            {% if is_hashdiff %}
                {%- if hash_alg == "MD5" %}
                    {{- "\n))) AS {}".format(dbtvault.escape_column_names(alias)) -}}
                {%- else %}
                    {{- "\n), {})) AS {}".format(bit_length, dbtvault.escape_column_names(alias)) -}}
                {%- endif %}
            {%- else -%}
                {%- if hash_alg == "MD5" %}
                    {{- "\n), '{}'))) AS {}".format(all_null | join(""), dbtvault.escape_column_names(alias)) -}}
                {%- else %}
                    {{- "\n), '{}'), {})) AS {}".format(all_null | join(""), bit_length, dbtvault.escape_column_names(alias)) -}}
                {%- endif %}

            {%- endif -%}
        {%- else -%}

            {%- do all_null.append(concat_string) -%}

        {%- endif -%}

    {%- endfor -%}

{%- endif -%}

{%- endmacro -%}
