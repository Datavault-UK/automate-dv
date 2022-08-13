{%- macro as_of_date_window(src_pk, src_ldts, src_extra_columns, stage_tables_ldts, source_model) -%}

last_safe_load_datetime AS (
    SELECT MIN(LOAD_DATETIME) AS LAST_SAFE_LOAD_DATETIME
    FROM (

        {% for stg in stage_tables_ldts -%}
            {%- set stage_ldts = stage_tables_ldts[stg] -%}
            SELECT MIN({{ stage_ldts }}) AS LOAD_DATETIME
            FROM {{ ref(stg) }}
            {{ "UNION ALL" if not loop.last }}
        {% endfor %}

    ) AS l
),

as_of_grain_old_entries AS (
    SELECT DISTINCT AS_OF_DATE
    FROM {{ this }}
),

as_of_grain_lost_entries AS (
    SELECT a.AS_OF_DATE
    FROM as_of_grain_old_entries AS a
    LEFT OUTER JOIN as_of_dates AS b
        ON a.AS_OF_DATE = b.AS_OF_DATE
    WHERE b.AS_OF_DATE IS NULL
),

as_of_grain_new_entries AS (
    SELECT a.AS_OF_DATE
    FROM as_of_dates AS a
    LEFT OUTER JOIN as_of_grain_old_entries AS b
        ON a.AS_OF_DATE = b.AS_OF_DATE
    WHERE b.AS_OF_DATE IS NULL
),

min_date AS (
    SELECT min(AS_OF_DATE) AS MIN_DATE
    FROM as_of_dates
),

backfill_as_of AS (
    SELECT AS_OF_DATE
    FROM as_of_dates AS a
    WHERE a.AS_OF_DATE < (SELECT LAST_SAFE_LOAD_DATETIME FROM last_safe_load_datetime)
),

new_rows_pks AS (
    SELECT {{ dbtvault.prefix([src_pk], 'h') }}
    FROM {{ source_model }} AS h
    WHERE h.{{ src_ldts }} >= (SELECT LAST_SAFE_LOAD_DATETIME FROM last_safe_load_datetime)
),

new_rows_as_of AS (
    SELECT AS_OF_DATE
    FROM as_of_dates
    WHERE as_of_dates.AS_OF_DATE >= (SELECT LAST_SAFE_LOAD_DATETIME FROM last_safe_load_datetime)
    UNION
    SELECT as_of_date
    FROM as_of_grain_new_entries
),

overlap_pks AS (
    SELECT a.*
    {%- if dbtvault.is_something(src_extra_columns) -%},
       {{ dbtvault.prefix([src_extra_columns], 'a') }}
    {%- endif %}
    FROM {{ this }} AS a
    INNER JOIN {{ source_model }} as b
        ON {{ dbtvault.multikey(src_pk, prefix=['a','b'], condition='=') }}
    WHERE a.AS_OF_DATE >= (SELECT MIN_DATE FROM min_date)
        AND a.AS_OF_DATE < (SELECT LAST_SAFE_LOAD_DATETIME FROM last_safe_load_datetime)
        AND a.AS_OF_DATE NOT IN (SELECT AS_OF_DATE FROM as_of_grain_lost_entries)
)

{%- endmacro -%}
