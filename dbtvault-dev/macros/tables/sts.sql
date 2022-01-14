{%- macro sts(src_pk, src_ldts, src_source, src_status, source_model) -%}
    {{- adapter.dispatch('sts', 'dbtvault')(src_pk=src_pk,
                                            src_ldts=src_ldts,
                                            src_source=src_source,
                                            src_status=src_status,
                                            source_model=source_model) -}}
{%- endmacro -%}

{%- macro default__sts(src_pk, src_ldts, src_source, src_status, source_model) -%}

{%- set src_pk = dbtvault.escape_column_name(src_pk) -%}
{%- set src_ldts = dbtvault.escape_column_name(src_ldts) -%}
{%- set src_source = dbtvault.escape_column_name(src_source) -%}
{%- set src_status = dbtvault.escape_column_name(src_status) -%}

{%- set source_cols = dbtvault.expand_column_list(columns=[src_pk, src_ldts, src_source, src_status]) -%}
{%- set rank_cols = dbtvault.expand_column_list(columns=[src_pk, src_ldts]) -%}
{%- set pk_cols = dbtvault.expand_column_list(columns=[src_pk]) -%}

{{ dbtvault.prepend_generated_by() }}

WITH source_data AS (
    SELECT {{ dbtvault.prefix(source_cols, 'a', alias_target='source') }}
    FROM {{ ref(source_model) }} AS a
    WHERE {{ dbtvault.multikey(src_pk, prefix='a', condition='IS NOT NULL') }}
),

{%- if dbtvault.is_any_incremental() %}

latest_records AS (

    SELECT {{ dbtvault.prefix(rank_cols, 'a', alias_target='target') }}
    FROM (
        SELECT {{ dbtvault.prefix(rank_cols, 'current_records', alias_target='target') }},
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

records_to_insert AS (
    SELECT DISTINCT {{ dbtvault.alias_all(source_cols, 'stage') }}
    FROM source_data AS stage
    {%- if dbtvault.is_any_incremental() %}
        LEFT JOIN latest_records
            ON {{ dbtvault.multikey(src_pk, prefix=['latest_records','stage'], condition='=') }}
            WHERE {{ dbtvault.prefix([src_ldts], 'latest_records', alias_target='target') }} <= {{ dbtvault.prefix([src_ldts], 'stage', alias_target='target') }}
                OR {{ dbtvault.prefix([src_ldts], 'latest_records', alias_target='target') }} IS NULL
    {%- endif %}
)

SELECT * FROM records_to_insert

{%- endmacro -%}

{%- macro sts2(src_pk, src_ldts, src_source, src_status, source_model) -%}
    {{- adapter.dispatch('sts2', 'dbtvault')(src_pk=src_pk,
                                             src_ldts=src_ldts,
                                             src_source=src_source,
                                             src_status=src_status,
                                             source_model=source_model) -}}
{%- endmacro -%}

{%- macro default__sts2(src_pk, src_ldts, src_source, src_status, source_model) -%}

{%- set src_pk = dbtvault.escape_column_name(src_pk) -%}
{%- set src_ldts = dbtvault.escape_column_name(src_ldts) -%}
{%- set src_source = dbtvault.escape_column_name(src_source) -%}
{%- set src_status = dbtvault.escape_column_name(src_status) -%}

{%- set source_cols = dbtvault.expand_column_list(columns=[src_pk, src_ldts, src_source]) -%}
{%- set rank_cols = dbtvault.expand_column_list(columns=[src_pk, src_ldts]) -%}
{%- set pk_cols = dbtvault.expand_column_list(columns=[src_pk]) -%}

{{ dbtvault.prepend_generated_by() }}

WITH source_data AS (
    SELECT {{ dbtvault.prefix(source_cols, 'a', alias_target='source') }}
    FROM {{ ref(source_model) }} AS a
    WHERE {{ dbtvault.multikey(src_pk, prefix='a', condition='IS NOT NULL') }}
),

{%- if dbtvault.is_any_incremental() %}

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
{#            JOIN (#}
{#                SELECT DISTINCT {{ dbtvault.prefix([src_pk], 'source_data') }}#}
{#                FROM source_data#}
{#            ) AS source_records#}
{#                ON {{ dbtvault.multikey(src_pk, prefix=['current_records','source_records'], condition='=') }}#}
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
{#        {{ dbtvault.prefix([src_ldts], 'latest_records') }},#}
        TIMESTAMPADD(millisecond, 1, {{ dbtvault.prefix([src_ldts], 'latest_records') }}) AS {{ src_ldts }},
        {{ dbtvault.prefix([src_source], 'latest_records') }},
        'D' AS {{ src_status }}
    FROM latest_records
    WHERE NOT EXISTS (
        SELECT 1
        FROM source_data AS stage
        WHERE {{ dbtvault.multikey(src_pk, prefix=['latest_records','stage'], condition='=') }}
            AND {{ dbtvault.prefix([src_source], 'latest_records') }} IS NOT NULL
    )

    UNION ALL

    SELECT DISTINCT {{ dbtvault.alias_all(source_cols, 'stage') }},
        'U' AS {{ src_status }}
    FROM source_data AS stage
    WHERE EXISTS (
        SELECT 1
        FROM latest_records
        WHERE {{ dbtvault.multikey(src_pk, prefix=['latest_records','stage'], condition='=') }}
            AND {{ dbtvault.prefix([src_status], 'latest_records') }} != 'D'
    )
    {%- endif %}
)

SELECT * FROM records_to_insert

{%- endmacro -%}
