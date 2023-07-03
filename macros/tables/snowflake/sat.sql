/*
 * Copyright (c) Business Thinking Ltd. 2019-2023
 * This software includes code developed by the AutomateDV (f.k.a dbtvault) Team at Business Thinking Ltd. Trading as Datavault
 */

{%- macro sat(src_pk, src_hashdiff, src_payload, src_extra_columns, src_eff, src_ldts, src_source, source_model) -%}

    {{- automate_dv.check_required_parameters(src_pk=src_pk, src_hashdiff=src_hashdiff, src_payload=src_payload,
                                           src_ldts=src_ldts, src_source=src_source,
                                           source_model=source_model) -}}

    {%- set src_payload = automate_dv.process_payload_column_excludes(
                              src_pk=src_pk, src_hashdiff=src_hashdiff,
                              src_payload=src_payload, src_extra_columns=src_extra_columns, src_eff=src_eff,
                              src_ldts=src_ldts, src_source=src_source, source_model=source_model) -%}

    {{ automate_dv.prepend_generated_by() }}

    {{ adapter.dispatch('sat', 'automate_dv')(src_pk=src_pk, src_hashdiff=src_hashdiff,
                                           src_payload=src_payload, src_extra_columns=src_extra_columns,
                                           src_eff=src_eff, src_ldts=src_ldts,
                                           src_source=src_source, source_model=source_model) -}}

{%- endmacro -%}

{%- macro default__sat(src_pk, src_hashdiff, src_payload, src_extra_columns, src_eff, src_ldts, src_source, source_model) -%}

{%- set source_cols = automate_dv.expand_column_list(columns=[src_pk, src_hashdiff, src_payload, src_extra_columns, src_eff, src_ldts, src_source]) -%}
{%- set window_cols = automate_dv.expand_column_list(columns=[src_pk, src_hashdiff, src_ldts]) -%}
{%- set pk_cols = automate_dv.expand_column_list(columns=[src_pk]) -%}
{%- set enable_ghost_record = var('enable_ghost_records', false) -%}
{%- set water_level_date = config.get('water_level_date', default='2018-06-01') -%}
{%- if model.config.materialized == 'vault_insert_by_rank' %}
    {%- set source_cols_with_rank = source_cols + [config.get('rank_column')] -%}
{%- endif %}


WITH source_data AS (
    SELECT {{ automate_dv.prefix(source_cols, 'a', alias_target='source') }}
    FROM {{ ref(source_model) }} AS a
    WHERE {{ automate_dv.multikey(src_pk, prefix='a', condition='IS NOT NULL') }}
),

{%- if automate_dv.is_any_incremental() %}
latest_records AS (
    SELECT {{ automate_dv.prefix(source_cols, 'a', alias_target='target') }}
    FROM (
        SELECT {{ automate_dv.prefix(source_cols, 'current_records', alias_target='target') }},
            RANK() OVER (
               PARTITION BY {{ automate_dv.prefix([src_pk], 'current_records') }}
               ORDER BY {{ automate_dv.prefix([src_ldts], 'current_records') }} DESC
            ) AS rank
        FROM {{ this }} AS current_records
            JOIN (
                SELECT DISTINCT {{ automate_dv.prefix([src_pk], 'source_data') }}
                FROM source_data
            ) AS source_records
                ON {{ automate_dv.multikey(src_pk, prefix=['source_records','current_records'], condition='=') }}
    ) AS a
    WHERE a.rank = 1
),
{%- endif %}
    

first_record_in_set AS (
    SELECT DISTINCT 
    {{ automate_dv.alias_all(source_cols, 'f') }}
    , ROW_NUMBER() OVER(PARTITION BY {{ automate_dv.prefix([src_pk], 'deduped') }} ORDER BY {{ automate_dv.prefix([src_ldts], 'deduped') }} as asc_row_number
    FROM source_data AS f
    QUALIFY asc_row_number = 1
),

unique_source_records AS (
    SELECT 
    {{ automate_dv.alias_all(source_cols, 'deduped') }}
    FROM (
    SELECT DISTINCT
        {{ automate_dv.alias_all(source_cols, 'sd') }}
    FROM source_data as sd
    QUALIFY {{ src_hashdiff }} != LAG({{ src_hashdiff }}) OVER(PARTITION BY {{ src_pk }} ORDER BY {{ src_ldts }} ASC)) AS deduped
),

records_to_insert AS (
        SELECT * FROM (
            SELECT {{ source_cols }}
            FROM first_record_in_set as usr
            UNION
            SELECT {{ source_cols }}
            FROM unique_source_records as usr) rejoined_records
        {%- if automate_dv.is_any_incremental() %}
            WHERE {{ automate_dv.multikey(src_pk, prefix=['latest_records','rejoined_records'], condition='=') }}
            AND {{ automate_dv.multikey(src_hashdiff, prefix=['latest_records','rejoined_records'], condition='=') }}
            AND {{ automate_dv.prefix(['asc_row_number'], 'rejoined_records') }} = 1
        {%- endif %}
)

SELECT * FROM records_to_insert
{%- endmacro -%}
