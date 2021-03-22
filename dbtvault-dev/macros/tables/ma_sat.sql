{%- macro ma_sat(src_pk, src_cdk, src_hashdiff, src_payload, src_eff, src_ldts, src_source, source_model) -%}

    {{- adapter.dispatch('ma_sat', packages = dbtvault.get_dbtvault_namespaces())(src_pk=src_pk, src_cdk=src_cdk, src_hashdiff=src_hashdiff,
                                                                                  src_payload=src_payload, src_eff=src_eff, src_ldts=src_ldts,
                                                                                  src_source=src_source, source_model=source_model) -}}

{%- endmacro %}

{%- macro default__ma_sat(src_pk, src_cdk, src_hashdiff, src_payload, src_eff, src_ldts, src_source, source_model) -%}


{{- dbtvault.check_required_parameters(src_pk=src_pk, src_cdk=src_cdk, src_hashdiff=src_hashdiff, src_payload=src_payload,
                                       src_eff=src_eff, src_ldts=src_ldts, src_source=src_source,
                                       source_model=source_model) -}}

{%- set source_cols = dbtvault.expand_column_list(columns=[src_pk, src_hashdiff, src_cdk, src_payload, src_eff, src_ldts, src_source]) -%}
{%- set rank_cols = dbtvault.expand_column_list(columns=[src_pk, src_hashdiff, src_ldts]) -%}
{%- set cdk_cols = dbtvault.expand_column_list(columns=[src_cdk]) -%}

{%- if model.config.materialized == 'vault_insert_by_rank' %}
    {%- set source_cols_with_rank = source_cols + [config.get('rank_column')] -%}
{%- endif -%}

{{ dbtvault.prepend_generated_by() }}

WITH source_data AS (
    {%- if model.config.materialized == 'vault_insert_by_rank' %}
    SELECT {{ dbtvault.prefix(source_cols_with_rank, 'a', alias_target='source') }}
    {%- else %}
    SELECT {{ dbtvault.prefix(source_cols, 'a', alias_target='source') }}
    {%- endif %}
    ,COUNT(DISTINCT {{ dbtvault.prefix([src_hashdiff], 'a') }} )
        OVER (PARTITION BY {{ dbtvault.prefix([src_pk], 'a') }}) AS source_count
    FROM {{ ref(source_model) }} AS a
    {%- if model.config.materialized == 'vault_insert_by_period' %}
    WHERE __PERIOD_FILTER__
    {% endif %}
    {%- set source_cte = "source_data" %}
),

{%- if model.config.materialized == 'vault_insert_by_rank' %}
rank_col AS (
    SELECT * FROM source_data
    WHERE __RANK_FILTER__
    {%- set source_cte = "rank_col" %}
),
{% endif -%}

{% if dbtvault.is_vault_insert_by_period() or dbtvault.is_vault_insert_by_rank() or is_incremental() %}

update_records AS (
    SELECT {{ dbtvault.prefix(source_cols, 'a', alias_target='target') }}
    FROM {{ this }} as a
    JOIN source_data as b
    ON a.{{ src_pk }} = b.{{ src_pk }}
),

{#Select latest records from satellite together with count of distinct hashdiffs for each hashkey#}
latest_records AS (
    SELECT {{ dbtvault.prefix(cdk_cols, 'update_records', alias_target='target') }}, {{ dbtvault.prefix(rank_cols, 'update_records', alias_target='target') }}
        ,COUNT(DISTINCT {{ dbtvault.prefix([src_hashdiff], 'update_records') }} )
            OVER (PARTITION BY {{ dbtvault.prefix([src_pk], 'update_records') }}) AS target_count
        ,CASE WHEN RANK()
            OVER (PARTITION BY {{ dbtvault.prefix([src_pk], 'update_records') }}
            ORDER BY {{ dbtvault.prefix([src_ldts], 'update_records') }} DESC) = 1
        THEN 'Y' ELSE 'N' END AS latest
    FROM update_records
    QUALIFY latest = 'Y'
),

{#Select PKs and hashdiff counts for matching stage and sat records#}
{#Matching by hashkey + hashdiff + cdk#}
matching_records AS (
    SELECT {{ dbtvault.prefix([src_pk], 'stage', alias_target='target') }}
    	,COUNT(DISTINCT {{ dbtvault.prefix([src_hashdiff], 'stage') }}) AS match_count
    FROM {{ source_cte }} AS stage
    INNER JOIN latest_records
        ON {{ dbtvault.prefix([src_pk], 'stage') }} = {{ dbtvault.prefix([src_pk], 'latest_records', alias_target='target') }}
        AND {{ dbtvault.prefix([src_hashdiff], 'stage') }} = {{ dbtvault.prefix([src_hashdiff], 'latest_records', alias_target='target') }}
        AND {{ dbtvault.multikey([src_cdk], 'stage', condition='IS  NOT NULL') }} = {{ dbtvault.multikey([src_cdk], 'latest_records', condition='IS  NOT NULL') }}
     GROUP BY {{ dbtvault.prefix([src_pk], 'stage') }}
),

{#Select PKs where PKs exist in sat but match counts differ#}
satellite_update AS (
SELECT {{ dbtvault.prefix([src_pk], 'stage', alias_target='target') }}
FROM {{ source_cte }} AS stage
INNER JOIN latest_records
    ON {{ dbtvault.prefix([src_pk], 'latest_records') }} = {{ dbtvault.prefix([src_pk], 'stage') }}
LEFT OUTER JOIN matching_records
    ON {{ dbtvault.prefix([src_pk], 'matching_records') }} = {{ dbtvault.prefix([src_pk], 'latest_records') }}
WHERE
    (
    stage.source_count != latest_records.target_count
    AND
    COALESCE(matching_records.match_count, 0) = latest_records.target_count
    )
    OR
    (
    COALESCE(matching_records.match_count, 0) != latest_records.target_count
    )
),

{#Select PKs which do not exist in sat yet#}
satellite_insert AS (
    SELECT {{ dbtvault.prefix([src_pk], 'stage', alias_target='target') }}
    FROM {{ source_cte }} AS stage
    LEFT OUTER JOIN latest_records
        ON {{ dbtvault.prefix([src_pk], 'stage') }} = {{ dbtvault.prefix([src_pk], 'latest_records') }}
    WHERE {{ dbtvault.prefix([src_pk], 'latest_records') }} IS NULL
),

{%- endif %}

final_selection AS (
    SELECT {{ dbtvault.alias_all(source_cols, 'stage') }}
    FROM {{ source_cte }} AS stage
    {#Restrict to "to-do lists" of keys selected by satellite_update and satellite_insert CTEs#}
    {% if dbtvault.is_vault_insert_by_period() or dbtvault.is_vault_insert_by_rank() or is_incremental() %}
    INNER JOIN satellite_update
        ON {{ dbtvault.prefix([src_pk], 'satellite_update') }} = {{ dbtvault.prefix([src_pk], 'stage') }}

    UNION

    SELECT {{ dbtvault.alias_all(source_cols, 'stage') }}
    FROM {{ source_cte }} AS stage
    INNER JOIN satellite_insert
        ON {{ dbtvault.prefix([src_pk], 'satellite_insert') }} = {{ dbtvault.prefix([src_pk], 'stage') }}
    {%- endif %}
)

    {#Select stage records#}
    SELECT *
    FROM final_selection

{%- endmacro -%}