/*
 * Copyright (c) Business Thinking Ltd. 2019-2023
 * This software includes code developed by the AutomateDV (f.k.a dbtvault) Team at Business Thinking Ltd. Trading as Datavault
 */

{%- macro ma_sat(src_pk, src_cdk, src_hashdiff, src_payload, src_extra_columns, src_eff, src_ldts, src_source, source_model) -%}

    {{- automate_dv.check_required_parameters(src_pk=src_pk, src_cdk=src_cdk, src_hashdiff=src_hashdiff,
                                           src_payload=src_payload, src_ldts=src_ldts, src_source=src_source,
                                           source_model=source_model) -}}

    {{- automate_dv.prepend_generated_by() }}

    {{ adapter.dispatch('ma_sat', 'automate_dv')(src_pk=src_pk, src_cdk=src_cdk, src_hashdiff=src_hashdiff,
                                                 src_payload=src_payload, src_extra_columns=src_extra_columns,
                                                 src_eff=src_eff, src_ldts=src_ldts,
                                                 src_source=src_source, source_model=source_model) -}}

{%- endmacro %}

{%- macro default__ma_sat(src_pk, src_cdk, src_hashdiff, src_payload, src_extra_columns, src_eff, src_ldts, src_source, source_model) -%}

{%- set source_cols = automate_dv.expand_column_list(columns=[src_pk, src_cdk, src_payload, src_extra_columns, src_hashdiff, src_eff, src_ldts, src_source]) -%}
{%- set rank_cols = automate_dv.expand_column_list(columns=[src_pk, src_hashdiff, src_ldts]) -%}
{%- set cdk_cols = automate_dv.expand_column_list(columns=[src_cdk]) -%}
{%- set cols_for_latest = automate_dv.expand_column_list(columns=[src_pk, src_hashdiff, src_cdk, src_ldts]) %}

{%- if model.config.materialized == 'vault_insert_by_rank' -%}
    {%- set source_cols_with_rank = source_cols + [config.get('rank_column')] -%}
{%- endif %}

{# Select unique source records #}
WITH source_data AS (
    {%- if model.config.materialized == 'vault_insert_by_rank' %}
    SELECT DISTINCT {{ automate_dv.prefix(source_cols_with_rank, 's', alias_target='source') }}
    {%- else %}
    SELECT DISTINCT {{ automate_dv.prefix(source_cols, 's', alias_target='source') }}
    {%- endif %}
    {% if automate_dv.is_any_incremental() %}
        ,COUNT(DISTINCT {{ automate_dv.prefix([src_hashdiff], 's', alias_target='source') }}, {{ automate_dv.prefix(cdk_cols, 's', alias_target='source') }})
            OVER (PARTITION BY {{ automate_dv.prefix([src_pk], 's') }}) AS source_count
    {% endif %}
    FROM {{ ref(source_model) }} AS s
    WHERE {{ automate_dv.multikey(src_pk, prefix='s', condition='IS NOT NULL') }}
    {%- for child_key in cdk_cols %}
        AND {{ automate_dv.multikey(child_key, prefix='s', condition='IS NOT NULL') }}
    {%- endfor %}
    {%- if model.config.materialized == 'vault_insert_by_period' %}
        AND __PERIOD_FILTER__
    {%- elif model.config.materialized == 'vault_insert_by_rank' %}
        AND __RANK_FILTER__
    {%- endif %}
),

{# if any_incremental -#}
{% if automate_dv.is_any_incremental() %}

{# Select latest records from satellite, restricted to PKs in source data -#}
latest_records AS (
    SELECT {{ automate_dv.prefix(cols_for_latest, 'mas', alias_target='target') }},
           mas.latest_rank,
           DENSE_RANK() OVER (PARTITION BY {{ automate_dv.prefix([src_pk], 'mas') }}
                              ORDER BY {{ automate_dv.prefix([src_hashdiff], 'mas', alias_target='target') }}, {{ automate_dv.prefix(cdk_cols, 'mas') }} ASC
           ) AS check_rank
    FROM (
    SELECT {{ automate_dv.prefix(cols_for_latest, 'inner_mas', alias_target='target') }},
           RANK() OVER (PARTITION BY {{ automate_dv.prefix([src_pk], 'inner_mas') }}
                        ORDER BY {{ automate_dv.prefix([src_ldts], 'inner_mas') }} DESC
           ) AS latest_rank
    FROM {{ this }} AS inner_mas
        INNER JOIN (
            SELECT DISTINCT {{ automate_dv.prefix([src_pk], 's') }}
            FROM source_data as s
        ) AS spk
            ON {{ automate_dv.multikey(src_pk, prefix=['inner_mas', 'spk'], condition='=') }}
            QUALIFY latest_rank = 1
    ) AS mas
),

{# Select summary details for each group of latest records -#}
latest_group_details AS (
    SELECT {{ automate_dv.prefix([src_pk], 'lr') }},
           {{ automate_dv.prefix([src_ldts], 'lr') }},
           MAX(lr.check_rank) AS latest_count
    FROM latest_records AS lr
    GROUP BY {{ automate_dv.prefix([src_pk], 'lr') }}, {{ automate_dv.prefix([src_ldts], 'lr') }}
),

{# endif any_incremental -#}
{%- endif %}

{# Select groups of source records where at least one member does not appear in a group of latest records -#}
records_to_insert AS (
    SELECT {{ automate_dv.alias_all(source_cols, 'source_data') }}
    FROM source_data

{# if any_incremental -#}
{% if automate_dv.is_any_incremental() %}
    WHERE EXISTS (
        SELECT 1
        FROM source_data AS stage
        WHERE NOT EXISTS (
            SELECT 1
            FROM (
                SELECT {{ automate_dv.prefix(cols_for_latest, 'lr', alias_target='target') }},
                lg.latest_count
                FROM latest_records AS lr
                INNER JOIN latest_group_details AS lg
                    ON {{ automate_dv.multikey(src_pk, prefix=['lr', 'lg'], condition='=') }}
                    AND {{ automate_dv.prefix([src_ldts], 'lr') }} = {{ automate_dv.prefix([src_ldts], 'lg') }}
            ) AS active_records
            WHERE {{ automate_dv.multikey(src_pk, prefix=['stage', 'active_records'], condition='=') }}
                AND {{ automate_dv.prefix([src_hashdiff], 'stage') }} = {{ automate_dv.prefix([src_hashdiff], 'active_records', alias_target='target') }}
                AND {{ automate_dv.multikey(cdk_cols, prefix=['stage', 'active_records'], condition='=') }}
                AND stage.source_count = active_records.latest_count
        )
        AND {{ automate_dv.multikey(src_pk, prefix=['source_data', 'stage'], condition='=') }}
    )
{# endif any_incremental -#}
{%- endif %}
)

SELECT * FROM records_to_insert

{%- endmacro -%}
