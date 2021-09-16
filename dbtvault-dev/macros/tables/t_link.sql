{%- macro t_link(src_pk, src_fk, src_payload, src_eff, src_ldts, src_source, source_model, time_window_period, time_window_value) -%}

    {{- adapter.dispatch('t_link', packages = dbtvault.get_dbtvault_namespaces())(src_pk=src_pk, src_fk=src_fk, src_payload=src_payload,
                                                                                  src_eff=src_eff, src_ldts=src_ldts, src_source=src_source,
                                                                                  source_model=source_model,
                                                                                  time_window_period=time_window_period,
                                                                                  time_window_value=time_window_value) -}}

{%- endmacro %}

{%- macro default__t_link(src_pk, src_fk, src_payload, src_eff, src_ldts, src_source, source_model, time_window_period, time_window_value) -%}

{{- dbtvault.check_required_parameters(src_pk=src_pk, src_fk=src_fk, src_eff=src_eff,
                                       src_ldts=src_ldts, src_source=src_source,
                                       time_window_period=time_window_period,
                                       time_window_value=time_window_value
                                       source_model=source_model) -}}

{%- set source_cols = dbtvault.expand_column_list(columns=[src_pk, src_fk, src_payload, src_eff, src_ldts, src_source]) -%}
{%- set fk_cols = dbtvault.expand_column_list([src_fk]) -%}

{{ dbtvault.prepend_generated_by() }}

WITH stage AS (
    SELECT {{ source_cols | join(', ') }}
    FROM {{ ref(source_model) }}
    {%- if model.config.materialized == 'vault_insert_by_period' %}
    WHERE __PERIOD_FILTER__
    AND {{ dbtvault.multikey(src_pk, condition='IS NOT NULL') }}
    AND {{ dbtvault.multikey(fk_cols, condition='IS NOT NULL') }}
    {%- elif model.config.materialized == 'vault_insert_by_rank' %}
    WHERE __RANK_FILTER__
    AND {{ dbtvault.multikey(src_pk, condition='IS NOT NULL') }}
    AND {{ dbtvault.multikey(fk_cols, condition='IS NOT NULL') }}
    {%- else %}
    WHERE {{ dbtvault.multikey(src_pk, condition='IS NOT NULL') }}
    AND {{ dbtvault.multikey(fk_cols, condition='IS NOT NULL') }}
    {%- endif %}
),
records_to_insert AS (
    SELECT DISTINCT {{ dbtvault.prefix(source_cols, 'stg') }}
    FROM stage AS stg
    {% if dbtvault.is_any_incremental() -%}
    LEFT JOIN {{ this }} AS tgt
    ON {{ dbtvault.multikey(src_pk, prefix=['stg','tgt'], condition='=') }}
    {% if time_window_period and time_window_value -%}
    AND CAST({{ dbtvault.prefix([src_ldts], 'tgt') }} AS DATE) >= CAST(DATEADD({{ time_window_period }}, -{{ time_window_value }}, {{ dbtvault.current_timestamp() }}) AS DATE)
    {%- endif %}
    WHERE {{ dbtvault.multikey(src_pk, prefix='tgt', condition='IS NULL') }}
    {%- endif %}
)

SELECT * FROM records_to_insert

{%- endmacro -%}