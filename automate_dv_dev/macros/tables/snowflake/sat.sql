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

{%- if model.config.materialized == 'vault_insert_by_rank' %}
    {%- set source_cols_with_rank = source_cols + [config.get('rank_column')] -%}
{%- endif %}

WITH source_data AS (
    {%- if model.config.materialized == 'vault_insert_by_rank' %}
    SELECT {{ automate_dv.prefix(source_cols_with_rank, 'a', alias_target='source') }}
    {%- else %}
    SELECT {{ automate_dv.prefix(source_cols, 'a', alias_target='source') }}
    {%- endif %}
    FROM {{ ref(source_model) }} AS a
    WHERE {{ automate_dv.multikey(src_pk, prefix='a', condition='IS NOT NULL') }}
    {%- if model.config.materialized == 'vault_insert_by_period' %}
    AND __PERIOD_FILTER__
    {% elif model.config.materialized == 'vault_insert_by_rank' %}
    AND __RANK_FILTER__
    {% endif %}
),

{%- if automate_dv.is_any_incremental() %}

latest_records AS (
    SELECT {{ automate_dv.prefix(window_cols, 'a', alias_target='target') }}
    FROM (
        SELECT {{ automate_dv.prefix(window_cols, 'current_records', alias_target='target') }},
            RANK() OVER (
               PARTITION BY {{ automate_dv.prefix([src_pk], 'current_records') }}
               ORDER BY {{ automate_dv.prefix([src_ldts], 'current_records') }} DESC
            ) AS rank
        FROM {{ this }} AS current_records
            JOIN (
                SELECT DISTINCT {{ automate_dv.prefix([src_pk], 'source_data') }}
                FROM source_data
            ) AS source_records
                ON {{ automate_dv.multikey(src_pk, prefix=['current_records','source_records'], condition='=') }}
    ) AS a
    WHERE a.rank = 1
),

{%- endif %}

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
    UNION {% if target.type == 'bigquery' -%} DISTINCT {%- endif -%}
    {%- endif %}
    SELECT DISTINCT {{ automate_dv.alias_all(source_cols, 'stage') }}
    FROM source_data AS stage
    {%- if automate_dv.is_any_incremental() %}
    LEFT JOIN latest_records
    ON {{ automate_dv.multikey(src_pk, prefix=['latest_records','stage'], condition='=') }}
        AND {{ automate_dv.prefix([src_hashdiff], 'latest_records', alias_target='target') }} = {{ automate_dv.prefix([src_hashdiff], 'stage') }}
    WHERE {{ automate_dv.prefix([src_hashdiff], 'latest_records', alias_target='target') }} IS NULL
    {%- endif %}
)

SELECT * FROM records_to_insert
{%- endmacro -%}
