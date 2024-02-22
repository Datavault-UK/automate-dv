/*
 * Copyright (c) Business Thinking Ltd. 2019-2023
 * This software includes code developed by the AutomateDV (f.k.a dbtvault) Team at Business Thinking Ltd. Trading as Datavault
 */

{%- macro get_period_boundaries(target_relation, timestamp_field, start_date, stop_date, period) -%}

    {% set macro = adapter.dispatch('get_period_boundaries',
                                    'automate_dv')(target_relation=target_relation,
                                                   timestamp_field=timestamp_field,
                                                   start_date=start_date,
                                                   stop_date=stop_date,
                                                   period=period) %}

    {% do return(macro) %}
{%- endmacro %}


{% macro default__get_period_boundaries(target_relation, timestamp_field, start_date, stop_date, period) -%}
    {%- set from_date_or_timestamp = "NULLIF('{}','none')::TIMESTAMP".format(stop_date | lower) -%}
    {%- set datepart = period -%}
    {% set period_boundary_sql -%}
        WITH period_data AS (
           SELECT
                COALESCE(MAX({{ timestamp_field }}), '{{ start_date }}')::TIMESTAMP AS start_timestamp,
                COALESCE({{ automate_dv.timestamp_add(datepart, interval, from_date_or_timestamp) }},
                         {{ current_timestamp() }} )::TIMESTAMP AS stop_timestamp
            FROM {{ target_relation }}
         )
        SELECT
            start_timestamp,
            stop_timestamp,
            {{ datediff('start_timestamp',
                                  'stop_timestamp',
                                  period) }} + 1 AS num_periods
        FROM period_data
    {%- endset %}

    {% set period_boundaries_dict = automate_dv.get_query_results_as_dict(period_boundary_sql) %}

    {% set period_boundaries = {'start_timestamp': period_boundaries_dict['START_TIMESTAMP'][0] | string,
                                'stop_timestamp': period_boundaries_dict['STOP_TIMESTAMP'][0] | string,
                                'num_periods': period_boundaries_dict['NUM_PERIODS'][0] | int} %}

    {% do return(period_boundaries) %}
{%- endmacro %}


{% macro bigquery__get_period_boundaries(target_relation, timestamp_field, start_date, stop_date, period) -%}

    {%- set from_date_or_timestamp = "NULLIF('{}','none')".format(stop_date | lower) -%}
    {%- set datepart = period -%}

    {% set period_boundary_sql -%}
        with data as (
            select
                COALESCE(
                    CAST(MAX({{ timestamp_field }}) AS TIMESTAMP),
                    CAST('{{ start_date }}' AS TIMESTAMP))
                as START_TIMESTAMP,
                COALESCE(
                    CAST({{ automate_dv.timestamp_add(datepart, interval, from_date_or_timestamp) }} AS TIMESTAMP),
                    CAST({{ current_timestamp() }} AS TIMESTAMP))
                as STOP_TIMESTAMP
            from {{ target_relation }}
        )
        select
            START_TIMESTAMP,
            STOP_TIMESTAMP,
            {{ datediff('start_timestamp', 'stop_timestamp', period) }} + 1 as NUM_PERIODS
        from data
    {%- endset %}


    {% set period_boundaries_dict = automate_dv.get_query_results_as_dict(period_boundary_sql) %}

    {% set period_boundaries = {'start_timestamp': period_boundaries_dict['START_TIMESTAMP'][0] | string,
                                'stop_timestamp': period_boundaries_dict['STOP_TIMESTAMP'][0] | string,
                                'num_periods': period_boundaries_dict['NUM_PERIODS'][0] | int} %}

    {% do return(period_boundaries) %}
{%- endmacro %}


{% macro sqlserver__get_period_boundaries(target_relation, timestamp_field, start_date, stop_date, period) -%}
    {%- if period is in ['microsecond', 'millisecond', 'second'] -%}
        {{ automate_dv.datepart_too_small_error(period=period) }}
    {%- endif -%}

    {#  MSSQL cannot CAST datetime2 strings with more than 7 decimal places #}
    {% set start_date = start_date[0:27] %}
    {% set stop_date = stop_date[0:27] %}
    {%- set datepart = period -%}
    {%- set from_date_or_timestamp = "CAST(NULLIF('{}','none') AS DATETIME2)".format(stop_date | lower) %}

    {% set period_boundary_sql -%}
        WITH period_data AS (
           SELECT
                CAST(COALESCE(MAX({{ timestamp_field }}), CAST('{{ start_date }}' AS DATETIME2)) AS DATETIME2) AS start_timestamp,
                CAST(COALESCE({{ automate_dv.timestamp_add(datepart, interval, from_date_or_timestamp) }},
                         {{ current_timestamp() }} ) AS DATETIME2) AS stop_timestamp
            FROM {{ target_relation }}
        )
        SELECT
            start_timestamp,
            stop_timestamp,
            {{ datediff('start_timestamp', 'stop_timestamp', period) }} + 1 AS num_periods
        FROM period_data
    {%- endset %}

    {% set period_boundaries_dict = automate_dv.get_query_results_as_dict(period_boundary_sql) %}

    {% set period_boundaries = {'start_timestamp': period_boundaries_dict['START_TIMESTAMP'][0] | string,
                                'stop_timestamp': period_boundaries_dict['STOP_TIMESTAMP'][0] | string,
                                'num_periods': period_boundaries_dict['NUM_PERIODS'][0] | int} %}

    {% do return(period_boundaries) %}
{%- endmacro %}


{% macro databricks__get_period_boundaries(target_relation, timestamp_field, start_date, stop_date, period) -%}

    {%- set from_date_or_timestamp = "NULLIF('{}','none')::TIMESTAMP".format(stop_date | lower) -%}
            {%- set datepart = period -%}
    {% set period_boundary_sql -%}

        WITH period_data AS (
            SELECT
                COALESCE(MAX({{ timestamp_field }}), CAST('{{ start_date }}' AS TIMESTAMP)) AS start_timestamp,
                COALESCE(
                {{ automate_dv.timestamp_add(datepart, interval, from_date_or_timestamp) }},
                         {{ current_timestamp() }}) AS stop_timestamp
            FROM {{ target_relation }}
        )
        SELECT
            IF(stop_timestamp < start_timestamp, stop_timestamp, start_timestamp) AS start_timestamp,
            stop_timestamp,
            {{ datediff('start_timestamp', 'stop_timestamp', period) }} + 1 AS num_periods

        FROM period_data
    {%- endset %}

    {% set period_boundaries_dict = automate_dv.get_query_results_as_dict(period_boundary_sql) %}

    {% set period_boundaries = {'start_timestamp': period_boundaries_dict['START_TIMESTAMP'][0] | string,
                                'stop_timestamp': period_boundaries_dict['STOP_TIMESTAMP'][0] | string,
                                'num_periods': period_boundaries_dict['NUM_PERIODS'][0] | int} %}

    {% do return(period_boundaries) %}
{%- endmacro %}


{% macro postgres__get_period_boundaries(target_relation, timestamp_field, start_date, stop_date, period) -%}

    {% set period_boundary_sql -%}
        WITH period_data AS (
            SELECT
                COALESCE(MAX({{ timestamp_field }}), '{{ start_date }}')::TIMESTAMP AS start_timestamp,
                COALESCE({{ automate_dv.timestamp_add('millisecond', 86399999, "NULLIF('" ~ stop_date | lower ~ "','none')::TIMESTAMP") }},
                         {{ current_timestamp() }} )::TIMESTAMP AS stop_timestamp
            FROM {{ target_relation }}
        )
        SELECT
            start_timestamp,
            stop_timestamp,
            {{ datediff('start_timestamp', 'stop_timestamp', period) }} + 1 AS num_periods
        FROM period_data
    {%- endset %}

    {% set period_boundaries_dict = automate_dv.get_query_results_as_dict(period_boundary_sql) %}

    {% set period_boundaries = {'start_timestamp': period_boundaries_dict['START_TIMESTAMP'][0] | string,
                                'stop_timestamp': period_boundaries_dict['STOP_TIMESTAMP'][0] | string,
                                'num_periods': period_boundaries_dict['NUM_PERIODS'][0] | int} %}

    {% do return(period_boundaries) %}
{%- endmacro %}