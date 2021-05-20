{%- macro bridge1(src_pk, as_of_dates_table, bridge_walk, source_model) -%}

    {{- adapter.dispatch('bridge', packages = dbtvault.get_dbtvault_namespaces())(source_model=source_model, src_pk=src_pk,
                                                                                  bridge_walk=bridge_walk,
                                                                                  as_of_dates_table=as_of_dates_table) -}}
{%- endmacro -%}

{%- macro default__bridge1(src_pk, as_of_dates_table, bridge_walk, source_model) -%}

{{ dbtvault.prepend_generated_by() }}

{%- if (as_of_dates_table is none) and execute -%}
    {%- set error_message -%}
    "bridge error: Missing as_of_dates table configuration. A as_of_dates_table must be provided."
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

{%- set maxdate = '9999-12-31 23:59:59.999' -%}
{%- set ghost_pk = '0000000000000000' -%}
{%- set ghost_date = '1990-01-01 00:00:00.000' %}

WITH AS_OF_DATES_FOR_BRIDGE AS (
     SELECT a.AS_OF_DATE
     FROM {{ source_relation }} AS a
     WHERE a.AS_OF_DATE <= CURRENT_DATE()
     {%- if load_relation(this) -%}
     AND
         a.AS_OF_DATE >
         (
         CASE
             WHEN (SELECT MAX(AS_OF_DATE) FROM {{ this }}) IS NULL
                 THEN {{ 'CAST('"'"~ ghost_date ~"'"' AS TIMESTAMP_NTZ)' }}
             ELSE
                 (SELECT MAX(AS_OF_DATE) FROM {{ this }})
         END
         )
     {%- endif %}
),

BRIDGE_WALK AS (
    SELECT
        a.{{ src_pk }}
        ,b.AS_OF_DATE
        {%- for bridge_step in bridge_walk.keys() -%}
            {% set link_table = bridge_walk[bridge_step]['link_table'] -%}
            {% set bridge_link_pk_col = bridge_walk[bridge_step]['bridge_link_pk_col'] -%}
            {% set link_pk = bridge_walk[bridge_step]['link_pk'] -%}
            {% set eff_sat_table = bridge_walk[bridge_step]['eff_sat_table'] -%}
            {% set bridge_end_date_col = bridge_walk[bridge_step]['bridge_end_date_col'] -%}
            {% set eff_sat_end_date = bridge_walk[bridge_step]['eff_sat_end_date'] -%}
            {%- filter indent(width=8) -%}
            {{- "\n" -}}
            {{ ',COALESCE(MAX('~ link_table ~'.'~ link_pk ~'), CAST('"'"~ ghost_pk ~"'"' AS BINARY(16))) AS '~ bridge_link_pk_col }}
            {{- "\n" -}}
            {{ ',COALESCE(MAX('~ eff_sat_table ~'.'~ eff_sat_end_date ~'), CAST('"'"~ maxdate ~"'"' AS TIMESTAMP_NTZ)) AS '~ bridge_end_date_col }}
            {%- endfilter -%}
        {% endfor %}
    FROM {{ ref(source_model) }} AS a
    INNER JOIN AS_OF_DATES_FOR_BRIDGE AS b
        ON (1=1)
    {%- set loop_vars = namespace(lastlink = '', last_link_fk = '') %}
    {%- for bridge_step in bridge_walk.keys() -%}
        {%- set current_link = bridge_walk[bridge_step]['link_table'] -%}
        {%- set current_eff_sat = bridge_walk[bridge_step]['eff_sat_table'] -%}
        {%- set link_pk = bridge_walk[bridge_step]['link_pk'] -%}
        {%- set link_fk1 = bridge_walk[bridge_step]['link_fk1'] -%}
        {%- set link_fk2 = bridge_walk[bridge_step]['link_fk2'] -%}
        {%- set eff_sat_pk = bridge_walk[bridge_step]['eff_sat_pk'] -%}
        {%- set eff_sat_end_date = bridge_walk[bridge_step]['eff_sat_end_date'] -%}
        {%- set eff_sat_ldts = bridge_walk[bridge_step]['eff_sat_ldts'] -%}
        {%- if loop.first  %}
    LEFT JOIN {{ ref(current_link) }} AS {{ current_link }}
        ON a.{{ src_pk }} = {{ current_link }}.{{ link_fk1 }}
        {%- else %}
    LEFT JOIN {{ ref(current_link) }} AS {{ current_link }}
        ON {{ loop_vars.last_link }}.{{ loop_vars.last_link_fk2 }} = {{ current_link }}.{{ link_fk1 }}
        {%- endif %}
    INNER JOIN {{ ref(current_eff_sat) }} AS {{ current_eff_sat }}
        ON {{ current_eff_sat }}.{{ eff_sat_pk }} = {{ current_link }}.{{ link_pk }}
        AND {{ current_eff_sat }}.{{ eff_sat_ldts }} <= b.AS_OF_DATE
        {%- set loop_vars.last_link = current_link -%}
        {%- set loop_vars.last_link_fk2 = link_fk2 -%}
    {% endfor %}
    GROUP BY b.AS_OF_DATE
            ,a.{{ src_pk }}
            {% for bridge_step in bridge_walk.keys() %}
                {%- set current_link = bridge_walk[bridge_step]['link_table'] -%}
                {%- set link_pk = bridge_walk[bridge_step]['link_pk'] -%}
                {%- filter indent(width=12) -%}
                {{ ','~ current_link ~'.'~ link_pk -}}
                {%- endfilter %}
            {% endfor %}
    ORDER BY 1,2
)

SELECT * FROM BRIDGE_WALK
    {%- for bridge_step in bridge_walk.keys() -%}
        {%- set bridge_end_date_col = bridge_walk[bridge_step]['bridge_end_date_col'] -%}
        {%- if loop.first %}
WHERE {{ bridge_end_date_col ~" = '"~ maxdate ~"'" }}
        {%- else %}
    AND {{ bridge_end_date_col ~" = '"~ maxdate ~"'" }}
        {%- endif -%}
    {% endfor -%}

{%- endmacro -%}