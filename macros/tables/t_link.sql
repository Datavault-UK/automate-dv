{%- macro t_link(src_pk, src_fk, src_payload, src_eff, src_ldts, src_source, source_model) -%}
    {# BQ Change: Look locally cause of incompatible prefix macro call #}
    {{- adapter.dispatch('t_link')(
            src_pk=src_pk, src_fk=src_fk, src_payload=src_payload,
            src_eff=src_eff, src_ldts=src_ldts, src_source=src_source,
            source_model=source_model
        ) -}}

{%- endmacro %}

{# BQ Change: snowflake__t_link -> bigquery__t_link #}
{%- macro bigquery__t_link(src_pk, src_fk, src_payload, src_eff, src_ldts, src_source, source_model) -%}

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
    {# BQ Change: prefix -> snowflake__prefix #}
    SELECT DISTINCT {{ dbtvault.snowflake__prefix(source_cols, 'stg') }}
    FROM stage AS stg
    {% if is_incremental() -%}
    LEFT JOIN {{ this }} AS tgt
    {# BQ Change: prefix -> snowflake__prefix #}
    ON {{ dbtvault.snowflake__prefix([src_pk], 'stg') }} = {{ dbtvault.snowflake__prefix([src_pk], 'tgt') }}
    {# BQ Change: prefix -> snowflake__prefix #}
    WHERE {{ dbtvault.snowflake__prefix([src_pk], 'tgt') }} IS NULL
    {%- endif %}
)

SELECT * FROM records_to_insert

{%- endmacro -%}