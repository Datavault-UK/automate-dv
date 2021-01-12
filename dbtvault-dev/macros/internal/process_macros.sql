{%- macro process_columns_to_select(columns_list=none, exclude_columns_list=none) -%}

    {%- do log("columns_list: " ~ columns_list, true) -%}
    {%- do log("exclude_columns_list: " ~ exclude_columns_list, true) -%}

    {% set columns_to_select = [] %}

    {% if not dbtvault.is_list(columns_list) or not dbtvault.is_list(exclude_columns_list)  %}

        {{- exceptions.raise_compiler_error("One or both arguments are not of list type.") -}}

    {%- endif -%}

    {%- if columns_list is not none and columns_list and exclude_columns_list is not none and exclude_columns_list -%}

        {%- for col in columns_list -%}

            {%- if col not in exclude_columns_list -%}
                {%- do columns_to_select.append(col) -%}
            {%- endif -%}

        {%- endfor -%}

    {%- endif -%}

    {%- do log("columns_to_select: " ~ columns_to_select, true) -%}
    {%- do return(columns_to_select) -%}

{%- endmacro -%}


{%- macro extract_column_names(columns_dict=none) -%}

{%- set extracted_column_names = [] -%}

{%- do log("columns_dict: " ~ columns_dict, true) -%}

{%- if columns_dict is none -%}
    {%- do return([]) -%}
{%- elif columns_dict is mapping -%}
    {%- for key, value in columns_dict.items() -%}
        {%- do extracted_column_names.append(key) -%}
    {%- endfor -%}

    {%- do return(extracted_column_names) -%}
{%- endif -%}

{%- endmacro -%}