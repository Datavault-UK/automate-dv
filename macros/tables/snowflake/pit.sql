/*
 * Copyright (c) Business Thinking Ltd. 2019-2023
 * This software includes code developed by the dbtvault Team at Business Thinking Ltd. Trading as Datavault
 */

{%- macro pit(src_pk, src_extra_columns, as_of_dates_table, satellites, stage_tables_ldts, src_ldts, source_model) -%}

    {%- if dbtvault.is_something(src_extra_columns) and execute -%}
      {%- do exceptions.warn("WARNING: src_extra_columns not yet available for PITs or Bridges. This parameter will be ignored.") -%}
    {%- endif -%}

    {{- dbtvault.check_required_parameters(src_pk=src_pk,
                                           as_of_dates_table=as_of_dates_table,
                                           satellites=satellites,
                                           stage_tables_ldts=stage_tables_ldts,
                                           src_ldts=src_ldts,
                                           source_model=source_model) -}}

    {{- dbtvault.prepend_generated_by() }}

    {%- for stg in stage_tables_ldts %}
        {{ "-- depends_on: " ~ ref(stg) -}}
    {%- endfor -%}

    {{ adapter.dispatch('pit', 'dbtvault')(src_pk=src_pk,
                                           src_extra_columns=src_extra_columns,
                                           as_of_dates_table=as_of_dates_table,
                                           satellites=satellites,
                                           stage_tables_ldts=stage_tables_ldts,
                                           src_ldts=src_ldts,
                                           source_model=source_model) -}}
{%- endmacro -%}

{%- macro default__pit(src_pk, src_extra_columns, as_of_dates_table, satellites, stage_tables_ldts, src_ldts, source_model) -%}

{#- Acquiring the source relation for the AS_OF table -#}
{%- if as_of_dates_table is mapping and as_of_dates_table is not none -%}
    {%- set source_name = as_of_dates_table | first -%}
    {%- set source_table_name = as_of_dates_table[source_name] -%}
    {%- set as_of_table_relation = source(source_name, source_table_name) -%}
{%- elif as_of_dates_table is not mapping and as_of_dates_table is not none -%}
    {%- set as_of_table_relation = ref(as_of_dates_table) -%}
{%- endif -%}

{#- Setting ghost values to replace NULLS -#}
{%- set ghost_pk = '0000000000000000' -%}
{%- set ghost_date = '1900-01-01 00:00:00.000' %}

{%- set enable_ghost_record = var('enable_ghost_records', false) -%}

{%- if dbtvault.is_any_incremental() -%}
    {%- set new_as_of_dates_cte = 'new_rows_as_of' -%}
{%- else -%}
    {%- set new_as_of_dates_cte = 'as_of_dates' -%}
{%- endif %}

WITH as_of_dates AS (
    SELECT * FROM {{ as_of_table_relation }}
),

{%- if dbtvault.is_any_incremental() %}

{{ dbtvault.as_of_date_window(src_pk, src_ldts, stage_tables_ldts, ref(source_model)) }},

backfill_rows_as_of_dates AS (
    SELECT
        {{ dbtvault.prefix([src_pk], 'a') }},
        b.AS_OF_DATE
    FROM new_rows_pks AS a
    INNER JOIN backfill_as_of AS b
        ON (1=1)
),

backfill AS (
    SELECT
        {{ dbtvault.prefix([src_pk], 'a') }},
        a.AS_OF_DATE,

    {%- for sat_name in satellites -%}
        {%- set sat_pk_name = (satellites[sat_name]['pk'].keys() | list )[0] -%}
        {%- set sat_ldts_name = (satellites[sat_name]['ldts'].keys() | list )[0] -%}
        {%- set sat_name = sat_name -%}
        {%- set sat_pk = satellites[sat_name]['pk'][sat_pk_name] -%}
        {%- set sat_ldts = satellites[sat_name]['ldts'][sat_ldts_name] -%}
        {%- set column_str = "{}.{}".format(sat_name | lower ~ '_src', sat_ldts) -%}

        {% if enable_ghost_record %}
        MIN({{ sat_name | lower ~ '_src' }}.{{ sat_pk }}) AS {{ sat_name }}_{{ sat_pk_name }},
        MIN({{ dbtvault.cast_date(column_str=column_str, datetime=true) }}) AS {{ sat_name }}_{{ sat_ldts_name }}
        {%- else %}

        {{ dbtvault.cast_binary(ghost_pk, quote=true, alias=sat_name ~ '_' ~ sat_pk_name) }},
        {{ dbtvault.cast_date(ghost_date, as_string=true, datetime=true, alias=sat_name ~ '_' ~ sat_ldts_name) }}
        {%- endif -%}

        {%- if not loop.last -%},{%- endif -%}
    {%- endfor %}

    FROM backfill_rows_as_of_dates AS a

    {%- for sat_name in satellites -%}
        {%- set sat_pk_name = (satellites[sat_name]['pk'].keys() | list )[0] -%}
        {%- set sat_ldts_name = (satellites[sat_name]['ldts'].keys() | list )[0] -%}
        {%- set sat_pk = satellites[sat_name]['pk'][sat_pk_name] -%}
        {%- set sat_ldts = satellites[sat_name]['ldts'][sat_ldts_name] %}

        LEFT JOIN {{ ref(sat_name) }} AS {{ sat_name | lower ~ '_src' }}
            ON a.{{ src_pk }} = {{ sat_name | lower ~ '_src' }}.{{ sat_pk }}
            AND {{ sat_name | lower ~ '_src' }}.{{ sat_ldts }} <= a.AS_OF_DATE
            OR {{ sat_name | lower ~ '_src' }}.{{ sat_ldts }} = '1900-01-01 00:00:00.000'
    {% endfor %}

    GROUP BY
        {{ dbtvault.prefix([src_pk], 'a') }}, a.AS_OF_DATE
),
{%- endif %}

new_rows_as_of_dates AS (
    SELECT
        {{ dbtvault.prefix([src_pk], 'a') }},
        b.AS_OF_DATE
    FROM {{ ref(source_model) }} AS a
    INNER JOIN {{ new_as_of_dates_cte }} AS b
    ON (1=1)
),

new_rows AS (
    SELECT
        {{ dbtvault.prefix([src_pk], 'a') }},
        a.AS_OF_DATE,

    {%- for sat_name in satellites -%}
        {%- set sat_pk_name = (satellites[sat_name]['pk'].keys() | list)[0] -%}
        {%- set sat_ldts_name = (satellites[sat_name]['ldts'].keys() | list)[0] -%}
        {%- set sat_pk = satellites[sat_name]['pk'][sat_pk_name] -%}
        {%- set sat_ldts = satellites[sat_name]['ldts'][sat_ldts_name] -%}
        {%- set column_str = "{}.{}".format(sat_name | lower ~ '_src', sat_ldts) -%}

        {% if enable_ghost_record %}
        MAX({{ sat_name | lower ~ '_src' }}.{{ sat_pk }}) AS {{ sat_name }}_{{ sat_pk_name }},
        MAX({{ dbtvault.cast_date(column_str=column_str, datetime=true)}}) AS {{ sat_name }}_{{ sat_ldts_name }}
        {%- else %}

        COALESCE(MAX({{ sat_name | lower ~ '_src' }}.{{ sat_pk }}),
                 {{ dbtvault.cast_binary(ghost_pk, quote=true) }})
        AS {{ sat_name }}_{{ sat_pk_name }},

        COALESCE(MAX({{ sat_name | lower ~ '_src' }}.{{ sat_ldts }}),
                 {{ dbtvault.cast_date(ghost_date, as_string=true, datetime=true) }})
        AS {{ sat_name }}_{{ sat_ldts_name }}
        {%- endif -%}

        {%- if not loop.last -%},{%- endif -%}

    {%- endfor %}

    FROM new_rows_as_of_dates AS a

    {%- for sat_name in satellites -%}
        {%- set sat_pk_name = (satellites[sat_name]['pk'].keys() | list )[0] -%}
        {%- set sat_ldts_name = (satellites[sat_name]['ldts'].keys() | list )[0] -%}
        {%- set sat_pk = satellites[sat_name]['pk'][sat_pk_name] -%}
        {%- set sat_ldts = satellites[sat_name]['ldts'][sat_ldts_name] %}

        LEFT JOIN {{ ref(sat_name) }} AS {{ sat_name | lower ~ '_src' }}
            ON a.{{ src_pk }} = {{ sat_name | lower }}_src.{{ sat_pk }}
            AND {{ sat_name | lower ~ '_src'}}.{{ sat_ldts }} <= a.AS_OF_DATE
            OR {{ sat_name | lower ~ '_src'}}.{{ sat_ldts }} = '1900-01-01 00:00:00.000'
    {% endfor %}

    GROUP BY
        {{ dbtvault.prefix([src_pk], 'a') }},
        a.AS_OF_DATE
),

pit AS (
    SELECT * FROM new_rows
    {%- if dbtvault.is_any_incremental() %}
    UNION ALL
    SELECT * FROM overlap_pks
    UNION ALL
    SELECT * FROM backfill
    {% endif %}
)

SELECT DISTINCT * FROM pit

{%- endmacro -%}