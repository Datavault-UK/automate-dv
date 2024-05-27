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
{%- set columns = adapter.get_columns_in_relation(ref(source_model)) -%}
{%- set col_definitions = [] -%}

{%- set string_columns = [src_payload] -%}

{%- if src_extra_columns != none -%}
    {%- do string_columns.append(src_extra_columns) -%}
{%- endif -%}

{%- set string_columns = automate_dv.expand_column_list(string_columns) -%}

{%- for col in columns -%}

    {%- set col_name = col.column -%}
    {%- set col_compare = col_name | lower -%}
    {%- set col_type = col.dtype | lower -%}

    {%- do col_definitions.append(automate_dv.ghost_for_type(col_type, col_name)) -%}

{%- endfor -%}

SELECT
    {% for column_def in col_definitions -%}
    {{ column_def }}
    {%- if not loop.last -%},
    {% endif %}
    {%- endfor -%}

{%- endmacro -%}

