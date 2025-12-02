/*
 * Copyright (c) Business Thinking Ltd. 2019-2025
 * This software includes code developed by the AutomateDV (f.k.a dbtvault) Team at Business Thinking Ltd. Trading as Datavault
 */

{%- macro databricks__ref_table(src_pk, src_extra_columns, src_ldts, src_source, source_model) -%}

{%- set source_cols = automate_dv.expand_column_list(columns=[src_pk, src_extra_columns, src_ldts, src_source]) %}

WITH source_data AS (
    {%- for src in source_model %}
    SELECT DISTINCT
        {{ automate_dv.prefix(source_cols, 'a') }}
    FROM {{ ref(src) }} AS a
    WHERE a.{{ src_pk }} IS NOT NULL
    {%- endfor %}
),

records_to_insert AS (
    SELECT
        {{ automate_dv.prefix(source_cols, 'a') }}
    FROM source_data AS a
    {%- if automate_dv.is_any_incremental() %}
    LEFT ANTI JOIN {{ this }} AS d
       ON {{ automate_dv.multikey(src_pk, prefix=['a','d'], condition='=') }}
    {%- endif %}
)

SELECT * FROM records_to_insert

{%- endmacro -%}