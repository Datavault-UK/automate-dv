{%- macro escape_column_name(columns=none) -%}

{# TODO: different platforms use different escape characters, the coding below is for Snowflake which uses double quotes #}

    {%- if columns -%}

        {%- set col_list = [] -%}
        {%- set col_string = '' -%}

        {%- if columns is string -%}

            {%- set col_string = '"'~ columns | replace('"', '') | trim ~'"' -%}

        {%- elif dbtvault.is_list(columns) -%}

--          {%- if columns is defined and columns|length -%}

            {%- for col in columns -%}

                {%- if col is string -%}

                    {%- set escaped_col = '"'~ col | replace('"', '') | trim ~'"' -%}

                    {%- do col_list.append(escaped_col) -%}

                {%- else -%}

                    {%- if execute -%}
                        {{- exceptions.raise_compiler_error("Invalid column name(s) provided. Must be a string.") -}}
                    {%- endif -%}

                {%- endif -%}

            {%- endfor -%}

--          {%- else -%}
--
--             {%- if execute -%}
--                 {{- exceptions.raise_compiler_error("The list of column names provided was empty") -}}
--             {%- endif -%}
--
--           {%- endif -%}


        {%- else -%}

            {%- if execute -%}
                {{- exceptions.raise_compiler_error("Invalid column name(s) provided. Must be a string or a list of strings.") -}}
            {%- endif %}

        {%- endif -%}

    {%- else -%}

        {%- if execute -%}
             {{- exceptions.raise_compiler_error("Expected a column name or a list of column names, got: None") -}}
        {%- endif -%}

    {%- endif -%}

{%- if columns is string -%}

    {%- do return(col_string) -%}

{%- elif dbtvault.is_list(columns) -%}

    {%- do return(col_list) -%}

{%- endif -%}

{%- endmacro -%}