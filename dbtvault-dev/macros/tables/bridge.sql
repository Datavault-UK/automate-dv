{%- macro bridge(source_model, src_pk, links, eff_sats, as_of_date_table) -%}

    {{- adapter.dispatch('bridge', packages = dbtvault.get_dbtvault_namespaces())(source_model=source_model, src_pk=src_pk,
                                                                                  links=links, eff_sats=eff_sats,
                                                                                  as_of_date_table=as_of_date_table) -}}
{%- endmacro -%}

{%- macro default__bridge(source_model, src_pk, links, eff_sats, as_of_date_table) -%}

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
        {%- for index in range(len(links.keys())) -%}
            {%- filter indent(width=8) -%}
            {% set link_key = links[list(links.keys())[index]]['pk']['PK'] -%}
            {% set eff_sat_end_date = eff_sats[list(eff_sats.keys())[index]]['end_date']['ENDDATE'] -%}
            {{- "\n" -}}
            {{ ',COALESCE(MAX('~ list(links.keys())[index] ~'_SRC.'~ link_key~'), CAST( '"'"~ ghost_pk ~"'"' AS BINARY)) AS LINK_' ~ link_key  }}
            {{ ',COALESCE(MAX('~ list(eff_sats.keys())[index] ~'_SRC.'~ eff_sat_end_date ~'), CAST( '"'"~ ghost_date ~"'"' AS BINARY)) AS '~ list(eff_sats.keys())[index] ~'_'~ eff_sat_end_date }}
            {{- ',' if not loop.last -}}
            {% endfilter %}
        {%- endfor %}

    FROM {{ ref(source_model) }} AS a
    INNER JOIN AS_OF_DATES_FOR_BRIDGE AS b
        ON (1=1)

    {% for index in range(len(links.keys())) -%}
        {%- filter indent(width=8) -%}
        {%- set current_link = list(links.keys())[index] -%}
        {%- set current_eff_sat = list(eff_sats.keys())[index] -%}
        {%- set link_key = links[list(links.keys())[index]]['pk']['PK'] -%}
        {%- set eff_sat_end_date = eff_sats[list(eff_sats.keys())[index]]['end_date']['ENDDATE'] -%}
        {%- if loop.first  -%}
        LEFT JOIN {{  ref(current_link) }} AS {{- current_link -}}_SRC
            ON a.{{- src_pk }} = {{-  current_link -}}_SRC.{{ link_key }}
        {% else %}
        LEFT JOIN {{  ref(current_link) }} AS {{- current_link -}}_SRC
-- {#                {% if previous_link_eff_sat.split('_')[-1] == link_and_eff_sat.split('_')[0]  %}#}
            {% set common_hub = list(links.keys())[index-1].split('_')[-1] %}
            ON {{- list(links.keys())[index-1] -}}_SRC.{{- common_hub -}}_FK = {{- current_link -}}_SRC.{{- common_hub -}}_FK
        {%- endif -%}
        INNER JOIN {{ ref(current_eff_sat) }} AS {{- current_eff_sat -}}_SRC
            ON {{- current_eff_sat -}}_SRC.{{ link_key }} = {{-  current_link -}}_SRC.{{ link_key }}
            AND {{- current_eff_sat -}}_SRC.LOAD_DATE <= b.AS_OF_DATE
            {% endfilter %}

    {%- endfor %}

    GROUP BY
        b."AS_OF_DATE", a."CUSTOMER_PK"

    ORDER BY 1,2)


SELECT * FROM BRIDGE_WALK WHERE
    {% for index in range(len(links.keys())) -%}
        {%- filter indent(width=8) -%}
        {% set eff_sat_end_date = eff_sats[list(eff_sats.keys())[index]]['end_date']['ENDDATE'] -%}
        {{ list(eff_sats.keys())[index] ~'_'~ eff_sat_end_date ~"='"~ maxdate ~"'" }}
        {{- 'AND' if not loop.last -}}
        {% endfilter %}
    {%- endfor %}


{%- endmacro -%}