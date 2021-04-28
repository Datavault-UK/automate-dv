{%- macro bridge(src_pk, as_of_dates_table, links_and_eff_sats, source_model) -%}

    {{- adapter.dispatch('bridge', packages = dbtvault.get_dbtvault_namespaces())(source_model=source_model, src_pk=src_pk,
                                                                                  links_and_eff_sats=links_and_eff_sats,
                                                                                  as_of_dates_table=as_of_dates_table) -}}
{%- endmacro -%}

{%- macro default__bridge(src_pk, as_of_dates_table, links_and_eff_sats, source_model) -%}

{{ dbtvault.prepend_generated_by() }}

{%- if (as_of_dates_table is none) and execute -%}
    {%- set error_message -%}
    "pit error: Missing as_of_dates table configuration. A as_of_dates_table must be provided."
    {%- endset -%}
    {{- exceptions.raise_compiler_error(error_message) -}}
{%- endif -%}

{#- Acquiring the source relation for the AS_OF table -#}
{%- if as_of_dates_table is mapping and as_of_dates_table is not none -%}
    {%- set source_name = as_of_dates_table | first -%}
    {%- set source_table_name = as_of_dates_table[source_name] -%}
    {%- set source_relation = source(source_name, source_table_name) -%}
{%- elif as_of_dates_table is not mapping and as_of_dates_table is not none -%}
    {%- set source_relation = ref(as_of_dates_table) -%}
{%- endif -%}

{%- set maxdate = '9999-12-31 23:59:59.999999' -%}
{%- set ghost_pk = '0000000000000000' -%}
{%- set ghost_date = '1990-01-01 00:00:00.000000' %}

WITH
    AS_OF_DATES_FOR_BRIDGE AS (
         SELECT
             a.AS_OF_DATE
         FROM {{ source_relation }} AS a
         WHERE
               a.AS_OF_DATE <= CURRENT_DATE()
    ),

BRIDGE_WALK AS (
    SELECT
        a.{{ src_pk }}
        ,b.AS_OF_DATE
        {% for index in links_and_eff_sats.keys() -%}
            {% set link_table = links_and_eff_sats[index]['link_table'] -%}
            {% set bridge_link_pk_col = links_and_eff_sats[index]['bridge_link_pk_col'] -%}
            {% set link_pk = links_and_eff_sats[index]['link_pk'] -%}
            {% set eff_sat_table = links_and_eff_sats[index]['eff_sat_table'] -%}
            {% set bridge_end_date_col = links_and_eff_sats[index]['bridge_end_date_col'] -%}
            {% set eff_sat_end_date = links_and_eff_sats[index]['eff_sat_end_date'] -%}
            {{ ',COALESCE(MAX('~ link_table ~'.'~ link_pk ~'), CAST('"'"~ ghost_pk ~"'"' AS BINARY(16))) AS '~ bridge_link_pk_col }}
            {{ ',COALESCE(MAX('~ eff_sat_table ~'.'~ eff_sat_end_date ~'), CAST('"'"~ ghost_date ~"'"' AS BINARY(16))) AS '~ bridge_end_date_col }}
        {% endfor -%}

    FROM {{ ref(source_model) }} AS a
    INNER JOIN AS_OF_DATES_FOR_BRIDGE AS b
        ON (1=1)
    {%  set loop_vars = namespace(lastlink = '', last_link_fk = '') %}
    {% for index in links_and_eff_sats.keys() -%}
        {%- set current_link = links_and_eff_sats[index]['link_table'] -%}
        {%- set current_eff_sat = links_and_eff_sats[index]['eff_sat_table'] -%}
        {%- set link_pk = links_and_eff_sats[index]['link_pk'] -%}
        {%- set link_fk1 = links_and_eff_sats[index]['link_fk1'] -%}
        {%- set link_fk2 = links_and_eff_sats[index]['link_fk2'] -%}
        {%- set eff_sat_pk = links_and_eff_sats[index]['eff_sat_pk'] -%}
        {%- set eff_sat_end_date = links_and_eff_sats[index]['eff_sat_end_date'] -%}
        {%- set eff_sat_ldts = links_and_eff_sats[index]['eff_sat_ldts'] -%}
        {%- if loop.first  -%}
        LEFT JOIN {{ ref(current_link) }} AS {{ current_link }}
            ON a.{{ src_pk }} = {{ current_link }}.{{ link_fk1 }}
        {% else %}
        LEFT JOIN {{ ref(current_link) }} AS {{ current_link }}
            ON {{ loop_vars.last_link }}.{{ loop_vars.last_link_fk2 }} = {{ current_link }}.{{ link_fk1 }}
        {% endif %}
        INNER JOIN {{ ref(current_eff_sat) }} AS {{ current_eff_sat }}
            ON {{ current_eff_sat }}.{{ eff_sat_pk }} = {{ current_link }}.{{ link_pk }}
            AND {{ current_eff_sat }}.{{ eff_sat_ldts }} <= b.AS_OF_DATE
        {%- set loop_vars.last_link = current_link -%}
        {%- set loop_vars.last_link_fk2 = link_fk2 -%}
    {% endfor %}

    GROUP BY
        b.AS_OF_DATE, a.{{ src_pk }}

    ORDER BY 1,2)

SELECT * FROM BRIDGE_WALK
    {% for index in links_and_eff_sats.keys() -%}
        {{ 'WHERE' ~ '\n' if loop.first }}
        {%- set eff_sat_table = links_and_eff_sats[index]['eff_sat_table'] -%}
        {%- set eff_sat_end_date = links_and_eff_sats[index]['eff_sat_end_date'] -%}
        {{ eff_sat_table ~'.'~ eff_sat_end_date ~"='"~ maxdate ~"'" }}
        {{ 'AND' if not loop.last }}
    {% endfor -%}

{%- endmacro -%}