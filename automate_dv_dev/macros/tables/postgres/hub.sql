/*
 * Copyright (c) Business Thinking Ltd. 2019-2023
 * This software includes code developed by the AutomateDV (f.k.a dbtvault) Team at Business Thinking Ltd. Trading as Datavault
 */

{%- macro postgres__hub(src_pk, src_nk, src_extra_columns, src_ldts, src_source, source_model) -%}

{%- set source_cols = automate_dv.expand_column_list(columns=[src_pk, src_nk, src_extra_columns, src_ldts, src_source]) -%}

{%- if model.config.materialized == 'vault_insert_by_rank' %}
    {%- set source_cols_with_rank = source_cols + [config.get('rank_column')] -%}
{%- endif %}

{{ 'WITH ' -}}

{%- if not (source_model is iterable and source_model is not string) -%}
    {%- set source_model = [source_model] -%}
{%- endif -%}

{%- set ns = namespace(last_cte= "") -%}

{%- for src in source_model -%}

{%- set source_number = loop.index | string -%}

row_rank_{{ source_number }} AS (
{#- PostgreSQL has DISTINCT ON which should be more performant than the
    strategy used by Snowflake ROW_NUMBER() OVER( PARTITION BY ...
-#}
    {%- if model.config.materialized == 'vault_insert_by_rank' %}
    SELECT DISTINCT ON ({{ automate_dv.prefix([src_pk], 'rr') }}) {{ automate_dv.prefix(source_cols_with_rank, 'rr') }}
    {%- else %}
    SELECT DISTINCT ON ({{ automate_dv.prefix([src_pk], 'rr') }}) {{ automate_dv.prefix(source_cols, 'rr') }}
    {%- endif %}
    FROM {{ ref(src) }} AS rr
    WHERE {{ automate_dv.multikey(src_pk, prefix='rr', condition='IS NOT NULL') }}
    ORDER BY {{ automate_dv.prefix([src_pk], 'rr') }}, {{ automate_dv.prefix([src_ldts], 'rr') }}
    {%- set ns.last_cte = "row_rank_{}".format(source_number) %}
),{{ "\n" if not loop.last }}
{% endfor -%}
{% if source_model | length > 1 %}
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
{%- if source_model | length > 1 %}

row_rank_union AS (
{#- PostgreSQL has DISTINCT ON which should be more performant than the
    strategy used by Snowflake ROW_NUMBER() OVER( PARTITION BY ...
-#}
    SELECT DISTINCT ON ({{ automate_dv.prefix([src_pk], 'ru') }}) ru.*
    FROM {{ ns.last_cte }} AS ru
    WHERE {{ automate_dv.multikey(src_pk, prefix='ru', condition='IS NOT NULL') }}
    ORDER BY {{ automate_dv.prefix([src_pk], 'ru') }}, {{ automate_dv.prefix([src_ldts], 'ru') }}, {{ automate_dv.prefix([src_source], 'ru') }} ASC
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