{%- macro bridge(source_model, src_pk, links, eff_satellites, as_of_date_table) -%}

    {{- adapter.dispatch('bridge', packages = dbtvault.get_dbtvault_namespaces())(source_model=source_model, src_pk=src_pk,
                                                                                  links=links, eff_satellites=eff_satellites,
                                                                                  as_of_date_table=as_of_date_table) -}}
{%- endmacro -%}

{%- macro default__bridge(source_model, src_pk, links, eff_satellites, as_of_date_table) -%}

{{ dbtvault.prepend_generated_by() }}

{%- if (as_of_dates_table is none) and execute -%}
    {%- set error_message -%}
    "pit error: Missing as_of_dates table configuration. A as_of_dates_table must be provided."
    {%- endset -%}
    {{- exceptions.raise_compiler_error(error_message) -}}
{%- endif -%}

{#- Aquiring the source relation for the AS_OF table -#}
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

WITH
    AS_OF_DATES_FOR_BRIDGE AS(
         SELECT
               a.AS_OF_DATE
         FROM {{ source_relation_AS_OF }} AS a
         WHERE
               a.AS_OF_DATE <= CURRENT_DATE()
          {#      AND #}
          {#      a.AS_OF_DATE > #}
          {#      (#}
          {#      CASE#}
          {#             WHEN (SELECT MAX(b.AS_OF_DATE) FROM "SANDBOX"."NORBERT_ACATRINEI"."BRIDGE" AS b) IS NULL#}
          {#                    THEN TO_TIMESTAMP( '"'"~ghost_date~"'"')#}
          {#             ELSE#}
          {#                    (SELECT MAX(b."AS_OF_DATE") FROM "SANDBOX"."NORBERT_ACATRINEI"."BRIDGE" AS b)#}
          {#      END#}
          {#  )#}
    ),

BRIDGE_WALK AS (
    SELECT
        a.{{ src_pk }},
        b."AS_OF_DATE",
        {%- for link in links -%}
            {%- filter indent(width=8) -%}
            {% set link_key = (links[link]['pk'].keys() | list )[0] -%}
            {{- "\n" -}}
            {{ 'COALESCE(MAX('~ link ~'_SRC.'~ links[link]['pk'][link_key]~'), CAST( '"'"~ghost_pk~"'"' AS BINARY)) AS '~ link ~'_'~ link_key ~','  }}
            {% endfilter %}
        {%- endfor %}
        {%-  for eff_sat in eff_satellites -%}
            {%- filter indent(width=8) -%}
            {% set eff_sat_key = (eff_satellites[eff_sat]['end_date'].keys() | list )[0] -%}
            {{- "\n" -}}
            {{ 'COALESCE(MAX('~ eff_sat ~'_SRC.'~ eff_satellites[eff_sat]['pk'][eff_sat_key]~'), CAST( '"'"~ghost_date~"'"' AS BINARY)) AS '~ eff_sat ~'_'~ eff_sat_key ~','  }}
            {{- ',' if not loop.last -}}
            {% endfilter %}
        {%- endfor %}

    FROM
    {{ ref(source_model) }} AS a
    INNER JOIN AS_OF_DATES_FOR_BRIDGE AS b
        ON (1=1)

    {# THINK OF HOW YOU CAN WRITE AS FEW LOOPS FOR THIS NEXT SECTION #}
    {% for link in links -%}
        {% set link_key = (links[link]['pk'].keys() | list )[0] -%}
        LEFT JOIN {{ ref(link) }} AS {{  link -}}_SRC
            ON a.{{- src_pk }} = {{ link -}}_SRC.{{ links[link]['pk'][link_key] }}
    {% endfor %}
    {%-  for eff_sat in eff_satellites -%}
        {% set eff_sat_key = (eff_satellites[eff_sat]['end_date'].keys() | list )[0] -%}
        INNER JOIN {{ ref(eff_sat) }} AS {{  eff_sat -}}_SRC
            ON a.{{- src_pk }} = {{ link -}}_SRC.{{ links[link]['pk'][link_key] }}
        {%- endfor %}
    INNER JOIN "SANDBOX"."NORBERT_ACATRINEI".EFF_SAT_CUSTOMER_NATION AS efs1
        ON c."LINK_CUSTOMER_NATION_PK" = efs1."LINK_CUSTOMER_NATION_PK"
        AND efs1."LOAD_DATE" <= b."AS_OF_DATE"
    INNER JOIN "SANDBOX"."NORBERT_ACATRINEI".EFF_SAT_CUSTOMER_ORDER AS efs2
        ON e."ORDER_CUSTOMER_PK" = efs2."ORDER_CUSTOMER_PK"
        AND efs2."LOAD_DATE" <= b."AS_OF_DATE"

    WHERE

    GROUP BY
        b."AS_OF_DATE", a."CUSTOMER_PK"

    ORDER BY 1,2)


SELECT * FROM BRIDGE_WALK WHERE
    EFF1_END_DATE = $maxdate and
    EFF2_END_DATE = $maxdate;



{%- endmacro -%}