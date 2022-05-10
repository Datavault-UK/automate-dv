{%- macro hub(src_pk, src_nk, src_ldts, src_source, source_model) -%}

    {{- adapter.dispatch('hub', 'dbtvault')(src_pk=src_pk, src_nk=src_nk,
                                            src_ldts=src_ldts, src_source=src_source,
                                            source_model=source_model) -}}

{%- endmacro -%}

{%- macro default__hub(src_pk, src_nk, src_ldts, src_source, source_model) -%}

{{- dbtvault.check_required_parameters(src_pk=src_pk, src_nk=src_nk,
                                       src_ldts=src_ldts, src_source=src_source,
                                       source_model=source_model) -}}

{%- set src_pk = dbtvault.escape_column_names(src_pk) -%}
{%- set src_nk = dbtvault.escape_column_names(src_nk) -%}
{%- set src_ldts = dbtvault.escape_column_names(src_ldts) -%}
{%- set src_source = dbtvault.escape_column_names(src_source) -%}

{%- set source_cols = dbtvault.expand_column_list(columns=[src_pk, src_nk, src_ldts, src_source]) -%}

{%- if model.config.materialized == 'vault_insert_by_rank' %}
    {%- set source_cols_with_rank = source_cols + dbtvault.escape_column_names([config.get('rank_column')]) -%}
{%- endif -%}

{{ dbtvault.prepend_generated_by() }}

{{ 'WITH ' -}}

{%- if not (source_model is iterable and source_model is not string) -%}
    {%- set source_model = [source_model] -%}
{%- endif -%}

{%- set ns = namespace(last_cte= "") -%}

{%- for src in source_model -%}

{%- set source_number = loop.index | string -%}

row_rank_{{ source_number }} AS (
    {%- if model.config.materialized == 'vault_insert_by_rank' %}
    SELECT {{ dbtvault.prefix(source_cols_with_rank, 'rr') }},
    {%- else %}
    SELECT {{ dbtvault.prefix(source_cols, 'rr') }},
    {%- endif %}
           ROW_NUMBER() OVER(
               PARTITION BY {{ dbtvault.prefix([src_pk], 'rr') }}
               ORDER BY {{ dbtvault.prefix([src_ldts], 'rr') }}
           ) AS row_number
    FROM {{ ref(src) }} AS rr
    WHERE {{ dbtvault.multikey(src_pk, prefix='rr', condition='IS NOT NULL') }}
    QUALIFY row_number = 1
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
    SELECT ru.*,
           ROW_NUMBER() OVER(
               PARTITION BY {{ dbtvault.prefix([src_pk], 'ru') }}
               ORDER BY {{ dbtvault.prefix([src_ldts], 'ru') }}, {{ dbtvault.prefix([src_source], 'ru') }} ASC
           ) AS row_rank_number
    FROM {{ ns.last_cte }} AS ru
    WHERE {{ dbtvault.multikey(src_pk, prefix='ru', condition='IS NOT NULL') }}
    QUALIFY row_rank_number = 1
    {%- set ns.last_cte = "row_rank_union" %}
),
{% endif %}
records_to_insert AS (
    SELECT {{ dbtvault.prefix(source_cols, 'a', alias_target='target') }}
    FROM {{ ns.last_cte }} AS a
    {%- if dbtvault.is_any_incremental() %}
    LEFT JOIN {{ this }} AS d
    ON {{ dbtvault.multikey(src_pk, prefix=['a','d'], condition='=') }}
    WHERE {{ dbtvault.multikey(src_pk, prefix='d', condition='IS NULL') }}
    {%- endif %}
)

SELECT * FROM records_to_insert

{%- endmacro -%}