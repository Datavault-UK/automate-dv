/*
 * Copyright (c) Business Thinking Ltd. 2019-2023
 * This software includes code developed by the dbtvault Team at Business Thinking Ltd. Trading as Datavault
 */

{%- macro sqlserver__eff_sat(src_pk, src_dfk, src_sfk, src_extra_columns, src_start_date, src_end_date, src_eff, src_ldts, src_source, source_model) -%}

{%- set source_cols = dbtvault.expand_column_list(columns=[src_pk, src_dfk, src_sfk, src_extra_columns, src_start_date, src_end_date, src_eff, src_ldts, src_source]) -%}
{%- set fk_cols = dbtvault.expand_column_list(columns=[src_dfk, src_sfk]) -%}
{%- set dfk_cols = dbtvault.expand_column_list(columns=[src_dfk]) -%}
{%- set is_auto_end_dating = config.get('is_auto_end_dating', default=false) %}

{%- set max_datetime = dbtvault.max_datetime() %}

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
latest_records AS (
    SELECT *
    FROM
    (
        SELECT {{ dbtvault.alias_all(source_cols, 'b') }},
               ROW_NUMBER() OVER (
                    PARTITION BY {{ dbtvault.prefix([src_pk], 'b') }}
                    ORDER BY b.{{ src_ldts }} DESC
               ) AS row_num
        FROM {{ this }} AS b
    ) l
    WHERE l.row_num = 1
),

{# Selecting the open records of the most recent records for each link hashkey -#}
latest_open AS (
    SELECT {{ dbtvault.alias_all(source_cols, 'c') }}
    FROM latest_records AS c
    WHERE CONVERT(DATE, c.{{ src_end_date }}) = CONVERT(DATE, '{{ max_datetime }}')
),

{# Selecting the closed records of the most recent records for each link hashkey -#}
latest_closed AS (
    SELECT {{ dbtvault.alias_all(source_cols, 'd') }}
    FROM latest_records AS d
    WHERE CONVERT(DATE, d.{{ src_end_date }}) != CONVERT(DATE, '{{ max_datetime }}')
),

{# Identifying the completely new link relationships to be opened in eff sat -#}
new_open_records AS (
    SELECT DISTINCT
        {{ dbtvault.prefix([src_pk], 'f') }},
        {{ dbtvault.alias_all(fk_cols, 'f') }},
        {%- if dbtvault.is_something(src_extra_columns) -%}
        {{ dbtvault.prefix([src_extra_columns], 'f') }},
        {%- endif -%}
        {%- if is_auto_end_dating %}
        f.{{ src_eff }} AS {{ src_start_date }},
        {% else %}
        f.{{ src_start_date }} AS {{ src_start_date }},
        {% endif %}
        f.{{ src_end_date }} AS {{ src_end_date }},
        f.{{ src_eff }} AS {{ src_eff }},
        f.{{ src_ldts }},
        f.{{ src_source }}
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
        {%- if dbtvault.is_something(src_extra_columns) -%}
        {{ dbtvault.prefix([src_extra_columns], 'g') }},
        {%- endif -%}
        {%- if is_auto_end_dating %}
        g.{{ src_eff }} AS {{ src_start_date }},
        {% else %}
        g.{{ src_start_date }} AS {{ src_start_date }},
        {% endif %}
        g.{{ src_end_date }} AS {{ src_end_date }},
        g.{{ src_eff }} AS {{ src_eff }},
        g.{{ src_ldts }},
        g.{{ src_source }}
    FROM source_data AS g
    INNER JOIN latest_closed AS lc
    ON {{ dbtvault.multikey(src_pk, prefix=['g','lc'], condition='=') }}
    WHERE CAST((g.{{ src_end_date }}) AS DATE) = CAST(('{{ max_datetime }}') AS DATE)
),

{%- if is_auto_end_dating %}

{# Creating the closing records -#}
{# Identifying the currently open relationships that need to be closed due to change in SFK(s) -#}
new_closed_records AS (
    SELECT DISTINCT
        {{ dbtvault.prefix([src_pk], 'lo') }},
        {{ dbtvault.alias_all(fk_cols, 'lo') }},
        {%- if dbtvault.is_something(src_extra_columns) -%}
        {{ dbtvault.prefix([src_extra_columns], 'h') }},
        {%- endif -%}
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

{#- else if (not) is_auto_end_dating -#}
{% else %}

new_closed_records AS (
    SELECT DISTINCT
        {{ dbtvault.prefix([src_pk], 'lo') }},
        {{ dbtvault.alias_all(fk_cols, 'lo') }},
        {%- if dbtvault.is_something(src_extra_columns) -%}
        {{ dbtvault.prefix([src_extra_columns], 'h') }},
        {%- endif -%}
        h.{{ src_start_date }} AS {{ src_start_date }},
        h.{{ src_end_date }} AS {{ src_end_date }},
        h.{{ src_eff }} AS {{ src_eff }},
        h.{{ src_ldts }},
        lo.{{ src_source }}
    FROM source_data AS h
    LEFT JOIN Latest_open AS lo
    ON lo.{{ src_pk }} = h.{{ src_pk }}
    LEFT JOIN latest_closed AS lc
    ON lc.{{ src_pk }} = h.{{ src_pk }}
    WHERE CAST((h.{{ src_end_date }}) AS DATE) != CAST(('{{ max_datetime }}') AS DATE)
    AND lo.{{ src_pk }} IS NOT NULL
    AND lc.{{ src_pk }} IS NULL
),

{#- end if is_auto_end_dating -#}
{%- endif %}

records_to_insert AS (
    SELECT * FROM new_open_records
    UNION
    SELECT * FROM new_reopened_records
    UNION
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

SELECT * FROM records_to_insert
{%- endmacro -%}
