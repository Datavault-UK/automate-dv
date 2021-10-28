{%- macro sat(src_pk, src_hashdiff, src_payload, src_eff, src_ldts, src_source, source_model, out_of_sequence=none) -%}

    {{- adapter.dispatch('sat', 'dbtvault')(src_pk=src_pk, src_hashdiff=src_hashdiff,
                                            src_payload=src_payload, src_eff=src_eff, src_ldts=src_ldts,
                                            src_source=src_source, source_model=source_model,
                                            out_of_sequence=out_of_sequence) -}}

{%- endmacro %}

{%- macro default__sat(src_pk, src_hashdiff, src_payload, src_eff, src_ldts, src_source, source_model, out_of_sequence) -%}

{{- dbtvault.check_required_parameters(src_pk=src_pk, src_hashdiff=src_hashdiff, src_payload=src_payload,
                                       src_ldts=src_ldts, src_source=src_source,
                                       source_model=source_model) -}}

{%- set source_cols = dbtvault.expand_column_list(columns=[src_pk, src_hashdiff, src_payload, src_eff, src_ldts, src_source]) -%}
{%- set rank_cols = dbtvault.expand_column_list(columns=[src_pk, src_hashdiff, src_ldts]) -%}
{%- set pk_cols = dbtvault.expand_column_list(columns=[src_pk]) -%}

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
    {%- elif out_of_sequence is not none %}
    SELECT DISTINCT {{ dbtvault.prefix(source_cols, 'a', alias_target='source') }}
    {%- else %}
    SELECT {{ dbtvault.prefix(source_cols, 'a', alias_target='source') }}
    {%- endif %}
    FROM {{ ref(source_model) }} AS a
    WHERE {{ dbtvault.multikey(src_pk, prefix='a', condition='IS NOT NULL') }}
    {%- if model.config.materialized == 'vault_insert_by_period' %}
    AND __PERIOD_FILTER__
    {% elif model.config.materialized == 'vault_insert_by_rank' %}
    AND __RANK_FILTER__
    {% endif %}
),

{% if dbtvault.is_any_incremental() %}

latest_records AS (

    SELECT {{ dbtvault.prefix(rank_cols, 'a', alias_target='target') }}
    FROM (
        SELECT {{ dbtvault.prefix(rank_cols, 'current_records', alias_target='target') }},
        RANK() OVER (
        PARTITION BY {{ dbtvault.prefix([src_pk], 'current_records') }}
        ORDER BY {{ dbtvault.prefix([src_ldts], 'current_records') }} DESC
        ) AS rank
        FROM {{ this }} AS current_records
        JOIN (
        SELECT DISTINCT {{ dbtvault.prefix([src_pk], 'source_data') }}
        FROM source_data
        ) AS source_records
        ON {{ dbtvault.multikey(src_pk, prefix=['current_records','source_records'], condition='=') }}
        {%- if out_of_sequence is not none %}
        WHERE {{ dbtvault.prefix([src_ldts], 'current_records') }} < {{ dbtvault.date_timestamp(out_of_sequence) }}
        {%- endif %}
        ) a
    WHERE a.rank = 1
),

{%- if out_of_sequence is not none %}

sat_records_before_insert_date AS (
  SELECT DISTINCT
    {{ dbtvault.prefix(source_cols, 'a') }}
  FROM {{ this }} AS a
  WHERE {{ dbtvault.prefix([src_ldts], 'a') }} < {{ dbtvault.date_timestamp(out_of_sequence) }}
),

matching_xts_stg_records AS (
  SELECT
    {{ dbtvault.prefix(source_cols, 'b') }},
    {{ dbtvault.prefix([src_ldts], 'a') }} AS XTS_LOAD_DATE,
    LEAD({{ dbtvault.prefix([src_ldts], 'a') }}) OVER(
        PARTITION BY {{ dbtvault.prefix([src_pk], 'a') }}
        ORDER BY {{ dbtvault.prefix([src_ldts], 'a') }}) AS NEXT_RECORD_DATE,
    {{ dbtvault.prefix([src_pk], 'a') }} AS PREV_RECORD_HASHDIFF,
    LEAD({{ dbtvault.prefix([src_hashdiff], 'a') }}) OVER(
        PARTITION BY {{ dbtvault.prefix([src_pk], 'a') }}
        ORDER BY {{ dbtvault.prefix([src_ldts], 'a') }}) AS NEXT_RECORD_HASHDIFF
  FROM {{ ref(xts_model) }} AS a
  INNER JOIN source_data AS b
  ON {{ dbtvault.multikey(src_pk, prefix=['a','b'], condition='=') }}
  WHERE {{ dbtvault.prefix([sat_name_col], 'a') }} = '{{ this.identifier }}'
  QUALIFY ((PREV_RECORD_HASHDIFF != {{ dbtvault.prefix([src_hashdiff], 'b') }}
           AND PREV_RECORD_HASHDIFF = NEXT_RECORD_HASHDIFF)
           OR (PREV_RECORD_HASHDIFF != {{ dbtvault.prefix([src_hashdiff], 'b') }}
           AND NEXT_RECORD_HASHDIFF != {{ dbtvault.prefix([src_hashdiff], 'b') }}))
  AND {{ dbtvault.prefix([src_ldts], 'b') }}
  BETWEEN XTS_LOAD_DATE AND NEXT_RECORD_DATE
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
  ON {{ dbtvault.multikey(src_pk, prefix=['c','d'], condition='=') }}
),

out_of_sequence_inserts AS (
  SELECT {{ dbtvault.prefix(source_cols, 'c') }} FROM matching_xts_stg_records AS c
  UNION
  SELECT * FROM records_from_sat
),
{%- endif %}

{%- endif %}

records_to_insert AS (
    SELECT DISTINCT {{ dbtvault.alias_all(source_cols, 'stage') }}
    FROM source_data AS stage
    {%- if dbtvault.is_any_incremental() %}
    LEFT JOIN latest_records
    ON {{ dbtvault.multikey(src_pk, prefix=['latest_records','stage'], condition='=') }}
    WHERE {{ dbtvault.prefix([src_hashdiff], 'latest_records', alias_target='target') }} != {{ dbtvault.prefix([src_hashdiff], 'stage') }}
        OR {{ dbtvault.prefix([src_hashdiff], 'latest_records', alias_target='target') }} IS NULL
    {% if out_of_sequence is not none -%}
    UNION
    SELECT * FROM out_of_sequence_inserts
    {%- endif %}
    {%- endif %}
)

SELECT * FROM records_to_insert

{%- endmacro -%}

{%- macro bigquery__sat(src_pk, src_hashdiff, src_payload, src_eff, src_ldts, src_source, source_model) -%}

{{- dbtvault.check_required_parameters(src_pk=src_pk, src_hashdiff=src_hashdiff, src_payload=src_payload,
                                       src_ldts=src_ldts, src_source=src_source,
                                       source_model=source_model) -}}

{%- set source_cols = dbtvault.expand_column_list(columns=[src_pk, src_hashdiff, src_payload, src_eff, src_ldts, src_source]) -%}
{%- set rank_cols = dbtvault.expand_column_list(columns=[src_pk, src_hashdiff, src_ldts]) -%}
{%- set pk_cols = dbtvault.expand_column_list(columns=[src_pk]) -%}

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
    {%- elif out_of_sequence is not none %}
    SELECT DISTINCT {{ dbtvault.prefix(source_cols, 'a', alias_target='source') }}
    {%- else %}
    SELECT {{ dbtvault.prefix(source_cols, 'a', alias_target='source') }}
    {%- endif %}
    FROM {{ ref(source_model) }} AS a
    WHERE {{ dbtvault.multikey(src_pk, prefix='a', condition='IS NOT NULL') }}
    {%- if model.config.materialized == 'vault_insert_by_period' %}
    AND __PERIOD_FILTER__
    {% elif model.config.materialized == 'vault_insert_by_rank' %}
    AND __RANK_FILTER__
    {% endif %}
),

{% if dbtvault.is_any_incremental() %}

latest_records_non_ranked AS (

    SELECT {{ dbtvault.prefix(rank_cols, 'a', alias_target='target') }}
    FROM (
        SELECT {{ dbtvault.prefix(rank_cols, 'current_records', alias_target='target') }},
        RANK() OVER (
        PARTITION BY {{ dbtvault.prefix([src_pk], 'current_records') }}
        ORDER BY {{ dbtvault.prefix([src_ldts], 'current_records') }} DESC
        ) AS rank
        FROM {{ this }} AS current_records
        JOIN (
        SELECT DISTINCT {{ dbtvault.prefix([src_pk], 'source_data') }}
        FROM source_data
        ) AS source_records
        ON {{ dbtvault.multikey(src_pk, prefix=['current_records','source_records'], condition='=') }}
        {%- if out_of_sequence is not none %}
        WHERE {{ dbtvault.prefix([src_ldts], 'current_records') }} < {{ dbtvault.date_timestamp(out_of_sequence) }}
        {%- endif %}
        ) a
    WHERE a.rank = 1
),

latest_records AS (
    SELECT * FROM latest_records_non_ranked
    WHERE rank = 1
),


{%- if out_of_sequence is not none %}

sat_records_before_insert_date AS (
  SELECT DISTINCT
    {{ dbtvault.prefix(source_cols, 'a') }}
  FROM {{ this }} AS a
  WHERE {{ dbtvault.prefix([src_ldts], 'a') }} < {{ dbtvault.date_timestamp(out_of_sequence) }}
),

matching_xts_stg_records AS (
  SELECT
    {{ dbtvault.prefix(source_cols, 'b') }},
    {{ dbtvault.prefix([src_ldts], 'a') }} AS XTS_LOAD_DATE,
    LEAD({{ dbtvault.prefix([src_ldts], 'a') }}) OVER(
        PARTITION BY {{ dbtvault.prefix([src_pk], 'a') }}
        ORDER BY {{ dbtvault.prefix([src_ldts], 'a') }}) AS NEXT_RECORD_DATE,
    {{ dbtvault.prefix([src_pk], 'a') }} AS PREV_RECORD_HASHDIFF,
    LEAD({{ dbtvault.prefix([src_hashdiff], 'a') }}) OVER(
        PARTITION BY {{ dbtvault.prefix([src_pk], 'a') }}
        ORDER BY {{ dbtvault.prefix([src_ldts], 'a') }}) AS NEXT_RECORD_HASHDIFF
  FROM {{ ref(xts_model) }} AS a
  INNER JOIN source_data AS b
  ON {{ dbtvault.multikey(src_pk, prefix=['a','b'], condition='=') }}
  WHERE {{ dbtvault.prefix([sat_name_col], 'a') }} = '{{ this.identifier }}'
  QUALIFY ((PREV_RECORD_HASHDIFF != {{ dbtvault.prefix([src_hashdiff], 'b') }}
           AND PREV_RECORD_HASHDIFF = NEXT_RECORD_HASHDIFF)
           OR (PREV_RECORD_HASHDIFF != {{ dbtvault.prefix([src_hashdiff], 'b') }}
           AND NEXT_RECORD_HASHDIFF != {{ dbtvault.prefix([src_hashdiff], 'b') }}))
  AND {{ dbtvault.prefix([src_ldts], 'b') }}
  BETWEEN XTS_LOAD_DATE AND NEXT_RECORD_DATE
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
  ON {{ dbtvault.multikey(src_pk, prefix=['c','d'], condition='=') }}
),

out_of_sequence_inserts AS (
  SELECT {{ dbtvault.prefix(source_cols, 'c') }} FROM matching_xts_stg_records AS c
  UNION
  SELECT * FROM records_from_sat
),
{%- endif %}

{%- endif %}

records_to_insert AS (
    SELECT DISTINCT {{ dbtvault.alias_all(source_cols, 'stage') }}
    FROM source_data AS stage
    {%- if dbtvault.is_any_incremental() %}
    LEFT JOIN latest_records
    ON {{ dbtvault.multikey(src_pk, prefix=['latest_records','stage'], condition='=') }}
    WHERE {{ dbtvault.prefix([src_hashdiff], 'latest_records', alias_target='target') }} != {{ dbtvault.prefix([src_hashdiff], 'stage') }}
        OR {{ dbtvault.prefix([src_hashdiff], 'latest_records', alias_target='target') }} IS NULL
    {% if out_of_sequence is not none -%}
    UNION
    SELECT * FROM out_of_sequence_inserts
    {%- endif %}
    {%- endif %}
)

SELECT * FROM records_to_insert

{%- endmacro -%}


{%- macro sqlserver__sat(src_pk, src_hashdiff, src_payload, src_eff, src_ldts, src_source, source_model, out_of_sequence) -%}

{{- dbtvault.check_required_parameters(src_pk=src_pk, src_hashdiff=src_hashdiff, src_payload=src_payload,
                                       src_ldts=src_ldts, src_source=src_source,
                                       source_model=source_model) -}}

{%- set source_cols = dbtvault.expand_column_list(columns=[src_pk, src_hashdiff, src_payload, src_eff, src_ldts, src_source]) -%}
{%- set rank_cols = dbtvault.expand_column_list(columns=[src_pk, src_hashdiff, src_ldts]) -%}
{%- set pk_cols = dbtvault.expand_column_list(columns=[src_pk]) -%}

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
    {%- elif out_of_sequence is not none %}
    SELECT DISTINCT {{ dbtvault.prefix(source_cols, 'a', alias_target='source') }}
    {%- else %}
    SELECT {{ dbtvault.prefix(source_cols, 'a', alias_target='source') }}
    {%- endif %}
    FROM {{ ref(source_model) }} AS a
    WHERE {{ dbtvault.multikey(src_pk, prefix='a', condition='IS NOT NULL') }}
    {%- if model.config.materialized == 'vault_insert_by_period' %}
    AND __PERIOD_FILTER__
    {% elif model.config.materialized == 'vault_insert_by_rank' %}
    AND __RANK_FILTER__
    {% endif %}
),

{% if dbtvault.is_any_incremental() %}

latest_records AS (

    SELECT {{ dbtvault.prefix(rank_cols, 'a', alias_target='target') }}
    FROM
    (
        SELECT {{ dbtvault.prefix(rank_cols, 'current_records', alias_target='target') }},
               RANK() OVER (
                   PARTITION BY {{ dbtvault.prefix([src_pk], 'current_records') }}
                   ORDER BY {{ dbtvault.prefix([src_ldts], 'current_records') }} DESC
               ) AS rank
        FROM {{ this }} AS current_records
        JOIN (
            SELECT DISTINCT {{ dbtvault.prefix([src_pk], 'source_data') }}
            FROM source_data
        ) AS source_records
        ON {{ dbtvault.multikey(src_pk, prefix=['current_records','source_records'], condition='=') }}
        {%- if out_of_sequence is not none %}
        WHERE {{ dbtvault.prefix([src_ldts], 'current_records') }} < {{ dbtvault.date_timestamp(out_of_sequence) }}
        {%- endif %}
    ) a
    WHERE a.rank = 1
),

{%- if out_of_sequence is not none %}

sat_records_before_insert_date AS (
  SELECT DISTINCT
    {{ dbtvault.prefix(source_cols, 'a') }}
  FROM {{ this }} AS a
  WHERE {{ dbtvault.prefix([src_ldts], 'a') }} < {{ dbtvault.date_timestamp(out_of_sequence) }}
),

matching_xts_stg_records AS (
  SELECT *
  FROM (
      SELECT
        {{ dbtvault.prefix(source_cols, 'b') }},
        {{ dbtvault.prefix([src_ldts], 'a') }} AS XTS_LOAD_DATE,
        LEAD({{ dbtvault.prefix([src_ldts], 'a') }}) OVER(
            PARTITION BY {{ dbtvault.prefix([src_pk], 'a') }}
            ORDER BY {{ dbtvault.prefix([src_ldts], 'a') }}) AS NEXT_RECORD_DATE,
        {{ dbtvault.prefix([src_pk], 'a') }} AS PREV_RECORD_HASHDIFF,
        LEAD({{ dbtvault.prefix([src_hashdiff], 'a') }}) OVER(
            PARTITION BY {{ dbtvault.prefix([src_pk], 'a') }}
            ORDER BY {{ dbtvault.prefix([src_ldts], 'a') }}) AS NEXT_RECORD_HASHDIFF
      FROM {{ ref(xts_model) }} AS a
      INNER JOIN source_data AS b
      ON {{ dbtvault.multikey(src_pk, prefix=['a','b'], condition='=') }}
      WHERE {{ dbtvault.prefix([sat_name_col], 'a') }} = '{{ this.identifier }}'
  ) AS mr
  WHERE ((mr.PREV_RECORD_HASHDIFF != {{ dbtvault.prefix([src_hashdiff], 'mr') }}
           AND mr.PREV_RECORD_HASHDIFF = mr.NEXT_RECORD_HASHDIFF)
           OR (mr.PREV_RECORD_HASHDIFF != {{ dbtvault.prefix([src_hashdiff], 'mr') }}
           AND mr.NEXT_RECORD_HASHDIFF != {{ dbtvault.prefix([src_hashdiff], 'mr') }}))
  AND {{ dbtvault.prefix([src_ldts], 'mr') }}
  BETWEEN mr.XTS_LOAD_DATE AND mr.NEXT_RECORD_DATE
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
  ON {{ dbtvault.multikey(src_pk, prefix=['c','d'], condition='=') }}
),

out_of_sequence_inserts AS (
  SELECT {{ dbtvault.prefix(source_cols, 'c') }} FROM matching_xts_stg_records AS c
  UNION
  SELECT * FROM records_from_sat
),
{%- endif %}

{%- endif %}

records_to_insert AS (
    SELECT DISTINCT {{ dbtvault.alias_all(source_cols, 'stage') }}
    FROM source_data AS stage
    {%- if dbtvault.is_any_incremental() %}
    LEFT JOIN latest_records
    ON {{ dbtvault.multikey(src_pk, prefix=['latest_records','stage'], condition='=') }}
    WHERE {{ dbtvault.prefix([src_hashdiff], 'latest_records', alias_target='target') }} != {{ dbtvault.prefix([src_hashdiff], 'stage') }}
        OR {{ dbtvault.prefix([src_hashdiff], 'latest_records', alias_target='target') }} IS NULL
    {% if out_of_sequence is not none -%}
    UNION
    SELECT * FROM out_of_sequence_inserts
    {%- endif %}
    {%- endif %}
)

SELECT * FROM records_to_insert

{%- endmacro -%}