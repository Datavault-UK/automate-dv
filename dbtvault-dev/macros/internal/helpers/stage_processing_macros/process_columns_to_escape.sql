/*
 *  Copyright (c) Business Thinking Ltd. 2019-2022
 *  This software includes code developed by the dbtvault Team at Business Thinking Ltd. Trading as Datavault
 */

{%- macro process_columns_to_escape(derived_columns_list=none) -%}

    {%- set ns = namespace(columns_to_select=[]) -%}

    {%- for col_name, col_def in derived_columns_list.items() -%}

        {%- if col_def is mapping -%}
            {%- if col_def['escape'] == true -%}
                {%- if dbtvault.is_list(col_def['source_column']) -%}
                    {%- set ns.columns_to_select = ns.columns_to_select + col_def['source_column'] -%}
                {%- else -%}
                    {%- set ns.columns_to_select = ns.columns_to_select + [col_def['source_column']] -%}
                {%- endif -%}
            {%- endif -%}
        {%- else -%}
            {#- Find a quoted string in the column definition so that we can escape it everywhere else -#}
            {%- set escape_char_left, escape_char_right = dbtvault.get_escape_characters() -%}
            {%- set quote_pattern = '\{}([a-zA-Z\s]+)\{}'.format(escape_char_left, escape_char_right) -%}

            {% set re = modules.re %}
            {% set is_match = re.findall(quote_pattern, col_def, re.IGNORECASE) %}
            {%- if is_match -%}
                {%- set ns.columns_to_select = ns.columns_to_select + is_match -%}
            {%- endif -%}
        {%- endif -%}
    {%- endfor -%}

    {%- do return(ns.columns_to_select | unique | list) -%}

{%- endmacro -%}