/*
 * Copyright (c) Business Thinking Ltd. 2019-2023
 * This software includes code developed by the AutomateDV (f.k.a dbtvault) Team at Business Thinking Ltd. Trading as Datavault
 */

{%- macro bridge(src_pk, src_extra_columns, as_of_dates_table, bridge_walk, stage_tables_ldts, src_ldts, source_model) -%}

    {%- if automate_dv.is_something(src_extra_columns) and execute -%}
      {%- do exceptions.warn("WARNING: src_extra_columns not yet available for PITs or Bridges. This parameter will be ignored.") -%}
    {%- endif -%}

    {{- automate_dv.check_required_parameters(src_pk=src_pk,
                                           as_of_dates_table=as_of_dates_table,
                                           bridge_walk=bridge_walk,
                                           stage_tables_ldts=stage_tables_ldts,
                                           src_ldts=src_ldts,
                                           source_model=source_model) -}}

    {{- automate_dv.prepend_generated_by() }}

    {% for stg in stage_tables_ldts %}
    {{- "-- depends_on: " ~ ref(stg) }}
    {% endfor %}

    {#- Acquiring the source relation for the AS_OF table -#}
    {%- if as_of_dates_table is mapping and as_of_dates_table is not none -%}
        {%- set source_name = as_of_dates_table | first -%}
        {%- set source_table_name = as_of_dates_table[source_name] -%}
        {%- set as_of_dates_table = source(source_name, source_table_name) -%}
    {%- elif as_of_dates_table is not mapping and as_of_dates_table is not none -%}
        {%- set as_of_dates_table = ref(as_of_dates_table) -%}
    {%- endif %}

    {{- adapter.dispatch('bridge', 'automate_dv')(src_pk=src_pk,
                                                  src_extra_columns=src_extra_columns,
                                                  src_ldts=src_ldts,
                                                  as_of_dates_table=as_of_dates_table,
                                                  bridge_walk=bridge_walk,
                                                  stage_tables_ldts=stage_tables_ldts,
                                                  source_model=source_model) -}}
{%- endmacro -%}

{%- macro default__bridge(src_pk, src_extra_columns, src_ldts, as_of_dates_table, bridge_walk, stage_tables_ldts, source_model) -%}

{%- set max_datetime = automate_dv.max_datetime() -%}

{#- Setting the new AS_OF dates CTE name -#}
{%- if automate_dv.is_any_incremental() -%}
    {%- set new_as_of_dates_cte = 'new_rows_as_of'  -%}
{%- else -%}
    {%- set new_as_of_dates_cte = 'as_of_dates' -%}
{%- endif %}

WITH as_of_dates AS (
    SELECT *
    FROM {{ as_of_dates_table }}
),

{%- if automate_dv.is_any_incremental() %}

{{ automate_dv.as_of_date_window(src_pk, src_ldts, stage_tables_ldts, ref(source_model)) }},

overlap AS (
    {{ automate_dv.bridge_overlap_and_new_rows(src_pk, bridge_walk, 'overlap_pks', 'overlap_as_of') }}
),
{%- endif %}

new_rows AS (
    {{ automate_dv.bridge_overlap_and_new_rows(src_pk, bridge_walk, ref(source_model), new_as_of_dates_cte) }}
),

{# Full data from bridge walk(s) -#}
all_rows AS (
    SELECT * FROM new_rows
    {%- if automate_dv.is_any_incremental() %}
    UNION ALL
    SELECT * FROM overlap
    {%- endif %}
),

{# Select most recent set of relationship key(s) for each as of date -#}
candidate_rows AS (
    SELECT *
    FROM (
        SELECT *,
               ROW_NUMBER() OVER (
               PARTITION BY
                   AS_OF_DATE,
                   {% for bridge_step in bridge_walk.keys() -%}

                       {%- set bridge_link_pk = bridge_walk[bridge_step]['bridge_link_pk'] -%}

                       {{ bridge_link_pk }} {%- if not loop.last %}, {% endif -%}

                   {%- endfor %}
               ORDER BY
                   {% for bridge_step in bridge_walk.keys() -%}

                       {%- set bridge_load_date = bridge_walk[bridge_step]['bridge_load_date'] -%}

                       {{ bridge_load_date }} DESC {%- if not loop.last %}, {% endif -%}

                   {%- endfor %}
               ) AS ROW_NUM
        FROM all_rows
    ) AS a
    WHERE a.ROW_NUM = 1
),

bridge AS (
    SELECT
        {{ automate_dv.prefix([src_pk], 'c') }},
        c.AS_OF_DATE,

        {% for bridge_step in bridge_walk.keys() %}

        {% set bridge_link_pk = bridge_walk[bridge_step]['bridge_link_pk'] %}
        c.{{ bridge_link_pk }}
        {%- if not loop.last %}, {%- endif -%}
        {%- endfor %}

    FROM candidate_rows AS c

{%- for bridge_step in bridge_walk.keys() -%}
    {%- set bridge_end_date = bridge_walk[bridge_step]['bridge_end_date'] %}

    {% if loop.first -%} WHERE {%- else -%} AND {%- endif %} {{ automate_dv.cast_date(automate_dv.prefix([bridge_end_date], 'c')) }} = {{ automate_dv.cast_date(max_datetime, true, false) }}

{% endfor -%}
)

SELECT * FROM bridge

{%- endmacro -%}
