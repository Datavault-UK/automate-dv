{%- macro t_link(src_pk, src_fk, src_payload, src_eff, src_ldts, src_source, source_model) -%}

    {{- adapter.dispatch('t_link', packages = ['dbtvault'])(src_pk=src_pk, src_fk=src_fk, src_payload=src_payload,
                                                            src_eff=src_eff, src_ldts=src_ldts, src_source=src_source,
                                                            source_model=source_model) -}}

{%- endmacro %}

{%- macro snowflake__t_link(src_pk, src_fk, src_payload, src_eff, src_ldts, src_source, source_model) -%}

{%- set source_cols = dbtvault.expand_column_list(columns=[src_pk, src_fk, src_payload, src_eff, src_ldts, src_source]) -%}

{{ dbtvault.prepend_generated_by() }}

WITH stage AS (
    SELECT {{ source_cols | join(', ') }}
    FROM {{ ref(source_model) }}
    {%- if model.config.materialized == 'vault_insert_by_period' %}
    WHERE __PERIOD_FILTER__
    {%- endif %}
),
records_to_insert AS (
    SELECT DISTINCT {{ dbtvault.prefix(source_cols, 'stg') }}
    FROM stage AS stg
    {% if is_incremental() -%}
    LEFT JOIN {{ this }} AS tgt
    ON {{ dbtvault.prefix([src_pk], 'stg') }} = {{ dbtvault.prefix([src_pk], 'tgt') }}
    WHERE {{ dbtvault.prefix([src_pk], 'tgt') }} IS NULL
    {%- endif %}
)

SELECT * FROM records_to_insert

{%- endmacro -%}