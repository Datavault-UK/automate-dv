{%- macro bigquery__pit(src_pk, src_extra_columns, as_of_dates_table, satellites, stage_tables_ldts, src_ldts, source_model) %}

{#- Acquiring the source relation for the AS_OF table -#}
{%- if as_of_dates_table is mapping and as_of_dates_table is not none -%}
    {%- set source_name = as_of_dates_table | first -%}
    {%- set source_table_name = as_of_dates_table[source_name] -%}
    {%- set as_of_table_relation = source(source_name, source_table_name) -%}
{%- elif as_of_dates_table is not mapping and as_of_dates_table is not none -%}
    {%- set as_of_table_relation = ref(as_of_dates_table) -%}
{%- endif -%}

{#- Setting ghost values to replace NULLS -#}
{%- set ghost_pk = '0x0000000000000000' -%}
{%- set ghost_date = '1900-01-01 00:00:00.000000' %}

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
        ON (1=1 )
),

backfill AS (
    SELECT
        {{ dbtvault.prefix([src_pk], 'a') }},
        a.AS_OF_DATE,
    {%- for sat_name in satellites -%}
        {%- set sat_key_name = (satellites[sat_name]['pk'].keys() | list )[0] | upper -%}
        {%- set sat_ldts_name = (satellites[sat_name]['ldts'].keys() | list )[0] | upper -%}
        {%- set sat_name = sat_name | upper %}
        '{{ ghost_pk }}' AS {{ dbtvault.escape_column_names( sat_name ~ '_' ~ sat_key_name ) }},
        PARSE_DATETIME('%F %H:%M:%E6S', '{{ ghost_date }}') AS {{ dbtvault.escape_column_names( sat_name ~ '_' ~ sat_ldts_name ) }}
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
    ORDER BY (1)
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
        COALESCE(MAX({{ dbtvault.escape_column_names( sat_name | lower ~ '_src' ) }}.{{ sat_pk }}),
        '{{ ghost_pk }}') AS {{ sat_name | upper }}_{{ sat_pk_name | upper }},
        COALESCE(MAX({{ dbtvault.escape_column_names( sat_name | lower ~ '_src' ) }}.{{ sat_ldts }}),
        PARSE_DATETIME('%F %H:%M:%E6S', '{{ ghost_date }}')) AS {{ sat_name | upper }}_{{ sat_ldts_name | upper }}
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
    ORDER BY (1)
),

pit AS (
    SELECT * FROM new_rows
{%- if dbtvault.is_any_incremental() %}
    UNION ALL
    SELECT * FROM overlap_pks
    UNION ALL
    SELECT * FROM backfill
{%- endif %}
)

SELECT DISTINCT * FROM pit

{%- endmacro -%}
