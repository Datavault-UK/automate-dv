{%- macro oos_sat(src_pk, src_hashdiff, src_payload, src_eff, src_ldts, src_source, source_model, out_of_sequence=None) -%}

    {{- adapter.dispatch('oos_sat', packages = dbtvault.get_dbtvault_namespaces())(src_pk=src_pk, src_hashdiff=src_hashdiff,
                                                                                   src_payload=src_payload, src_eff=src_eff, src_ldts=src_ldts,
                                                                                   src_source=src_source, source_model=source_model,
                                                                                   out_of_sequence=out_of_sequence) -}}

{%- endmacro %}

{%- macro default__oos_sat(src_pk, src_hashdiff, src_payload, src_eff, src_ldts, src_source, source_model, out_of_sequence) -%}

{%- set source_cols = dbtvault.expand_column_list(columns=[src_pk, src_hashdiff, src_payload, src_eff, src_ldts, src_source]) -%}
{%- set rank_cols = dbtvault.expand_column_list(columns=[src_pk, src_hashdiff, src_ldts]) -%}

{%- if model.config.materialized == 'vault_insert_by_rank' %}
    {%- set source_cols_with_rank = source_cols + [config.get('rank_column')] -%}
{%- endif -%}

{%- if out_of_sequence is not none %}
    {%- set xts_model = out_of_sequence["source_xts"] %}
    {%- set sat_name_col = out_of_sequence["sat_name_col"] %}
    {%- set insert_date = out_of_sequence["insert_date"] %}
    -- depends_on: {{ ref(xts_model) }}
    -- depends_on: {{ this }}
{% endif -%}

{{ dbtvault.prepend_generated_by() }}

WITH source_data AS (
    {%- if model.config.materialized == 'vault_insert_by_rank' %}
    SELECT {{ dbtvault.prefix(source_cols_with_rank, 'a', alias_target='source') }}
    {%- else %}
    SELECT {{ dbtvault.prefix(source_cols, 'a', alias_target='source') }}
    {%- endif %}
    FROM {{ ref(source_model) }} AS a
    {%- if model.config.materialized == 'vault_insert_by_period' %}
    WHERE __PERIOD_FILTER__
    {% endif %}
    {%- set source_cte = "source_data" %}
),

{%- if model.config.materialized == 'vault_insert_by_rank' %}
rank_col AS (
    SELECT * FROM source_data
    WHERE __RANK_FILTER__
    {%- set source_cte = "rank_col" %}
),
{% endif -%}

{% if dbtvault.is_vault_insert_by_period() or dbtvault.is_vault_insert_by_rank() or is_incremental() %}

update_records AS (
    SELECT {{ dbtvault.prefix(source_cols, 'a', alias_target='target') }}
    FROM {{ this }} as a
    JOIN source_data as b
    ON a.{{ src_pk }} = b.{{ src_pk }}
    {%- if out_of_sequence is not none %}
    WHERE {{ dbtvault.prefix([src_ldts], 'a') }} < {{ dbtvault.date_timestamp(out_of_sequence) }}
    {%- endif %}
),

latest_records AS (
    SELECT {{ dbtvault.prefix(rank_cols, 'c', alias_target='target') }},
           CASE WHEN RANK()
           OVER (PARTITION BY {{ dbtvault.prefix([src_pk], 'c') }}
           ORDER BY {{ dbtvault.prefix([src_ldts], 'c') }} DESC) = 1
    THEN 'Y' ELSE 'N' END AS latest
    FROM update_records as c
    QUALIFY latest = 'Y'
),
{%- if out_of_sequence is not none %}

sat_records_before_insert_date AS (
  SELECT DISTINCT
    {{ dbtvault.prefix(source_cols, 'a') }},
    {{ dbtvault.prefix([src_ldts], 'b') }} AS STG_LOAD_DATE,
    {{ dbtvault.prefix([src_eff], 'b') }} AS STG_EFFECTIVE_FROM
  FROM {{ this }} AS a
  LEFT JOIN {{ ref(source_model) }} AS b ON {{ dbtvault.prefix([src_pk], 'a') }} = {{ dbtvault.prefix([src_pk], 'b') }}
  WHERE {{ dbtvault.prefix([src_ldts], 'a') }} < {{ dbtvault.date_timestamp(out_of_sequence) }}
),

distinct_stage AS (
  SELECT DISTINCT * FROM {{ ref(source_model) }}
),

matching_xts_stg_records AS (
  SELECT
    {{ dbtvault.prefix(source_cols, 'b') }},
    {{ dbtvault.prefix([src_ldts], 'a') }} AS XTS_LOAD_DATE,
    LEAD({{ dbtvault.prefix([src_ldts], 'a') }}) OVER(
        PARTITION BY {{ dbtvault.prefix([src_pk], 'a') }}
        ORDER BY {{ dbtvault.prefix([src_ldts], 'a') }}) AS NEXT_RECORD_DATE,
    LAG({{ dbtvault.prefix([src_hashdiff], 'a') }}) OVER(
        PARTITION BY {{ dbtvault.prefix([src_pk], 'a') }}
        ORDER BY {{ dbtvault.prefix([src_ldts], 'a') }}) AS PREV_RECORD_HASHDIFF,
    LEAD({{ dbtvault.prefix([src_hashdiff], 'a') }}) OVER(
        PARTITION BY {{ dbtvault.prefix([src_pk], 'a') }}
        ORDER BY {{ dbtvault.prefix([src_ldts], 'a') }}) AS NEXT_RECORD_HASHDIFF
  FROM {{ ref(xts_model) }} AS a
  INNER JOIN distinct_stage AS b
  ON {{ dbtvault.prefix([src_pk], 'a') }} = {{ dbtvault.prefix([src_pk], 'b') }}
  WHERE {{ dbtvault.prefix([sat_name_col], 'a') }} = '{{ this.identifier }}'
  QUALIFY ((PREV_RECORD_HASHDIFF != {{ dbtvault.prefix([src_hashdiff], 'b') }}
           AND PREV_RECORD_HASHDIFF = NEXT_RECORD_HASHDIFF)
           OR (PREV_RECORD_HASHDIFF != {{ dbtvault.prefix([src_hashdiff], 'b') }}
           AND NEXT_RECORD_HASHDIFF != {{ dbtvault.prefix([src_hashdiff], 'b') }}))
  AND {{ dbtvault.prefix([src_ldts], 'b') }}
  BETWEEN XTS_LOAD_DATE
  AND NEXT_RECORD_DATE
  ORDER BY {{ src_pk }}, XTS_LOAD_DATE
),
records_from_sat AS (
  SELECT
    {{ dbtvault.prefix([src_pk, src_hashdiff], 'd')}},
    {{ dbtvault.prefix(src_payload, 'd') }},
    c.NEXT_RECORD_DATE AS {{ src_ldts }},
    c.NEXT_RECORD_DATE AS {{ src_eff }},
    {{ dbtvault.prefix([src_source], 'd') }}
  FROM matching_xts_stg_records AS c
  INNER JOIN sat_records_before_insert_date AS d
  ON {{dbtvault.prefix([src_pk], 'c') }} = {{dbtvault.prefix([src_pk], 'd') }}
),
out_of_sequence_inserts AS (
  SELECT {{ dbtvault.prefix(source_cols, 'c') }} FROM matching_xts_stg_records AS c
  UNION
  SELECT * FROM records_from_sat
),
{%- endif %}

{%- endif %}

records_to_insert AS (
    SELECT DISTINCT {{ dbtvault.alias_all(source_cols, 'e') }}
    FROM {{ source_cte }} AS e
    {%- if dbtvault.is_vault_insert_by_period() or dbtvault.is_vault_insert_by_rank() or is_incremental() %}
    LEFT JOIN latest_records
    ON {{ dbtvault.prefix([src_hashdiff], 'latest_records', alias_target='target') }} = {{ dbtvault.prefix([src_hashdiff], 'e') }}
    WHERE {{ dbtvault.prefix([src_hashdiff], 'latest_records', alias_target='target') }} IS NULL
    {% if out_of_sequence is not none -%}
    UNION
    SELECT * FROM out_of_sequence_inserts
    {%- endif %}
    {%- endif %}
)

SELECT * FROM records_to_insert

{%- endmacro -%}