{%- macro bridge(hubs, links, eff_satellites, as_of_date_table) -%}

    {{- adapter.dispatch('bridge', packages = dbtvault.get_dbtvault_namespaces())(hubs=hubs, links=links,
                                                                                  eff_satellites=eff_satellites,
                                                                                  as_of_date_table=as_of_date_table) -}}
{%- endmacro -%}

{%- macro default__bridge(hubs, links, eff_satellites, as_of_date_table) -%}

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
  AS_OF_DATES_FOR_BRIDGE AS
    (
       SELECT
             a.AS_OF_DATE
       FROM {{ source_relation_AS_OF }} AS a
       WHERE
             a.AS_OF_DATE <= CURRENT_DATE()
{#             AND #}
{#             a.AS_OF_DATE > #}
{#             (#}
{#             CASE#}
{#                    WHEN (SELECT MAX(b.AS_OF_DATE) FROM "SANDBOX"."NORBERT_ACATRINEI"."BRIDGE" AS b) IS NULL#}
{#                           THEN TO_TIMESTAMP( '"'"~ghost_date~"'"')#}
{#                    ELSE#}
{#                           (SELECT MAX(b."AS_OF_DATE") FROM "SANDBOX"."NORBERT_ACATRINEI"."BRIDGE" AS b)#}
{#             END#}
{#         )#}
    ),

BRIDGE_WALK AS
    (
      SELECT
          {%-  for hub in hubs -%}
               {%- filter indent(width=8) -%}
               {% set hub_key = (hubs[hub]['pk'].keys() | list )[0] -%}
               {{- "\n" -}}
               a.hubs[hub]['pk'][hub_key]
               {{- ',' if not loop.last -}}
               {% endfilter %}
          {%- endfor %}
          b."AS_OF_DATE",
          {%-  for link in links -%}
               {%- filter indent(width=8) -%}
               {% set link_key = (links[link]['pk'].keys() | list )[0] -%}
               {{- "\n" -}}
               a.links[link]['pk'][link_key]
               {{- ',' if not loop.last -}}
               {% endfilter %}
          {%- endfor %}
          COALESCE(MAX(c."LINK_CUSTOMER_NATION_PK"), $ghost_pk) AS LINK1_PK,
          COALESCE(MAX(e."ORDER_CUSTOMER_PK"), $ghost_pk) AS LINK2_PK,
          COALESCE(MAX(efs1."END_DATE"), $ghost_date) AS EFF1_END_DATE,
          COALESCE(MAX(efs2."END_DATE"), $ghost_date) AS EFF2_END_DATE


      FROM
          {%-  for hub in hubs.keys() -%}
               {%- filter indent(width=8) -%}
               {{- "\n" -}}
               {{ ref(hub) }}
               {{- ',' if not loop.last -}}
               {% endfilter %}
          {%- endfor %}
      INNER JOIN AS_OF_DATES_FOR_BRIDGE AS b
          ON (1=1)

      LEFT JOIN "SANDBOX"."NORBERT_ACATRINEI"."LINK_CUSTOMER_NATION" AS c
          ON c."CUSTOMER_PK" = a."CUSTOMER_PK"
      INNER JOIN "SANDBOX"."NORBERT_ACATRINEI".EFF_SAT_CUSTOMER_NATION AS efs1
          ON c."LINK_CUSTOMER_NATION_PK" = efs1."LINK_CUSTOMER_NATION_PK"
          AND efs1."LOAD_DATE" <= b."AS_OF_DATE"

      LEFT JOIN "SANDBOX"."NORBERT_ACATRINEI"."LINK_CUSTOMER_ORDER" AS e
          ON c."CUSTOMER_PK" = e."CUSTOMER_PK"
      INNER JOIN "SANDBOX"."NORBERT_ACATRINEI".EFF_SAT_CUSTOMER_ORDER AS efs2
          ON e."ORDER_CUSTOMER_PK" = efs2."ORDER_CUSTOMER_PK"
          AND efs2."LOAD_DATE" <= b."AS_OF_DATE"

      WHERE

      GROUP BY
          b."AS_OF_DATE", a."CUSTOMER_PK"

      ORDER BY 1,2)



{%- endmacro -%}