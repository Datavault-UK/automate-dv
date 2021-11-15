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

--
-- if any_incremental
--


--
-- endif any_incremental
--

-- Select groups of source records where at least one member does not appear in a group of latest records
records_to_insert AS (
SELECT {{ dbtvault.alias_all(source_cols, 'stage') }}
FROM source_data AS stage
--
-- if any_incremental
--


--
-- endif any_incremental
--
)

SELECT * FROM records_to_insert

{%- endmacro -%}
