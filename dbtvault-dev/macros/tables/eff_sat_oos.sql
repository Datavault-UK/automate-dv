{%- macro eff_sat_oos(src_pk, src_dfk, src_sfk, status, src_hashdiff, src_eff, src_ldts, src_source, source_model,out_of_sequence=none) -%}

    {{- adapter.dispatch('eff_sat_oos', 'dbtvault')(src_pk=src_pk, src_dfk=src_dfk, src_sfk=src_sfk,
                                                         status=status, src_hashdiff=src_hashdiff, src_eff=src_eff,
                                                         src_ldts=src_ldts, src_source=src_source, source_model=source_model,
                                                          out_of_sequence=out_of_sequence) -}}
{%- endmacro -%}

{%- macro default__eff_sat_oos(src_pk, src_dfk, src_sfk, status, src_hashdiff, src_eff, src_ldts, src_source, source_model, out_of_sequence) -%}

{{- dbtvault.check_required_parameters(src_pk=src_pk, src_dfk=src_dfk, src_sfk=src_sfk,
                                       status=status, src_hashdiff=src_hashdiff, src_eff=src_eff, src_ldts=src_ldts,
                                       src_source=src_source, source_model=source_model) -}}

{%- set source_cols = dbtvault.expand_column_list(columns=[src_pk, src_dfk, src_sfk, status, src_hashdiff, src_eff, src_ldts, src_source]) -%}
{%- set fk_cols = dbtvault.expand_column_list(columns=[src_dfk, src_sfk]) -%}
{%- set dfk_cols = dbtvault.expand_column_list(columns=[src_dfk]) -%}
{%- set is_auto_end_dating = config.get('is_auto_end_dating', default=false) %}
{%- set HASHDIFF_F = dbtvault.hash(columns=none, values= '0', alias=src_hashdiff, is_hashdiff=false) -%}
{%- set HASHDIFF_T = dbtvault.hash(columns=none, values= '1', alias=src_hashdiff, is_hashdiff=false) -%}


{%- if out_of_sequence is not none %}
    {%- set xts_model = out_of_sequence["source_xts"] %}
    {%- set sat_name_col = out_of_sequence["sat_name_col"] %}
    {%- set out_of_sequence_columns = ('PREV_RECORD_PK','NEXT_RECORD_PK','NEXT_CHANGED_RECORD_DATE') -%}
    -- depends_on: {{ ref(xts_model) }}
    -- depends_on: {{ this }}
{% endif -%}

{{- dbtvault.prepend_generated_by() }}

WITH source_data AS (
    SELECT {{ dbtvault.prefix(source_cols, 'a', alias_target='source') }}
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

{%- if out_of_sequence is not none %}
insert_date AS (
    SELECT DISTINCT {{ src_ldts }}
    FROM source_data
    ),
{%- endif -%}

{# Selecting the most recent records for each link hashkey -#}
latest_records AS (
    SELECT {{ dbtvault.alias_all(source_cols, 'b') }},
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
    WHERE status = 'TRUE'::BOOLEAN
),

{# Selecting the closed records of the most recent records for each link hashkey -#}
latest_closed AS (
    SELECT {{ dbtvault.alias_all(source_cols, 'd') }}
    FROM latest_records AS d
    WHERE status = 'FALSE'::BOOLEAN
),

{# Identifying the completely new link relationships to be opened in eff sat -#}
new_open_records AS (
    SELECT DISTINCT
        {{ dbtvault.alias_all(source_cols, 'f') }}
    FROM source_data AS f
    LEFT JOIN latest_records AS lr
    ON f.{{ src_pk }} = lr.{{ src_pk }}
    WHERE lr.{{ src_pk }} IS NULL
{#- not selecting any thing out of sequence -#}
{%- if out_of_sequence is not none %}
    AND f.{{ src_ldts }} > (SELECT {{ src_ldts }} FROM insert_date)
{%- endif -%}
),

{# Identifying the currently closed link relationships to be reopened in eff sat -#}
new_reopened_records AS (
    SELECT DISTINCT
        g.{{ src_pk }},
        {{ dbtvault.alias_all(fk_cols, 'g') }},
        'TRUE'::BOOLEAN AS {{ status }},
        g.{{ src_hashdiff }},
        g.{{ src_eff }},
        g.{{ src_ldts }},
        g.{{ src_source }}
    FROM source_data AS g
    INNER JOIN latest_closed AS lc
    ON g.{{ src_pk }} = lc.{{ src_pk }}
    WHERE g.{{ status }} = 'TRUE'::BOOLEAN
{#- not selecting any thing out of sequence -#}
{%- if out_of_sequence is not none %}
    AND g.{{ src_ldts }} > (SELECT {{ src_ldts }} FROM insert_date)
{%- endif -%}
),
{%- if is_auto_end_dating %}

{# Creating the closing records -#}
{# Identifying the currently open relationships that need to be closed due to change in SFK(s) -#}
new_closed_records AS (
    SELECT DISTINCT
        lo.{{ src_pk }},
        {{ dbtvault.alias_all(fk_cols, 'lo') }},
        'FALSE'::BOOLEAN AS {{ status }},
        {{ HASHDIFF_F }},
        h.{{ src_eff }},
        h.{{ src_ldts }},
        lo.{{ src_source }}
    FROM source_data AS h
    INNER JOIN latest_open AS lo
    ON {{ dbtvault.multikey(src_dfk, prefix=['lo', 'h'], condition='=') }}
    WHERE ({{ dbtvault.multikey(src_sfk, prefix=['lo', 'h'], condition='<>', operator='OR') }})
{#- not selecting any thing out of sequence -#}
{%- if out_of_sequence is not none %}
    AND h.{{ src_ldts }} > (SELECT {{ src_ldts }} FROM insert_date)
{%- endif -%}
),
{% else %}

new_closed_records AS (
    SELECT DISTINCT
        lo.{{ src_pk }},
        {{ dbtvault.alias_all(fk_cols, 'lo') }},
        h.{{ status }},
        h.{{ src_hashdiff }},
        h.{{ src_eff }},
        h.{{ src_ldts }},
        lo.{{ src_source }}
    FROM source_data AS h
    LEFT JOIN Latest_open AS lo
    ON lo.{{ src_pk }} = h.{{ src_pk }}
    LEFT JOIN latest_closed AS lc
    ON lc.{{ src_pk }} = h.{{ src_pk }}
     WHERE h.{{ status }} = 'FALSE'::BOOLEAN
    AND lo.{{ src_pk }} IS NOT NULL
    AND lc.{{ src_pk }} IS NULL
),
{#- end if is_auto_end_dating -#}
{%- endif %}

{%- if out_of_sequence is not none %}

{# Selecting the rocrds from the eff sat that are before the out of sequence insert date #}
sat_records_before_insert_date AS (
    SELECT DISTINCT
       {{ dbtvault.prefix(source_cols, 'a') }},
       {{ dbtvault.prefix([src_ldts], 'b') }} AS STG_LOAD_DATE,
       {{ dbtvault.prefix([src_eff], 'b') }} AS STG_EFFECTIVE_FROM
    FROM {{ this }} AS a
    LEFT JOIN {{ ref(source_model) }} AS b ON {{ dbtvault.prefix([src_pk], 'a') }} = {{ dbtvault.prefix([src_pk], 'b') }}
    WHERE {{ dbtvault.prefix([src_ldts], 'a') }} < (select distinct {{ src_ldts }} from insert_date)
),

        {# selecting a list of driving keys #}
driving_keys AS (
    SELECT eff.{{ src_pk }}, {{ dbtvault.alias_all(dfk_cols, 'eff') }} FROM {{ this }} AS eff
    UNION
    SELECT sd.{{ src_pk }}, {{ dbtvault.alias_all(dfk_cols, 'sd') }} FROM source_data AS sd
),

    {# identifying the new link hash keys to be added sat #}
new_oos_links AS (
    SELECT DISTINCT
        {{ dbtvault.alias_all(source_cols, 'f') }}
    FROM source_data AS f
    LEFT JOIN {{ this }} AS v
    ON f.{{ src_pk }} = v.{{ src_pk }}
    WHERE v.{{ src_pk }} IS NULL
    ),

{%- if is_auto_end_dating %}

    {# Dfk information added to xts #}
xts_dfk_enhanced AS (
    SELECT
        a.{{ src_pk }},
        a.{{ src_hashdiff }},
        a.{{ src_ldts }},
        {{ dbtvault.alias_all(dfk_cols, 'b') }}
    FROM {{ ref(xts_model) }} AS a
    LEFT JOIN driving_keys AS b
    ON a.{{ src_pk }} = b. {{ src_pk }}
    WHERE {{ dbtvault.prefix([sat_name_col], 'a') }} = '{{ this.identifier }}'
),

    {# matches the xts records on the new link hash keys on the dfk where the ldts of lnk hash key is > the min first seen date for dfk #}
matching_xts_stg_records_dfk_new_later_links AS (
    SELECT
      {{ dbtvault.prefix(source_cols, 'b') }},
      {{ dbtvault.prefix([src_ldts], 'a') }} AS XTS_LOAD_DATE,
      FIRST_VALUE({{ dbtvault.prefix([src_ldts], 'a') }}) OVER(
          PARTITION BY {{ dbtvault.alias_all([src_dfk], 'a') }}
          ORDER BY {{ dbtvault.prefix([src_ldts], 'a') }}) AS FIRST_SEEN_DATE
      {%- if is_auto_end_dating %},
      LEAD({{ dbtvault.prefix([src_ldts], 'a') }}) OVER(
        PARTITION BY {{ dbtvault.alias_all(dfk_cols, 'a') }}
        ORDER BY {{ dbtvault.prefix([src_ldts], 'a') }})  AS NEXT_CHANGED_RECORD_DATE,
      LAG({{ dbtvault.prefix([src_pk], 'a') }}) OVER(
          PARTITION BY {{ dbtvault.alias_all(dfk_cols, 'a') }}
          ORDER BY {{ dbtvault.prefix([src_ldts], 'a') }}) AS PREV_RECORD_PK,
      LEAD({{ dbtvault.prefix([src_pk], 'a') }}) OVER(
          PARTITION BY {{ dbtvault.alias_all(dfk_cols, 'a') }}
          ORDER BY {{ dbtvault.prefix([src_ldts], 'a') }}) AS NEXT_RECORD_PK
      {% endif %}
    FROM new_oos_links AS b
    LEFT JOIN xts_dfk_enhanced AS a
    ON {{ dbtvault.multikey(src_dfk, prefix=['a', 'b'], condition='=') }}
    QUALIFY ({{ dbtvault.prefix([src_ldts], 'b') }}
    BETWEEN XTS_LOAD_DATE
    AND NEXT_CHANGED_RECORD_DATE)

),

   {# matches the xts records on the new link hash keys on the dfk where the ldts of lnk hash key is < the min first seen date for dfk #}
matching_xts_stg_records_dfk_new_earlier_links AS (
    SELECT
      {{ dbtvault.prefix(source_cols, 'b') }},
      a.{{ src_ldts }} AS XTS_LOAD_DATE,
      FIRST_VALUE({{ dbtvault.prefix([src_ldts], 'a') }}) OVER(
          PARTITION BY {{ dbtvault.alias_all([src_dfk], 'a') }}
          ORDER BY {{ dbtvault.prefix([src_ldts], 'a') }}) AS FIRST_SEEN_DATE
      {%- if is_auto_end_dating %},
      FIRST_SEEN_DATE  AS NEXT_CHANGED_RECORD_DATE,
      NULL AS PREV_RECORD_PK,
    {{ dbtvault.prefix([src_pk], 'a') }} AS NEXT_RECORD_PK
      {% endif %}
    FROM new_oos_links AS b
    LEFT JOIN xts_dfk_enhanced AS a
    ON {{ dbtvault.multikey(src_dfk, prefix=['a', 'b'], condition='=') }}
    QUALIFY  {{ dbtvault.prefix([src_ldts], 'b') }} < FIRST_SEEN_DATE
    AND XTS_LOAD_DATE = FIRST_SEEN_DATE

),

{% endif %}

    {# normal oos logic for lnk hash keys where the records are comapred to the xts on hashdiff #}
matching_xts_stg_records AS (
    SELECT
    {{ dbtvault.prefix(source_cols, 'b') }},
    {{ dbtvault.prefix([src_ldts], 'a') }} AS XTS_LOAD_DATE,
    FIRST_VALUE({{ dbtvault.prefix([src_ldts], 'a') }}) OVER(
        PARTITION BY {{ dbtvault.prefix([src_pk], 'a') }}
        ORDER BY {{ dbtvault.prefix([src_ldts], 'a') }}) AS FIRST_SEEN_DATE,
    LEAD({{ dbtvault.prefix([src_ldts], 'a') }}) OVER(
        PARTITION BY {{ dbtvault.prefix([src_pk], 'a') }}
        ORDER BY {{ dbtvault.prefix([src_ldts], 'a') }}) AS NEXT_RECORD_DATE,
    LAG({{ dbtvault.prefix([src_hashdiff], 'a') }}) OVER(
        PARTITION BY {{ dbtvault.prefix([src_pk], 'a') }}
        ORDER BY {{ dbtvault.prefix([src_ldts], 'a') }}) AS PREV_RECORD_HASHDIFF,
    LEAD({{ dbtvault.prefix([src_hashdiff], 'a') }}) OVER(
        PARTITION BY {{ dbtvault.prefix([src_pk], 'a') }}
        ORDER BY {{ dbtvault.prefix([src_ldts], 'a') }}) AS NEXT_RECORD_HASHDIFF
    FROM xts_dfk_enhanced AS a
    INNER JOIN source_data AS b
    ON {{ dbtvault.prefix([src_pk], 'a') }} = {{ dbtvault.prefix([src_pk], 'b') }}
    QUALIFY ((PREV_RECORD_HASHDIFF != {{ dbtvault.prefix([src_hashdiff], 'b') }} )
             OR (PREV_RECORD_HASHDIFF IS NULL)
             OR (PREV_RECORD_HASHDIFF != {{ dbtvault.prefix([src_hashdiff], 'b') }}
             AND NEXT_RECORD_HASHDIFF != {{ dbtvault.prefix([src_hashdiff], 'b') }}))
        AND (({{ dbtvault.prefix([src_ldts], 'b') }}
    BETWEEN XTS_LOAD_DATE
    AND NEXT_RECORD_DATE)
    OR  ( XTS_LOAD_DATE = CASE
              WHEN ({{ dbtvault.prefix([src_ldts], 'b') }} < FIRST_SEEN_DATE) THEN FIRST_SEEN_DATE
              ELSE NULL
              END ))
),

{%- if is_auto_end_dating %}
 {# matches the xts records on the link hash keys on the dfk where the ldts of lnk hash key is > the min first seen date for dfk #}
matching_xts_stg_records_on_dfk_later_links AS (
    SELECT
    {{ dbtvault.prefix(source_cols, 'b') }},
    {{ dbtvault.prefix([src_ldts], 'a') }} AS XTS_LOAD_DATE,
     FIRST_VALUE({{ dbtvault.prefix([src_ldts], 'a') }}) OVER(
        PARTITION BY {{ dbtvault.alias_all(dfk_cols, 'a') }}
        ORDER BY {{ dbtvault.prefix([src_ldts], 'a') }}) AS FIRST_SEEN_DFK_DATE,
    LEAD({{ dbtvault.prefix([src_ldts], 'a') }}) OVER(
        PARTITION BY {{ dbtvault.alias_all(dfk_cols, 'a') }}
        ORDER BY {{ dbtvault.prefix([src_ldts], 'a') }}) AS NEXT_CHANGED_RECORD_DATE,
    LAG({{ dbtvault.prefix([src_pk], 'a') }}) OVER(
        PARTITION BY {{ dbtvault.alias_all(dfk_cols, 'a') }}
        ORDER BY {{ dbtvault.prefix([src_ldts], 'a') }}) AS PREV_RECORD_PK,
    LEAD({{ dbtvault.prefix([src_pk], 'a') }}) OVER(
        PARTITION BY {{ dbtvault.alias_all(dfk_cols, 'a') }}
        ORDER BY {{ dbtvault.prefix([src_ldts], 'a') }}) AS NEXT_RECORD_PK
    FROM xts_dfk_enhanced AS a
    INNER JOIN matching_xts_stg_records AS b
    ON {{ dbtvault.multikey(src_dfk, prefix=['a', 'b'], condition='=') }}
    QUALIFY ( b.{{ src_ldts }}
    BETWEEN a.{{ src_ldts }}
    AND NEXT_CHANGED_RECORD_DATE)
    AND  b.{{ src_ldts }} > FIRST_SEEN_DFK_DATE
),

 {# matches the xts records on the link hash keys on the dfk where the ldts of lnk hash key is < the min first seen date for dfk #}
matching_xts_stg_records_on_dfk_earlier_links AS (
    SELECT
    {{ dbtvault.prefix(source_cols, 'b') }},
    {{ dbtvault.prefix([src_ldts], 'a') }} AS XTS_LOAD_DATE,
    FIRST_VALUE({{ dbtvault.prefix([src_ldts], 'a') }}) OVER(
        PARTITION BY {{ dbtvault.alias_all(dfk_cols, 'a') }}
        ORDER BY {{ dbtvault.prefix([src_ldts], 'a') }}) AS FIRST_SEEN_DFK_DATE,
    a.{{ src_ldts }} AS NEXT_CHANGED_RECORD_DATE,
    NULL AS PREV_RECORD_PK,
    a.{{ src_pk }} AS NEXT_RECORD_PK
    FROM xts_dfk_enhanced AS a
    INNER JOIN matching_xts_stg_records AS b
    ON {{ dbtvault.multikey(src_dfk, prefix=['a', 'b'], condition='=') }}
    QUALIFY b.{{ src_ldts }} < FIRST_SEEN_DFK_DATE
    AND a.{{ src_ldts }} = FIRST_SEEN_DFK_DATE
),

xts_union AS (
 SELECT {{ dbtvault.prefix(source_cols, 'L') }},{{ dbtvault.prefix(out_of_sequence_columns, 'L') }} FROM matching_xts_stg_records_on_dfk_later_links AS L
 UNION
 SELECT {{ dbtvault.prefix(source_cols, 'E') }},{{ dbtvault.prefix(out_of_sequence_columns, 'E') }} FROM matching_xts_stg_records_on_dfk_earlier_links AS E
 UNION
 SELECT {{ dbtvault.prefix(source_cols, 'NLL') }},{{ dbtvault.prefix(out_of_sequence_columns, 'NLL') }} FROM matching_xts_stg_records_dfk_new_later_links AS NLL
 UNION
 SELECT {{ dbtvault.prefix(source_cols, 'NLE') }},{{ dbtvault.prefix(out_of_sequence_columns, 'NLE') }} FROM matching_xts_stg_records_dfk_new_earlier_links AS NLE

),
{% endif %}

    {#   looking for changes in hashdiffs #}
records_from_sat AS (
    SELECT
        d.{{ src_pk }},
        {{ dbtvault.alias_all(fk_cols, 'd') }},
        'TRUE'::BOOLEAN AS {{ status }},
        d.{{ src_hashdiff }},
        c.NEXT_RECORD_DATE AS {{ src_ldts }},
        c.NEXT_RECORD_DATE AS {{ src_eff }},
        {{ dbtvault.prefix([src_source], 'd') }}
    FROM matching_xts_stg_records AS c
    INNER JOIN sat_records_before_insert_date AS d
    ON {{dbtvault.prefix([src_pk], 'c') }} = {{dbtvault.prefix([src_pk], 'd') }}
    WHERE  c.PREV_RECORD_HASHDIFF != {{ dbtvault.prefix([src_hashdiff], 'c') }}
    AND c.PREV_RECORD_HASHDIFF = c.NEXT_RECORD_HASHDIFF
    AND c.PREV_RECORD_HASHDIFF IS NOT NULL
),

{%- if is_auto_end_dating %}
close_new_inserted_records AS(
    SELECT
        a.{{ src_pk }},
        {{ dbtvault.alias_all(fk_cols, 'a') }},
        'FALSE'::BOOLEAN AS {{ status }},
        {{ HASHDIFF_F }},
        a.NEXT_CHANGED_RECORD_DATE AS {{ src_eff }},
        a.NEXT_CHANGED_RECORD_DATE AS {{ src_ldts }},
        a.{{ src_source }}
    FROM xts_union a
    WHERE a.NEXT_RECORD_PK != a.{{ src_pk }}
),

close_previosuly_active AS (
    SELECT  DISTINCT
        b.{{ src_pk }},
        {{ dbtvault.alias_all(fk_cols, 'b') }},
        'FALSE'::BOOLEAN AS {{ status }},
        {{ HASHDIFF_F }},
        a.{{ src_eff }},
        a.{{ src_ldts }},
        b.{{ src_source }}
    FROM xts_union a
    INNER JOIN {{ this }} b
    ON a.PREV_RECORD_PK = b.{{ src_pk }}
    WHERE a.PREV_RECORD_PK != a.{{ src_pk }}
),

re_open_previous_link AS (
        SELECT  DISTINCT
        b.{{ src_pk }},
        {{ dbtvault.alias_all(fk_cols, 'b') }},
        'TRUE'::BOOLEAN AS {{ status }},
        {{ HASHDIFF_T }},
        a.NEXT_changed_RECORD_DATE AS {{ src_eff }},
        a.NEXT_CHANGED_RECORD_DATE AS {{ src_ldts }},
        b.{{ src_source }}
    FROM xts_union a
    INNER JOIN {{ this }} b
    ON a.NEXT_RECORD_PK = b.{{ src_pk }}
    WHERE a.PREV_RECORD_PK = a.NEXT_RECORD_PK
),

{%- endif -%}

out_of_sequence_inserts AS (
    SELECT {{ dbtvault.alias_all(source_cols, 'xts') }} FROM matching_xts_stg_records AS xts
    UNION
    SELECT * FROM records_from_sat
    UNION
    SELECT * FROM new_oos_links
{%- if is_auto_end_dating %}
    UNION
    SELECT {{ dbtvault.alias_all(source_cols, 'new') }} FROM close_new_inserted_records AS new
    UNION
    SELECT {{ dbtvault.alias_all(source_cols, 'cl_prev') }} FROM close_previosuly_active AS cl_prev
    UNION
    SELECT {{ dbtvault.alias_all(source_cols, 'op_prev') }}  FROM re_open_previous_link as op_prev
{% endif %}
),
{%- endif %}


records_to_insert AS (
    SELECT * FROM new_open_records
    UNION
    SELECT * FROM new_reopened_records
    UNION
    SELECT * FROM new_closed_records
    {% if out_of_sequence is not none  -%}
    UNION
    SELECT * FROM out_of_sequence_inserts
    {%- endif %}
)

{%- else %}

records_to_insert AS (
    SELECT {{ dbtvault.alias_all(source_cols, 'i') }}
    FROM source_data AS i
)

{#- end if not dbtvault.is_any_incremental() -#}
{%- endif %}

SELECT * FROM records_to_insert
{%- endmacro -%}

