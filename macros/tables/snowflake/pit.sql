{%- macro pit(src_pk, as_of_dates_table, satellites, stage_tables, src_ldts, source_model ) -%}

{# TODO Should the length of the ghost_pk zero hash be determined by the hashing option being used, i.e. MD5 = 16, SHA = 32 ? #}

    {{- adapter.dispatch('pit', 'dbtvault')(source_model=source_model, src_pk=src_pk,
                                            as_of_dates_table=as_of_dates_table,
                                            satellites=satellites,
                                            stage_tables=stage_tables,
                                            src_ldts=src_ldts) -}}
{%- endmacro -%}

{%- macro default__pit(src_pk, as_of_dates_table, satellites, stage_tables, src_ldts, source_model) -%}

{{- dbtvault.check_required_parameters(source_model=source_model, src_pk=src_pk,
                                       satellites=satellites,
                                       stage_tables=stage_tables,
                                       src_ldts=src_ldts) -}}

{%- set src_pk = dbtvault.escape_column_names(src_pk) -%}
{%- set src_ldts = dbtvault.escape_column_names(src_ldts) -%}

{{ dbtvault.prepend_generated_by() }}

{%- if (as_of_dates_table is none) and execute -%}
    {%- set error_message -%}
    "PIT error: Missing as_of_dates table configuration. A as_of_dates_table must be provided."
    {%- endset -%}
    {{- exceptions.raise_compiler_error(error_message) -}}
{%- endif -%}

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

{# Stating the dependancies on the stage tables outside of the If STATEMENT #}
{% for stg in stage_tables -%}
    {{ "-- depends_on: " ~ ref(stg) }}
{% endfor %}

{#- Setting the new AS_OF dates CTE name -#}
{%- if dbtvault.is_any_incremental() -%}
{%- set new_as_of_dates_cte = 'new_rows_as_of' -%}
{%- else -%}
{%- set new_as_of_dates_cte = 'as_of_dates' -%}
{%- endif %}

WITH as_of_dates AS (
    SELECT * FROM {{ as_of_table_relation }}
),

{%- if dbtvault.is_any_incremental() %}

last_safe_load_datetime AS (
    SELECT MIN(LOAD_DATETIME) AS LAST_SAFE_LOAD_DATETIME FROM (
    {%- for stg in stage_tables -%}
        {%- set stage_ldts = stage_tables[stg] %}
        SELECT MIN({{ stage_ldts }}) AS LOAD_DATETIME FROM {{ (ref(stg)) }}
        {{ "UNION ALL" if not loop.last }}
    {%- endfor %}
    ) a
),

as_of_grain_old_entries AS (
    SELECT DISTINCT AS_OF_DATE FROM {{ this }}
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
    SELECT {{ dbtvault.prefix([src_pk], 'a') }}
    FROM {{ ref(source_model) }} AS a
    WHERE a.{{ src_ldts }} >= (SELECT LAST_SAFE_LOAD_DATETIME FROM last_safe_load_datetime)
),

new_rows_as_of AS (
    SELECT AS_OF_DATE
    FROM as_of_dates AS a
    WHERE a.AS_OF_DATE >= (SELECT LAST_SAFE_LOAD_DATETIME FROM last_safe_load_datetime)
    UNION
    SELECT AS_OF_DATE
    FROM as_of_grain_new_entries
),

overlap AS (
    SELECT a.*
    FROM {{ this }} AS a
    INNER JOIN {{ ref(source_model) }} as b
    ON {{ dbtvault.multikey(src_pk, prefix=['a','b'], condition='=') }}
    WHERE a.AS_OF_DATE >= (SELECT MIN_DATE FROM min_date)
    AND a.AS_OF_DATE < (SELECT LAST_SAFE_LOAD_DATETIME FROM last_safe_load_datetime)
    AND a.AS_OF_DATE NOT IN (SELECT AS_OF_DATE FROM as_of_grain_lost_entries)
),

{#- Back-fill any newly arrived hubs, set all historical pit dates to ghost records -#}

backfill_rows_as_of_dates AS (
    SELECT
        {{ dbtvault.prefix([src_pk], 'a') }},
        b.AS_OF_DATE
    FROM new_rows_pks AS a
    INNER JOIN backfill_as_of AS b
        ON (1=1 )
),

backfill AS (
    SELECT
        {{ dbtvault.prefix([src_pk], 'a') }},
        a.AS_OF_DATE,
    {%- for sat_name in satellites -%}
        {%- set sat_pk_name = (satellites[sat_name]['pk'].keys() | list )[0] | upper -%}
        {%- set sat_ldts_name = (satellites[sat_name]['ldts'].keys() | list )[0] | upper -%}
        {%- set sat_name = sat_name | upper %}
        {%- if target.type == "sqlserver" -%}
        CONVERT(BINARY(16), '{{ ghost_pk }}', 2) AS {{ dbtvault.escape_column_names( sat_name ~ '_' ~ sat_pk_name ) }},
        {%- else -%}
        CAST('{{ ghost_pk }}' AS BINARY(16)) AS {{ dbtvault.escape_column_names( sat_name ~ '_' ~ sat_pk_name ) }},
        {%- endif -%}
        CAST('{{ ghost_date }}' AS {{ dbtvault.type_timestamp() }}) AS {{ dbtvault.escape_column_names( sat_name ~ '_' ~ sat_ldts_name ) }}
        {{- ',' if not loop.last -}}
    {%- endfor %}
    FROM backfill_rows_as_of_dates AS a

    {% for sat_name in satellites -%}
        {%- set sat_pk_name = (satellites[sat_name]['pk'].keys() | list )[0] -%}
        {%- set sat_ldts_name = (satellites[sat_name]['ldts'].keys() | list )[0] -%}
        {%- set sat_pk = dbtvault.escape_column_names(satellites[sat_name]['pk'][sat_pk_name]) -%}
        {%- set sat_ldts = dbtvault.escape_column_names(satellites[sat_name]['ldts'][sat_ldts_name]) -%}
        LEFT JOIN {{ ref(sat_name) }} AS {{ dbtvault.escape_column_names( sat_name | lower ~ '_src' ) }}
        {{ "ON" | indent(4) }} a.{{ src_pk }} = {{ dbtvault.escape_column_names( sat_name | lower ~ '_src' ) }}.{{ sat_pk }}
        {{ "AND" | indent(4) }} {{ dbtvault.escape_column_names( sat_name | lower ~ '_src' ) }}.{{ sat_ldts }} <= a.AS_OF_DATE
    {% endfor -%}

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
        {%- set sat_pk_name = (satellites[sat_name]['pk'].keys() | list )[0] -%}
        {%- set sat_ldts_name = (satellites[sat_name]['ldts'].keys() | list )[0] -%}
        {%- set sat_pk = dbtvault.escape_column_names(satellites[sat_name]['pk'][sat_pk_name]) -%}
        {%- set sat_ldts = dbtvault.escape_column_names(satellites[sat_name]['ldts'][sat_ldts_name]) %}
        {%- if target.type == "sqlserver" -%}
        COALESCE(MAX({{ dbtvault.escape_column_names( sat_name | lower ~ '_src' ) }}.{{ sat_pk }}), CONVERT(BINARY(16), '{{ ghost_pk }}', 2)) AS {{ dbtvault.escape_column_names( sat_name | upper ~ '_' ~ sat_pk_name | upper ) }},
        {%- else -%}
        COALESCE(MAX({{ dbtvault.escape_column_names( sat_name | lower ~ '_src' ) }}.{{ sat_pk }}), CAST('{{ ghost_pk }}' AS BINARY(16))) AS {{ dbtvault.escape_column_names( sat_name | upper ~ '_' ~ sat_pk_name | upper ) }},
        {%- endif -%}
        COALESCE(MAX({{ dbtvault.escape_column_names( sat_name | lower ~ '_src' ) }}.{{ sat_ldts }}), CAST('{{ ghost_date }}' AS {{ dbtvault.type_timestamp() }})) AS {{ dbtvault.escape_column_names( sat_name | upper ~ '_' ~ sat_ldts_name | upper ) }}
        {{- "," if not loop.last }}
    {%- endfor %}
    FROM new_rows_as_of_dates AS a

    {% for sat_name in satellites -%}
        {%- set sat_pk_name = (satellites[sat_name]['pk'].keys() | list )[0] -%}
        {%- set sat_ldts_name = (satellites[sat_name]['ldts'].keys() | list )[0] -%}
        {%- set sat_pk = dbtvault.escape_column_names(satellites[sat_name]['pk'][sat_pk_name]) -%}
        {%- set sat_ldts = dbtvault.escape_column_names(satellites[sat_name]['ldts'][sat_ldts_name]) -%}
        LEFT JOIN {{ ref(sat_name) }} AS {{ dbtvault.escape_column_names( sat_name | lower ~ '_src' ) }}
        {{ "ON" | indent(4) }} a.{{ src_pk }} = {{ dbtvault.escape_column_names( sat_name | lower ~ '_src' ) }}.{{ sat_pk }}
        {{ "AND" | indent(4) }} {{ dbtvault.escape_column_names( sat_name | lower ~ '_src' ) }}.{{ sat_ldts }} <= a.AS_OF_DATE
    {% endfor -%}

    GROUP BY
        {{ dbtvault.prefix([src_pk], 'a') }}, a.AS_OF_DATE
),

pit AS (
    SELECT * FROM new_rows
{%- if dbtvault.is_any_incremental() %}
    UNION ALL
    SELECT * FROM overlap
    UNION ALL
    SELECT * FROM backfill

{%- endif %}
)

SELECT DISTINCT * FROM pit

{%- endmacro -%}