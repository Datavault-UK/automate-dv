{%- macro bridge(source_model, src_pk, links_and_eff_sats, as_of_date_table) -%}

    {{- adapter.dispatch('bridge', packages = dbtvault.get_dbtvault_namespaces())(source_model=source_model, src_pk=src_pk,
                                                                                  links_and_eff_sats=links_and_eff_sats,
                                                                                  as_of_date_table=as_of_date_table) -}}
{%- endmacro -%}

{%- macro default__bridge(source_model, src_pk, links_and_eff_sats, as_of_date_table) -%}

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
        ,b."AS_OF_DATE"
        {%- for link_and_eff_sat in links_and_eff_sats -%}
            {%- filter indent(width=8) -%}
            {% set link_key = links_and_eff_sats[link_and_eff_sat]['pk']['PK'] -%}
            {% set eff_sat_end_date = links_and_eff_sats[link_and_eff_sat]['end_date']['END_DATE'] -%}
            {{- "\n" -}}
            {{ ',COALESCE(MAX(LINK_'~ link_and_eff_sat ~'_SRC.'~ link_key~'), CAST( '"'"~ ghost_pk ~"'"' AS BINARY)) AS LINK_' ~ link_key  }}
            {{ ',COALESCE(MAX(EFF_SAT_'~ link_and_eff_sat ~'_SRC.'~ eff_sat_end_date ~'), CAST( '"'"~ ghost_date ~"'"' AS BINARY)) AS LINK_EFF_'~ eff_sat_end_date }}
            {{- ',' if not loop.last -}}
            {% endfilter %}
        {%- endfor %}

    FROM
    {{ ref(source_model) }} AS a
    INNER JOIN AS_OF_DATES_FOR_BRIDGE AS b
        ON (1=1)

    {% for link_and_eff_sat in links_and_eff_sats -%}
            {%- filter indent(width=8) -%}
            {% set link_key = links_and_eff_sats[link_and_eff_sat]['pk']['PK'] -%}
            {% set eff_sat_end_date = links_and_eff_sats[link_and_eff_sat]['end_date']['END_DATE'] -%}
        {% if loop.first  %}
        LEFT JOIN {{  ref('LINK_' ~ link_and_eff_sat) }} AS LINK_{{-  link_and_eff_sat -}}_SRC
            ON a.{{- src_pk }} = LINK_{{-  link_and_eff_sat -}}_SRC.{{ link_key }}
        {% else %}
        LEFT JOIN {{  ref('LINK_' ~ link_and_eff_sat) }} AS LINK_{{-  link_and_eff_sat -}}_SRC
{#            {% if previous_link_eff_sat.split('_')[-1] == link_and_eff_sat.split('_')[0]  %}#}
            {% set common_hub = previous_link_eff_sat.split('_')[-1] %}
            ON LINK_{{-  previous_link_eff_sat -}}_SRC.{{ common_hub }}_FK = LINK_{{-  link_and_eff_sat -}}_SRC.{{ common_hub }}_FK

        INNER JOIN {{ ref('EFF_SAT_' ~ link_and_eff_sat) }} AS EFF_SAT_{{-  link_and_eff_sat -}}_SRC
            ON EFF_SAT_{{-  link_and_eff_sat -}}_SRC.{{ link_key }} = LINK_{{-  link_and_eff_sat -}}_SRC.{{ link_key }}
            AND EFF_SAT_{{-  link_and_eff_sat -}}_SRC.LOAD_DATE <= b.AS_OF_DATE
            {% set previous_link_eff_sat = links_and_eff_sats -%}
            {% set previous_link_key = links_and_eff_sats[previous_link_eff_sat]['pk']['PK'] -%}
            {% endfilter %}

    {%- endfor %}

    GROUP BY
        b."AS_OF_DATE", a."CUSTOMER_PK"

    ORDER BY 1,2)


SELECT * FROM BRIDGE_WALK WHERE
    {% for link_and_eff_sat in links_and_eff_sats -%}
            {%- filter indent(width=8) -%}
            {% set eff_sat_end_date = links_and_eff_sats[link_and_eff_sat]['end_date']['END_DATE'] -%}
            {{ 'LINK_EFF_'~ eff_sat_end_date~"='"~maxdate~"'" }}
            {{- 'AND' if not loop.last -}}
            {% endfilter %}
    {%- endfor %}


{%- endmacro -%}