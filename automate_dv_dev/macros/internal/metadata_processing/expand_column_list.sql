/*
 * Copyright (c) Business Thinking Ltd. 2019-2023
 * This software includes code developed by the AutomateDV (f.k.a dbtvault) Team at Business Thinking Ltd. Trading as Datavault
 */

{%- macro expand_column_list(columns=none) -%}

{%- if not columns -%}
    {%- do return([]) -%}
{%- endif -%}

{%- set col_list = [] -%}

{%- if automate_dv.is_list(columns) -%}

    {%- set columns = columns | reject("none") %}

    {%- for col in columns -%}

        {%- if col is string -%}

            {%- do col_list.append(col) -%}

        {#- If list of lists -#}
        {%- elif automate_dv.is_list(col) -%}

            {%- for cols in col -%}

                {%- do col_list.append(cols) -%}

            {%- endfor -%}
        {%- elif col is mapping -%}

            {%- do col_list.append(col) -%}

        {%- else -%}

            {%- if execute -%}
                {{- exceptions.raise_compiler_error("Invalid columns object provided. Must be a list of lists, dictionaries or strings.") -}}
            {%- endif %}

        {%- endif -%}

    {%- endfor -%}
{%- else -%}

    {%- if execute -%}
        {{- exceptions.raise_compiler_error("Invalid columns object provided. Must be a list.") -}}
    {%- endif %}

{%- endif -%}

{%- do return(col_list) -%}

{%- endmacro -%}
