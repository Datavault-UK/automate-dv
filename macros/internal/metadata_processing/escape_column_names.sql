/*
 * Copyright (c) Business Thinking Ltd. 2019-2025
 * This software includes code developed by the AutomateDV (f.k.a dbtvault) Team at Business Thinking Ltd. Trading as Datavault
 */

{%- macro escape_column_names(columns=none) -%}

    {# -- Base cases -- #}
    {%- if columns is none -%}
        {%- do return(none) -%}
    {%- elif columns == [] -%}
        {%- do return([]) -%}
    {%- elif columns == {} -%}
        {%- do return({}) -%}
    {%- elif columns == '' -%}
        {%- if execute -%}
            {{ exceptions.raise_compiler_error("Expected a column name or a list of column names, got an empty string") }}
        {%- endif -%}
    {%- endif -%}

    {# -- Expand lists -- #}
    {%- if automate_dv.is_list(columns) -%}
        {%- set columns = automate_dv.expand_column_list(columns) -%}
    {%- endif -%}

    {%- set result = none -%}

    {# -- Single column -- #}
    {%- if columns is string -%}

        {%- set result = automate_dv.escape_column_name(columns) -%}

    {# -- List of columns -- #}
    {%- elif automate_dv.is_list(columns, empty_is_false=true) -%}

        {%- set temp_list = [] -%}

        {%- for col in columns -%}
            {%- if col is string -%}
                {%- do temp_list.append(automate_dv.escape_column_name(col)) -%}
            {%- else -%}
                {%- if execute -%}
                    {{ exceptions.raise_compiler_error("Invalid column name(s) provided. Must be strings.") }}
                {%- endif -%}
            {%- endif -%}
        {%- endfor -%}

        {%- set result = temp_list -%}

    {# -- Mapping (HASHDIFF metadata) -- #}
    {%- elif columns is mapping -%}

        {%- if 'source_column' in columns and 'alias' in columns -%}

            {%- set result = {
                "source_column": automate_dv.escape_column_name(columns['source_column']),
                "alias": automate_dv.escape_column_name(columns['alias'])
            } -%}

        {%- else -%}

            {%- if execute -%}
                {{ exceptions.raise_compiler_error(
                    "Invalid column mapping. Must contain 'source_column' and 'alias'"
                ) }}
            {%- endif -%}

        {%- endif -%}

    {# -- Illegal type -- #}
    {%- else -%}

        {%- if execute -%}
            {{ exceptions.raise_compiler_error(
                "Invalid column input type. Must be string, list of strings, or mapping."
            ) }}
        {%- endif -%}

    {%- endif -%}

    {%- do return(result) -%}

{%- endmacro -%}