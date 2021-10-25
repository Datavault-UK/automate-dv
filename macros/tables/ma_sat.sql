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

WITH source_data AS (
    SELECT s.*
    FROM (
        {%- if model.config.materialized == 'vault_insert_by_rank' %}
        SELECT {{ dbtvault.prefix(source_cols_with_rank, 'a', alias_target='source') }}
        {%- else %}
        SELECT {{ dbtvault.prefix(source_cols, 'a', alias_target='source') }}
        {%- endif %}
        {% if dbtvault.is_any_incremental() %}
        ,COUNT(DISTINCT {{ dbtvault.prefix([src_hashdiff], 'a', alias_target='source') }}, {{ dbtvault.prefix(cdk_cols, 'a') }} )
            OVER (PARTITION BY {{ dbtvault.prefix([src_pk], 'a') }}) AS source_count
        {%- endif %}
        ,RANK() OVER (PARTITION BY {{ dbtvault.prefix([src_pk], 'a') }}, {{ dbtvault.prefix([src_hashdiff], 'a', alias_target='source') }}, {{ dbtvault.prefix(cdk_cols, 'a') }} ORDER BY {{ dbtvault.prefix([src_ldts], 'a') }} ASC) AS source_rank
        FROM {{ ref(source_model) }} AS a
        WHERE {{ dbtvault.prefix([src_pk], 'a') }} IS NOT NULL
        {%- for child_key in src_cdk %}
            AND {{ dbtvault.multikey(child_key, 'a', condition='IS NOT NULL') }}
        {%- endfor %}
    ) AS s
    WHERE s.source_rank = 1
    {%- if model.config.materialized == 'vault_insert_by_period' %}
        AND __PERIOD_FILTER__
    {%- elif model.config.materialized == 'vault_insert_by_rank' %}
        AND __RANK_FILTER__
    {%- endif %}
),

{% if dbtvault.is_any_incremental() %}

{# Select latest records from satellite together with count of distinct hashdiff + cdk combinations for each hashkey #}
latest_records AS (
    SELECT latest_selection.*,
        COUNT(DISTINCT {{ dbtvault.prefix([src_hashdiff], 'latest_selection') }}, {{ dbtvault.prefix(cdk_cols, 'latest_selection') }} )
            OVER (PARTITION BY {{ dbtvault.prefix([src_pk], 'latest_selection') }}) AS target_count
    FROM (
        {# Select the most recent group of records relating to each PK in the source data #}
        SELECT {{ dbtvault.prefix(cdk_cols, 'target_records') }}, {{ dbtvault.prefix(rank_cols, 'target_records', alias_target='target') }}
            ,RANK() OVER (PARTITION BY {{ dbtvault.prefix([src_pk], 'target_records') }}
                    ORDER BY {{ dbtvault.prefix([src_ldts], 'target_records') }} DESC) AS latest_rank
        FROM {{ this }} AS target_records
        INNER JOIN
            (SELECT DISTINCT {{ dbtvault.prefix([src_pk], 'source_pks') }}
            FROM source_data AS source_pks) AS source_records
                ON {{ dbtvault.prefix([src_pk], 'target_records') }} = {{ dbtvault.prefix([src_pk], 'source_records') }}
        QUALIFY latest_rank = 1
        ) AS latest_selection
),

{# Select PKs and hashdiff counts for matching stage and satellite records #}
{# Matching by hashkey + hashdiff + cdk #}
matching_records AS (
    SELECT {{ dbtvault.prefix([src_pk], 'stage') }}
        ,COUNT(DISTINCT {{ dbtvault.prefix([src_hashdiff], 'stage') }}, {{ dbtvault.prefix(cdk_cols, 'stage') }}) AS match_count
    FROM source_data AS stage
    INNER JOIN latest_records
        ON {{ dbtvault.prefix([src_pk], 'stage') }} = {{ dbtvault.prefix([src_pk], 'latest_records') }}
        AND {{ dbtvault.prefix([src_hashdiff], 'stage') }} = {{ dbtvault.prefix([src_hashdiff], 'latest_records', alias_target='target') }}
    {%- for child_key in src_cdk %}
        AND {{ dbtvault.prefix([child_key], 'stage') }} = {{ dbtvault.prefix([child_key], 'latest_records') }}
    {%- endfor %}
    GROUP BY {{ dbtvault.prefix([src_pk], 'stage') }}
),

{# Select stage records with PKs that exist in satellite but where hashdiffs or group size differ #}
{# i.e. either match counts differ or where source / target counts differ  #}
satellite_update AS (
    SELECT DISTINCT {{ dbtvault.prefix([src_pk], 'stage') }}
    FROM source_data AS stage
    INNER JOIN (
        SELECT {{ dbtvault.prefix([src_pk], 'latest_records') }},
            MAX(latest_records.target_count) AS target_count,
            MAX({{ dbtvault.prefix([src_ldts], 'latest_records') }}) AS max_load_datetime
        FROM latest_records
        GROUP BY {{ dbtvault.prefix([src_pk], 'latest_records') }}
    ) AS latest_records
        ON {{ dbtvault.prefix([src_pk], 'latest_records') }} = {{ dbtvault.prefix([src_pk], 'stage') }}
    LEFT OUTER JOIN matching_records
        ON {{ dbtvault.prefix([src_pk], 'matching_records') }} = {{ dbtvault.prefix([src_pk], 'latest_records') }}
    WHERE (stage.source_count != latest_records.target_count
        OR COALESCE(matching_records.match_count, 0) != latest_records.target_count
        OR stage.source_count != COALESCE(matching_records.match_count, 0))
    {%- if model.config.materialized == 'vault_insert_by_rank' or model.config.materialized == 'vault_insert_by_period' %}
        AND {{ dbtvault.prefix([src_ldts], 'stage') }} > latest_records.max_load_datetime
    {%- endif %}
),

{# Select stage records with PKs that do not exist in satellite #}
satellite_insert AS (
    SELECT DISTINCT {{ dbtvault.prefix([src_pk], 'stage') }}
    FROM source_data AS stage
    LEFT OUTER JOIN latest_records
        ON {{ dbtvault.prefix([src_pk], 'stage') }} = {{ dbtvault.prefix([src_pk], 'latest_records') }}
    WHERE {{ dbtvault.prefix([src_pk], 'latest_records') }} IS NULL
),

{%- endif %}

records_to_insert AS (
    {#- Restrict to "to-do lists" of keys selected by satellite_update and satellite_insert CTEs #}
    SELECT {% if not dbtvault.is_any_incremental() %} DISTINCT {% endif %} {{ dbtvault.alias_all(source_cols, 'stage') }}
    FROM source_data AS stage
    {%- if dbtvault.is_vault_insert_by_period() or dbtvault.is_vault_insert_by_rank() or is_incremental() %}
    INNER JOIN satellite_update
        ON {{ dbtvault.prefix([src_pk], 'satellite_update') }} = {{ dbtvault.prefix([src_pk], 'stage') }}

    UNION

    SELECT {{ dbtvault.alias_all(source_cols, 'stage') }}
    FROM source_data AS stage
    INNER JOIN satellite_insert
        ON {{ dbtvault.prefix([src_pk], 'satellite_insert') }} = {{ dbtvault.prefix([src_pk], 'stage') }}
    {%- endif %}
)

{# Final selection of records for insertion #}
SELECT * FROM records_to_insert

{%- endmacro -%}