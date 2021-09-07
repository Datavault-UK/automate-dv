{%- macro eff_sat_oos(src_pk, src_dfk, src_sfk, status, src_eff, src_ldts, src_source, source_model) -%}

    {{- adapter.dispatch('eff_sat_oos', 'dbtvault')(src_pk=src_pk, src_dfk=src_dfk, src_sfk=src_sfk,
                                                status=status, src_eff=src_eff, src_ldts=src_ldts,
                                                src_source=src_source, source_model=source_model) -}}
{%- endmacro -%}

{%- macro default__eff_sat_oos(src_pk, src_dfk, src_sfk, status, src_eff, src_ldts, src_source, source_model) -%}

{{- dbtvault.check_required_parameters(src_pk=src_pk, src_dfk=src_dfk, src_sfk=src_sfk,
                                       status=status, src_eff=src_eff, src_ldts=src_ldts, src_source=src_source,
                                       source_model=source_model) -}}

{%- set source_cols = dbtvault.expand_column_list(columns=[src_pk, src_dfk, src_sfk, src_eff, src_ldts, src_source]) -%}
{%- set fk_cols = dbtvault.expand_column_list(columns=[src_dfk, src_sfk]) -%}
{%- set dfk_cols = dbtvault.expand_column_list(columns=[src_dfk]) -%}
{%- set is_auto_end_dating = config.get('is_auto_end_dating', default=false) %}

{{- dbtvault.prepend_generated_by() }}

{%- set max_date = '9999-12-31 23:59:59.999' %}


WITH source_data AS (
    SELECT {{ dbtvault.prefix(source_cols, 'a', alias_target='source') }},
           ('TRUE'::BOOLEAN) AS {{ status }}
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
    SELECT {{ dbtvault.alias_all(source_cols, 'b') }}, b.{{- status }},
           ROW_NUMBER() OVER (
                PARTITION BY b.{{ src_pk }}
                ORDER BY b.{{ src_ldts }} DESC
           ) AS row_num
    FROM {{ this }} AS b
    QUALIFY row_num = 1
),

{# Selecting the open records of the most recent records for each link hashkey -#}
latest_open AS (
    SELECT {{ dbtvault.alias_all(source_cols, 'c') }}
    FROM latest_records AS c
    WHERE status = 'TRUE'
),

{# Selecting the closed records of the most recent records for each link hashkey -#}
latest_closed AS (
    SELECT {{ dbtvault.alias_all(source_cols, 'd') }}, {{ status }}
    FROM latest_records AS d
    WHERE status= 'FALSE'
),

{# Identifying the completely new link relationships to be opened in eff sat -#}
new_open_records AS (
    SELECT DISTINCT
        {{ dbtvault.alias_all(source_cols, 'f') }},
        'TRUE'::BOOLEAN AS {{ status }}
    FROM source_data AS f
    LEFT JOIN latest_records AS lr
    ON f.{{ src_pk }} = lr.{{ src_pk }}
    WHERE lr.{{ src_pk }} IS NULL
),

{# Identifying the currently closed link relationships to be reopened in eff sat -#}
new_reopened_records AS (
    SELECT DISTINCT
        lc.{{ src_pk }},
        {{ dbtvault.alias_all(fk_cols, 'lc') }},
        g.{{ src_eff }} AS {{ src_eff }},
        g.{{ src_ldts }},
        g.{{ src_source }},
        'TRUE'::BOOLEAN AS {{ status }}
    FROM source_data AS g
    INNER JOIN latest_closed AS lc
    ON g.{{ src_pk }} = lc.{{ src_pk }}
),

{%- if is_auto_end_dating %}

{# Creating the closing records -#}
{# Identifying the currently open relationships that need to be closed due to change in SFK(s) -#}
new_closed_records AS (
    SELECT DISTINCT
        lo.{{ src_pk }},
        {{ dbtvault.alias_all(fk_cols, 'lo') }},
        h.{{ src_eff }} AS {{ src_eff }},
        h.{{ src_ldts }},
        lo.{{ src_source }},
        'FALSE'::BOOLEAN AS {{ status }}
    FROM source_data AS h
    INNER JOIN latest_open AS lo
    ON {{ dbtvault.multikey(src_dfk, prefix=['lo', 'h'], condition='=') }}
    WHERE ({{ dbtvault.multikey(src_sfk, prefix=['lo', 'h'], condition='<>', operator='OR') }})
),

{#- end if is_auto_end_dating -#}
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

{%- else %}

records_to_insert AS (
    SELECT {{ dbtvault.alias_all(source_cols, 'i') }},
    {{ status }}
    FROM source_data AS i
)

{#- end if not dbtvault.is_any_incremental() -#}
{%- endif %}

SELECT * FROM records_to_insert
{%- endmacro -%}

