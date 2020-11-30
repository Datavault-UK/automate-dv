{%- macro sat(src_pk, src_hashdiff, src_payload, src_eff, src_ldts, src_source, source_model) -%}
    {# BQ Change: Look at local package cause of incompatible prefix macro call #}
    {{- adapter.dispatch('sat', packages=['dbtvault_bq'])(src_pk=src_pk, src_hashdiff=src_hashdiff,
                                                         src_payload=src_payload, src_eff=src_eff, src_ldts=src_ldts,
                                                         src_source=src_source, source_model=source_model) -}}

{%- endmacro %}
{# BQ Change: snowflake__sat to bigquery__sat #}
{%- macro bigquery__sat(src_pk, src_hashdiff, src_payload, src_eff, src_ldts, src_source, source_model) -%}

{%- set source_cols = dbtvault.expand_column_list(columns=[src_pk, src_hashdiff, src_payload, src_eff, src_ldts, src_source]) -%}

{{ dbtvault.prepend_generated_by() }}

WITH source_data AS (
    SELECT *
    FROM {{ ref(source_model) }}
    {%- if model.config.materialized == 'vault_insert_by_period' %}
    WHERE __PERIOD_FILTER__
    {% endif %}
),
{% if dbtvault.is_vault_insert_by_period() or is_incremental() -%}

update_records AS (
    {# BQ Change: prefix -> snowflake__prefix #}
    SELECT {{ dbtvault_bq.prefix(source_cols, 'a', alias_target='target') }}
    FROM {{ this }} as a
    JOIN source_data as b
    ON a.{{ src_pk }} = b.{{ src_pk }}
),
rank AS (
    {# BQ Change: prefix -> snowflake__prefix #}
    SELECT {{ dbtvault_bq.prefix(source_cols, 'c', alias_target='target') }},
           CASE WHEN RANK()
           {# BQ Change: prefix -> snowflake__prefix #}
           OVER (PARTITION BY {{ dbtvault_bq.prefix([src_pk], 'c') }}
           {# BQ Change: prefix -> snowflake__prefix #}
           ORDER BY {{ dbtvault_bq.prefix([src_ldts], 'c') }} DESC) = 1
    THEN 'Y' ELSE 'N' END AS latest
    FROM update_records as c
),
stage AS (
    {# BQ Change: prefix -> snowflake__prefix #}
    SELECT {{ dbtvault_bq.prefix(source_cols, 'd', alias_target='target') }}
    FROM rank AS d
    WHERE d.latest = 'Y'
),
{% endif -%}

records_to_insert AS (
    SELECT DISTINCT {{ dbtvault_bq.alias_all(source_cols, 'e') }}
    FROM source_data AS e
    {% if dbtvault.is_vault_insert_by_period() or is_incremental() -%}
    LEFT JOIN stage
    {# BQ Change: prefix -> snowflake__prefix #}
    ON {{ dbtvault_bq.prefix([src_hashdiff], 'stage', alias_target='target') }} = {{ dbtvault_bq.prefix([src_hashdiff], 'e') }}
    {# BQ Change: prefix -> snowflake__prefix #}
    WHERE {{ dbtvault_bq.prefix([src_hashdiff], 'stage', alias_target='target') }} IS NULL
    {% endif %}
)

SELECT * FROM records_to_insert

{%- endmacro -%}