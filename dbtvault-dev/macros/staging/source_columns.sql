{%- macro source_columns(source_relation=none) -%}

    {%- if source_relation is defined and source_relation is not none and source_relation -%}
        {%- set source_model_cols = adapter.get_columns_in_relation(source_relation) -%}

        {%- set column_list = [] -%}

        {%- for source_col in source_model_cols -%}
            {%- do column_list.append(source_col.column) -%}
        {%- endfor -%}

        {%- do return(column_list) -%}
    {%- else -%}
        {%- if execute -%}
            {%- set error_message = "Source Relation object is empty or null. Please provide a valid source relation." -%}
            {{- exceptions.raise_compiler_error(error_message) -}}
        {%- endif -%}
    {%- endif %}

{%- endmacro -%}