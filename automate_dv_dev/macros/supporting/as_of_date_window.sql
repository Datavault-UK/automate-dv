/*
 * Copyright (c) Business Thinking Ltd. 2019-2023
 * This software includes code developed by the AutomateDV (f.k.a dbtvault) Team at Business Thinking Ltd. Trading as Datavault
 */

{%- macro as_of_date_window(src_pk, src_ldts, stage_tables_ldts, source_model) -%}

last_safe_load_datetime AS (
    SELECT MIN(LOAD_DATETIME) AS LAST_SAFE_LOAD_DATETIME
    FROM (

        {% for stg in stage_tables_ldts -%}
            {%- set stage_ldts = stage_tables_ldts[stg] -%}
            SELECT MIN({{ stage_ldts }}) AS LOAD_DATETIME FROM {{ ref(stg) }}
            {% if not loop.last %} UNION ALL {% endif %}
        {% endfor -%}

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
    SELECT MIN(AS_OF_DATE) AS MIN_DATE
    FROM as_of_dates
),

backfill_as_of AS (
    SELECT AS_OF_DATE
    FROM as_of_dates AS a

    {% if target.type == "bigquery" -%}
    INNER JOIN last_safe_load_datetime as l
    ON a.AS_OF_DATE < l.LAST_SAFE_LOAD_DATETIME
    {% else %}
    WHERE a.AS_OF_DATE < (SELECT LAST_SAFE_LOAD_DATETIME FROM last_safe_load_datetime)
    {%- endif %}
),

new_rows_pks AS (
    SELECT {{ automate_dv.prefix([src_pk], 'h') }}
    FROM {{ source_model }} AS h

    {% if target.type == "bigquery" -%}
    INNER JOIN last_safe_load_datetime as l
    ON h.{{ src_ldts }} >= l.LAST_SAFE_LOAD_DATETIME
    {% else %}
    WHERE h.{{ src_ldts }} >= (SELECT LAST_SAFE_LOAD_DATETIME FROM last_safe_load_datetime)
    {%- endif %}
),

new_rows_as_of AS (
    SELECT AS_OF_DATE
    FROM as_of_dates AS a
    {% if target.type == "bigquery" -%}
    INNER JOIN last_safe_load_datetime as l
    ON a.AS_OF_DATE >= l.LAST_SAFE_LOAD_DATETIME
    UNION DISTINCT
    {% else %}
    WHERE a.AS_OF_DATE >= (SELECT LAST_SAFE_LOAD_DATETIME FROM last_safe_load_datetime)
    UNION
    {%- endif %}
    SELECT as_of_date
    FROM as_of_grain_new_entries
),

overlap_pks AS (
    SELECT a.*
    FROM {{ this }} AS a
    INNER JOIN {{ source_model }} as b
        ON {{ automate_dv.multikey(src_pk, prefix=['a','b'], condition='=') }}
    {% if target.type == "bigquery" -%}
    INNER JOIN min_date
    ON 1 = 1
    INNER JOIN last_safe_load_datetime
    ON 1 = 1
	LEFT OUTER JOIN as_of_grain_lost_entries
	ON a.AS_OF_DATE = as_of_grain_lost_entries.AS_OF_DATE
    WHERE a.AS_OF_DATE >= min_date.MIN_DATE
        AND a.AS_OF_DATE < last_safe_load_datetime.LAST_SAFE_LOAD_DATETIME
		AND as_of_grain_lost_entries.AS_OF_DATE IS NULL
    {% else %}
    WHERE a.AS_OF_DATE >= (SELECT MIN_DATE FROM min_date)
        AND a.AS_OF_DATE < (SELECT LAST_SAFE_LOAD_DATETIME FROM last_safe_load_datetime)
        AND a.AS_OF_DATE NOT IN (SELECT AS_OF_DATE FROM as_of_grain_lost_entries)
    {%- endif %}
),

overlap_as_of AS (
    SELECT p.AS_OF_DATE
    FROM as_of_dates AS p
    {% if target.type == "bigquery" -%}
    INNER JOIN min_date
    ON 1 = 1
    INNER JOIN last_safe_load_datetime
    ON 1 = 1
	LEFT OUTER JOIN as_of_grain_lost_entries
	ON p.AS_OF_DATE = as_of_grain_lost_entries.AS_OF_DATE
    WHERE p.AS_OF_DATE >= min_date.MIN_DATE
        AND p.AS_OF_DATE < last_safe_load_datetime.LAST_SAFE_LOAD_DATETIME
		AND as_of_grain_lost_entries.AS_OF_DATE IS NULL
    {% else %}
    WHERE p.AS_OF_DATE >= (SELECT MIN_DATE FROM min_date)
        AND p.AS_OF_DATE < (SELECT LAST_SAFE_LOAD_DATETIME FROM last_safe_load_datetime)
        AND p.AS_OF_DATE NOT IN (SELECT AS_OF_DATE FROM as_of_grain_lost_entries)
    {% endif %}
)

{%- endmacro -%}
