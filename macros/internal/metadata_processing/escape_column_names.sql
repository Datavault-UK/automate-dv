{%- macro escape_column_names(columns=none) -%}

{# Different platforms use different escape characters, the default below is for Snowflake which uses double quotes #}

    {%- if dbtvault.is_something(columns) -%}

        {%- set col_string = '' -%}
        {%- set col_list = [] -%}
        {%- set col_mapping = {} -%}

        {%- if columns is string -%}

            {%- set col_string = dbtvault.escape_column_name(columns) -%}

        {%- elif dbtvault.is_list(columns) -%}

            {%- for col in columns -%}

                {%- if col is string -%}

                    {%- set escaped_col = dbtvault.escape_column_name(col) -%}

                    {%- do col_list.append(escaped_col) -%}

                {%- else -%}

                    {%- if execute -%}
                        {{- exceptions.raise_compiler_error("Invalid column name(s) provided. Must be a string.") -}}
                    {%- endif -%}

                {%- endif -%}

            {%- endfor -%}

        {%- elif columns is mapping -%}

            {%- if columns['source_column'] and columns['alias'] -%}

                {%- set escaped_source_col = dbtvault.escape_column_name(columns['source_column']) -%}
                {%- set escaped_alias_col = dbtvault.escape_column_name(columns['alias']) -%}
                {%- set col_mapping = {"source_column": escaped_source_col, "alias": escaped_alias_col} -%}

            {%- else -%}

                {%- if execute -%}
                    {{- exceptions.raise_compiler_error("Invalid column name(s) provided. Must be a string, a list of strings, or a dictionary of hashdiff metadata.") -}}
                {%- endif %}

            {%- endif -%}

        {%- else -%}

            {%- if execute -%}
                {{- exceptions.raise_compiler_error("Invalid column name(s) provided. Must be a string, a list of strings, or a dictionary of hashdiff metadata.") -}}
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

{%- elif columns == {} -%}

    {%- do return({}) -%}

{%- elif columns is string -%}

    {%- do return(col_string) -%}

{%- elif dbtvault.is_list(columns) -%}

    {%- do return(col_list) -%}

{%- elif columns is mapping -%}

    {%- do return(col_mapping) -%}

{%- endif -%}

{%- endmacro -%}


{%- macro escape_column_name(column) -%}

    {{- adapter.dispatch('escape_column_name', 'dbtvault')(column=column) -}}

{%- endmacro %}

{%- macro default__escape_column_name(column) -%}

    {%- set escape_char_left  = var('escape_char_left',  '"') -%}
    {%- set escape_char_right = var('escape_char_right', '"') -%}

    {%- set escaped_column_name = escape_char_left ~ column | replace(escape_char_left, '') | replace(escape_char_right, '') | trim ~ escape_char_right -%}

    {%- do return(escaped_column_name) -%}

{%- endmacro -%}

{%- macro sqlserver__escape_column_name(column) -%}

    {%- set escape_char_left  = var('escape_char_left',  '"') -%}
    {%- set escape_char_right = var('escape_char_right', '"') -%}

    {%- set escaped_column_name = escape_char_left ~ column | replace(escape_char_left, '') | replace(escape_char_right, '') | trim ~ escape_char_right -%}

    {%- do return(escaped_column_name) -%}

{%- endmacro -%}

{%- macro bigquery__escape_column_name(column) -%}

    {%- set escape_char_left  = var('escape_char_left',  '`') -%}
    {%- set escape_char_right = var('escape_char_right', '`') -%}

    {%- set escaped_column_name = escape_char_left ~ column | replace(escape_char_left, '') | replace(escape_char_right, '') | trim ~ escape_char_right -%}

    {%- do return(escaped_column_name) -%}

{%- endmacro -%}