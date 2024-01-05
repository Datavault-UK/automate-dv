/*
 * Copyright (c) Business Thinking Ltd. 2019-2023
 * This software includes code developed by the AutomateDV (f.k.a dbtvault) Team at Business Thinking Ltd. Trading as Datavault
 */

{%- macro bigquery__pit(src_pk, src_extra_columns, as_of_dates_table, satellites, stage_tables_ldts, src_ldts, source_model) %}

{#- Acquiring the source relation for the AS_OF table -#}
{%- if as_of_dates_table is mapping and as_of_dates_table is not none -%}
    {%- set source_name = as_of_dates_table | first -%}
    {%- set source_table_name = as_of_dates_table[source_name] -%}
    {%- set as_of_table_relation = source(source_name, source_table_name) -%}
{%- elif as_of_dates_table is not mapping and as_of_dates_table is not none -%}
    {%- set as_of_table_relation = ref(as_of_dates_table) -%}
{%- endif -%}
    {%- set enable_ghost_record = var('enable_ghost_records', false) -%}
    {%- set hash = var('hash', 'MD5') -%}

{%- if not enable_ghost_record -%}
{#- Setting ghost values to replace NULLS -#}
{%- set ghost_pk = '0x0000000000000000' -%}
{%- set ghost_date = '1900-01-01 00:00:00.000000' %}
{%- endif -%}

{%- if automate_dv.is_any_incremental() -%}
    {%- set new_as_of_dates_cte = 'new_rows_as_of' -%}
{%- else -%}
    {%- set new_as_of_dates_cte = 'as_of_dates' -%}
{%- endif %}

WITH as_of_dates AS (
    SELECT * FROM {{ as_of_table_relation }}
),

{%- if automate_dv.is_any_incremental() %}

{{ automate_dv.as_of_date_window(src_pk, src_ldts, stage_tables_ldts, ref(source_model)) }},

backfill_rows_as_of_dates AS (
    SELECT
        {{ automate_dv.prefix([src_pk], 'a') }},
        b.AS_OF_DATE
    FROM new_rows_pks AS a
    INNER JOIN backfill_as_of AS b
        ON (1=1 )
),

backfill AS (
    SELECT
        {{ automate_dv.prefix([src_pk], 'a') }},
        a.AS_OF_DATE,
    {%- for sat_name in satellites -%}
        {%- set sat_pk_name = (satellites[sat_name]['pk'].keys() | list )[0] | upper -%}
        {%- set sat_ldts_name = (satellites[sat_name]['ldts'].keys() | list )[0] | upper -%}
        {%- set sat_name = sat_name | upper -%}
        {%- set sat_pk = satellites[sat_name]['pk'][sat_pk_name] -%}
        {%- set sat_ldts = satellites[sat_name]['ldts'][sat_ldts_name] -%}

        {% if enable_ghost_record %}

        COALESCE(MAX({{ sat_name | lower ~ '_src' }}.{{ sat_pk }}),
            {{ automate_dv.binary_ghost(none, hash) }})
        AS {{ sat_name | upper }}_{{ sat_pk_name | upper }},

        COALESCE(MAX({{ sat_name | lower ~ '_src' }}.{{ sat_ldts }}),
            {{ automate_dv.date_ghost(date_type = sat_ldts.dtype, alias=none) }})
        AS {{ sat_name | upper }}_{{ sat_ldts_name | upper }}

        {%- else -%}
        COALESCE(MAX({{ sat_name | lower ~ '_src' }}.{{ sat_pk }}),
        '{{ ghost_pk }}') AS {{ sat_name | upper }}_{{ sat_pk_name | upper }},

        COALESCE(MAX({{ sat_name | lower ~ '_src' }}.{{ sat_ldts }}),
        PARSE_DATETIME('%F %H:%M:%E6S', '{{ ghost_date }}')) AS {{ sat_name | upper }}_{{ sat_ldts_name | upper }}
        {%- endif -%}
        {{- ',' if not loop.last -}}
    {%- endfor %}
    FROM backfill_rows_as_of_dates AS a

    {% for sat_name in satellites -%}
        {%- set sat_pk_name = (satellites[sat_name]['pk'].keys() | list )[0] -%}
        {%- set sat_ldts_name = (satellites[sat_name]['ldts'].keys() | list )[0] -%}
        {%- set sat_pk = satellites[sat_name]['pk'][sat_pk_name] -%}
        {%- set sat_ldts = satellites[sat_name]['ldts'][sat_ldts_name] %}
        LEFT JOIN {{ ref(sat_name) }} AS {{ sat_name | lower ~ '_src' }}
        {{ "ON" | indent(4) }} a.{{ src_pk }} = {{ sat_name | lower ~ '_src' }}.{{ sat_pk }}
        {{ "AND" | indent(4) }} {{ sat_name | lower ~ '_src' }}.{{ sat_ldts }} <= a.AS_OF_DATE

    {% endfor %}

    GROUP BY
        {{ automate_dv.prefix([src_pk], 'a') }}, a.AS_OF_DATE
    ORDER BY (1)
),
{%- endif %}

new_rows_as_of_dates AS (
    SELECT
        {{ automate_dv.prefix([src_pk], 'a') }},
        b.AS_OF_DATE
    FROM {{ ref(source_model) }} AS a
    INNER JOIN {{ new_as_of_dates_cte }} AS b
    ON (1=1)
),

new_rows AS (
    SELECT
        {{ automate_dv.prefix([src_pk], 'a') }},
        a.AS_OF_DATE,
    {%- for sat_name in satellites -%}
        {%- set sat_pk_name = (satellites[sat_name]['pk'].keys() | list )[0] -%}
        {%- set sat_ldts_name = (satellites[sat_name]['ldts'].keys() | list )[0] -%}
        {%- set sat_name = sat_name -%}
        {%- set sat_pk = satellites[sat_name]['pk'][sat_pk_name] -%}
        {%- set sat_ldts = satellites[sat_name]['ldts'][sat_ldts_name] -%}

        {%- if enable_ghost_record %}

        COALESCE(MAX({{ sat_name | lower ~ '_src' }}.{{ sat_pk }}),
            {{ automate_dv.binary_ghost(none, hash) }})
        AS {{ sat_name | upper }}_{{ sat_pk_name | upper }},

        COALESCE(MAX({{ sat_name | lower ~ '_src' }}.{{ sat_ldts }}),
            {{ automate_dv.date_ghost(date_type = sat_ldts.dtype, alias=none) }})
        AS {{ sat_name | upper }}_{{ sat_ldts_name | upper }}

        {%- else -%}

        COALESCE(MAX({{ sat_name | lower ~ '_src' }}.{{ sat_pk }}),
        '{{ ghost_pk }}') AS {{ sat_name | upper }}_{{ sat_pk_name | upper }},

        COALESCE(MAX({{ sat_name | lower ~ '_src' }}.{{ sat_ldts }}),
        PARSE_DATETIME('%F %H:%M:%E6S', '{{ ghost_date }}')) AS {{ sat_name | upper }}_{{ sat_ldts_name | upper }}

        {%- endif -%}
        {{- "," if not loop.last }}
    {%- endfor %}
    FROM new_rows_as_of_dates AS a


    {% for sat_name in satellites -%}
        {%- set sat_pk_name = (satellites[sat_name]['pk'].keys() | list )[0] -%}
        {%- set sat_ldts_name = (satellites[sat_name]['ldts'].keys() | list )[0] -%}
        {%- set sat_pk = satellites[sat_name]['pk'][sat_pk_name] -%}
        {%- set sat_ldts = satellites[sat_name]['ldts'][sat_ldts_name] %}
        LEFT JOIN {{ ref(sat_name) }} AS {{ sat_name | lower ~ '_src' }}
        {{ "ON" | indent(4) }} a.{{ src_pk }} = {{ sat_name | lower ~ '_src' }}.{{ sat_pk }}
        {{ "AND" | indent(4) }} {{ sat_name | lower ~ '_src' }}.{{ sat_ldts }} <= a.AS_OF_DATE

    {% endfor -%}

    GROUP BY
        {{ automate_dv.prefix([src_pk], 'a') }}, a.AS_OF_DATE
    ORDER BY (1)
),

pit AS (
    SELECT * FROM new_rows
{%- if automate_dv.is_any_incremental() %}
    UNION ALL
    SELECT * FROM overlap_pks
    UNION ALL
    SELECT * FROM backfill
{%- endif %}
)

SELECT DISTINCT * FROM pit

{%- endmacro -%}
