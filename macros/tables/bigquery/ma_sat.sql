{%- macro bigquery__ma_sat(src_pk, src_cdk, src_hashdiff, src_payload, src_eff, src_ldts, src_source, source_model) -%}


{{- dbtvault.check_required_parameters(src_pk=src_pk, src_cdk=src_cdk, src_hashdiff=src_hashdiff,
                                       src_payload=src_payload, src_ldts=src_ldts, src_source=src_source,
                                       source_model=source_model) -}}

{%- set src_pk = dbtvault.escape_column_names(src_pk) -%}
{%- set src_cdk = dbtvault.escape_column_names(src_cdk) -%}
{%- set src_hashdiff = dbtvault.escape_column_names(src_hashdiff) -%}
{%- set src_payload = dbtvault.escape_column_names(src_payload) -%}
{%- set src_ldts = dbtvault.escape_column_names(src_ldts) -%}
{%- set src_source = dbtvault.escape_column_names(src_source) -%}

{%- set source_cols = dbtvault.expand_column_list(columns=[src_pk, src_hashdiff, src_cdk, src_payload, src_eff, src_ldts, src_source]) -%}
{%- set rank_cols = dbtvault.expand_column_list(columns=[src_pk, src_hashdiff, src_ldts]) -%}
{%- set cdk_cols = dbtvault.expand_column_list(columns=[src_cdk]) -%}

{%- if model.config.materialized == 'vault_insert_by_rank' -%}
    {%- set source_cols_with_rank = source_cols + [config.get('rank_column')] -%}
{%- endif -%}

{{ dbtvault.prepend_generated_by() }}

{# Select unique source records -#}
WITH source_data AS (
    {%- if model.config.materialized == 'vault_insert_by_rank' %}
    SELECT DISTINCT {{ dbtvault.prefix(source_cols_with_rank, 's', alias_target='source') }}
    {%- else %}
    SELECT DISTINCT {{ dbtvault.prefix(source_cols, 's', alias_target='source') }}
    {%- endif %}
    FROM {{ ref(source_model) }} AS s
    WHERE {{ dbtvault.multikey([src_pk], prefix='s', condition='IS NOT NULL') }}
    {%- for child_key in src_cdk %}
        AND {{ dbtvault.multikey(child_key, prefix='s', condition='IS NOT NULL') }}
    {%- endfor %}
    {%- if model.config.materialized == 'vault_insert_by_period' %}
        AND __PERIOD_FILTER__
    {%- elif model.config.materialized == 'vault_insert_by_rank' %}
        AND __RANK_FILTER__
    {%- endif %}
),

{# if any_incremental -#}
{% if dbtvault.is_any_incremental() %}

source_data_with_count AS (
    SELECT a.*
        ,b.source_count
    FROM source_data a
    INNER JOIN
    (
        SELECT {{ dbtvault.prefix([src_pk], 't') }}
            ,COUNT(*) AS source_count
        FROM (SELECT DISTINCT {{ dbtvault.prefix([src_pk], 's') }}, {{ dbtvault.prefix([src_hashdiff], 's', alias_target='source') }}, {{ dbtvault.prefix(cdk_cols, 's') }} FROM source_data AS s) AS t
        GROUP BY {{ dbtvault.prefix([src_pk], 't') }}
    ) AS b
    ON {{ dbtvault.multikey([src_pk], prefix=['a','b'], condition='=') }}
),

{# Select latest records from satellite, restricted to PKs in source data -#}
latest_records AS (
    SELECT {{ dbtvault.prefix([src_pk], 'mas', alias_target='target') }}
        ,{{ dbtvault.prefix([src_hashdiff], 'mas', alias_target='target') }}
        ,{{ dbtvault.prefix([src_cdk], 'mas', alias_target='target') }}
        ,{{ dbtvault.prefix([src_ldts], 'mas', alias_target='target') }}
        ,mas.latest_rank
        ,DENSE_RANK() OVER (PARTITION BY {{ dbtvault.prefix([src_pk], 'mas') }}
            ORDER BY {{ dbtvault.prefix([src_hashdiff], 'mas', alias_target='target') }}, {{ dbtvault.prefix([src_cdk], 'mas') }} ASC) AS check_rank
    FROM
    (
    SELECT {{ dbtvault.prefix([src_pk], 'inner_mas', alias_target='target') }}
        ,{{ dbtvault.prefix([src_hashdiff], 'inner_mas', alias_target='target') }}
        ,{{ dbtvault.prefix([src_cdk], 'inner_mas', alias_target='target') }}
        ,{{ dbtvault.prefix([src_ldts], 'inner_mas', alias_target='target') }}
        ,RANK() OVER (PARTITION BY {{ dbtvault.prefix([src_pk], 'inner_mas') }}
            ORDER BY {{ dbtvault.prefix([src_ldts], 'inner_mas') }} DESC) AS latest_rank
    FROM {{ this }} AS inner_mas
    INNER JOIN (SELECT DISTINCT {{ dbtvault.prefix([src_pk], 's') }} FROM source_data as s ) AS spk
        ON {{ dbtvault.multikey([src_pk], prefix=['inner_mas', 'spk'], condition='=') }}
    ) AS mas
    WHERE latest_rank = 1
),

{# Select summary details for each group of latest records -#}
latest_group_details AS (
    SELECT {{ dbtvault.prefix([src_pk], 'lr') }}
        ,{{ dbtvault.prefix([src_ldts], 'lr') }}
        ,MAX(lr.check_rank) AS latest_count
    FROM latest_records AS lr
    GROUP BY {{ dbtvault.prefix([src_pk], 'lr') }}, {{ dbtvault.prefix([src_ldts], 'lr') }}
),

{# endif any_incremental -#}
{%- endif %}

{# Select groups of source records where at least one member does not appear in a group of latest records -#}
records_to_insert AS (
{% if not dbtvault.is_any_incremental() %}
    SELECT {{ dbtvault.alias_all(source_cols, 'source_data') }}
    FROM source_data
{%- endif %}

{# if any_incremental -#}
{% if dbtvault.is_any_incremental() %}
    SELECT {{ dbtvault.alias_all(source_cols, 'source_data_with_count') }}
    FROM source_data_with_count
    WHERE EXISTS
    (
        SELECT 1
        FROM source_data_with_count AS stage
        WHERE NOT EXISTS
        (
            SELECT 1
            FROM
            (
                SELECT {{ dbtvault.prefix([src_pk], 'lr', alias_target='target') }}
                ,{{ dbtvault.prefix([src_hashdiff], 'lr', alias_target='target') }}
                ,{{ dbtvault.prefix([src_cdk], 'lr', alias_target='target') }}
                ,{{ dbtvault.prefix([src_ldts], 'lr', alias_target='target') }}
                ,lg.latest_count
                FROM latest_records AS lr
                INNER JOIN latest_group_details AS lg
                    ON {{ dbtvault.multikey([src_pk], prefix=['lr', 'lg'], condition='=') }}
                    AND {{ dbtvault.prefix([src_ldts], 'lr') }} = {{ dbtvault.prefix([src_ldts], 'lg') }}
            ) AS active_records
            WHERE {{ dbtvault.multikey([src_pk], prefix=['stage', 'active_records'], condition='=') }}
                AND {{ dbtvault.prefix([src_hashdiff], 'stage') }} = {{ dbtvault.prefix([src_hashdiff], 'active_records', alias_target='target') }}
{# In order to maintain the parallel with the standard satellite, we don''t allow for groups of records to be updated if the ldts is the only difference #}
{#        AND {{ dbtvault.prefix([src_ldts], 'stage') }} = {{ dbtvault.prefix([src_ldts], 'active_records') }} #}
                AND {{ dbtvault.multikey(src_cdk, prefix=['stage', 'active_records'], condition='=') }}
                AND stage.source_count = active_records.latest_count
        )
        AND {{ dbtvault.multikey([src_pk], prefix=['source_data_with_count', 'stage'], condition='=') }}
    )
{# endif any_incremental -#}
{%- endif %}
)

SELECT * FROM records_to_insert

{%- endmacro -%}