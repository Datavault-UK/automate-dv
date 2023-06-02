/*
 * Copyright (c) Business Thinking Ltd. 2019-2023
 * This software includes code developed by the AutomateDV (f.k.a dbtvault) Team at Business Thinking Ltd. Trading as Datavault
 */

{%- macro process_hash_column_excludes(hash_columns=none, source_columns=none) -%}

    {%- set processed_hash_columns = {} -%}

    {%- for col, col_mapping in hash_columns.items() -%}

        {%- if col_mapping is mapping -%}
            {%- if col_mapping.exclude_columns -%}

                {%- if col_mapping.columns -%}

                    {%- set columns_to_hash = automate_dv.process_columns_to_select(source_columns, col_mapping.columns) -%}

                    {%- do hash_columns[col].pop('exclude_columns') -%}
                    {%- do hash_columns[col].update({'columns': columns_to_hash}) -%}

                    {%- do processed_hash_columns.update({col: hash_columns[col]}) -%}
                {%- else -%}

                    {%- do hash_columns[col].pop('exclude_columns') -%}
                    {%- do hash_columns[col].update({'columns': source_columns}) -%}

                    {%- do processed_hash_columns.update({col: hash_columns[col]}) -%}
                {%- endif -%}
            {%- else -%}
                {%- do processed_hash_columns.update({col: col_mapping}) -%}
            {%- endif -%}
        {%- else -%}
            {%- do processed_hash_columns.update({col: col_mapping}) -%}
        {%- endif -%}

    {%- endfor -%}

    {%- do return(processed_hash_columns) -%}

{%- endmacro -%}
