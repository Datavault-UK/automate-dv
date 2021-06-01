{%- macro eff_sat(src_pk, src_dfk, src_sfk, src_start_date, src_end_date, src_eff, src_ldts, src_source, source_model) -%}

    {{- adapter.dispatch('eff_sat', packages = dbtvault.get_dbtvault_namespaces())(src_pk=src_pk, src_dfk=src_dfk, src_sfk=src_sfk,
                                                                                   src_start_date=src_start_date, src_end_date=src_end_date,
                                                                                   src_eff=src_eff, src_ldts=src_ldts, src_source=src_source,
                                                                                   source_model=source_model) -}}
{%- endmacro -%}

{%- macro default__eff_sat(src_pk, src_dfk, src_sfk, src_start_date, src_end_date, src_eff, src_ldts, src_source, source_model) -%}

{{- dbtvault.check_required_parameters(src_pk=src_pk, src_dfk=src_dfk, src_sfk=src_sfk,
                                       src_start_date=src_start_date, src_end_date=src_end_date,
                                       src_eff=src_eff, src_ldts=src_ldts, src_source=src_source,
                                       source_model=source_model) -}}

{%- set source_cols = dbtvault.expand_column_list(columns=[src_pk, src_dfk, src_sfk, src_start_date, src_end_date, src_eff, src_ldts, src_source]) -%}
{%- set fk_cols = dbtvault.expand_column_list(columns=[src_dfk, src_sfk]) -%}
{%- set dfk_cols = dbtvault.expand_column_list(columns=[src_dfk]) -%}
{%- set is_auto_end_dating = config.get('is_auto_end_dating', default=false) %}
{%- set rank_cols = dbtvault.expand_column_list(columns=[src_pk, src_hashdiff, src_ldts]) -%}

{%- if model.config.materialized == 'vault_insert_by_rank' %}
    {%- set source_cols_with_rank = source_cols + [config.get('rank_column')] -%}
{%- endif -%}

{{- dbtvault.prepend_generated_by() }}

WITH source_data AS (
    {%- if model.config.materialized == 'vault_insert_by_rank' %}
    SELECT {{ dbtvault.prefix(source_cols_with_rank, 'a', alias_target='source') }}
    {%- else %}
    SELECT {{ dbtvault.prefix(source_cols, 'a', alias_target='source') }}
    {%- endif %}
    FROM {{ ref(source_model) }} AS a
    {%- if model.config.materialized == 'vault_insert_by_period' %}
    WHERE __PERIOD_FILTER__
    {%- elif model.config.materialized == 'vault_insert_by_rank' %}
    WHERE __RANK_FILTER__
    {%- endif %}
),

{%- if load_relation(this) is none %}

records_to_insert AS (
    SELECT {{ dbtvault.alias_all(source_cols, 'e') }}
    FROM source_data AS e
)

{%- else %}

{#- Selecting the most recent records for each link hashkey -#}
latest_records AS (
    SELECT {{ dbtvault.alias_all(source_cols, 'b') }},
           RANK() OVER (
                PARTITION BY {{ src_pk }}
                ORDER BY b.{{ src_ldts }} DESC
           ) AS rank_num
    FROM {{ this }} AS b
    QUALIFY rank_num = 1
),

{#- Selecting the open records of the most recent records for each link hashkey -#}
latest_open AS (
    SELECT *
    FROM latest_records AS b
    WHERE TO_DATE(b.{{ src_end_date }}) = TO_DATE('9999-12-31')
),

{#- Selecting the closed records of the most recent records for each link hashkey -#}
latest_closed AS (
    SELECT *
    FROM latest_records AS b
    WHERE TO_DATE(b.{{ src_end_date }}) != TO_DATE('9999-12-31')
),

stage_slice AS (
    SELECT {{ dbtvault.alias_all(source_cols, 'stage') }}
    FROM source_data AS stage
),

{#- Identifying the completely new link relationships to be opened in eff sat -#}
new_open_records AS (
    SELECT DISTINCT
        {{ dbtvault.alias_all(source_cols, 'stage') }}
    FROM stage_slice AS stage
    LEFT JOIN latest_records AS lr
        ON stage.{{ src_pk }} = lr.{{ src_pk }}
    WHERE lr.{{ src_pk }} IS NULL
        AND {{ dbtvault.multikey(src_dfk, prefix='stage', condition='IS NOT NULL') }}
        AND {{ dbtvault.multikey(src_sfk, prefix='stage', condition='IS NOT NULL') }}
),

{#- Identifying the existing closed link relationships to be reopened in eff sat -#}
new_reopened_records AS (
    SELECT DISTINCT
        lc.{{ src_pk }}
        ,{{ dbtvault.alias_all(fk_cols, 'lc') }}
        ,lc.{{ src_start_date }}
        ,stage.{{ src_end_date }} AS END_DATE
        ,stage.{{ src_ldts }} AS EFFECTIVE_FROM
        ,stage.{{ src_ldts }}
        ,stage.{{ src_source }}
    FROM stage_slice AS stage
    INNER JOIN latest_closed lc
    ON stage.{{ src_pk }} = lc.{{ src_pk }}
    WHERE {{ dbtvault.multikey(src_dfk, prefix='stage', condition='IS NOT NULL') }}
    AND {{ dbtvault.multikey(src_sfk, prefix='stage', condition='IS NOT NULL') }}
),

{%- if is_auto_end_dating %}

{#- Identifying the currently open relationships that need to be closed due to change in SFK(s) -#}
links_to_close AS (
    SELECT DISTINCT a.*
    FROM latest_open AS a
    LEFT JOIN stage_slice AS b
    ON {{ dbtvault.multikey(src_dfk, prefix=['a', 'b'], condition='=') }}
    WHERE {{ dbtvault.multikey(src_sfk, prefix='b', condition='IS NULL', operator='OR') }}
    OR {{ dbtvault.multikey(src_sfk, prefix=['a', 'b'], condition='<>', operator='OR') }}
),

{#- Creating the closing records -#}
new_closed_records AS (
    SELECT DISTINCT
        a.{{ src_pk }}
        ,{{ dbtvault.alias_all(fk_cols, 'a') }}
        ,a.{{ src_start_date }}
        ,stage.{{ src_ldts }} AS END_DATE
        ,stage.{{ src_ldts }} AS EFFECTIVE_FROM
        ,stage.{{ src_ldts }}
        ,a.{{ src_source }}
    FROM latest_open AS a
    INNER JOIN links_to_close AS b
    ON a.{{ src_pk }} = b.{{ src_pk }}
    INNER JOIN stage_slice AS stage
    ON {{ dbtvault.multikey(src_dfk, prefix=['stage', 'a'], condition='=') }}
    WHERE {{ dbtvault.multikey(src_sfk, prefix='stage', condition='IS NOT NULL') }}
    AND {{ dbtvault.multikey(src_dfk, prefix='stage', condition='IS NOT NULL') }}
),

{# if is_auto_end_dating #}
{%- endif %}

records_to_insert AS (
    SELECT * FROM new_open_records
    UNION
    SELECT * FROM new_reopened_records
    {%- if is_auto_end_dating %}
    UNION
    SELECT * FROM new_closed_records
    {%- endif %}
)

{# if load_relation(this) is none #}
{%- endif %}

SELECT * FROM records_to_insert
{%- endmacro -%}