/*
 * Copyright (c) Business Thinking Ltd. 2019-2023
 * This software includes code developed by the AutomateDV (f.k.a dbtvault) Team at Business Thinking Ltd. Trading as Datavault
 */

{%- macro process_payload_column_excludes(src_pk, src_hashdiff, src_payload, src_extra_columns, src_cdk,
                                          src_eff, src_ldts, src_source, source_model) -%}

    {%- if src_payload is not mapping -%}
        {%- do return(src_payload) -%}
    {%- endif -%}

    {%- set source_model_cols = adapter.get_columns_in_relation(ref(source_model)) -%}
    {%- set columns_in_metadata = automate_dv.expand_column_list(
                                       columns=[src_pk, src_hashdiff, src_cdk,
                                                src_payload, src_extra_columns,
                                                src_eff, src_ldts, src_source]) | map('lower') | list -%}

    {%- set payload_cols = [] -%}
    {%- for col in source_model_cols -%}
        {%- if col.column | lower not in columns_in_metadata -%}
            {%- do payload_cols.append(col.column) -%}
        {%- endif -%}
    {%- endfor -%}

    {%- if 'exclude_columns' in src_payload.keys() -%}
        {%- set table_excludes_columns = src_payload.exclude_columns -%}

        {%- if table_excludes_columns -%}

            {%- set excluded_payload = [] -%}
            {%- set exclude_columns_list = src_payload.columns | map('lower') | list -%}

            {%- for col in payload_cols -%}
               {%- if col | lower not in exclude_columns_list -%}
                   {%- do excluded_payload.append(col) -%}
               {%- endif -%}
            {%- endfor -%}
        {%- endif -%}
    {%- endif -%}

    {%- do return(excluded_payload) -%}

{%- endmacro -%}
