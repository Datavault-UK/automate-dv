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
{%- set enable_native_hashes = var('enable_native_hashes', false) -%}

{%- set columns_in_source = adapter.get_columns_in_relation(ref(source_model)) -%}
{%- set src_hashdiff_name = src_hashdiff['source_column'] | default(src_hashdiff) -%}
{%- set col_definitions = [] -%}

{%- set binary_columns = automate_dv.expand_column_list([src_pk, src_hashdiff_name]) | map('lower') | list -%}
{%- set null_columns = automate_dv.expand_column_list([src_payload, src_extra_columns]) | map('lower') | list -%}
{%- set time_columns = automate_dv.expand_column_list([src_ldts, src_eff]) | map('lower') | list -%}

{%- set all_columns = automate_dv.expand_column_list([src_pk, src_hashdiff_name, src_payload, src_extra_columns,
                                                      src_eff, src_ldts, src_source]) | list -%}

{%- if target.type == 'bigquery' and not enable_native_hashes -%}
    {%- set warning_message -%}
    WARNING: In AutomateDV v0.10.2 and earlier, BigQuery used the STRING data type for hashes.
          If native hashes are disabled for BigQuery, all columns in the src_pk and src_hashdiff
          parameters will use a string of zeros (0000...) instead of the correct hash data type.
          To resolve this, enable native hashes at your earliest convenience.
    {%- endset -%}
    {%- do automate_dv.log_warning(warning_message) -%}
{%- endif -%}

{%- set filtered_source_columns = [] -%}
{%- for column in columns_in_source -%}
    {%- if column.column | lower in all_columns | map('lower') -%}
        {%- do filtered_source_columns.append(column) -%}
    {%- endif -%}
{%- endfor -%}

{%- set all_columns = all_columns | map('lower') | list -%}

{%- for col in filtered_source_columns -%}

    {%- set col_name = col.column -%}
    {%- set col_compare = col_name | lower -%}
    {%- set col_type = col.dtype | lower -%}
    {%- set source_system_str = var('system_record_value', 'AUTOMATE_DV_SYSTEM') -%}

    {# If src_pk col, use binary ghost unless composite #}
    {%- if col_compare in binary_columns -%}
        {%- if target.type == 'bigquery' and not enable_native_hashes -%}
            {%- do col_definitions.append(automate_dv.binary_ghost(alias=col_name, hash=hash)) -%}
        {%- else -%}
            {%- do col_definitions.append(automate_dv.ghost_for_type(col_type, col_name)) -%}
        {%- endif -%}
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

