{%- macro bridge(src_pk, as_of_dates_table, bridge_walk, stage_tables_ldts, src_additional_columns, src_ldts, source_model) -%}

    {{- dbtvault.check_required_parameters(source_model=source_model, src_pk=src_pk,
                                           as_of_dates_table=as_of_dates_table,
                                           bridge_walk=bridge_walk,
                                           stage_tables_ldts=stage_tables_ldts,
                                           src_ldts=src_ldts) -}}

    {%- set src_pk = dbtvault.escape_column_names(src_pk) -%}
    {%- set src_additional_columns = dbtvault.escape_column_names(src_additional_columns) -%}
    {%- set src_ldts = dbtvault.escape_column_names(src_ldts) -%}

    {{ dbtvault.prepend_generated_by() }}

    {{ adapter.dispatch('bridge', 'dbtvault')(source_model=source_model, src_pk=src_pk,
                                              bridge_walk=bridge_walk,
                                              as_of_dates_table=as_of_dates_table,
                                              stage_tables_ldts=stage_tables_ldts,
                                              src_additional_columns=src_additional_columns,
                                              src_ldts=src_ldts) -}}
{%- endmacro -%}

{%- macro default__bridge(src_pk, as_of_dates_table, bridge_walk, stage_tables_ldts, src_additional_columns, src_ldts, source_model) -%}

{#- Acquiring the source relation for the AS_OF table -#}
{%- if as_of_dates_table is mapping and as_of_dates_table is not none -%}
    {%- set source_name = as_of_dates_table | first -%}
    {%- set source_table_name = as_of_dates_table[source_name] -%}
    {%- set source_relation = source(source_name, source_table_name) -%}
{%- elif as_of_dates_table is not mapping and as_of_dates_table is not none -%}
    {%- set source_relation = ref(as_of_dates_table) -%}
{%- endif -%}

{%- set max_datetime = dbtvault.max_datetime() -%}

{#- Stating the dependencies on the stage tables outside of the If STATEMENT -#}
{% for stg in stage_tables_ldts -%}
    {{- "-- depends_on: " ~ ref(stg) -}}
{%- endfor %}

{#- Setting the new AS_OF dates CTE name -#}
{%- if dbtvault.is_any_incremental() -%}
    {%- set new_as_of_dates_cte = 'new_rows_as_of'  -%}
{%- else -%}
    {%- set new_as_of_dates_cte = 'as_of' -%}
{%- endif %}

WITH as_of AS (
     SELECT a.AS_OF_DATE
     FROM {{ source_relation }} AS a
     WHERE a.AS_OF_DATE <= CURRENT_DATE()
),

{%- if dbtvault.is_any_incremental() %}

last_safe_load_datetime AS (
    SELECT MIN(LOAD_DATETIME) AS LAST_SAFE_LOAD_DATETIME
    FROM (
    {%- filter indent(width=8) -%}
    {%- for stg in stage_tables_ldts -%}
        {%- set stage_ldts = stage_tables_ldts[stg] -%}
        SELECT MIN({{ stage_ldts }}) AS LOAD_DATETIME FROM {{ ref(stg) }}
        {{ "UNION ALL" if not loop.last }}
    {% endfor -%}
    {%- endfilter -%}
    ) AS l
),

as_of_grain_old_entries AS (
    SELECT DISTINCT AS_OF_DATE
    FROM {{ this }}
),

as_of_grain_lost_entries AS (
    SELECT a.AS_OF_DATE
    FROM as_of_grain_old_entries AS a
    LEFT OUTER JOIN as_of AS b
        ON a.AS_OF_DATE = b.AS_OF_DATE
    WHERE b.AS_OF_DATE IS NULL
),

as_of_grain_new_entries AS (
    SELECT a.AS_OF_DATE
    FROM as_of AS a
    LEFT OUTER JOIN as_of_grain_old_entries AS b
        ON a.AS_OF_DATE = b.AS_OF_DATE
    WHERE b.AS_OF_DATE IS NULL
),

min_date AS (
    SELECT min(AS_OF_DATE) AS MIN_DATE
    FROM as_of
),

new_rows_pks AS (
    SELECT {{ dbtvault.prefix([src_pk], 'h') }}
    FROM {{ ref(source_model) }} AS h
    WHERE h.{{ src_ldts }} >= (SELECT LAST_SAFE_LOAD_DATETIME FROM last_safe_load_datetime)
),

new_rows_as_of AS (
    SELECT AS_OF_DATE
    FROM as_of
    WHERE as_of.AS_OF_DATE >= (SELECT LAST_SAFE_LOAD_DATETIME FROM last_safe_load_datetime)
    UNION
    SELECT as_of_date
    FROM as_of_grain_new_entries
),

overlap_pks AS (
    SELECT {{ dbtvault.prefix([src_pk, src_additional_columns], 'p') }}
    FROM {{ this }} AS p
    INNER JOIN {{ ref(source_model) }} as h
        ON {{ dbtvault.multikey(src_pk, prefix=['p','h'], condition='=') }}
    WHERE p.AS_OF_DATE >= (SELECT MIN_DATE FROM min_date)
        AND p.AS_OF_DATE < (SELECT LAST_SAFE_LOAD_DATETIME FROM last_safe_load_datetime)
        AND p.AS_OF_DATE NOT IN (SELECT AS_OF_DATE FROM as_of_grain_lost_entries)
),

overlap_as_of AS (
    SELECT AS_OF_DATE
    FROM as_of AS p
    WHERE p.AS_OF_DATE >= (SELECT MIN_DATE FROM min_date)
        AND p.AS_OF_DATE < (SELECT LAST_SAFE_LOAD_DATETIME FROM last_safe_load_datetime)
        AND p.AS_OF_DATE NOT IN (SELECT AS_OF_DATE FROM as_of_grain_lost_entries)
),

overlap AS (
    SELECT
        {{ dbtvault.prefix([src_pk], 'a') }},
        b.AS_OF_DATE,
        {%- for bridge_step in bridge_walk.keys() -%}
            {%- set link_table = dbtvault.escape_column_names(bridge_walk[bridge_step]['link_table']) -%}
            {%- set link_pk = dbtvault.escape_column_names(bridge_walk[bridge_step]['link_pk']) -%}
            {%- set bridge_link_pk = dbtvault.escape_column_names(bridge_walk[bridge_step]['bridge_link_pk']) -%}
            {%- set eff_sat_table = dbtvault.escape_column_names(bridge_walk[bridge_step]['eff_sat_table']) -%}
            {%- set bridge_end_date = dbtvault.escape_column_names(bridge_walk[bridge_step]['bridge_end_date']) -%}
            {%- set bridge_load_date = dbtvault.escape_column_names(bridge_walk[bridge_step]['bridge_load_date']) -%}
            {%- set eff_sat_end_date = dbtvault.escape_column_names(bridge_walk[bridge_step]['eff_sat_end_date']) -%}
            {%- set eff_sat_load_date = dbtvault.escape_column_names(bridge_walk[bridge_step]['eff_sat_load_date']) -%}
            {%- filter indent(width=8) %}
            {{ link_table }}.{{ link_pk }} AS {{ bridge_link_pk }},
            {{ eff_sat_table }}.{{ eff_sat_end_date }} AS {{ bridge_end_date }},
            {{ eff_sat_table }}.{{ eff_sat_load_date }} AS {{ bridge_load_date }}
            {%- endfilter -%}
        {%- endfor -%}
        {%- if dbtvault.is_something(src_additional_columns) %}
        ,
        {{- dbtvault.prefix([src_additional_columns], 'a') }}
        {% endif %}
    FROM overlap_pks AS a
    INNER JOIN overlap_as_of AS b
        ON (1=1)
    {%- set loop_vars = namespace(lastlink = '', last_link_fk = '') -%}
    {%- for bridge_step in bridge_walk.keys() -%}
        {%- set current_link = bridge_walk[bridge_step]['link_table'] -%}
        {%- set current_eff_sat = bridge_walk[bridge_step]['eff_sat_table'] -%}
        {%- set link_pk = dbtvault.escape_column_names(bridge_walk[bridge_step]['link_pk']) -%}
        {%- set link_fk1 = dbtvault.escape_column_names(bridge_walk[bridge_step]['link_fk1']) -%}
        {%- set link_fk2 = dbtvault.escape_column_names(bridge_walk[bridge_step]['link_fk2']) -%}
        {%- set eff_sat_pk = dbtvault.escape_column_names(bridge_walk[bridge_step]['eff_sat_pk']) -%}
        {%- set eff_sat_load_date = dbtvault.escape_column_names(bridge_walk[bridge_step]['eff_sat_load_date']) -%}
    {%- if loop.first %}
    LEFT JOIN {{ ref(current_link) }} AS cur_link
        ON {{ dbtvault.multikey(src_pk, prefix=['a', 'cur_link'], condition='=') }}
        {%- else %}
    LEFT JOIN {{ ref(current_link) }} AS cur_link
        ON {{ loop_vars.last_link }}.{{ loop_vars.last_link_fk2 }} = cur_link.{{ link_fk1 }}
        {%- endif %}
    INNER JOIN {{ ref(current_eff_sat) }} AS cur_eff_sat
        ON cur_eff_sat.{{ eff_sat_pk }} = cur_link.{{ link_pk }}
        AND cur_eff_sat.{{ eff_sat_load_date }} <= b.AS_OF_DATE
        {%- set loop_vars.last_link = current_link -%}
        {%- set loop_vars.last_link_fk2 = link_fk2 -%}
    {% endfor %}
),
{%- endif %}

new_rows AS (
    SELECT
        {{ dbtvault.prefix([src_pk], 'a') }},
        b.AS_OF_DATE,
        {%- for bridge_step in bridge_walk.keys() -%}
            {%- set link_table = dbtvault.escape_column_names(bridge_walk[bridge_step]['link_table']) -%}
            {%- set link_pk = dbtvault.escape_column_names(bridge_walk[bridge_step]['link_pk']) -%}
            {%- set bridge_link_pk = dbtvault.escape_column_names(bridge_walk[bridge_step]['bridge_link_pk']) -%}
            {%- set eff_sat_table = dbtvault.escape_column_names(bridge_walk[bridge_step]['eff_sat_table']) -%}
            {%- set bridge_end_date = dbtvault.escape_column_names(bridge_walk[bridge_step]['bridge_end_date']) -%}
            {%- set bridge_load_date = dbtvault.escape_column_names(bridge_walk[bridge_step]['bridge_load_date']) -%}
            {%- set eff_sat_end_date = dbtvault.escape_column_names(bridge_walk[bridge_step]['eff_sat_end_date']) -%}
            {%- set eff_sat_load_date = dbtvault.escape_column_names(bridge_walk[bridge_step]['eff_sat_load_date']) %}

            {{- '\n       ' }} cur_link.{{ link_pk }} AS {{ bridge_link_pk }},
            {{- '\n       ' }} cur_eff_sat.{{ eff_sat_end_date }} AS {{ bridge_end_date }},
            {{- '\n       ' }} cur_eff_sat.{{ eff_sat_load_date }} AS {{ bridge_load_date }}

        {%- endfor -%}

        {%- if dbtvault.is_something(src_additional_columns) -%}
            ,
            {{- '\n       ' }} {{ dbtvault.prefix([src_additional_columns], 'a') }}
        {%- endif %}

    FROM {{ ref(source_model) }} AS a
    INNER JOIN {{ new_as_of_dates_cte }} AS b
        ON (1=1)
    {%- set loop_vars = namespace(lastlink = '', last_link_fk = '') %}

    {%- for bridge_step in bridge_walk.keys() -%}

        {%- set current_link = bridge_walk[bridge_step]['link_table'] -%}
        {%- set current_eff_sat = bridge_walk[bridge_step]['eff_sat_table'] -%}
        {%- set link_pk = dbtvault.escape_column_names(bridge_walk[bridge_step]['link_pk']) -%}
        {%- set link_fk1 = dbtvault.escape_column_names(bridge_walk[bridge_step]['link_fk1']) -%}
        {%- set link_fk2 = dbtvault.escape_column_names(bridge_walk[bridge_step]['link_fk2']) -%}
        {%- set eff_sat_pk = dbtvault.escape_column_names(bridge_walk[bridge_step]['eff_sat_pk']) -%}
        {%- set eff_sat_load_date = dbtvault.escape_column_names(bridge_walk[bridge_step]['eff_sat_load_date']) -%}

        {%- if loop.first %}
        LEFT JOIN {{ ref(current_link) }} AS cur_link
            ON a.{{ src_pk }} = cur_link.{{ link_fk1 }}
        {%- else %}
        LEFT JOIN {{ ref(current_link) }} AS cur_link
            ON {{ loop_vars.last_link }}.{{ loop_vars.last_link_fk2 }} = cur_link.{{ link_fk1 }}
        {%- endif %}

        INNER JOIN {{ ref(current_eff_sat) }} AS cur_eff_sat
            ON cur_eff_sat.{{ eff_sat_pk }} = cur_link.{{ link_pk }}
            AND cur_eff_sat.{{ eff_sat_load_date }} <= b.AS_OF_DATE
            {%- set loop_vars.last_link = cur_link -%}
            {%- set loop_vars.last_link_fk2 = link_fk2 -%}

    {% endfor %}
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

        {%- endfor -%}

        {%- if dbtvault.is_something(src_additional_columns) -%}
            ,
            {{- '\n       ' }} {{ dbtvault.prefix([src_additional_columns], 'c') }}
        {%- endif %}

    FROM candidate_rows AS c
        {%- for bridge_step in bridge_walk.keys() -%}
            {%- set bridge_end_date = dbtvault.escape_column_names(bridge_walk[bridge_step]['bridge_end_date']) -%}
            {%- if loop.first %}
    WHERE TO_DATE({{ 'c.' ~ bridge_end_date }}) = TO_DATE('{{ max_datetime }}')
            {%- else %}
        AND TO_DATE({{ 'c.' ~ bridge_end_date }}) = TO_DATE('{{ max_datetime }}')
            {%- endif -%}
        {%- endfor %}
)

SELECT * FROM bridge

{%- endmacro -%}
