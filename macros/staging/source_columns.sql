{%- macro source_columns(source_relation=none) -%}

{%- set include_columns = [] -%}

{%- if source_relation is defined and source_relation is not none -%}
    {%- set source_model_cols = adapter.get_columns_in_relation(source_relation) -%}
{%- endif %}

{#- Add all columns from source_model relation -#}
{%- for source_col in source_model_cols -%}
    {%- do include_columns.append(source_col.column) -%}
{%- endfor -%}

{%- do return(include_columns) -%}

{%- endmacro -%}