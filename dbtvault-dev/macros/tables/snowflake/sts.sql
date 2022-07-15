{%- macro sts(src_pk, src_ldts, src_source, src_status, source_model) -%}

    {{- adapter.dispatch('sts', 'dbtvault')(src_pk=src_pk,
                                             src_ldts=src_ldts,
                                             src_source=src_source,
                                             src_status=src_status,
                                             source_model=source_model) -}}
{%- endmacro -%}

{%- macro default__sts(src_pk, src_ldts, src_source, src_status, source_model) -%}

{{- dbtvault.check_required_parameters(src_pk=src_pk, src_ldts=src_ldts,
                                       src_source=src_source, src_status=src_status,
                                       source_model=source_model) -}}

{%- set src_pk = dbtvault.escape_column_name(src_pk) -%}
{%- set src_ldts = dbtvault.escape_column_name(src_ldts) -%}
{%- set src_source = dbtvault.escape_column_name(src_source) -%}
{%- set src_status = dbtvault.escape_column_name(src_status) -%}

{%- set source_cols = dbtvault.expand_column_list(columns=[src_pk, src_ldts, src_source]) -%}
{%- set rank_cols = dbtvault.expand_column_list(columns=[src_pk, src_hashdiff, src_ldts]) -%}
{%- set pk_cols = dbtvault.expand_column_list(columns=[src_pk]) -%}

{%- if model.config.materialized == 'vault_insert_by_rank' %}
    {%- set source_cols_with_rank = source_cols + dbtvault.escape_column_names([config.get('rank_column')]) -%}
{%- endif -%}

    {{ dbtvault.prepend_generated_by() }}

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

stage_datetime AS (
    SELECT MAX({{ dbtvault.prefix([src_ldts], 'b') }}) AS LOAD_DATETIME
    FROM source_data AS b
),

latest_records AS (

    SELECT {{ dbtvault.prefix(source_cols, 'a', alias_target='target') }},
        {{ dbtvault.prefix([src_status], 'a') }}
    FROM (
        SELECT {{ dbtvault.prefix(source_cols, 'current_records', alias_target='target') }},
            {{ dbtvault.prefix([src_status], 'current_records') }},
            RANK() OVER (
                PARTITION BY {{ dbtvault.prefix([src_pk], 'current_records') }}
                ORDER BY {{ dbtvault.prefix([src_ldts], 'current_records') }} DESC
            ) AS rank
        FROM {{ this }} AS current_records
    ) AS a
    WHERE a.rank = 1
),

{%- endif %}

records_to_insert AS (
    SELECT DISTINCT {{ dbtvault.alias_all(source_cols, 'stage') }},
        'I' AS {{ src_status }}
    FROM source_data AS stage

    {%- if dbtvault.is_any_incremental() %}
    WHERE NOT EXISTS (
        SELECT 1
        FROM latest_records
        WHERE ({{ dbtvault.multikey(src_pk, prefix=['latest_records','stage'], condition='=') }}
            AND {{ dbtvault.prefix([src_status], 'latest_records') }} != 'D')
    )

    UNION ALL

    SELECT DISTINCT {{ dbtvault.prefix([src_pk], 'latest_records') }},
        (SELECT LOAD_DATETIME FROM stage_datetime) AS {{ src_ldts }},
--        CURRENT_TIMESTAMP() AS {{ src_ldts }},
        {{ dbtvault.prefix([src_source], 'latest_records') }},
        'D' AS {{ src_status }}
    FROM latest_records
    LEFT OUTER JOIN source_data AS stage
    ON {{ dbtvault.multikey(src_pk, prefix=['latest_records','stage'], condition='=') }}
    WHERE {{ dbtvault.prefix([src_pk], 'stage') }} IS NULL
    AND {{ dbtvault.prefix([src_status], 'latest_records') }} != 'D'
    AND (SELECT COUNT(*) FROM source_data) > 0

    UNION ALL

    SELECT DISTINCT {{ dbtvault.alias_all(source_cols, 'stage') }},
        'U' AS {{ src_status }}
    FROM source_data AS stage
    WHERE EXISTS (
        SELECT 1
        FROM latest_records
        WHERE ({{ dbtvault.multikey(src_pk, prefix=['latest_records','stage'], condition='=') }}
            AND {{ dbtvault.prefix([src_status], 'latest_records') }} != 'D'
            AND {{ dbtvault.prefix([src_ldts], 'stage') }} != {{ dbtvault.prefix([src_ldts], 'latest_records') }})
    )
    {%- endif %}
)

SELECT * FROM records_to_insert

{%- endmacro -%}
