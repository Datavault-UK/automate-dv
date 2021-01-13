{%- macro pit(src_pk, as_of_dates_table, satellites, source_model) -%}

    {{- adapter.dispatch('pit', packages = var('adapter_packages', ['dbtvault']))(source_model=source_model,src_pk=src_pk,
                                                                                   as_of_dates_table=as_of_dates_table,
                                                                                  satellites=satellites) -}}

{%- endmacro -%}

{%- macro default__pit(src_pk, as_of_dates_table, satellites, source_model) -%}

{# Set deafualts and obtain source model paths #}
{%- set maxdate = '9999-12-31 23:59:59.999999' -%}
{%- set ghost_pk =   ('0000000000000000') -%}
{%- set ghost_date = '0000-01-01 00:00:00.000000' -%}

    {#-  Loop to get the source relatiosn using source relation macro and can specify refs i think
    Loop throught the dict and call the 1st key or have a source model key pair in the sub dict
    Not in loop i can get the hub source relation -#}


{%- if as_of_dates_table is mapping and as_of_dates_table is not none -%}

    {%- set source_name = as_of_dates_table | first -%}
    {%- set source_table_name = as_of_dates_table[source_name] -%}

    {%- set source_relation = source(source_name, source_table_name) -%}

{%- elif as_of_dates_table is not mapping and as_of_dates_table is not none -%}

    {%- set source_relation = as_of_dates_table -%}
{%- endif -%}

    {#-
{% for sat in satelites -%}
    {%- set sat_src = dbtvault.prefix(columns=sat, prefix='_src') -%}
    {%- set sat ~ '_src' = ref(sat) %}
{% endfor %}
-#}

SELECT
        h.{{ src_pk }},
        x.AS_OF_DATE,
    {% for sat in satellites -%}
        {% set sat_key = (satellites[sat]['pk'].keys() | list )[0] -%}
        {%- set sat_ldts =(satellites[sat]['ldts'].keys() | list )[0] %}
        COALESCE(MAX({{  sat -}}_SRC.{{- satellites[sat]['pk'][sat_key] -}}), CAST( '{{ ghost_pk }}' AS BINARY)) AS {{ sat -}}_{{- sat_key -}},
        COALESCE(MAX({{  sat -}}_SRC.{{- satellites[sat]['ldts'][sat_ldts] -}}),TO_TIMESTAMP('{{ ghost_date }}')) AS {{ sat -}}_{{ sat_ldts }}
        {{- ',' if not loop.last }}
    {%- endfor %}

FROM {{ ref(source_model) }} AS h

INNER JOIN {{ ref(as_of_dates_table) }} AS x
    ON (1=1)

{% for sat in satellites -%}
    {%- set sat_key = (satellites[sat]['pk'].keys() | list )[0] -%}
    {%- set sat_ldts =(satellites[sat]['ldts'].keys() | list )[0] -%}
    LEFT JOIN {{ ref(sat) }} AS {{  sat -}}_SRC
        ON  h.{{- src_pk }} = {{ sat -}}_SRC.{{ satellites[sat]['pk'][sat_key] }}
    AND {{ sat -}}_SRC.{{ satellites[sat]['ldts'][sat_ldts] }} <= x.AS_OF_DATE

{% endfor %}

GROUP BY
 h.{{- src_pk }}, x.AS_OF_DATE
ORDER BY (1, 2)


{%- endmacro -%}
