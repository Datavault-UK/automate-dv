/*
 * Copyright (c) Business Thinking Ltd. 2019-2023
 * This software includes code developed by the AutomateDV (f.k.a dbtvault) Team at Business Thinking Ltd. Trading as Datavault
 */

{%- macro hub(src_pk, src_nk, src_extra_columns, src_ldts, src_source, source_model) -%}

    {{- automate_dv.check_required_parameters(src_pk=src_pk, src_nk=src_nk,
                                           src_ldts=src_ldts, src_source=src_source,
                                           source_model=source_model) -}}

    {%- if not automate_dv.is_list(source_model) -%}
        {%- set source_model = [source_model] -%}
    {%- endif -%}

    {{ automate_dv.log_relation_sources(this, source_model | length) }}

    {{- automate_dv.prepend_generated_by() }}

    {{ adapter.dispatch('hub', 'automate_dv')(src_pk=src_pk, src_nk=src_nk,
                                              src_extra_columns=src_extra_columns,
                                              src_ldts=src_ldts, src_source=src_source,
                                              source_model=source_model) -}}

{%- endmacro -%}

{%- macro default__hub(src_pk, src_nk, src_extra_columns, src_ldts, src_source, source_model) -%}

{%- set source_cols = automate_dv.expand_column_list(columns=[src_pk, src_nk, src_extra_columns, src_ldts, src_source]) -%}

{%- if model.config.materialized == 'vault_insert_by_rank' %}
    {%- set source_cols_with_rank = source_cols + [config.get('rank_column')] -%}
{%- endif %}

{{ 'WITH ' -}}

{%- set stage_count = source_model | length -%}

{%- set ns = namespace(last_cte= "") -%}

{%- for src in source_model -%}

{%- set source_number = loop.index | string -%}

row_rank_{{ source_number }} AS (
    {%- if model.config.materialized == 'vault_insert_by_rank' %}
    SELECT {{ automate_dv.prefix(source_cols_with_rank, 'rr') }},
    {%- else %}
    SELECT {{ automate_dv.prefix(source_cols, 'rr') }},
    {%- endif %}
           ROW_NUMBER() OVER(
               PARTITION BY {{ automate_dv.prefix([src_pk], 'rr') }}
               ORDER BY {{ automate_dv.prefix([src_ldts], 'rr') }}
           ) AS row_number
    FROM {{ ref(src) }} AS rr
    WHERE {{ automate_dv.multikey(src_pk, prefix='rr', condition='IS NOT NULL') }}
    QUALIFY row_number = 1
    {%- set ns.last_cte = "row_rank_{}".format(source_number) %}
),{{ "\n" if not loop.last }}
{% endfor -%}
{% if stage_count > 1 %}
stage_union AS (
    {%- for src in source_model %}
    SELECT * FROM row_rank_{{ loop.index | string }}
    {%- if not loop.last %}
    UNION ALL
    {%- endif %}
    {%- endfor %}
    {%- set ns.last_cte = "stage_union" %}
),
{%- endif -%}

{%- if model.config.materialized == 'vault_insert_by_period' %}
stage_mat_filter AS (
    SELECT *
    FROM {{ ns.last_cte }}
    WHERE __PERIOD_FILTER__
    {%- set ns.last_cte = "stage_mat_filter" %}
),
{%- elif model.config.materialized == 'vault_insert_by_rank' %}
stage_mat_filter AS (
    SELECT *
    FROM {{ ns.last_cte }}
    WHERE __RANK_FILTER__
    {%- set ns.last_cte = "stage_mat_filter" %}
),
{%- endif -%}

{%- if stage_count > 1 %}

row_rank_union AS (
    SELECT ru.*,
           ROW_NUMBER() OVER(
               PARTITION BY {{ automate_dv.prefix([src_pk], 'ru') }}
               ORDER BY {{ automate_dv.prefix([src_ldts], 'ru') }}, {{ automate_dv.prefix([src_source], 'ru') }} ASC
           ) AS row_rank_number
    FROM {{ ns.last_cte }} AS ru
    WHERE {{ automate_dv.multikey(src_pk, prefix='ru', condition='IS NOT NULL') }}
    QUALIFY row_rank_number = 1
    {%- set ns.last_cte = "row_rank_union" %}
),
{% endif %}
records_to_insert AS (
    SELECT {{ automate_dv.prefix(source_cols, 'a', alias_target='target') }}
    FROM {{ ns.last_cte }} AS a
    {%- if automate_dv.is_any_incremental() %}
    LEFT JOIN {{ this }} AS d
    ON {{ automate_dv.multikey(src_pk, prefix=['a','d'], condition='=') }}
    WHERE {{ automate_dv.multikey(src_pk, prefix='d', condition='IS NULL') }}
    {%- endif %}
)

SELECT * FROM records_to_insert

{%- endmacro -%}
