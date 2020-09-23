{%- macro derive_columns(source_relation=none, columns=none) -%}

    {{- adapter.dispatch('derive_columns', packages = ['dbtvault'])(source_relation=source_relation, columns=columns) -}}

{%- endmacro %}

{%- macro snowflake__derive_columns(source_relation=none, columns=none) -%}

{%- set exclude_columns = [] -%}
{%- set include_columns = [] -%}

{%- if source_relation is defined and source_relation is not none -%}
    {%- set source_model_cols = adapter.get_columns_in_relation(source_relation) -%}
{%- endif %}

{%- if columns is mapping and columns is not none -%}

    {#- Add aliases of provided columns to excludes and full SQL to includes -#}
    {%- for col in columns -%}

        {% set column_str = dbtvault.as_constant(columns[col]) %}

        {%- set _ = include_columns.append(column_str ~ " AS " ~ col) -%}
        {%- set _ = exclude_columns.append(col) -%}

    {%- endfor -%}

    {#- Add all columns from source_model relation -#}
    {%- if source_relation is defined and source_relation is not none -%}

        {%- for source_col in source_model_cols -%}
            {%- if source_col.column not in exclude_columns -%}
                {%- set _ = include_columns.append(source_col.column) -%}
            {%- endif -%}
        {%- endfor -%}

    {%- endif %}

    {#- Print out all columns in includes -#}
    {%- for col in include_columns -%}
        {{ col }}
        {%- if not loop.last -%},
{% endif -%}
    {%- endfor -%}

{%- elif columns is none and source_relation is not none -%}

    {#- Add all columns from source_model relation -#}
    {%- for source_col in source_model_cols -%}
        {%- if source_col.column not in exclude_columns -%}
            {%- set _ = include_columns.append(source_col.column) -%}
        {%- endif -%}
    {%- endfor -%}

    {#- Print out all columns in includes -#}
    {%- for col in include_columns -%}
        {{ col }}
        {{- ',\n' if not loop.last -}}

    {%- endfor -%}

{%- else -%}

{%- if execute -%}
{{ exceptions.raise_compiler_error("Invalid column configuration:
expected format: {source_relation: Relation, columns: 'column_mapping'}
got: {'source_relation': " ~ source_relation ~ ", 'columns': " ~ columns ~ "}") }}
{%- endif %}

{%- endif %}

{%- endmacro -%}