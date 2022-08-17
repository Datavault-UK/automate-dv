{%- macro process_payload_column_excludes(payload_columns=none, exclude_columns=none) -%}

    {%- if 'exclude_columns' in exclude_columns.keys() -%}
        {%- set table_excludes_columns = exclude_columns.exclude_columns -%}

        {%- if table_excludes_columns -%}

            {%- set src_payload = [] -%}
            {%- set exclude_columns_list = exclude_columns.columns -%}

            {%- for col in payload_columns -%}
               {%- if col not in exclude_columns_list -%}
                   {%- do src_payload.append(col) -%}
               {%- endif -%}
            {%- endfor -%}

        {%- endif -%}
    {%- endif -%}

    {%- do return(src_payload) -%}

{%- endmacro -%}
