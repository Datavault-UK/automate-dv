{%- macro process_columns_to_select(columns_list=none, exclude_columns_list=none) -%}

    {%- do log("[process_columns_to_select]: columns_list: " ~ columns_list, true) -%}
    {%- do log("[process_columns_to_select]: exclude_columns_list: " ~ exclude_columns_list, true) -%}

    {% set columns_to_select = [] %}

    {% if not dbtvault.is_list(columns_list) or not dbtvault.is_list(exclude_columns_list)  %}

        {{- exceptions.raise_compiler_error("One or both arguments are not of list type.") -}}

    {%- endif -%}

    {%- if dbtvault.is_something(columns_list) and dbtvault.is_something(exclude_columns_list) -%}

        {%- for col in columns_list -%}

            {%- if col not in exclude_columns_list -%}
                {%- do columns_to_select.append(col) -%}
            {%- endif -%}

        {%- endfor -%}

    {%- endif -%}

    {%- do log("[process_columns_to_select]: columns_to_select: " ~ columns_to_select, true) -%}
    {%- do return(columns_to_select) -%}

{%- endmacro -%}


{%- macro extract_column_names(columns_dict=none) -%}

{%- set extracted_column_names = [] -%}

{%- do log("[extract_column_names]: columns_dict: " ~ columns_dict, true) -%}

{%- if columns_dict is none -%}
    {%- do return([]) -%}
{%- elif columns_dict is mapping -%}
    {%- for key, value in columns_dict.items() -%}
        {%- do extracted_column_names.append(key) -%}
    {%- endfor -%}

    {%- do return(extracted_column_names) -%}
{%- endif -%}

{%- endmacro -%}



{%- macro print_list(list_to_print=none, indent=4, trailing_comma=false) -%}
    {{- "\n\n" -}}
    {%- for col_name in list_to_print -%}
        {{- col_name | indent(indent, first=true) -}}{{- ",\n" if not loop.last -}}
        {{- "," if trailing_comma and loop.last -}}
    {%- endfor -%}

{%- endmacro -%}



