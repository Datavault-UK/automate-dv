{%- macro ma_sat(src_pk, src_cdk, src_hashdiff, src_payload, src_eff, src_ldts, src_source, source_model) -%}

    {{- adapter.dispatch('ma_sat', 'dbtvault')(src_pk=src_pk, src_cdk=src_cdk, src_hashdiff=src_hashdiff,
                                               src_payload=src_payload, src_eff=src_eff, src_ldts=src_ldts,
                                               src_source=src_source, source_model=source_model) -}}

{%- endmacro %}

{%- macro default__ma_sat(src_pk, src_cdk, src_hashdiff, src_payload, src_eff, src_ldts, src_source, source_model) -%}


{{- dbtvault.check_required_parameters(src_pk=src_pk, src_cdk=src_cdk, src_hashdiff=src_hashdiff,
                                       src_payload=src_payload, src_ldts=src_ldts, src_source=src_source,
                                       source_model=source_model) -}}

{%- set source_cols = dbtvault.expand_column_list(columns=[src_pk, src_hashdiff, src_cdk, src_payload, src_eff, src_ldts, src_source]) -%}
{%- set rank_cols = dbtvault.expand_column_list(columns=[src_pk, src_hashdiff, src_ldts]) -%}
{%- set cdk_cols = dbtvault.expand_column_list(columns=[src_cdk]) -%}

{%- if model.config.materialized == 'vault_insert_by_rank' -%}
    {%- set source_cols_with_rank = source_cols + [config.get('rank_column')] -%}
{%- endif -%}

{{ dbtvault.prepend_generated_by() }}

-- Select unique source records
WITH source_data AS (
    {%- if model.config.materialized == 'vault_insert_by_rank' %}
    SELECT DISTINCT {{ dbtvault.prefix(source_cols_with_rank, 's', alias_target='source') }}
    {%- else %}
    SELECT DISTINCT {{ dbtvault.prefix(source_cols, 's', alias_target='source') }}
    {%- endif %}
        ,COUNT(DISTINCT {{ dbtvault.prefix([src_hashdiff], 's', alias_target='source') }})
            OVER (PARTITION BY {{ dbtvault.prefix([src_pk], 's') }}) AS source_count
    FROM {{ ref(source_model) }} AS s
    WHERE {{ dbtvault.multikey([src_pk], 's', condition='IS NOT NULL') }}
    {%- for child_key in src_cdk %}
        AND {{ dbtvault.multikey(child_key, 's', condition='IS NOT NULL') }}
    {%- endfor %}
    {%- if model.config.materialized == 'vault_insert_by_period' %}
        AND __PERIOD_FILTER__
    {%- elif model.config.materialized == 'vault_insert_by_rank' %}
        AND __RANK_FILTER__
    {%- endif %}
),

-- if any_incremental
{% if dbtvault.is_any_incremental() %}

latest_records AS (
  SELECT *
        ,DENSE_RANK() OVER (PARTITION BY {{ dbtvault.prefix([src_pk], 'mas') }} ORDER BY {{ dbtvault.prefix([src_hashdiff], 'mas') }} ASC) AS check_rank
  FROM
  (
  SELECT mas.*
    ,RANK() OVER (PARTITION BY {{ dbtvault.prefix([src_pk], 'mas') }} ORDER BY {{ dbtvault.prefix([src_ldts], 'mas') }} DESC) AS latest_rank
  FROM {{ this }} AS mas
  INNER JOIN (SELECT DISTINCT {{ dbtvault.prefix([src_pk], 's') }} FROM source_data as s ) AS spk
    ON {{ dbtvault.multikey([src_pk], ['mas', 'spk'], condition='=') }}
  QUALIFY latest_rank = 1
  ) AS mas
),

-- Select summary details for each group of latest records
latest_group_details AS (
SELECT {{ dbtvault.prefix([src_pk], 'msat') }}
    ,{{ dbtvault.prefix([src_ldts], 'msat') }}
    ,MAX(msat.check_rank) AS latest_count
FROM latest_records AS msat
GROUP BY {{ dbtvault.prefix([src_pk], 'msat') }}, {{ dbtvault.prefix([src_ldts], 'msat') }}
),

-- endif any_incremental
{%- endif %}

-- Select groups of source records where at least one member does not appear in a group of latest records
records_to_insert AS (
SELECT {{ dbtvault.alias_all(source_cols, 'source_data') }}
FROM source_data

-- if any_incremental
{% if dbtvault.is_any_incremental() %}
  WHERE EXISTS
  (
    SELECT 1
    FROM source_data AS stage
    WHERE NOT EXISTS
    (
        SELECT 1
        FROM
        (
          SELECT {{ dbtvault.prefix([src_pk], 'lr') }}
            ,{{ dbtvault.prefix([src_hashdiff], 'lr') }}
            ,{{ dbtvault.prefix([src_ldts], 'lr') }}
            ,lr.check_rank
            ,lg.latest_count
          FROM latest_records AS lr
          INNER JOIN latest_group_details AS lg
            ON {{ dbtvault.multikey([src_pk], ['lr', 'lg'], condition='=') }}
            AND {{ dbtvault.prefix([src_ldts], 'lr') }} = {{ dbtvault.prefix([src_ldts], 'lg') }}
        ) AS active_records
        WHERE {{ dbtvault.multikey([src_pk], ['stage', 'active_records'], condition='=') }}
        AND {{ dbtvault.prefix([src_hashdiff], 'stage') }} = {{ dbtvault.prefix([src_hashdiff], 'active_records') }}
{# In order to maintain the parallel with the standard satellite, we don't allow for groups of records to be updated if the ldts is the only difference #}
{#        AND {{ dbtvault.prefix([src_ldts], 'stage') }} = {{ dbtvault.prefix([src_ldts], 'active_records') }}#}
        AND stage.source_count = active_records.latest_count
    )
    AND {{ dbtvault.multikey([src_pk], ['source_data', 'stage'], condition='=') }}
  )

-- endif any_incremental
{%- endif %}
)

SELECT * FROM records_to_insert

{%- endmacro -%}
