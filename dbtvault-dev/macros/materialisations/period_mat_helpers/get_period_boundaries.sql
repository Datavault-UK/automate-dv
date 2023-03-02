/*
 * Copyright (c) Business Thinking Ltd. 2019-2023
 * This software includes code developed by the dbtvault Team at Business Thinking Ltd. Trading as Datavault
 */

{%- macro get_period_boundaries(target_relation, timestamp_field, start_date, stop_date, period, timestamp_field_type='DATE') -%}

    {% set macro = adapter.dispatch('get_period_boundaries',
                                    'dbtvault')(target_relation=target_relation,
                                                timestamp_field=timestamp_field,
                                                start_date=start_date,
                                                stop_date=stop_date,
                                                period=period,
                                                timestamp_field_type=timestamp_field_type) %}

    {% do return(macro) %}
{%- endmacro %}



{% macro default__get_period_boundaries(target_relation, timestamp_field, start_date, stop_date, period, timestamp_field_type) -%}
    {%- set from_date_or_timestamp = "NULLIF('{}','none')::TIMESTAMP".format(stop_date | lower) -%}
    {%- do log('stop: ' ~ stop_date, info=true) -%}
    {%- do log('type: ' ~ timestamp_field_type, info=true) -%}
    {%- do log('relation: ' ~ target_relation, info=true) -%}
    {%- do log('start: ' ~ start_date, info=true) -%}
    {%- do log('from date: ' ~ from_date_or_timestamp, info=true) -%}
    {% set period_boundary_sql -%}
        WITH period_data AS (
            SELECT
                COALESCE(MAX({{ timestamp_field }}), '{{ start_date }}')::TIMESTAMP AS start_timestamp,
                COALESCE(
                {%- if timestamp_field_type == 'DATE' -%}
                {{ dbtvault.dateadd('millisecond', 86399999, from_date_or_timestamp) }},
                {%- else -%}
                {{ timestamp_field_type}}ADD('hour', 1, TO_{{ timestamp_field_type}}({{ from_date_or_timestamp }})),
                {%- endif -%}
                         {{ current_timestamp() }} ) AS stop_timestamp
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

    {% set period_boundaries_dict = dbtvault.get_query_results_as_dict(period_boundary_sql) %}

    {% set period_boundaries = {'start_timestamp': period_boundaries_dict['START_TIMESTAMP'][0] | string,
                                'stop_timestamp': period_boundaries_dict['STOP_TIMESTAMP'][0] | string,
                                'num_periods': period_boundaries_dict['NUM_PERIODS'][0] | int} %}

    {% do return(period_boundaries) %}
{%- endmacro %}


{% macro bigquery__get_period_boundaries(target_relation, timestamp_field, start_date, stop_date, period, timestamp_field_type) -%}
    {%- set from_date_or_timestamp = "NULLIF('{}','none')".format(stop_date | lower) -%}
    {% set period_boundary_sql -%}
        with data as (
            select
                COALESCE(
                    CAST(MAX({{ timestamp_field }}) AS {{ timestamp_field_type }}),
                    CAST('{{ start_date }}' AS {{ timestamp_field_type }}))
                as START_TIMESTAMP,
                COALESCE(
                    {%- if timestamp_field_type == 'DATE' -%}
                    {{ dbtvault.dateadd('millisecond', 86399999, from_date_or_timestamp) }},
                    {%- else -%}
                    {{ timestamp_field_type }}_ADD(CAST({{ from_date_or_timestamp}} AS {{ timestamp_field_type }}), INTERVAL 1 HOUR),
                    {% endif %}
                    CAST({{ current_timestamp() }} AS {{ timestamp_field_type }}))
                as STOP_TIMESTAMP
            from {{ target_relation }}
        )
        select
            START_TIMESTAMP,
            STOP_TIMESTAMP,
            {{ datediff('start_timestamp', 'stop_timestamp', period) }} + 1 as NUM_PERIODS
        from data
    {%- endset %}


    {% set period_boundaries_dict = dbtvault.get_query_results_as_dict(period_boundary_sql) %}

    {% set period_boundaries = {'start_timestamp': period_boundaries_dict['START_TIMESTAMP'][0] | string,
                                'stop_timestamp': period_boundaries_dict['STOP_TIMESTAMP'][0] | string,
                                'num_periods': period_boundaries_dict['NUM_PERIODS'][0] | int} %}

    {% do return(period_boundaries) %}
{%- endmacro %}




{% macro sqlserver__get_period_boundaries(target_relation, timestamp_field, start_date, stop_date, period) -%}

    {#  MSSQL cannot CAST datetime2 strings with more than 7 decimal places #}
    {% set start_date = start_date[0:27] %}
    {% set stop_date = stop_date[0:27] %}
    {%- set from_date_or_timestamp = "CAST(NULLIF('{}','none') AS DATETIME2)".format(stop_date | lower) %}

    {% set period_boundary_sql -%}
        WITH period_data AS (
            SELECT
                CAST(COALESCE(MAX({{ timestamp_field }}), CAST('{{ start_date }}' AS DATETIME2)) AS DATETIME2) AS start_timestamp,
                CAST(COALESCE({{ dbtvault.dateadd('millisecond', 86399999, from_date_or_timestamp) }},
                         {{ current_timestamp() }} ) AS DATETIME2) AS stop_timestamp
            FROM {{ target_relation }}
        )
        SELECT
            start_timestamp,
            stop_timestamp,
            {{ datediff('start_timestamp', 'stop_timestamp', period) }} + 1 AS num_periods
        FROM period_data
    {%- endset %}

    {% set period_boundaries_dict = dbtvault.get_query_results_as_dict(period_boundary_sql) %}

    {% set period_boundaries = {'start_timestamp': period_boundaries_dict['START_TIMESTAMP'][0] | string,
                                'stop_timestamp': period_boundaries_dict['STOP_TIMESTAMP'][0] | string,
                                'num_periods': period_boundaries_dict['NUM_PERIODS'][0] | int} %}

    {% do return(period_boundaries) %}
{%- endmacro %}


{% macro databricks__get_period_boundaries(target_relation, timestamp_field, start_date, stop_date, period) -%}

    {%- set from_date_or_timestamp = "NULLIF('{}','none')::TIMESTAMP".format(stop_date | lower) -%}

    {% set period_boundary_sql -%}

        WITH period_data AS (
            SELECT
                COALESCE(MAX({{ timestamp_field }}), CAST('{{ start_date }}' AS TIMESTAMP)) AS start_timestamp,
                COALESCE({{ dbtvault.dateadd('millisecond', 86399999, from_date_or_timestamp) }},
                         {{ current_timestamp() }}) AS stop_timestamp
            FROM {{ target_relation }}
        )
        SELECT
            IF(stop_timestamp < start_timestamp, stop_timestamp, start_timestamp) AS start_timestamp,
            stop_timestamp,
            {{ datediff('start_timestamp', 'stop_timestamp', period) }} + 1 AS num_periods

        FROM period_data
    {%- endset %}

    {% set period_boundaries_dict = dbtvault.get_query_results_as_dict(period_boundary_sql) %}

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
                COALESCE({{ dbtvault.dateadd('millisecond', 86399999, "NULLIF('" ~ stop_date | lower ~ "','none')::TIMESTAMP") }},
                         {{ current_timestamp() }} ) AS stop_timestamp
            FROM {{ target_relation }}
        )
        SELECT
            start_timestamp,
            stop_timestamp,
            {{ datediff('start_timestamp', 'stop_timestamp', period) }} + 1 AS num_periods
        FROM period_data
    {%- endset %}

    {% set period_boundaries_dict = dbtvault.get_query_results_as_dict(period_boundary_sql) %}

    {% set period_boundaries = {'start_timestamp': period_boundaries_dict['START_TIMESTAMP'][0] | string,
                                'stop_timestamp': period_boundaries_dict['STOP_TIMESTAMP'][0] | string,
                                'num_periods': period_boundaries_dict['NUM_PERIODS'][0] | int} %}

    {% do return(period_boundaries) %}
{%- endmacro %}