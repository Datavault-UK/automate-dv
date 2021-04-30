{%- macro pit(src_pk, as_of_dates_table, satellites, stage_tables, src_ldts, source_model ) -%}

    {{- adapter.dispatch('pit', packages = dbtvault.get_dbtvault_namespaces())(source_model=source_model, src_pk=src_pk,
                                                                               as_of_dates_table=as_of_dates_table,
                                                                               satellites=satellites,
                                                                               stage_tables=stage_tables,
                                                                               src_ldts=src_ldts) -}}
{%- endmacro -%}

{%- macro default__pit(src_pk, as_of_dates_table, satellites, stage_tables, src_ldts, source_model) -%}

{{ dbtvault.prepend_generated_by() }}

    {%- if (as_of_dates_table is none) and execute -%}
    {%- set error_message -%}
    "pit error: Missing as_of_dates table configuration. A as_of_dates_table must be provided."
    {%- endset -%}
    {{- exceptions.raise_compiler_error(error_message) -}}
{%- endif -%}

{#- Aquiring the source reltion for the AS_OF table -#}
{%- if as_of_dates_table is mapping and as_of_dates_table is not none -%}
    {%- set source_name = as_of_dates_table | first -%}
    {%- set source_table_name = as_of_dates_table[source_name] -%}
    {%- set source_relation = source(source_name, source_table_name) -%}
{%- elif as_of_dates_table is not mapping and as_of_dates_table is not none -%}
    {%- set source_relation = ref(as_of_dates_table) -%}
{%- endif -%}

{# Setting Ghost values to replace NULLS #}
{%- set maxdate = '9999-12-31 23:59:59.999999' -%}
{%- set ghost_pk = ('0000000000000000') -%}
{%- set ghost_date = '1900-01-01 00:00:00.000000' %}

{# Stating the dependancys on the stage tables outside of the If STATEMENT #}
{%- for stg in stage_tables -%}
    -- depends_on: {{ ref(stg) }}
{%- endfor %}



WITH as_of AS (
    SELECT * FROM {{ source_relation}}
),

{% if dbtvault.is_any_incremental() -%}

    last_safe_load_datetime AS (
    	SELECT min(LOAD_DATETIME) AS LAST_SAFE_LOAD_DATETIME FROM (
        {%- filter indent(width=8) -%}
        {%- for stg in stage_tables -%}
            {%- set stage_ldts =(stage_tables[stg])  -%}
            {{ "SELECT MIN("~stage_ldts~") AS LOAD_DATETIME FROM "~ ref(stg) }}
            {{ 'UNION ALL' if not loop.last }}
        {% endfor -%}
        {%- endfilter -%}
        )
    ),

    old_as_of_grain AS (
        SELECT DISTINCT AS_OF_DATE FROM {{ this }}
    ),

    as_of_grain_lost_entries AS (
        SELECT a.AS_OF_DATE
        FROM old_as_of_grain AS a
        LEFT OUTER JOIN as_of AS b
    	ON a.AS_OF_DATE = b.AS_OF_DATE
    	WHERE b.AS_OF_DATE IS NULL
    ),

    as_of_grain_new_entries AS (
        SELECT a.AS_OF_DATE
        FROM as_of AS a
        LEFT OUTER JOIN old_as_of_grain AS b
    	ON a.AS_OF_DATE = b.AS_OF_DATE
    	WHERE b.AS_OF_DATE IS NULL
    ),

    min_date AS(
        SELECT min(AS_OF_DATE) AS MIN_DATE
        FROM as_of
    ),

    backfill_as_of AS (
        SELECT AS_OF_DATE
    	from as_of
    	WHERE as_of.AS_OF_DATE < (SELECT LAST_SAFE_LOAD_DATETIME FROM last_safe_load_datetime)
    ),

    new_hubs AS (
        SELECT {{ src_pk }}
    	FROM {{ ref(source_model) }} AS h
    	WHERE h.{{ src_ldts }} >= (SELECT LAST_SAFE_LOAD_DATETIME FROM last_safe_load_datetime)
    	),

    new_row_as_of AS (
        SELECT AS_OF_DATE
    	FROM as_of
    	WHERE as_of.AS_OF_DATE >= (SELECT LAST_SAFE_LOAD_DATETIME FROM last_safe_load_datetime)
    	UNION
    	SELECT as_of_date
    	FROM as_of_grain_new_entries
    ),

    overlap AS (
        SELECT p.* FROM {{ this }} AS p
        INNER JOIN {{ ref(source_model) }} as h
        ON p.{{ src_pk }} = h.{{ src_pk }}
    	WHERE  P.AS_OF_DATE >= (SELECT MIN_DATE FROM min_date)
    	AND p.AS_OF_DATE < (SELECT LAST_SAFE_LOAD_DATETIME FROM last_safe_load_datetime)
    	AND p.AS_OF_DATE NOT IN (SELECT * FROM as_of_grain_lost_entries)
    ),
    -- backfill any newly arrived hubs, set all historical pit dates to ghost records

    bf_hub AS (
        SELECT
            nh.{{ src_pk }},
            bfa.AS_OF_DATE
        FROM new_hubs AS nh
        INNER JOIN backfill_as_of AS bfa
          ON (1=1)
    ),

    backfill AS (
        SELECT
            bf.{{ src_pk }},
            bf.AS_OF_DATE,
            {%- for sat in satellites -%}
                {%- filter indent(width=8) -%}
                {% set sat_key = (satellites[sat]['pk'].keys() | list )[0] -%}
                {%- set sat_ldts =(satellites[sat]['ldts'].keys() | list )[0]  -%}
                {{- "\n" -}}
                {{ "'"~ghost_pk~"'"'::BINARY(16) AS '~ sat ~'_'~ sat_key ~','  }}
                {{- "\n" -}}
                {{ "'"~ghost_date~"'"'::TIMESTAMP_NTZ AS '~ sat ~'_'~ sat_ldts  }}
                {{- ',' if not loop.last -}}
                {% endfilter %}
            {%- endfor %}S

          FROM bf_hub AS bf

         {% for sat in satellites -%}
                {%- set sat_key = (satellites[sat]['pk'].keys() | list )[0] -%}
                {%- set sat_ldts =(satellites[sat]['ldts'].keys() | list )[0] -%}
                LEFT JOIN {{ ref(sat) }} AS {{  sat -}}_SRC
                    ON  bf.{{- src_pk }} = {{ sat -}}_SRC.{{ satellites[sat]['pk'][sat_key] }}
                AND {{ sat -}}_SRC.{{ satellites[sat]['ldts'][sat_ldts] }} <= bf.AS_OF_DATE

             {% endfor %}

            GROUP BY
                bf.{{- src_pk }}, bf.AS_OF_DATE
            ORDER BY (1, 2)
    ),

{% else %}
    new_row_as_of AS(
    SELECT * FROM as_of
    ),
{% endif %}

new_as_of_dates_PK_join AS (
    SELECT
        hub.{{ src_pk }},
        x.AS_OF_DATE
    FROM {{ ref(source_model) }} hub
    INNER JOIN new_row_as_of AS x
    ON (1=1)
),

new_rows AS (

    SELECT
        a.{{ src_pk }},
        a.AS_OF_DATE,
        {%- for sat in satellites -%}
            {%- filter indent(width=8) -%}
            {% set sat_key = (satellites[sat]['pk'].keys() | list )[0] -%}
            {%- set sat_ldts =(satellites[sat]['ldts'].keys() | list )[0]  -%}
            {{- "\n" -}}
            {{ 'COALESCE(MAX('~ sat ~'_SRC.'~ satellites[sat]['pk'][sat_key]~'), '"'"~ghost_pk~"'"'::BINARY(16)) AS '~ sat ~'_'~ sat_key ~','  }}
            {{- "\n" -}}
            {{ 'COALESCE(MAX('~ sat ~'_SRC.'~ satellites[sat]['ldts'][sat_ldts]~'), '"'"~ghost_date~"'"'::TIMESTAMP_NTZ) AS '~ sat ~'_'~ sat_ldts  }}
            {{- ',' if not loop.last -}}
            {% endfilter %}
        {%- endfor %}
    FROM new_as_of_dates_PK_join AS a

    {% for sat in satellites -%}
        {%- set sat_key = (satellites[sat]['pk'].keys() | list )[0] -%}
        {%- set sat_ldts =(satellites[sat]['ldts'].keys() | list )[0] -%}
        LEFT JOIN {{ ref(sat) }} AS {{  sat -}}_SRC
            ON  a.{{- src_pk }} = {{ sat -}}_SRC.{{ satellites[sat]['pk'][sat_key] }}
        AND {{ sat -}}_SRC.{{ satellites[sat]['ldts'][sat_ldts] }} <= a.AS_OF_DATE
     {% endfor %}

    GROUP BY
        a.{{- src_pk }}, a.AS_OF_DATE
    ORDER BY (1, 2)
),

PIT AS (
SELECT * FROM new_rows
{% if dbtvault.is_any_incremental() -%}
    UNION ALL
    SELECT * FROM overlap
    UNION ALL
    SELECT * FROM backfill

{%- endif -%}
)

SELECT * FROM PIT

{%- endmacro -%}
