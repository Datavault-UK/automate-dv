/*
 * Copyright (c) Business Thinking Ltd. 2019-2023
 * This software includes code developed by the AutomateDV (f.k.a dbtvault) Team at Business Thinking Ltd. Trading as Datavault
 */

{%- macro bridge_overlap_and_new_rows(src_pk, bridge_walk, source_model, new_as_of_dates_cte) -%}

SELECT
    {{ automate_dv.prefix([src_pk], 'a') }},
    b.AS_OF_DATE,
    {%- for bridge_step in bridge_walk.keys() -%}
        {%- set link_table = bridge_walk[bridge_step]['link_table'] -%}
        {%- set eff_sat_table = bridge_walk[bridge_step]['eff_sat_table'] -%}

        {%- set link_pk = bridge_walk[bridge_step]['link_pk'] -%}

        {%- set bridge_link_pk = bridge_walk[bridge_step]['bridge_link_pk'] -%}
        {%- set bridge_end_date = bridge_walk[bridge_step]['bridge_end_date'] -%}
        {%- set bridge_load_date = bridge_walk[bridge_step]['bridge_load_date'] -%}

        {%- set eff_sat_end_date = bridge_walk[bridge_step]['eff_sat_end_date'] -%}
        {%- set eff_sat_load_date = bridge_walk[bridge_step]['eff_sat_load_date'] %}

        {{- '\n   ' }} {{ link_table | lower }}.{{ link_pk }} AS {{ bridge_link_pk }},
        {{- '\n   ' }} {{ eff_sat_table | lower }}.{{ eff_sat_end_date }} AS {{ bridge_end_date }},
        {{- '\n   ' }} {{ eff_sat_table | lower }}.{{ eff_sat_load_date }} AS {{ bridge_load_date }}

        {%- if not loop.last %}, {%- endif -%}

    {% endfor %}

    FROM {{ source_model }} AS a
    INNER JOIN {{ new_as_of_dates_cte }} AS b
        ON (1=1)

    {%- set loop_vars = namespace(last_link = '', last_link_fk = '') %}
    {%- for bridge_step in bridge_walk.keys() -%}

        {%- set current_link = bridge_walk[bridge_step]['link_table'] -%}
        {%- set current_eff_sat = bridge_walk[bridge_step]['eff_sat_table'] -%}

        {%- set link_pk = bridge_walk[bridge_step]['link_pk'] -%}
        {%- set link_fk1 = bridge_walk[bridge_step]['link_fk1'] -%}
        {%- set link_fk2 = bridge_walk[bridge_step]['link_fk2'] -%}

        {%- set eff_sat_pk = bridge_walk[bridge_step]['eff_sat_pk'] -%}
        {%- set eff_sat_load_date = bridge_walk[bridge_step]['eff_sat_load_date'] -%}

    {%- if loop.first %}
    LEFT JOIN {{ ref(current_link) }} AS {{ current_link | lower }}
        ON {{ automate_dv.multikey(src_pk, prefix=['a', current_link | lower], condition='=') }}
    {%- else %}
    LEFT JOIN {{ ref(current_link) }} AS {{ current_link | lower }}
        ON {{ loop_vars.last_link }}.{{ loop_vars.last_link_fk2 }} = {{ current_link | lower }}.{{ link_fk1 }}
    {%- endif %}
    INNER JOIN {{ ref(current_eff_sat) }} AS {{ current_eff_sat | lower }}
        ON {{ current_eff_sat | lower }}.{{ eff_sat_pk }} = {{ current_link | lower }}.{{ link_pk }}
        AND {{ current_eff_sat | lower }}.{{ eff_sat_load_date }} <= b.AS_OF_DATE
        {%- set loop_vars.last_link = current_link | lower -%}
        {%- set loop_vars.last_link_fk2 = link_fk2 -%}
    {% endfor %}

{%- endmacro -%}
