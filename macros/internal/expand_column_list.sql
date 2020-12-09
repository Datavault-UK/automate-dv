{%- macro expand_column_list(columns=none) -%}

{%- if not columns -%}
    {%- if execute -%}
         {{ exceptions.raise_compiler_error("Expected a list of columns, got: " ~ columns) }}
    {%- endif -%}
{%- endif -%}

{%- set col_list = [] -%}

{%- if columns is iterable -%}

    {%- for col in columns -%}

        {%- if col is string -%}

            {%- set _ = col_list.append(col) -%}

        {#- If list of lists -#}
        {%- elif col is iterable and col is not string -%}

            {%- if col is mapping -%}

                {%- set _ = col_list.append(col) -%}

            {%- else -%}

                {%- for cols in col -%}

                    {%- set _ = col_list.append(cols) -%}

                {%- endfor -%}

            {%- endif -%}

        {%- endif -%}

    {%- endfor -%}
{%- endif -%}

{% do return(col_list) %}

{%- endmacro -%}