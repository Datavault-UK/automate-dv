{%- macro sts(src_pk, src_ldts, src_source, src_status, src_hashdiff, source_model ) -%}

    {{- adapter.dispatch('sts', 'dbtvault')(src_pk=src_pk,
                                             src_ldts=src_ldts,
                                             src_source=src_source,
                                             src_status=src_status,
                                             src_hashdiff=src_hashdiff,
                                             source_model=source_model) -}}
{%- endmacro -%}

{%- macro default__sts(src_pk, src_ldts, src_source, src_status, src_hashdiff, source_model) -%}

{% if model.config.materialized != 'incremental' and execute %}

    {%- set error_message -%}
    STS staging error: The materialization must be incremental.
    {%- endset -%}

    {{- exceptions.raise_compiler_error(error_message) -}}
{%- endif -%}

{{- dbtvault.check_required_parameters(src_pk=src_pk, src_ldts=src_ldts,
                                       src_source=src_source, src_status=src_status,
                                       src_hashdiff=src_hashdiff,
                                       source_model=source_model) -}}

{%- set src_pk = dbtvault.escape_column_name(src_pk) -%}
{%- set src_ldts = dbtvault.escape_column_name(src_ldts) -%}
{%- set src_source = dbtvault.escape_column_name(src_source) -%}
{%- set src_status = dbtvault.escape_column_name(src_status) -%}

{%- set source_cols = dbtvault.expand_column_list(columns=[src_pk, src_ldts, src_source]) -%}

    {{ dbtvault.prepend_generated_by() }}

WITH source_data AS (
    SELECT {{ dbtvault.prefix(source_cols, 'a', alias_target='source') }}
    FROM {{ ref(source_model) }} AS a
    WHERE {{ dbtvault.multikey(src_pk, prefix='a', condition='IS NOT NULL') }}
    {%- if model.config.materialized == 'vault_insert_by_period' %}
    AND __PERIOD_FILTER__
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
        stage_datetime.LOAD_DATETIME AS {{ src_ldts }},
        {{ dbtvault.prefix([src_source], 'latest_records') }},
        'D' AS {{ src_status }}
    FROM latest_records
    INNER JOIN stage_datetime
    ON 1 = 1
    WHERE NOT EXISTS (
        SELECT 1
        FROM source_data AS stage
        WHERE {{ dbtvault.multikey(src_pk, prefix=['latest_records','stage'], condition='=') }}
    )
    AND {{ dbtvault.prefix([src_status], 'latest_records') }} != 'D'
    AND stage_datetime.LOAD_DATETIME IS NOT NULL

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

SELECT *,
    {{- dbtvault.hash_columns(columns=src_hashdiff) | indent(4) }}
FROM records_to_insert

{%- endmacro -%}
