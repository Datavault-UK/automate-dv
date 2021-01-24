{%- macro sat(src_pk, src_hashdiff, src_payload, src_eff, src_ldts, src_source, source_model) -%}

    {{- adapter.dispatch('sat', packages = dbtvault.get_dbtvault_namespaces())(src_pk=src_pk, src_hashdiff=src_hashdiff,
                                                                      src_payload=src_payload, src_eff=src_eff, src_ldts=src_ldts,
                                                                      src_source=src_source, source_model=source_model) -}}

{%- endmacro %}

{%- macro default__sat(src_pk, src_hashdiff, src_payload, src_eff, src_ldts, src_source, source_model) -%}

{%- set source_cols = dbtvault.expand_column_list(columns=[src_pk, src_hashdiff, src_payload, src_eff, src_ldts, src_source]) -%}
{%- set rank_cols = dbtvault.expand_column_list(columns=[src_pk, src_hashdiff, src_ldts]) -%}

{{ dbtvault.prepend_generated_by() }}

WITH source_data AS (
    {%- if model.config.materialized == 'vault_insert_by_rank' %}
    SELECT {{ dbtvault.prefix(source_cols + [config.get('rank_column')], 'a', alias_target='source') }}
    {%- else %}
    SELECT {{ dbtvault.prefix(source_cols, 'a', alias_target='source') }}
    {%- endif %}
    FROM {{ ref(source_model) }} AS a
    {%- if model.config.materialized == 'vault_insert_by_period' %}
    WHERE __PERIOD_FILTER__
    {% endif %}
),

{%- if model.config.materialized == 'vault_insert_by_rank' %}
rank_col AS (
    SELECT * FROM source_data
    WHERE __RANK_FILTER__
),
{% endif -%}

{% if dbtvault.is_vault_insert_by_period() or dbtvault.is_vault_insert_by_rank() or is_incremental() -%}

update_records AS (
    SELECT {{ dbtvault.prefix(source_cols, 'a', alias_target='target') }}
    FROM {{ this }} as a
    JOIN source_data as b
    ON a.{{ src_pk }} = b.{{ src_pk }}
),
rank AS (
    SELECT {{ dbtvault.prefix(rank_cols, 'c', alias_target='target') }},
           CASE WHEN RANK()
           OVER (PARTITION BY {{ dbtvault.prefix([src_pk], 'c') }}
           ORDER BY {{ dbtvault.prefix([src_ldts], 'c') }} DESC) = 1
    THEN 'Y' ELSE 'N' END AS latest
    FROM update_records as c
),
stage AS (
    SELECT {{ dbtvault.prefix(rank_cols + ['latest'], 'd', alias_target='target') }}
    FROM rank AS d
    WHERE d.latest = 'Y'
),
{% endif -%}

records_to_insert AS (
    SELECT DISTINCT {{ dbtvault.alias_all(source_cols, 'e') }}
    {%- if model.config.materialized == 'vault_insert_by_rank' %}
    FROM rank_col AS e
    {% else %}
    FROM source_data AS e
    {% endif -%}
    {% if dbtvault.is_vault_insert_by_period() or dbtvault.is_vault_insert_by_rank() or is_incremental() -%}
    LEFT JOIN stage
    ON {{ dbtvault.prefix([src_hashdiff], 'stage', alias_target='target') }} = {{ dbtvault.prefix([src_hashdiff], 'e') }}
    WHERE {{ dbtvault.prefix([src_hashdiff], 'stage', alias_target='target') }} IS NULL
    {% endif %}
)

SELECT * FROM records_to_insert

{%- endmacro -%}