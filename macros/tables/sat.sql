{%- macro bigquery__sat(src_pk, src_hashdiff, src_payload, src_eff, src_ldts, src_source, source_model, out_of_sequence) -%}

{# START > ADDED BY GEORGIAN #}
{%- if out_of_sequence and execute -%}
  {{- exceptions.raise_compiler_error("Out of sequence Sats are not supported by the current version of dbtvault_bq") -}}
{%- endif -%}
{# END   > ADDED BY GEORGIAN #}

{%- set source_cols = dbtvault.expand_column_list(columns=[src_pk, src_hashdiff, src_payload, src_eff, src_ldts, src_source]) -%}

{{ dbtvault.prepend_generated_by() }}

WITH source_data AS (
    SELECT *
    FROM {{ ref(source_model) }}
    {%- if model.config.materialized == 'vault_insert_by_period' %}
    WHERE __PERIOD_FILTER__
    {% endif %}
),

{% if dbtvault.is_vault_insert_by_period() or is_incremental() -%}

latest_sat_records_in_source AS (
    SELECT {{ dbtvault.prefix(source_cols, 'a', alias_target='target') }}
    FROM {{ this }} as a
    JOIN source_data as b
    ON a.{{ src_pk }} = b.{{ src_pk }}
    WHERE 1 = 1
    QUALIFY
        1 = RANK() OVER (
            PARTITION BY {{ dbtvault.prefix([src_pk], 'a') }}
            ORDER BY {{ dbtvault.prefix([src_ldts], 'a') }} DESC
        )
),

{% endif -%}

records_to_insert AS (
    SELECT DISTINCT {{ dbtvault.alias_all(source_cols, 'c') }}
    FROM source_data AS c
    {% if dbtvault.is_vault_insert_by_period() or is_incremental() -%}
    LEFT JOIN
        latest_sat_records_in_source
    ON
        {{ dbtvault.prefix([src_hashdiff], 'latest_sat_records_in_source', alias_target='target') }} = {{ dbtvault.prefix([src_hashdiff], 'c') }}
    WHERE
        {{ dbtvault.prefix([src_hashdiff], 'latest_sat_records_in_source', alias_target='target') }} IS NULL
    {% endif %}
)

SELECT * FROM records_to_insert

{%- endmacro -%}