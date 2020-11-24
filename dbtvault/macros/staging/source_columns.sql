{%- macro source_columns(source_relation=none) -%}

    {{- adapter.dispatch('source_columns', packages = ['dbtvault'])(source_relation=source_relation) -}}

{%- endmacro %}

{%- macro snowflake__derive_columns(source_relation=none, columns=none) -%}


{%- set include_columns = [] -%}

{%- if source_relation is defined and source_relation is not none -%}
    {%- set source_model_cols = adapter.get_columns_in_relation(source_relation) -%}
{%- endif %}



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

{%- if execute -%}
{{ exceptions.raise_compiler_error("Invalid column configuration:
expected format: {source_relation: Relation}
got: {'source_relation': " ~ source_relation ~ "}") }}
{%- endif %}


{%- endmacro -%}