/*
 * Copyright (c) Business Thinking Ltd. 2019-2023
 * This software includes code developed by the AutomateDV (f.k.a dbtvault) Team at Business Thinking Ltd. Trading as Datavault
 */

{%- macro postgres__sat(src_pk, src_hashdiff, src_payload, src_extra_columns, src_eff, src_ldts, src_source, source_model) -%}

{%- set source_cols = automate_dv.expand_column_list(columns=[src_pk, src_hashdiff, src_payload, src_extra_columns, src_eff, src_ldts, src_source]) -%}
{%- set window_cols = automate_dv.expand_column_list(columns=[src_pk, src_hashdiff, src_ldts]) -%}
{%- set pk_cols = automate_dv.expand_column_list(columns=[src_pk]) -%}
{%- set enable_ghost_record = var('enable_ghost_records', false) -%}
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
    SELECT * FROM (
        SELECT
        {{ automate_dv.prefix(source_cols, 'sd', alias_target='source') }}
        , ROW_NUMBER() OVER(PARTITION BY {{ src_pk }} ORDER BY {{ src_ldts }} ASC) as asc_row_number
        FROM source_data as sd ) rin
    WHERE rin.asc_row_number = 1
),

unique_source_records AS (
    SELECT
        {{ automate_dv.prefix(source_cols, 'b', alias_target='source') }}
    FROM (
        SELECT DISTINCT
            {{ automate_dv.prefix(source_cols, 'sd', alias_target='source') }},
            LAG({{ src_hashdiff }}) OVER(PARTITION BY {{ src_pk }}
                ORDER BY {{ src_ldts }} ASC) as prev_hashdiff
        FROM source_data as sd
        ) b
    WHERE {{ automate_dv.prefix([src_hashdiff], 'b', alias_target='source') }} != b.prev_hashdiff
),


{%- if enable_ghost_record %}

ghost AS (
    {{ automate_dv.create_ghost_record(src_pk=src_pk, src_hashdiff=src_hashdiff,
                                    src_payload=src_payload, src_extra_columns=src_extra_columns,
                                    src_eff=src_eff, src_ldts=src_ldts,
                                    src_source=src_source, source_model=source_model) }}
),

{%- endif %}

records_to_insert AS (
    {%- if enable_ghost_record %}
    SELECT
        {{ automate_dv.alias_all(source_cols, 'g') }}
        FROM ghost AS g
        {%- if automate_dv.is_any_incremental() %}
        WHERE NOT EXISTS ( SELECT 1 FROM {{ this }} AS h WHERE {{ automate_dv.prefix([src_hashdiff], 'h', alias_target='target') }} = {{ automate_dv.prefix([src_hashdiff], 'g') }} )
        {%- endif %}
    UNION
    {%- endif %}
        SELECT {{ automate_dv.alias_all(source_cols, 'frin') }}
        FROM first_record_in_set AS frin
        {%- if automate_dv.is_any_incremental() %}
        LEFT JOIN LATEST_RECORDS lr
            ON {{ automate_dv.multikey(src_pk, prefix=['lr','frin'], condition='=') }}
            AND {{ automate_dv.prefix([src_hashdiff], 'lr', alias_target='target') }} = {{ automate_dv.prefix([src_hashdiff], 'frin') }}
            WHERE {{ automate_dv.prefix([src_hashdiff], 'lr', alias_target='target') }} IS NULL
        {%- endif %}
        UNION
        SELECT {{ automate_dv.prefix(source_cols, 'usr', alias_target='source') }}
        FROM unique_source_records as usr
)

SELECT * FROM records_to_insert
{%- endmacro -%}
