/*
 * Copyright (c) Business Thinking Ltd. 2019-2023
 * This software includes code developed by the dbtvault Team at Business Thinking Ltd. Trading as Datavault
 */

{%- macro process_columns_to_select(columns_list=none, exclude_columns_list=none) -%}

    {% set columns_list = columns_list | list %}
    {% set exclude_columns_list = exclude_columns_list | list %}

    {% set columns_to_select = [] %}

    {% if not dbtvault.is_list(columns_list) or not dbtvault.is_list(exclude_columns_list)  %}

        {{- exceptions.raise_compiler_error("One or both arguments are not of list type.") -}}

    {%- endif -%}

    {%- if dbtvault.is_something(columns_list) and dbtvault.is_something(exclude_columns_list) -%}

        {%- for col in columns_list -%}

            {%- if (col | upper) not in (exclude_columns_list | map('upper') | list) -%}
                {%- do columns_to_select.append(col) -%}
            {%- endif -%}

        {%- endfor -%}

    {%- endif -%}

    {%- do return(columns_to_select) -%}

{%- endmacro -%}