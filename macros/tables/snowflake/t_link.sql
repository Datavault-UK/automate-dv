/*
 * Copyright (c) Business Thinking Ltd. 2019-2023
 * This software includes code developed by the AutomateDV (f.k.a dbtvault) Team at Business Thinking Ltd. Trading as Datavault
 */

{%- macro t_link(src_pk, src_fk, src_payload, src_extra_columns, src_eff, src_ldts, src_source, source_model) -%}

    {{- automate_dv.check_required_parameters(src_pk=src_pk, src_fk=src_fk, src_eff=src_eff,
                                              src_ldts=src_ldts, src_source=src_source,
                                              source_model=source_model) -}}

    {{ automate_dv.prepend_generated_by() }}

    {{ adapter.dispatch('t_link', 'automate_dv')(src_pk=src_pk, src_fk=src_fk, src_payload=src_payload,
                                                 src_extra_columns=src_extra_columns,
                                                 src_eff=src_eff, src_ldts=src_ldts, src_source=src_source,
                                                 source_model=source_model) -}}

{%- endmacro %}

{%- macro default__t_link(src_pk, src_fk, src_payload, src_extra_columns, src_eff, src_ldts, src_source, source_model) -%}

{%- set source_cols = automate_dv.expand_column_list(columns=[src_pk, src_fk, src_payload, src_extra_columns, src_eff, src_ldts, src_source]) -%}
{%- set fk_cols = automate_dv.expand_column_list([src_fk]) %}

WITH stage AS (
    SELECT {{ source_cols | join(', ') }}
    FROM {{ ref(source_model) }}
    {%- if model.config.materialized == 'vault_insert_by_period' %}
    WHERE __PERIOD_FILTER__
    AND {{ automate_dv.multikey(src_pk, condition='IS NOT NULL') }}
    AND {{ automate_dv.multikey(fk_cols, condition='IS NOT NULL') }}
    {%- elif model.config.materialized == 'vault_insert_by_rank' %}
    WHERE __RANK_FILTER__
    AND {{ automate_dv.multikey(src_pk, condition='IS NOT NULL') }}
    AND {{ automate_dv.multikey(fk_cols, condition='IS NOT NULL') }}
    {%- else %}
    WHERE {{ automate_dv.multikey(src_pk, condition='IS NOT NULL') }}
    AND {{ automate_dv.multikey(fk_cols, condition='IS NOT NULL') }}
    {%- endif %}
),
records_to_insert AS (
    SELECT DISTINCT {{ automate_dv.prefix(source_cols, 'stg') }}
    FROM stage AS stg
    {% if automate_dv.is_any_incremental() -%}
    LEFT JOIN {{ this }} AS tgt
    ON {{ automate_dv.multikey(src_pk, prefix=['stg','tgt'], condition='=') }}
    WHERE {{ automate_dv.multikey(src_pk, prefix='tgt', condition='IS NULL') }}
    {%- endif %}
)

SELECT * FROM records_to_insert

{%- endmacro -%}
