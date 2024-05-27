/*
 * Copyright (c) Business Thinking Ltd. 2019-2024
 * This software includes code developed by the AutomateDV (f.k.a dbtvault) Team at Business Thinking Ltd. Trading as Datavault
 */

{%- macro create_ghost_record(src_pk, src_hashdiff, src_payload, src_extra_columns, src_eff, src_ldts, src_source, source_model) -%}

    {{- adapter.dispatch('create_ghost_record', 'automate_dv')(src_pk=src_pk, src_hashdiff=src_hashdiff,
                                                               src_payload=src_payload, src_extra_columns=src_extra_columns,
                                                               src_eff=src_eff, src_ldts=src_ldts,
                                                               src_source=src_source, source_model=source_model) -}}

{%- endmacro -%}

{%- macro default__create_ghost_record(src_pk, src_hashdiff, src_payload, src_extra_columns, src_eff, src_ldts, src_source, source_model) -%}

{%- set hash = var('hash', 'MD5') -%}
{%- set source_str = var('system_record_value', 'AUTOMATE_DV_SYSTEM') -%}
{%- set columns_in_source = adapter.get_columns_in_relation(ref(source_model)) -%}
{%- set col_definitions = [] -%}

{%- set binary_columns = automate_dv.expand_column_list([src_pk, src_hashdiff]) | map('lower') | list -%}
{%- set null_columns = automate_dv.expand_column_list([src_payload, src_extra_columns]) | map('lower') | list -%}
{%- set time_columns = automate_dv.expand_column_list([src_ldts, src_eff]) | map('lower') | list -%}

{%- set all_columns = automate_dv.expand_column_list([src_pk, src_hashdiff, src_payload, src_extra_columns,
                                                      src_eff, src_ldts, src_source]) | list -%}

{%- set filtered_source_columns = columns_in_source | selectattr('column', 'in', all_columns) | list -%}
{%- set all_columns = all_columns | map('lower') | list -%}

{{ print('binary_columns: ' ~ binary_columns) }}
{{ print('null_columns: ' ~ null_columns) }}
{{ print('time_columns: ' ~ time_columns) }}

{{ print('all_columns: ' ~ all_columns) }}

{{ print('columns_in_source: ' ~ columns_in_source) }}
{{ print('filtered_source_columns: ' ~ filtered_source_columns) }}

{%- for col in filtered_source_columns -%}

    {%- set col_name = col.column -%}
    {%- set col_compare = col_name | lower -%}
    {%- set col_type = col.dtype | lower -%}
    {%- set source_system_str = var('system_record_value', 'AUTOMATE_DV_SYSTEM') -%}

    {# If src_pk col, use binary ghost unless composite #}
    {%- if col_compare in binary_columns -%}
        {%- do col_definitions.append(automate_dv.binary_ghost(alias=col_name, hash=hash)) -%}
    {# If record source col, replace with system value #}
    {%- elif col_compare == (src_source | lower) -%}
        {%- set col_sql -%}
            CAST('{{ source_system_str }}' AS {{ col.dtype }}) AS {{ src_source }}
        {%- endset -%}
        {%- do col_definitions.append(col_sql) -%}
    {# If column in payload, make its ghost representation NULL  #}
    {%- elif col_compare in null_columns -%}
        {%- do col_definitions.append(automate_dv.null_ghost(data_type=col_type, alias=col_name)) -%}
    {# Handle anything else as its correct ghost representation #}
    {%- else -%}
        {%- do col_definitions.append(automate_dv.ghost_for_type(col_type, col_name)) -%}
    {%- endif -%}

{%- endfor -%}

SELECT
    {% for column_def in col_definitions -%}
    {{ column_def }}
    {%- if not loop.last -%},
    {% endif %}
    {%- endfor -%}

{%- endmacro -%}

