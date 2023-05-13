/*
 * Copyright (c) Business Thinking Ltd. 2019-2023
 * This software includes code developed by the AutomateDV (f.k.a dbtvault) Team at Business Thinking Ltd. Trading as Datavault
 */

{%- macro escape_column_names(columns=none) -%}

    {%- if automate_dv.is_list(columns) -%}
        {%- set columns = automate_dv.expand_column_list(columns) -%}
    {%- endif -%}

    {%- if automate_dv.is_something(columns) -%}

        {%- set col_string = '' -%}
        {%- set col_list = [] -%}
        {%- set col_mapping = {} -%}

        {%- if columns is string -%}

            {%- set col_string = automate_dv.escape_column_name(columns) -%}

        {%- elif automate_dv.is_list(columns) -%}

            {%- for col in columns -%}

                {%- if col is string -%}

                    {%- set escaped_col = automate_dv.escape_column_name(col) -%}

                    {%- do col_list.append(escaped_col) -%}

                {%- else -%}

                    {%- if execute -%}
                        {{- exceptions.raise_compiler_error("Invalid column name(s) provided. Must be a string.") -}}
                    {%- endif -%}

                {%- endif -%}

            {%- endfor -%}

        {%- elif columns is mapping -%}

            {%- if columns['source_column'] and columns['alias'] -%}

                {%- set escaped_source_col = automate_dv.escape_column_name(columns['source_column']) -%}
                {%- set escaped_alias_col = automate_dv.escape_column_name(columns['alias']) -%}
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

    {%- elif automate_dv.is_list(columns) -%}

        {%- do return(col_list) -%}

    {%- elif columns is mapping -%}

        {%- do return(col_mapping) -%}

    {%- endif -%}

{%- endmacro -%}