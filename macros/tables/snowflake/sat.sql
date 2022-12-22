/*
 * Copyright (c) Business Thinking Ltd. 2019-2023
 * This software includes code developed by the dbtvault Team at Business Thinking Ltd. Trading as Datavault
 */

{%- macro sat(src_pk, src_hashdiff, src_payload, src_extra_columns, src_eff, src_ldts, src_source, source_model) -%}

    {{- dbtvault.check_required_parameters(src_pk=src_pk, src_hashdiff=src_hashdiff, src_payload=src_payload,
                                           src_ldts=src_ldts, src_source=src_source,
                                           source_model=source_model) -}}

    {%- set src_payload = dbtvault.process_payload_column_excludes(
                              src_pk=src_pk, src_hashdiff=src_hashdiff,
                              src_payload=src_payload, src_extra_columns=src_extra_columns, src_eff=src_eff,
                              src_ldts=src_ldts, src_source=src_source, source_model=source_model) -%}

    {{ dbtvault.prepend_generated_by() }}

    {{ adapter.dispatch('sat', 'dbtvault')(src_pk=src_pk, src_hashdiff=src_hashdiff,
                                           src_payload=src_payload, src_extra_columns=src_extra_columns,
                                           src_eff=src_eff, src_ldts=src_ldts,
                                           src_source=src_source, source_model=source_model) -}}

{%- endmacro -%}

{%- macro default__sat(src_pk, src_hashdiff, src_payload, src_extra_columns, src_eff, src_ldts, src_source, source_model) -%}

{%- set source_cols = dbtvault.expand_column_list(columns=[src_pk, src_hashdiff, src_payload, src_extra_columns, src_eff, src_ldts, src_source]) -%}
{%- set window_cols = dbtvault.expand_column_list(columns=[src_pk, src_hashdiff, src_ldts]) -%}
{%- set pk_cols = dbtvault.expand_column_list(columns=[src_pk]) -%}
{%- set enable_ghost_record = var('enable_ghost_records', false) -%}

{%- if model.config.materialized == 'vault_insert_by_rank' %}
    {%- set source_cols_with_rank = source_cols + [config.get('rank_column')] -%}
{%- endif %}

WITH source_data AS (
    {%- if model.config.materialized == 'vault_insert_by_rank' %}
    SELECT {{ dbtvault.prefix(source_cols_with_rank, 'a', alias_target='source') }}
    {%- else %}
    SELECT {{ dbtvault.prefix(source_cols, 'a', alias_target='source') }}
    {%- endif %}
    FROM {{ ref(source_model) }} AS a
    WHERE {{ dbtvault.multikey(src_pk, prefix='a', condition='IS NOT NULL') }}
    {%- if model.config.materialized == 'vault_insert_by_period' %}
    AND __PERIOD_FILTER__
    {% elif model.config.materialized == 'vault_insert_by_rank' %}
    AND __RANK_FILTER__
    {% endif %}
),

{%- if dbtvault.is_any_incremental() %}

latest_records AS (
    SELECT {{ dbtvault.prefix(window_cols, 'a', alias_target='target') }}
    FROM (
        SELECT {{ dbtvault.prefix(window_cols, 'current_records', alias_target='target') }},
            RANK() OVER (
               PARTITION BY {{ dbtvault.prefix([src_pk], 'current_records') }}
               ORDER BY {{ dbtvault.prefix([src_ldts], 'current_records') }} DESC
            ) AS rank
        FROM {{ this }} AS current_records
            JOIN (
                SELECT DISTINCT {{ dbtvault.prefix([src_pk], 'source_data') }}
                FROM source_data
            ) AS source_records
                ON {{ dbtvault.multikey(src_pk, prefix=['current_records','source_records'], condition='=') }}
    ) AS a
    WHERE a.rank = 1
),

{%- endif %}

{%- if enable_ghost_record %}

ghost AS (
    {{ dbtvault.create_ghost_record(src_pk=src_pk, src_hashdiff=src_hashdiff,
                                    src_payload=src_payload, src_extra_columns=src_extra_columns,
                                    src_eff=src_eff, src_ldts=src_ldts,
                                    src_source=src_source, source_model=source_model) }}
),

{%- endif %}

records_to_insert AS (
    {%- if enable_ghost_record %}
    SELECT
        {{ dbtvault.alias_all(source_cols, 'g') }}
        FROM ghost AS g
        {%- if dbtvault.is_any_incremental() %}
        WHERE NOT EXISTS ( SELECT 1 FROM {{ this }} AS h WHERE {{ dbtvault.prefix([src_hashdiff], 'h', alias_target='target') }} = {{ dbtvault.prefix([src_hashdiff], 'g') }} )
        {%- endif %}
    UNION {% if target.type == 'bigquery' -%} DISTINCT {%- endif -%}
    {%- endif %}
    SELECT DISTINCT {{ dbtvault.alias_all(source_cols, 'stage') }}
    FROM source_data AS stage
    {%- if dbtvault.is_any_incremental() %}
    LEFT JOIN latest_records
    ON {{ dbtvault.multikey(src_pk, prefix=['latest_records','stage'], condition='=') }}
        AND {{ dbtvault.prefix([src_hashdiff], 'latest_records', alias_target='target') }} = {{ dbtvault.prefix([src_hashdiff], 'stage') }}
    WHERE {{ dbtvault.prefix([src_hashdiff], 'latest_records', alias_target='target') }} IS NULL
    {%- endif %}
)

SELECT * FROM records_to_insert
{%- endmacro -%}
