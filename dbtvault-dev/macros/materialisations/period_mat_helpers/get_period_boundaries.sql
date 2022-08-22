{%- macro get_period_boundaries(target_relation, timestamp_field, start_date, stop_date, period) -%}

    {% set macro = adapter.dispatch('get_period_boundaries',
                                    'dbtvault')(target_relation=target_relation,
                                                timestamp_field=timestamp_field,
                                                start_date=start_date,
                                                stop_date=stop_date,
                                                period=period) %}

    {% do return(macro) %}
{%- endmacro %}



{% macro default__get_period_boundaries(target_relation, timestamp_field, start_date, stop_date, period) -%}

    {% set period_boundary_sql -%}
        WITH period_data AS (
            SELECT
                COALESCE(MAX({{ timestamp_field }}), '{{ start_date }}')::TIMESTAMP AS start_timestamp,
                COALESCE({{ dbt_utils.dateadd('millisecond', 86399999, "NULLIF('" ~ stop_date | lower ~ "','none')::TIMESTAMP") }},
                         {{ dbtvault.current_timestamp() }} ) AS stop_timestamp
            FROM {{ target_relation }}
        )
        SELECT
            start_timestamp,
            stop_timestamp,
            {{ dbt_utils.datediff('start_timestamp',
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




{% macro bigquery__get_period_boundaries(target_relation, timestamp_field, start_date, stop_date, period) -%}

    {% set period_boundary_sql -%}
        with data as (
            select
                coalesce(CAST(max({{ timestamp_field }}) AS DATETIME), CAST('{{ start_date }}' AS DATETIME)) as START_TIMESTAMP,
                coalesce({{ dbt_utils.dateadd('millisecond', 86399999, "nullif('" ~ stop_date | lower ~ "','none')") }},
                         CAST(CURRENT_TIMESTAMP() AS DATETIME) ) as STOP_TIMESTAMP
            from {{ target_relation }}
        )
        select
            START_TIMESTAMP,
            STOP_TIMESTAMP,
            {{ dbt_utils.datediff('start_timestamp',
                                  'stop_timestamp',
                                  period) }} + 1 as NUM_PERIODS
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
    {% set start_date_mssql = start_date[0:27] %}
    {% set stop_date_mssql  = stop_date[0:27] %}

    {% set period_boundary_sql -%}
        WITH period_data AS (
            SELECT
                CAST(COALESCE(MAX({{ timestamp_field }}), CAST('{{ start_date_mssql }}' AS DATETIME2)) AS DATETIME2) AS start_timestamp,
                COALESCE({{ dbt_utils.dateadd('millisecond', 86399999, "CAST(NULLIF('" ~ stop_date_mssql | lower ~ "','none') AS DATETIME2)") }},
                         {{ dbtvault.current_timestamp() }} ) AS stop_timestamp
            FROM {{ target_relation }}
        )
        SELECT
            start_timestamp,
            stop_timestamp,
            {{ dbt_utils.datediff('start_timestamp',
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


{% macro databricks__get_period_boundaries(target_relation, timestamp_field, start_date, stop_date, period) -%}

    {#  MSSQL cannot CAST datetime strings with more than 3 decimal places #}
    {% set start_date_mssql = start_date[0:23] %}
    {% set stop_date_mssql  = stop_date[0:23] %}

    {% set period_boundary_sql -%}

        WITH period_data AS (
            SELECT
                CAST(COALESCE(MAX({{ timestamp_field }}), CAST('{{ start_date_mssql }}' AS TIMESTAMP)) AS TIMESTAMP) AS start_timestamp,

            COALESCE( {{ dbtvault.databricks__dateadd('millisecond', 86399999, "NULLIF('" ~ stop_date | lower ~ "','none')::TIMESTAMP") }},
                                     {{ dbtvault.current_timestamp() }} ) AS stop_timestamp
                        FROM {{ target_relation }}
                    )
            SELECT
                start_timestamp,
                stop_timestamp,
                {{  dbtvault.databricks__datediff('start_timestamp',
                                  'stop_timestamp',
                                  period) }}
                 + 1 AS num_periods

        FROM period_data
    {%- endset %}

    {% set period_boundaries_dict = dbtvault.get_query_results_as_dict(period_boundary_sql) %}

    {% set period_boundaries = {'start_timestamp': period_boundaries_dict['START_TIMESTAMP'][0] | string,
                                'stop_timestamp': period_boundaries_dict['STOP_TIMESTAMP'][0] | string,
                                'num_periods': period_boundaries_dict['NUM_PERIODS'][0] | int} %}

    {% do return(period_boundaries) %}
{%- endmacro %}