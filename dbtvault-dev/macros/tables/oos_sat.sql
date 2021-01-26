{%- macro oos_sat(src_pk, src_hashdiff, src_payload, src_eff, src_ldts, src_source, source_model, out_of_sequence=None) -%}

    {{- adapter.dispatch('oos_sat', packages = dbtvault.get_dbtvault_namespaces())(src_pk=src_pk, src_hashdiff=src_hashdiff,
                                                                                   src_payload=src_payload, src_eff=src_eff, src_ldts=src_ldts,
                                                                                   src_source=src_source, source_model=source_model,
                                                                                   out_of_sequence=out_of_sequence) -}}

{%- endmacro %}

{%- macro default__oos_sat(src_pk, src_hashdiff, src_payload, src_eff, src_ldts, src_source, source_model, out_of_sequence) -%}

{%- set source_cols = dbtvault.expand_column_list(columns=[src_pk, src_hashdiff, src_payload, src_eff, src_ldts, src_source]) -%}

{%- if out_of_sequence is not none %}
    {%- set xts_model = out_of_sequence["source_xts"] %}
    {%- set sat_name_col = out_of_sequence["sat_name_col"] %}
    {%- set insert_date = out_of_sequence["insert_date"] %}
    -- depends_on: {{ ref(xts_model) }}
    -- depends_on: {{ this }}
{% endif -%}

{{ dbtvault.prepend_generated_by() }}

WITH source_data AS (
    SELECT *
    FROM {{ ref(source_model) }}
    {%- if model.config.materialized == 'vault_insert_by_period' %}
    WHERE __PERIOD_FILTER__
    {% endif %}
),
{% if dbtvault.is_vault_insert_by_period() or is_incremental() -%}

update_records AS (
    SELECT {{ dbtvault.prefix(source_cols, 'a', alias_target='target') }}
    FROM {{ this }} as a
    JOIN source_data as b
    ON a.{{ src_pk }} = b.{{ src_pk }}
    {%- if out_of_sequence is not none %}
    WHERE {{ dbtvault.prefix([src_ldts], 'a') }} < DATE('{{ insert_date }}')
    {%- endif %}
),
rank AS (
    SELECT {{ dbtvault.prefix(source_cols, 'c', alias_target='target') }},
           CASE WHEN RANK()
           OVER (PARTITION BY {{ dbtvault.prefix([src_pk], 'c') }}
           ORDER BY {{ dbtvault.prefix([src_ldts], 'c') }} DESC) = 1
    THEN 'Y' ELSE 'N' END AS latest
    FROM update_records as c
),
stage AS (
    SELECT {{ dbtvault.prefix(source_cols, 'd', alias_target='target') }}
    FROM rank AS d
    WHERE d.latest = 'Y'
),
{% endif -%}
{%- if out_of_sequence is not none and is_incremental() %}
sat_stg AS (
  SELECT DISTINCT
    {{ dbtvault.prefix(source_cols, 'a') }},
    {{ dbtvault.prefix([src_ldts], 'b') }} AS STG_LOAD_DATE,
    {{ dbtvault.prefix([src_eff], 'b') }} AS STG_EFFECTIVE_FROM
  FROM {{ this }} AS a
  LEFT JOIN {{ ref(source_model) }} AS b ON {{ dbtvault.prefix([src_pk], 'a') }} = {{ dbtvault.prefix([src_pk], 'b') }}
  WHERE {{ dbtvault.prefix([src_ldts], 'a') }} < DATE('{{ insert_date }}')
),
distinct_stage AS (
  SELECT DISTINCT * FROM {{ ref(source_model) }}
),
xts_stg AS (
  SELECT
    {{ dbtvault.prefix(source_cols, 'b') }},
    {{ dbtvault.prefix([src_ldts], 'a') }} AS XTS_LOAD_DATE,
    LEAD({{ dbtvault.prefix([src_ldts], 'a') }})
    OVER(PARTITION BY {{ dbtvault.prefix([src_pk], 'a') }}
    ORDER BY {{ dbtvault.prefix([src_ldts], 'b') }}) AS NEXT_RECORD_DATE,
    LAG({{ dbtvault.prefix([src_hashdiff], 'a') }})
    OVER(PARTITION BY {{ dbtvault.prefix([src_pk], 'a') }}
    ORDER BY {{ dbtvault.prefix([src_ldts], 'b') }}) AS PREV_RECORD_HASHDIFF,
    LEAD({{ dbtvault.prefix([src_hashdiff], 'a') }})
    OVER(PARTITION BY {{ dbtvault.prefix([src_pk], 'a') }}
    ORDER BY {{ dbtvault.prefix([src_ldts], 'b') }}) AS NEXT_RECORD_HASHDIFF
  FROM {{ ref(xts_model) }} AS a
  INNER JOIN distinct_stage AS b
  ON {{ dbtvault.prefix([src_pk], 'a') }} = {{ dbtvault.prefix([src_pk], 'b') }}
  WHERE {{ dbtvault.prefix([sat_name_col], 'a') }} = '{{ this }}'
  ORDER BY {{ src_pk }}, XTS_LOAD_DATE
),
out_of_sequence_inserts AS (
  SELECT
    {{ dbtvault.prefix(source_cols, 'c') }}
  FROM xts_stg AS c
  WHERE (({{ dbtvault.prefix([src_hashdiff], 'c') }} != c.PREV_RECORD_HASHDIFF
          AND c.PREV_RECORD_HASHDIFF = c.NEXT_RECORD_HASHDIFF)
          OR ({{ dbtvault.prefix([src_hashdiff], 'c') }} != c.PREV_RECORD_HASHDIFF
          AND {{ dbtvault.prefix([src_hashdiff], 'c') }} = c.NEXT_RECORD_HASHDIFF))
  AND ({{ dbtvault.prefix([src_ldts], 'c') }}
  BETWEEN c.XTS_LOAD_DATE
  AND c.NEXT_RECORD_DATE)
  UNION
  SELECT
    {{ dbtvault.prefix([src_pk, src_hashdiff], 'd')}},
    {{ dbtvault.prefix(src_payload, 'd') }},
    c.NEXT_RECORD_DATE AS {{ src_ldts }},
    c.NEXT_RECORD_DATE AS {{ src_eff }},
    {{ dbtvault.prefix([src_source], 'd') }}
  FROM xts_stg AS c
  INNER JOIN sat_stg AS d
  ON {{dbtvault.prefix([src_pk], 'c') }} = {{dbtvault.prefix([src_pk], 'd') }}
  WHERE ({{ dbtvault.prefix([src_hashdiff], 'c') }} != c.PREV_RECORD_HASHDIFF
  AND c.PREV_RECORD_HASHDIFF = c.NEXT_RECORD_HASHDIFF)
  AND ({{ dbtvault.prefix([src_ldts], 'c') }}
  BETWEEN c.XTS_LOAD_DATE
  AND c.NEXT_RECORD_DATE)
),
{%- endif %}

records_to_insert AS (
    SELECT DISTINCT {{ dbtvault.alias_all(source_cols, 'e') }}
    FROM source_data AS e
    {% if dbtvault.is_vault_insert_by_period() or is_incremental() -%}
    LEFT JOIN stage
    ON {{ dbtvault.prefix([src_hashdiff], 'stage', alias_target='target') }} = {{ dbtvault.prefix([src_hashdiff], 'e') }}
    WHERE {{ dbtvault.prefix([src_hashdiff], 'stage', alias_target='target') }} IS NULL
    {% endif %}
)

SELECT * FROM records_to_insert
{% if out_of_sequence is not none and is_incremental()-%}
UNION
SELECT * FROM out_of_sequence_inserts
{% endif -%}

{%- endmacro -%}