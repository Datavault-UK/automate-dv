{%- macro pit(src_pk, as_of_dates_table, satellites, source_model) -%}

    {{- adapter.dispatch('pit', packages = dbtvault.get_dbtvault_namespaces())(source_model=source_model, src_pk=src_pk,
                                                                               as_of_dates_table=as_of_dates_table,
                                                                               satellites=satellites) -}}

{%- endmacro -%}

{%- macro default__pit(src_pk, as_of_dates_table, satellites, source_model) -%}

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
    {%- set source_relation_AS_OF = ref(as_of_dates_table) -%}
{%- endif -%}

{%- set maxdate = '9999-12-31 23:59:59.999999' -%}
{%- set ghost_pk = ('0000000000000000') -%}
{%- set ghost_date = '1990-01-01 00:00:00.000000' %}
WITH hub AS (

	SELECT * FROM {{ ref(source_model) }}

),
as_of_dates_PK_join AS (
    SELECT
        hub.{{ src_pk }},
        as_of.AS_OF_DATE
    FROM hub

    INNER JOIN {{ source_relation_AS_OF}} AS as_of
    ON (1=1)
),

satellites_cte AS (

    SELECT
        a.{{ src_pk }},
        a.AS_OF_DATE,
        {%- for sat in satellites -%}
            {%- filter indent(width=8) -%}
            {% set sat_key = (satellites[sat]['pk'].keys() | list )[0] -%}
            {%- set sat_ldts =(satellites[sat]['ldts'].keys() | list )[0]  -%}
            {{- "\n" -}}
            {{ 'COALESCE(MAX('~ sat ~'_SRC.'~ satellites[sat]['pk'][sat_key]~'), CAST( '"'"~ghost_pk~"'"' AS BINARY)) AS '~ sat ~'_'~ sat_key ~','  }}
            {{- "\n" -}}
            {{ 'COALESCE(MAX('~ sat ~'_SRC.'~ satellites[sat]['ldts'][sat_ldts]~'), TO_TIMESTAMP( '"'"~ghost_date~"'"')) AS '~ sat ~'_'~ sat_ldts  }}
            {{- ',' if not loop.last -}}
            {% endfilter %}
        {%- endfor %}

    FROM as_of_dates_PK_join AS a

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
)

SELECT * FROM satellites_cte
{%- endmacro -%}
