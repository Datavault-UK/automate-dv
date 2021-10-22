{# Copied from the dbtvault feat/bigquery branch #}
{% macro bigquery__replace_placeholder_with_period_filter(core_sql, timestamp_field, start_timestamp, stop_timestamp, offset, period) %}

    {%- set period_filter -%}
            (DATE({{ timestamp_field }}) >= DATE_TRUNC(DATE_ADD( DATE('{{ start_timestamp }}'), INTERVAL {{ offset }} {{ period }}), {{ period }} ) AND
             DATE({{ timestamp_field }}) < DATE_TRUNC(DATE_ADD(DATE_ADD( DATE('{{ start_timestamp }}'), INTERVAL {{ offset }} {{ period }}), INTERVAL 1 {{ period }}), {{ period }} )
      AND DATE({{ timestamp_field }}) >= DATE('{{ start_timestamp }}'))
    {%- endset -%}

    {%- set filtered_sql = core_sql | replace("__PERIOD_FILTER__", period_filter) -%}

    {% do return(filtered_sql) %}
{% endmacro %}

{# Copied from the dbtvault feat/bigquery branch #}
{% macro bigquery__get_period_boundaries(target_schema, target_table, timestamp_field, start_date, stop_date, period) -%}

    {% set period_boundary_sql -%}
        with data as (
            select
                coalesce(CAST(max({{ timestamp_field }}) AS DATETIME), CAST('{{ start_date }}' AS DATETIME)) as START_TIMESTAMP,
                coalesce({{ dbt_utils.dateadd('millisecond', 86399999, "nullif('" ~ stop_date | lower ~ "','none')") }},
                         CAST(CURRENT_TIMESTAMP() AS DATETIME) ) as STOP_TIMESTAMP
            from {{ target_schema }}.{{ target_table }}
        )
        select
            START_TIMESTAMP,
            STOP_TIMESTAMP,
            {{ dbt_utils.datediff('start_timestamp',
                                  'stop_timestamp',
                                  period) }} + 1 as NUM_PERIODS
        from data
    {%- endset %}


    {% set period_boundaries_dict = dbt_utils.get_query_results_as_dict(period_boundary_sql) %}

    {% set period_boundaries = {'start_timestamp': period_boundaries_dict['START_TIMESTAMP'][0] | string,
                                'stop_timestamp': period_boundaries_dict['STOP_TIMESTAMP'][0] | string,
                                'num_periods': period_boundaries_dict['NUM_PERIODS'][0] | int} %}

    {% do return(period_boundaries) %}
{%- endmacro %}

{# Copied from the dbtvault feat/bigquery branch #}
{%- macro bigquery__get_period_of_load(period, offset, start_timestamp) -%}
    {% set period_of_load_sql -%}
        SELECT DATE_TRUNC(DATE_ADD( DATE('{{start_timestamp}}'), INTERVAL {{ offset }} {{ period }}), {{ period }}  ) AS PERIOD_OF_LOAD
    {%- endset %}

    {% set period_of_load_dict = dbt_utils.get_query_results_as_dict(period_of_load_sql) %}

    {% set period_of_load = period_of_load_dict['PERIOD_OF_LOAD'][0] | string %}

    {% do return(period_of_load) %}
{%- endmacro -%}