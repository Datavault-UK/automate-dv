{%- macro process_columns_to_select(columns_list=none, exclude_columns_list=none) -%}

    {% set columns_to_select = [] %}

    {% if not dbtvault.is_list(columns_list) or not dbtvault.is_list(exclude_columns_list)  %}

        {{- exceptions.raise_compiler_error("One or both arguments are not of list type.") -}}

    {%- endif -%}

    {%- if dbtvault.is_something(columns_list) and dbtvault.is_something(exclude_columns_list) -%}

        {%- for col in columns_list -%}

            {%- if col not in exclude_columns_list -%}
                {%- do columns_to_select.append(col) -%}
            {%- endif -%}

        {%- endfor -%}

    {%- endif -%}

    {%- do return(columns_to_select) -%}

{%- endmacro -%}


{%- macro extract_column_names(columns_dict=none) -%}

    {%- set extracted_column_names = [] -%}

    {%- if columns_dict is mapping -%}
        {%- for key, value in columns_dict.items() -%}
            {%- do extracted_column_names.append(key) -%}
        {%- endfor -%}

        {%- do return(extracted_column_names) -%}
    {%- else -%}
        {%- do return([]) -%}
    {%- endif -%}

{%- endmacro -%}


{%- macro process_hash_column_excludes(hash_columns=none, source_columns=none) -%}

    {%- set processed_hash_columns = {} -%}

    {%- for col, col_mapping in hash_columns.items() -%}
        
        {%- if col_mapping is mapping -%}
            {%- if col_mapping.exclude_columns -%}

                {%- if col_mapping.columns -%}

                    {%- set columns_to_hash = dbtvault.process_columns_to_select(source_columns, col_mapping.columns) -%}

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


{%- macro print_list(list_to_print=none, indent=4) -%}

    {%- for col_name in list_to_print -%}
        {{- col_name | indent(indent) -}}{{ ",\n    " if not loop.last }}
    {%- endfor -%}

{%- endmacro -%}
