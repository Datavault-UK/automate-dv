{%- macro bigquery__eff_sat(src_pk, src_dfk, src_sfk, src_start_date, src_end_date, src_eff, src_ldts, src_source, source_model) -%}

{{- dbtvault.check_required_parameters(src_pk=src_pk, src_dfk=src_dfk, src_sfk=src_sfk,
                                       src_start_date=src_start_date, src_end_date=src_end_date,
                                       src_eff=src_eff, src_ldts=src_ldts, src_source=src_source,
                                       source_model=source_model) -}}

{%- set src_pk = dbtvault.escape_column_names(src_pk) -%}
{%- set src_dfk = dbtvault.escape_column_names(src_dfk) -%}
{%- set src_sfk = dbtvault.escape_column_names(src_sfk) -%}
{%- set src_start_date = dbtvault.escape_column_names(src_start_date) -%}
{%- set src_end_date = dbtvault.escape_column_names(src_end_date) -%}
{%- set src_eff = dbtvault.escape_column_names(src_eff) -%}
{%- set src_ldts = dbtvault.escape_column_names(src_ldts) -%}
{%- set src_source = dbtvault.escape_column_names(src_source) -%}

{%- set source_cols = dbtvault.expand_column_list(columns=[src_pk, src_dfk, src_sfk, src_start_date, src_end_date, src_eff, src_ldts, src_source]) -%}
{%- set fk_cols = dbtvault.expand_column_list(columns=[src_dfk, src_sfk]) -%}
{%- set dfk_cols = dbtvault.expand_column_list(columns=[src_dfk]) -%}
{%- set is_auto_end_dating = config.get('is_auto_end_dating', default=false) %}

{%- set max_datetime = var('max_datetime', '9999-12-31 23:59:59.999999') %}

{{- dbtvault.prepend_generated_by() }}

WITH source_data AS (
    SELECT {{ dbtvault.prefix(source_cols, 'a', alias_target='source') }}
    FROM {{ ref(source_model) }} AS a
    WHERE {{ dbtvault.multikey(src_dfk, prefix='a', condition='IS NOT NULL') }}
    AND {{ dbtvault.multikey(src_sfk, prefix='a', condition='IS NOT NULL') }}
    {%- if model.config.materialized == 'vault_insert_by_period' %}
    AND __PERIOD_FILTER__
    {%- elif model.config.materialized == 'vault_insert_by_rank' %}
    AND __RANK_FILTER__
    {%- endif %}
),

{%- if dbtvault.is_any_incremental() %}

{# Selecting the most recent records for each link hashkey -#}
latest_records_unranked AS (
    SELECT {{ dbtvault.alias_all(source_cols, 'b') }},
           ROW_NUMBER() OVER (
                PARTITION BY {{ dbtvault.prefix([src_pk], 'b') }}
                ORDER BY b.{{ src_ldts }} DESC
           ) AS row_num
    FROM {{ this }} AS b
),

latest_records AS (
    SELECT *
    FROM latest_records_unranked
    WHERE row_num = 1
),

{# Selecting the open records of the most recent records for each link hashkey -#}
latest_open AS (
    SELECT {{ dbtvault.alias_all(source_cols, 'c') }}
    FROM latest_records AS c
    WHERE DATE(c.{{ src_end_date }}) = CAST(PARSE_DATETIME('%F %H:%M:%E6S', '{{ max_datetime }}') AS DATE)
),

{# Selecting the closed records of the most recent records for each link hashkey -#}
latest_closed AS (
    SELECT {{ dbtvault.alias_all(source_cols, 'd') }}
    FROM latest_records AS d
    WHERE DATE(d.{{ src_end_date }}) != CAST(PARSE_DATETIME('%F %H:%M:%E6S', '{{ max_datetime }}') AS DATE)
),

{# Identifying the completely new link relationships to be opened in eff sat -#}
new_open_records AS (
    SELECT DISTINCT
        {{ dbtvault.alias_all(source_cols, 'f') }}
    FROM source_data AS f
    LEFT JOIN latest_records AS lr
    ON {{ dbtvault.multikey(src_pk, prefix=['f','lr'], condition='=') }}
    WHERE {{ dbtvault.multikey(src_pk, prefix='lr', condition='IS NULL') }}
),

{# Identifying the currently closed link relationships to be reopened in eff sat -#}
new_reopened_records AS (
    SELECT DISTINCT
        {{ dbtvault.prefix([src_pk], 'lc') }},
        {{ dbtvault.alias_all(fk_cols, 'lc') }},
        lc.{{ src_start_date }} AS {{ src_start_date }},
        g.{{ src_end_date }} AS {{ src_end_date }},
        g.{{ src_eff }} AS {{ src_eff }},
        g.{{ src_ldts }},
        g.{{ src_source }}
    FROM source_data AS g
    INNER JOIN latest_closed AS lc
    ON {{ dbtvault.multikey(src_pk, prefix=['g','lc'], condition='=') }}
    WHERE CAST((g.{{ src_end_date }}) AS DATE) = CAST(PARSE_DATETIME('%F %H:%M:%E6S', '{{ max_datetime }}') AS DATE)
),

{%- if is_auto_end_dating %}

{# Creating the closing records -#}
{# Identifying the currently open relationships that need to be closed due to change in SFK(s) -#}
new_closed_records AS (
    SELECT DISTINCT
        {{ dbtvault.prefix([src_pk], 'lo') }},
        {{ dbtvault.alias_all(fk_cols, 'lo') }},
        lo.{{ src_start_date }} AS {{ src_start_date }},
        h.{{ src_eff }} AS {{ src_end_date }},
        h.{{ src_eff }} AS {{ src_eff }},
        h.{{ src_ldts }},
        lo.{{ src_source }}
    FROM source_data AS h
    INNER JOIN latest_open AS lo
    ON {{ dbtvault.multikey(src_dfk, prefix=['lo', 'h'], condition='=') }}
    WHERE ({{ dbtvault.multikey(src_sfk, prefix=['lo', 'h'], condition='<>', operator='OR') }})
),

{#- else if is_auto_end_dating -#}
{% else %}

new_closed_records AS (
    SELECT DISTINCT
        lo.{{ src_pk }},
        {{ dbtvault.alias_all(fk_cols, 'lo') }},
        lo.{{ src_start_date }} AS {{ src_start_date }},
        h.{{ src_eff }} AS {{ src_end_date }},
        h.{{ src_eff }} AS {{ src_eff }},
        h.{{ src_ldts }},
        lo.{{ src_source }}
    FROM source_data AS h
    LEFT JOIN Latest_open AS lo
    ON lo.{{ src_pk }} = h.{{ src_pk }}
    LEFT JOIN latest_closed AS lc
    ON lc.{{ src_pk }} = h.{{ src_pk }}
    WHERE CAST((h.{{ src_end_date }}) AS DATE) != CAST(PARSE_DATETIME('%F %H:%M:%E6S', '{{ max_datetime }}') AS DATE)
    AND lo.{{ src_pk }} IS NOT NULL
    AND lc.{{ src_pk }} IS NULL
),

{#- end if is_auto_end_dating -#}
{%- endif %}

records_to_insert AS (
    SELECT * FROM new_open_records
    UNION DISTINCT
    SELECT * FROM new_reopened_records
    UNION DISTINCT
    SELECT * FROM new_closed_records
)

{#- else if not dbtvault.is_any_incremental() -#}
{%- else %}

records_to_insert AS (
    SELECT {{ dbtvault.alias_all(source_cols, 'i') }}
    FROM source_data AS i
)

{#- end if not dbtvault.is_any_incremental() -#}
{%- endif %}

SELECT *
FROM records_to_insert

{%- endmacro -%}