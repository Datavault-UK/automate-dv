/*
 * Copyright (c) Business Thinking Ltd. 2019-2023
 * This software includes code developed by the AutomateDV (f.k.a dbtvault) Team at Business Thinking Ltd. Trading as Datavault
 */

{%- macro eff_sat(src_pk, src_dfk, src_sfk, src_extra_columns, src_start_date, src_end_date, src_eff, src_ldts, src_source, source_model) -%}

    {{- automate_dv.check_required_parameters(src_pk=src_pk, src_dfk=src_dfk, src_sfk=src_sfk,
                                              src_start_date=src_start_date, src_end_date=src_end_date,
                                              src_eff=src_eff, src_ldts=src_ldts, src_source=src_source,
                                              source_model=source_model) -}}

    {{- automate_dv.prepend_generated_by() }}

    {{ adapter.dispatch('eff_sat', 'automate_dv')(src_pk=src_pk, src_dfk=src_dfk, src_sfk=src_sfk,
                                                  src_extra_columns=src_extra_columns,
                                                  src_start_date=src_start_date, src_end_date=src_end_date,
                                                  src_eff=src_eff, src_ldts=src_ldts, src_source=src_source,
                                                  source_model=source_model) -}}
{%- endmacro -%}

{%- macro default__eff_sat(src_pk, src_dfk, src_sfk, src_extra_columns, src_start_date, src_end_date, src_eff, src_ldts, src_source, source_model) -%}

{%- set source_cols = automate_dv.expand_column_list(columns=[src_pk, src_dfk, src_sfk, src_extra_columns, src_start_date, src_end_date, src_eff, src_ldts, src_source]) -%}
{%- set fk_cols = automate_dv.expand_column_list(columns=[src_dfk, src_sfk]) -%}
{%- set dfk_cols = automate_dv.expand_column_list(columns=[src_dfk]) -%}
{%- set is_auto_end_dating = config.get('is_auto_end_dating', default=false) %}

{%- set max_datetime = automate_dv.max_datetime() %}

WITH source_data AS (
    SELECT {{ automate_dv.prefix(source_cols, 'a', alias_target='source') }}
    FROM {{ ref(source_model) }} AS a
    WHERE {{ automate_dv.multikey(src_dfk, prefix='a', condition='IS NOT NULL') }}
    AND {{ automate_dv.multikey(src_sfk, prefix='a', condition='IS NOT NULL') }}
    {%- if model.config.materialized == 'vault_insert_by_period' %}
    AND __PERIOD_FILTER__
    {%- elif model.config.materialized == 'vault_insert_by_rank' %}
    AND __RANK_FILTER__
    {%- endif %}
),

{%- if automate_dv.is_any_incremental() %}

{# Selecting the most recent records for each link hashkey -#}
latest_records AS (
    SELECT * FROM (
        SELECT {{ automate_dv.alias_all(source_cols, 'b') }},
               ROW_NUMBER() OVER (
                    PARTITION BY {{ automate_dv.prefix([src_pk], 'b') }}
                    ORDER BY b.{{ src_ldts }} DESC
               ) AS row_num
        FROM {{ this }} AS b
    )
    {%- if target.type == 'sqlserver' -%}
        l
        WHERE l.row_num = 1
    {%- else -%}
        AS inner_rank
        WHERE row_num = 1
    {%- endif -%}
),

{# Selecting the open records of the most recent records for each link hashkey -#}
latest_open AS (
    SELECT {{ automate_dv.alias_all(source_cols, 'c') }}
    FROM latest_records AS c
    WHERE {{ automate_dv.cast_date(automate_dv.alias(src_end_date, 'c')) }} = {{ automate_dv.cast_date(automate_dv.cast_datetime(max_datetime, as_string=true)) }}
),

{# Selecting the closed records of the most recent records for each link hashkey -#}
latest_closed AS (
    SELECT {{ automate_dv.alias_all(source_cols, 'd') }}
    FROM latest_records AS d
    WHERE {{ automate_dv.cast_date(automate_dv.alias(src_end_date, 'd')) }} != {{ automate_dv.cast_date(automate_dv.cast_datetime(max_datetime, as_string=true)) }}
),

{# Identifying the completely new link relationships to be opened in eff sat -#}
new_open_records AS (
    SELECT DISTINCT
        {{ automate_dv.prefix([src_pk], 'f') }},
        {{ automate_dv.alias_all(fk_cols, 'f') }},
        {% if automate_dv.is_something(src_extra_columns) %}
            {{ automate_dv.prefix([src_extra_columns], 'f') }},
        {% endif -%}
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
    ON {{ automate_dv.multikey(src_pk, prefix=['f','lr'], condition='=') }}
    WHERE {{ automate_dv.multikey(src_pk, prefix='lr', condition='IS NULL') }}
),

{# Identifying the currently closed link relationships to be reopened in eff sat -#}
new_reopened_records AS (
    SELECT DISTINCT
        {{ automate_dv.prefix([src_pk], 'lc') }},
        {{ automate_dv.alias_all(fk_cols, 'lc') }},
        {% if automate_dv.is_something(src_extra_columns) %}
            {{ automate_dv.prefix([src_extra_columns], 'g') }},
        {% endif -%}
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
    ON {{ automate_dv.multikey(src_pk, prefix=['g','lc'], condition='=') }}
    WHERE {{ automate_dv.cast_date(automate_dv.alias(src_end_date, 'g')) }} = {{ automate_dv.cast_date(automate_dv.cast_datetime(max_datetime, as_string=true)) }}
),

{%- if is_auto_end_dating %}

{# Creating the closing records -#}
{# Identifying the currently open relationships that need to be closed due to change in SFK(s) -#}
new_closed_records AS (
    SELECT DISTINCT
        {{ automate_dv.prefix([src_pk], 'lo') }},
        {{ automate_dv.alias_all(fk_cols, 'lo') }},
        {% if automate_dv.is_something(src_extra_columns) %}
            {{ automate_dv.prefix([src_extra_columns], 'h') }},
        {% endif -%}
        lo.{{ src_start_date }} AS {{ src_start_date }},
        h.{{ src_eff }} AS {{ src_end_date }},
        h.{{ src_eff }} AS {{ src_eff }},
        h.{{ src_ldts }},
        lo.{{ src_source }}
    FROM source_data AS h
    INNER JOIN latest_open AS lo
    ON {{ automate_dv.multikey(src_dfk, prefix=['lo', 'h'], condition='=') }}
    WHERE ({{ automate_dv.multikey(src_sfk, prefix=['lo', 'h'], condition='<>', operator='OR') }})
),

{#- else if (not) is_auto_end_dating -#}
{% else %}

new_closed_records AS (
    SELECT DISTINCT
        {{ automate_dv.prefix([src_pk], 'lo') }},
        {{ automate_dv.alias_all(fk_cols, 'lo') }},
        {% if automate_dv.is_something(src_extra_columns) %}
            {{ automate_dv.prefix([src_extra_columns], 'h') }},
        {% endif -%}
        h.{{ src_start_date }} AS {{ src_start_date }},
        h.{{ src_end_date }} AS {{ src_end_date }},
        h.{{ src_eff }} AS {{ src_eff }},
        h.{{ src_ldts }},
        lo.{{ src_source }}
    FROM source_data AS h
    LEFT JOIN latest_open AS lo
    ON {{ automate_dv.multikey(src_pk, prefix=['lo', 'h'], condition='=') }}
    LEFT JOIN latest_closed AS lc
    ON {{ automate_dv.multikey(src_pk, prefix=['lc', 'h'], condition='=') }}
    WHERE {{ automate_dv.cast_date(automate_dv.alias(src_end_date, 'h')) }} != {{ automate_dv.cast_date(automate_dv.cast_datetime(max_datetime, as_string=true)) }}
    AND {{ automate_dv.multikey(src_pk, prefix='lo', condition='IS NOT NULL') }}
    AND {{ automate_dv.multikey(src_pk, prefix='lc', condition='IS NULL') }}
),

{#- end if is_auto_end_dating -#}
{%- endif %}

records_to_insert AS (
    SELECT * FROM new_open_records
    {% if target.type == 'bigquery' -%}
        UNION DISTINCT
    {%- else -%}
        UNION
    {%- endif %}
    SELECT * FROM new_reopened_records
    {% if target.type == 'bigquery' -%}
        UNION DISTINCT
    {%- else -%}
        UNION
    {%- endif %}
    SELECT * FROM new_closed_records
)

{#- else if not automate_dv.is_any_incremental() -#}
{%- else %}

records_to_insert AS (
    SELECT {{ automate_dv.alias_all(source_cols, 'i') }}
    FROM source_data AS i
)

{#- end if not automate_dv.is_any_incremental() -#}
{%- endif %}

SELECT * FROM records_to_insert

{%- endmacro -%}
