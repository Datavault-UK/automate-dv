/*
 * Copyright (c) Business Thinking Ltd. 2019-2025
 * This software includes code developed by the AutomateDV (f.k.a dbtvault) Team at Business Thinking Ltd. Trading as Datavault
 */

{%- macro escape_column_names(columns=none) -%}
    {%- do log('ESCAPE_COLUMN_NAMES 1: ' ~ columns, true) -%}

    {%- if automate_dv.is_list(columns) -%}
        {%- set columns = automate_dv.expand_column_list(columns) -%}
    {%- endif -%}

    {%- do log('ESCAPE_COLUMN_NAMES 2: ' ~ columns, true) -%}

    {%- if automate_dv.is_something(columns) -%}
        {%- do log('ESCAPE_COLUMN_NAMES 3: ' ~ columns, true) -%}
        {%- set col_string = '' -%}
        {%- set col_list = [] -%}
        {%- set col_mapping = {} -%}

        {%- if columns is string -%}
            {%- do log('ESCAPE_COLUMN_NAMES 3.5: ' ~ columns, true) -%}
            {%- set col_string = automate_dv.escape_column_name(columns) -%}
        {%- elif automate_dv.is_list(columns) -%}
            {%- do log('ESCAPE_COLUMN_NAMES 4: ' ~ columns, true) -%}

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
        {%- do log('ESCAPE_COLUMN_NAMES 5: ' ~ columns, true) -%}
        {%- if execute -%}
            {{- exceptions.raise_compiler_error("Expected a column name or a list of column names, got an empty string") -}}
        {%- endif -%}

    {%- endif -%}

    {%- if columns is none -%}
        {%- do log('ESCAPE_COLUMN_NAMES 6: ' ~ columns, true) -%}
        {%- do return(none) -%}

    {%- elif columns == [] -%}
        {%- do log('ESCAPE_COLUMN_NAMES 7: ' ~ columns, true) -%}
        {%- do return([]) -%}

    {%- elif columns == {} -%}
        {%- do log('ESCAPE_COLUMN_NAMES 8: ' ~ columns, true) -%}
        {%- do return({}) -%}

    {%- elif columns is string -%}
        {%- do log('ESCAPE_COLUMN_NAMES 9 (col_string): ' ~ col_string, true) -%}
        {%- do log('ESCAPE_COLUMN_NAMES 9: (columns):  ' ~ columns, true) -%}
        {%- do return(col_string) -%}

    {%- elif automate_dv.is_list(columns) -%}
        {%- do log('ESCAPE_COLUMN_NAMES 10: ' ~ columns, true) -%}
        {%- do return(col_list) -%}

    {%- elif columns is mapping -%}
        {%- do log('ESCAPE_COLUMN_NAMES 11: ' ~ columns, true) -%}
        {%- do return(col_mapping) -%}

    {%- endif -%}

{%- endmacro -%}