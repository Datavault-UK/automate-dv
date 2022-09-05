{%- macro process_payload_column_excludes(src_pk, src_hashdiff, src_payload, src_eff, src_ldts, src_source, source_model) -%}

    {%- set source_model_cols = adapter.get_columns_in_relation(ref(source_model)) -%}

    {%- set payload_cols = [] -%}
    {%- for col in source_model_cols -%}
        {%- if col.column not in [src_pk, src_hashdiff, src_eff, src_ldts, src_source] -%}
            {%- do payload_cols.append(col.column) -%}
        {%- endif -%}
    {%- endfor -%}
{%- do log('payload_cols: '~payload_cols, true) -%}
    {%- if 'exclude_columns' in src_payload.keys() -%}
        {%- set table_excludes_columns = src_payload.exclude_columns -%}
{%- do log('table_excludes_columns: '~table_excludes_columns, true) -%}
        {%- if table_excludes_columns -%}

            {%- set excluded_payload = [] -%}
            {%- set exclude_columns_list = src_payload.columns -%}
{%- do log('exclude_columns_list: '~exclude_columns_list, true) -%}
            {%- for col in payload_cols -%}
               {%- if col not in exclude_columns_list -%}
                   {%- do excluded_payload.append(col) -%}
{%- do log('excluded_payload: '~excluded_payload, true) -%}
               {%- endif -%}
            {%- endfor -%}
        {%- endif -%}
    {%- endif -%}
{%- do log('excluded_payload: '~excluded_payload, true) -%}
    {%- do return(excluded_payload) -%}

{%- endmacro -%}
