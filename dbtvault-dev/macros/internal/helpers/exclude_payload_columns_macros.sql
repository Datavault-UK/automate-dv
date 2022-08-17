{%- macro process_payload_column_excludes(source_columns=none, exclude_columns=none) -%}
--     Identify if the sat uses exclude columns at all
    {%- if 'exclude_columns' in exclude_columns.keys() -%}
        {%- if exclude_columns.exclude_columns -%}
    --     Create a new empty src_payload list
            {%- set src_payload = [] -%}
            {%- set exclude_columns_list = exclude_columns.columns -%}
    --     For every column_name in the source_columns
            {%- for col in payload_columns -%}
        --      If column_name not in exclude columns
               {%- if col in exclude_columns -%}
            --      Add to src_payload list
                    {%- do src_payload.append(col) -%}
               {%- endif -%}
            {%- endfor -%}
    --     Return src_payload
        {%- endif -%}
    {%- endif -%}

    {%- do return(src_payload) -%}

{%- endmacro -%}
