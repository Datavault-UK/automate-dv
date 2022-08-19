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

    {% for column in columns %}
        {%- set column_str = dbtvault.as_constant(column) -%}
        {%- set escaped_column_str = dbtvault.escape_column_names(column_str) -%}

        {%- set column_expression -%}
            IFNULL({{ standardise | replace('[EXPRESSION]', escaped_column_str) }}, '{{ null_placeholder_string}}')
        {%- endset -%}

        {%- do all_null.append(null_placeholder_string) -%}
        {%- do processed_columns.append(column_expression) -%}

    {% endfor %}

    CAST({{ hash_alg }}(NULLIF(
         {{ dbtvault.concat_ws(processed_columns) -}}
        , '{{ all_null | join(concat_string) }}')) AS {{ dbtvault.type_binary() }}
    ) AS {{ dbtvault.escape_column_names(alias) }}

{%- endif -%}

{%- endmacro -%}

{%- macro bigquery__hash(columns, alias, is_hashdiff) -%}

    {{ dbtvault.defualt__hash(columns=columns, alias=alias, is_hashdiff=is_hashdiff) }}

{%- endmacro -%}

{%- macro sqlserver__hash(columns, alias, is_hashdiff) -%}

    {{ dbtvault.defualt__hash(columns=columns, alias=alias, is_hashdiff=is_hashdiff) }}

{%- endmacro -%}
