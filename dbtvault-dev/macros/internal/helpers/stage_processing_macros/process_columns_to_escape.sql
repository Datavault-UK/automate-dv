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
                {%- set ns.columns_to_select = ns.columns_to_select + [col_name] -%}
            {%- endif -%}
        {%- endif -%}
    {%- endfor -%}

    {%- do return(ns.columns_to_select) -%}

{%- endmacro -%}