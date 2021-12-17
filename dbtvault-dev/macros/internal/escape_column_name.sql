{%- macro escape_column_name(columns=none) -%}

{# Different platforms use different escape characters, the default below is for Snowflake which uses double quotes #}

    {%- set escape_char_left  = var('escape_char_left',  '"') -%}
    {%- set escape_char_right = var('escape_char_right', '"') -%}

    {%- if dbtvault.is_something(columns) -%}

        {%- set col_list = [] -%}
        {%- set col_string = '' -%}

        {%- if columns is string -%}

            {%- set col_string = escape_char_left ~ columns | replace(escape_char_left, '') | replace(escape_char_right, '') | trim ~ escape_char_right -%}

        {%- elif dbtvault.is_list(columns) -%}

            {%- for col in columns -%}

                {%- if col is string -%}

                    {%- set escaped_col = escape_char_left ~ col | replace(escape_char_left, '') | replace(escape_char_right, '') | trim ~ escape_char_right -%}

                    {%- do col_list.append(escaped_col) -%}

                {%- else -%}

                    {%- if execute -%}
                        {{- exceptions.raise_compiler_error("Invalid column name(s) provided. Must be a string.") -}}
                    {%- endif -%}

                {%- endif -%}

            {%- endfor -%}

        {%- else -%}

            {%- if execute -%}
                {{- exceptions.raise_compiler_error("Invalid column name(s) provided. Must be a string or a list of strings.") -}}
            {%- endif %}

        {%- endif -%}

    {%- elif columns == '' -%}

        {%- if execute -%}
            {{- exceptions.raise_compiler_error("Expected a column name or a list of column names, got an empty string") -}}
        {%- endif -%}

    {%- endif -%}

{%- if columns is none -%}

    {%- do return(none) -%}

{%- elif columns == [] -%}

    {%- do return([]) -%}

{%- elif columns is string -%}

    {%- do return(col_string) -%}

{%- elif dbtvault.is_list(columns) -%}

    {%- do return(col_list) -%}

{%- endif -%}

{%- endmacro -%}