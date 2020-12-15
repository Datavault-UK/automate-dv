{%- macro eff_sat(src_pk, src_dfk, src_sfk, src_start_date, src_end_date, src_eff, src_ldts, src_source, source_model) -%}

    {{- adapter.dispatch('eff_sat', packages = ['dbtvault'])(src_pk=src_pk, src_dfk=src_dfk, src_sfk=src_sfk,
                                                             src_start_date=src_start_date, src_end_date=src_end_date,
                                                             src_eff=src_eff, src_ldts=src_ldts, src_source=src_source,
                                                             source_model=source_model) -}}
{%- endmacro -%}

{%- macro snowflake__eff_sat(src_pk, src_dfk, src_sfk, src_start_date, src_end_date, src_eff, src_ldts, src_source, source_model) -%}

{%- set source_cols = dbtvault.expand_column_list(columns=[src_pk, src_dfk, src_sfk, src_start_date, src_end_date, src_eff, src_ldts, src_source]) -%}
{%- set fk_cols = dbtvault.expand_column_list(columns=[src_dfk, src_sfk]) -%}
{%- set is_auto_end_dating = config.get('is_auto_end_dating', default=false) %}

{{- dbtvault.prepend_generated_by() }}

WITH source_data AS (
    SELECT *
    FROM {{ ref(source_model) }}
    {%- if model.config.materialized == 'vault_insert_by_period' %}
    WHERE __PERIOD_FILTER__
    {% endif %}
),
{%- if load_relation(this) is none %}
records_to_insert AS (
    SELECT {{ dbtvault.alias_all(source_cols, 'e') }}
    FROM source_data AS e
)
{%- else %}
latest_eff AS
(
    SELECT {{ dbtvault.alias_all(source_cols, 'b') }},
           ROW_NUMBER() OVER (
                PARTITION BY b.{{ src_pk }}
                ORDER BY b.{{ src_ldts }} DESC
           ) AS row_number
    FROM {{ this }} AS b
),
latest_open_eff AS
(
    SELECT {{ dbtvault.alias_all(source_cols, 'a') }}
    FROM latest_eff AS a
    WHERE TO_DATE(a.{{ src_end_date }}) = TO_DATE('9999-12-31')
    AND a.row_number = 1
),
stage_slice AS
(
    SELECT {{ dbtvault.alias_all(source_cols, 'stage') }}
    FROM source_data AS stage
),
new_open_records AS (
    SELECT DISTINCT
        {{ dbtvault.alias_all(source_cols, 'stage') }}
    FROM stage_slice AS stage
    LEFT JOIN latest_open_eff AS e
    ON stage.{{ src_pk }} = e.{{ src_pk }}
    WHERE e.{{ src_pk }} IS NULL
    AND {{ dbtvault.multikey(src_dfk, prefix='stage', condition='IS NOT NULL') }}
    AND {{ dbtvault.multikey(src_sfk, prefix='stage', condition='IS NOT NULL') }}
),
{%- if is_auto_end_dating %}
links_to_end_date AS (
    SELECT a.*
    FROM latest_open_eff AS a
    LEFT JOIN stage_slice AS b
    ON {{ dbtvault.multikey(src_dfk, prefix=['a', 'b'], condition='=') }}
    WHERE {{ dbtvault.multikey(src_sfk, prefix='b', condition='IS NULL', operator='OR') }}
    OR {{ dbtvault.multikey(src_sfk, prefix=['a', 'b'], condition='<>', operator='OR') }}
),
new_end_dated_records AS (
    SELECT DISTINCT
        h.{{ src_pk }},
        {{ dbtvault.alias_all(fk_cols, 'g') }},
        h.EFFECTIVE_FROM AS {{ src_start_date }}, h.{{ src_source }}
    FROM latest_open_eff AS h
    INNER JOIN links_to_end_date AS g
    ON g.{{ src_pk }} = h.{{ src_pk }}
),
amended_end_dated_records AS (
    SELECT DISTINCT
        a.{{ src_pk }},
        {{ dbtvault.alias_all(fk_cols, 'a') }},
        a.{{ src_start_date }},
        stage.{{ src_eff }} AS END_DATE, stage.{{ src_eff }}, stage.{{ src_ldts }},
        a.{{ src_source }}
    FROM new_end_dated_records AS a
    INNER JOIN stage_slice AS stage
    ON {{ dbtvault.multikey(src_dfk, prefix=['stage', 'a'], condition='=') }}
    WHERE {{ dbtvault.multikey(src_sfk, prefix='stage', condition='IS NOT NULL') }}
    AND {{ dbtvault.multikey(src_dfk, prefix='stage', condition='IS NOT NULL') }}
),
{%- endif %}
records_to_insert AS (
    SELECT * FROM new_open_records
    {%- if is_auto_end_dating %}
    UNION
    SELECT * FROM amended_end_dated_records
    {%- endif %}
)
{%- endif %}

SELECT * FROM records_to_insert
{%- endmacro -%}