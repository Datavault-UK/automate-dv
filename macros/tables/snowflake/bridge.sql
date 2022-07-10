{%- macro bridge(src_pk, src_additional_columns, as_of_dates_table, bridge_walk, stage_tables_ldts, src_ldts, source_model) -%}

    {{- dbtvault.check_required_parameters(src_pk=src_pk,
                                           src_ldts=src_ldts,
                                           as_of_dates_table=as_of_dates_table,
                                           bridge_walk=bridge_walk,
                                           stage_tables_ldts=stage_tables_ldts,
                                           source_model=source_model) -}}

    {%- set src_pk = dbtvault.escape_column_names(src_pk) -%}
    {%- set src_additional_columns = dbtvault.escape_column_names(src_additional_columns) -%}
    {%- set src_ldts = dbtvault.escape_column_names(src_ldts) -%}

    {{- dbtvault.prepend_generated_by() }}

    {{ adapter.dispatch('bridge', 'dbtvault')(src_pk=src_pk,
                                              src_additional_columns=src_additional_columns,
                                              src_ldts=src_ldts,
                                              as_of_dates_table=as_of_dates_table,
                                              bridge_walk=bridge_walk,
                                              stage_tables_ldts=stage_tables_ldts,
                                              source_model=source_model) -}}
{%- endmacro -%}

{%- macro default__bridge(src_pk, src_additional_columns, src_ldts, as_of_dates_table, bridge_walk, stage_tables_ldts, source_model) -%}

{#- Acquiring the source relation for the AS_OF table -#}
{%- if as_of_dates_table is mapping and as_of_dates_table is not none -%}
    {%- set source_name = as_of_dates_table | first -%}
    {%- set source_table_name = as_of_dates_table[source_name] -%}
    {%- set source_relation = source(source_name, source_table_name) -%}
{%- elif as_of_dates_table is not mapping and as_of_dates_table is not none -%}
    {%- set source_relation = ref(as_of_dates_table) -%}
{%- endif -%}

{%- set max_datetime = dbtvault.max_datetime() -%}

{%- for stg in stage_tables_ldts -%}
    {{- "-- depends_on: " ~ ref(stg) }}
{% endfor %}

{#- Setting the new AS_OF dates CTE name -#}
{%- if dbtvault.is_any_incremental() -%}
    {%- set new_as_of_dates_cte = 'new_rows_as_of'  -%}
{%- else -%}
    {%- set new_as_of_dates_cte = 'as_of' -%}
{%- endif %}

WITH as_of_dates AS (
    SELECT * FROM {{ as_of_table_relation }}
),

{%- if dbtvault.is_any_incremental() %}

{{ dbtvault.as_of_date_window(stage_tables_ldts, this) }},

overlap_as_of AS (
    SELECT AS_OF_DATE
    FROM as_of AS p
    WHERE p.AS_OF_DATE >= (SELECT MIN_DATE FROM min_date)
        AND p.AS_OF_DATE < (SELECT LAST_SAFE_LOAD_DATETIME FROM last_safe_load_datetime)
        AND p.AS_OF_DATE NOT IN (SELECT AS_OF_DATE FROM as_of_grain_lost_entries)
),

overlap AS (
    {{ dbtvault.bridge_overlap_and_new_rows(src_pk, src_additional_columns, bridge_walk, 'overlap_pks', 'overlap_as_of') }}
),
{%- endif %}

new_rows AS (
    {{ dbtvault.bridge_overlap_and_new_rows(src_pk, src_additional_columns, bridge_walk, ref(source_model), new_as_of_dates_cte) }}
),

{# Full data from bridge walk(s) -#}
all_rows AS (
    SELECT * FROM new_rows
    {%- if dbtvault.is_any_incremental() %}
    UNION ALL
    SELECT * FROM overlap
    {%- endif %}
),

{# Select most recent set of relationship key(s) for each as of date -#}
candidate_rows AS (
    SELECT *,
        ROW_NUMBER() OVER (
            PARTITION BY
                AS_OF_DATE,
                {% for bridge_step in bridge_walk.keys() -%}

                    {%- set bridge_link_pk = dbtvault.escape_column_names(bridge_walk[bridge_step]['bridge_link_pk']) -%}

                    {{ bridge_link_pk }} {%- if not loop.last %}, {% endif -%}

                {%- endfor %}
            ORDER BY
                {% for bridge_step in bridge_walk.keys() -%}

                    {%- set bridge_load_date = dbtvault.escape_column_names(bridge_walk[bridge_step]['bridge_load_date']) -%}

                    {{ bridge_load_date }} DESC {%- if not loop.last %}, {% endif -%}

                {%- endfor %}
        ) AS row_num
    FROM all_rows
    QUALIFY row_num = 1
),

bridge AS (
    SELECT
        {{ dbtvault.prefix([src_pk], 'c') }},
        c.AS_OF_DATE,

        {%- for bridge_step in bridge_walk.keys() -%}

        {% set bridge_link_pk = dbtvault.escape_column_names(bridge_walk[bridge_step]['bridge_link_pk']) %}
        c.{{ bridge_link_pk }}

        {%- if not loop.last %}, {%- endif -%}

        {%- endfor -%}

        {%- if dbtvault.is_something(src_additional_columns) -%}
            ,
            {{- '\n       ' }} {{ dbtvault.prefix([src_additional_columns], 'c') }}
        {%- endif %}

    FROM candidate_rows AS c

{%- for bridge_step in bridge_walk.keys() -%}
    {%- set bridge_end_date = dbtvault.escape_column_names(bridge_walk[bridge_step]['bridge_end_date']) %}

    {% if loop.first -%} WHERE {%- else -%} AND {%- endif %} TO_DATE(c.{{ bridge_end_date }}) = TO_DATE('{{ max_datetime }}')

{% endfor -%}
)

SELECT * FROM bridge

{%- endmacro -%}

{%- macro bridge_overlap_and_new_rows(src_pk, src_additional_columns, bridge_walk, source_name, new_as_of_dates_cte) -%}

SELECT
    {{ dbtvault.prefix([src_pk], 'a') }},
    b.AS_OF_DATE,
    {%- for bridge_step in bridge_walk.keys() -%}
        {%- set link_table = bridge_walk[bridge_step]['link_table'] -%}
        {%- set eff_sat_table = bridge_walk[bridge_step]['eff_sat_table'] -%}

        {%- set link_pk = dbtvault.escape_column_names(bridge_walk[bridge_step]['link_pk']) -%}

        {%- set bridge_link_pk = dbtvault.escape_column_names(bridge_walk[bridge_step]['bridge_link_pk']) -%}
        {%- set bridge_end_date = dbtvault.escape_column_names(bridge_walk[bridge_step]['bridge_end_date']) -%}
        {%- set bridge_load_date = dbtvault.escape_column_names(bridge_walk[bridge_step]['bridge_load_date']) -%}

        {%- set eff_sat_end_date = dbtvault.escape_column_names(bridge_walk[bridge_step]['eff_sat_end_date']) -%}
        {%- set eff_sat_load_date = dbtvault.escape_column_names(bridge_walk[bridge_step]['eff_sat_load_date']) %}

        {{- '\n       ' }} {{ link_table | lower }}.{{ link_pk }} AS {{ bridge_link_pk }},
        {{- '\n       ' }} {{ eff_sat_table | lower }}.{{ eff_sat_end_date }} AS {{ bridge_end_date }},
        {{- '\n       ' }} {{ eff_sat_table | lower }}.{{ eff_sat_load_date }} AS {{ bridge_load_date }}

        {%- if not loop.last %}, {%- endif -%}

    {% endfor -%}

    {%- if dbtvault.is_something(src_additional_columns) -%}
        ,
        {{- '\n       ' }} {{ dbtvault.prefix([src_additional_columns], 'a') }}
    {%- endif %}

    FROM {{ source_name }} AS a
    INNER JOIN {{ new_as_of_dates_cte }} AS b
        ON (1=1)

    {%- set loop_vars = namespace(last_link = '', last_link_fk = '') %}
    {%- for bridge_step in bridge_walk.keys() -%}

        {%- set current_link = bridge_walk[bridge_step]['link_table'] -%}
        {%- set current_eff_sat = bridge_walk[bridge_step]['eff_sat_table'] -%}

        {%- set link_pk = dbtvault.escape_column_names(bridge_walk[bridge_step]['link_pk']) -%}
        {%- set link_fk1 = dbtvault.escape_column_names(bridge_walk[bridge_step]['link_fk1']) -%}
        {%- set link_fk2 = dbtvault.escape_column_names(bridge_walk[bridge_step]['link_fk2']) -%}

        {%- set eff_sat_pk = dbtvault.escape_column_names(bridge_walk[bridge_step]['eff_sat_pk']) -%}
        {%- set eff_sat_load_date = dbtvault.escape_column_names(bridge_walk[bridge_step]['eff_sat_load_date']) -%}

    {%- if loop.first %}
    LEFT JOIN {{ ref(current_link) }} AS {{ current_link | lower }}
        ON {{ dbtvault.multikey(src_pk, prefix=['a', current_link | lower], condition='=') }}
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
