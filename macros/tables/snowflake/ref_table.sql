/*
 * Copyright (c) Business Thinking Ltd. 2019-2022
 * This software includes code developed by the dbtvault Team at Business Thinking Ltd. Trading as Datavault
 */

{%- macro ref_table(src_pk, src_extra_columns, src_ldts, src_source, source_model) -%}

{{- dbtvault.check_required_parameters(src_pk=src_pk, src_ldts=src_ldts, src_source=src_source,
                                           source_model=source_model) -}}

    {%- set src_pk = dbtvault.escape_column_names(src_pk) -%}
    {%- set src_extra_columns = dbtvault.escape_column_names(src_extra_columns) -%}
    {%- set src_ldts = dbtvault.escape_column_names(src_ldts) -%}
    {%- set src_source = dbtvault.escape_column_names(src_source) -%}

    {%- if not dbtvault.is_list(source_model) -%}
        {%- set source_model = [source_model] -%}
    {%- endif -%}

    {{ dbtvault.log_relation_sources(this, source_model | length) }}

    {{- dbtvault.prepend_generated_by() -}}

    {{- adapter.dispatch('ref_table', 'dbtvault')(src_pk=src_pk, src_extra_columns=src_extra_columns,
                                            src_ldts=src_ldts, src_source=src_source,
                                            source_model=source_model) -}}

{%- endmacro -%}

{%- macro default__ref_table(src_pk, src_extra_columns, src_ldts, src_source, source_model) -%}

{%- set source_cols = dbtvault.expand_column_list(columns=[src_pk, src_extra_columns, src_ldts, src_source]) %}

WITH to_insert AS (
    {%- for src in source_model %}
    SELECT DISTINCT
    {{ dbtvault.prefix(source_cols, 'a') }}
    FROM {{ ref(src) }} AS a
    WHERE a.{{ src_pk }} IS NOT NULL
    {%- endfor %}
),

non_historized AS (
    SELECT
    {{ dbtvault.prefix(source_cols, 'a') }}
    FROM to_insert AS a
    {%- if dbtvault.is_any_incremental() %}
    LEFT JOIN {{ this }} AS d
    ON {{ dbtvault.multikey(src_pk, prefix=['a','d'], condition='=') }}
    WHERE {{ dbtvault.multikey(src_pk, prefix='d', condition='IS NULL') }}
    {%- endif %}
)

SELECT * FROM non_historized

{%- endmacro -%}