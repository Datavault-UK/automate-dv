{%- macro pit(src_pk, as_of_dates_table, satellite, source_model) -%}

    {{- adapter.dispatch('pit', packages = var('adapter_packages', ['dbtvault']))(source_model=source_model,src_pk=src_pk,
                                                                                   as_of_dates_table=as_of_dates_table,
                                                                                   satellite=satellite) -}}

{%- endmacro -%}

{%- macro default__pit(src_pk, as_of_dates_table, satellite, source_model) -%}

{# Set deafualts and obtain source model paths #}
{% set maxdate = '9999-12-31 23:59:59.999999' %}
{% set ghost_pk =   ('0000000000000000') %}
{% set ghost_date = '0000-00-00 00:00:00.000000' %}

    {#  Loop to get the source relatiosn using source relation macro and can specify refs i think
    Loop throught the dict and call the 1st key or have a source model key pair in the sub dict
    Not in loop i can get the hub source relation #}

{%- set source_relation = ref(source_model) %}
{%- set as_of_dates_table = ref(as_of_dates_table) -%}
{% for sat in satelites -%}
    {%- set sat_src = dbtvault.prefix(columns=sat, prefix='_src') -%}
    {%- set sat_src = ref(sat) %}
{% endfor %}


SELECT
    {{ as_of_dates_table -}}.as_of_date,
    {{ src_pk }},
    {% for sats in satellites -%}
        COALESCE(MAX({{- sat ~ '_src' -}}.{{- sat[pk] -}}), CAST(ghost_pk AS BINARY) AS {{ sat -}}_PK,
        COALESCE(MAX({{- sat ~ '_src' -}}.{{- sat[LDTS] -}}), ghost_date) AS {{ sat -}}_LDTS
        {{- ',' if not loop.last -}}
    {%- endfor %}

FROM {{ source_relation }} AS h

INNER JOIN {{ as_of_dates_table }} AS x
    ON (1=1)


{% for sat in satelites -%}
    LEFT JOIN {{- sat ~'_src' -}}
        ON {{ h.src_pk }} = {{ sat -}}.{{ sat.pk }},
    WHERE {{ sat -}}.LDTS <= x.as_of_date
{% endfor %}

GROUP BY
x.as_of_date, h.{{- src_pk }},
ORDER BY 1, 2;


{%- endmacro -%}