{%- macro replace_placeholder_with_period_filter(core_sql, timestamp_field, start_timestamp, stop_timestamp, offset, period) -%}

    {% set macro = adapter.dispatch('replace_placeholder_with_period_filter',
                                    'dbtvault')(core_sql=core_sql,
                                                timestamp_field=timestamp_field,
                                                start_timestamp=start_timestamp,
                                                stop_timestamp=stop_timestamp,
                                                offset=offset,
                                                period=period) %}
    {% do return(macro) %}
{%- endmacro %}




{% macro default__replace_placeholder_with_period_filter(core_sql, timestamp_field, start_timestamp, stop_timestamp, offset, period) %}

    {%- set period_filter -%}
        (TO_DATE({{ timestamp_field }})
        >= DATE_TRUNC('{{ period }}', TO_DATE('{{ start_timestamp }}') + INTERVAL '{{ offset }} {{ period }}') AND
             TO_DATE({{ timestamp_field }}) < DATE_TRUNC('{{ period }}', TO_DATE('{{ start_timestamp }}') + INTERVAL '{{ offset }} {{ period }}' + INTERVAL '1 {{ period }}'))
      AND (TO_DATE({{ timestamp_field }}) >= TO_DATE('{{ start_timestamp }}'))
    {%- endset -%}
    {%- set filtered_sql = core_sql | replace("__PERIOD_FILTER__", period_filter) -%}

    {% do return(filtered_sql) %}
{% endmacro %}




{% macro bigquery__replace_placeholder_with_period_filter(core_sql, timestamp_field, start_timestamp, stop_timestamp, offset, period) %}

    {%- set period_filter -%}
            (DATE({{ timestamp_field }}) >= DATE_TRUNC(DATE_ADD( DATE('{{ start_timestamp }}'), INTERVAL {{ offset }} {{ period }}), {{ period }} ) AND
             DATE({{ timestamp_field }}) < DATE_TRUNC(DATE_ADD(DATE_ADD( DATE('{{ start_timestamp }}'), INTERVAL {{ offset }} {{ period }}), INTERVAL 1 {{ period }}), {{ period }} )
      AND DATE({{ timestamp_field }}) >= DATE('{{ start_timestamp }}'))
    {%- endset -%}

    {%- set filtered_sql = core_sql | replace("__PERIOD_FILTER__", period_filter) -%}

    {% do return(filtered_sql) %}
{% endmacro %}




{% macro sqlserver__replace_placeholder_with_period_filter(core_sql, timestamp_field, start_timestamp, stop_timestamp, offset, period) %}

    {#  MSSQL cannot CAST datetime2 strings with more than 7 decimal places #}
    {% set start_timestamp_mssql = start_timestamp[0:27] %}

    {%- set period_filter -%}
            (CAST({{ timestamp_field }} AS DATE) >= DATEADD({{ period }}, DATEDIFF({{ period }}, 0, DATEADD({{ period }}, {{ offset }}, CAST('{{ start_timestamp_mssql }}' AS DATETIME2))), 0) AND
             CAST({{ timestamp_field }} AS DATE) < DATEADD({{ period }}, 1, DATEADD({{ period }}, {{ offset }}, CAST('{{ start_timestamp_mssql }}' AS DATETIME2)))
      AND (CAST({{ timestamp_field }} AS DATE) >= CAST('{{ start_timestamp_mssql }}' AS DATE)))
    {%- endset -%}

    {%- set filtered_sql = core_sql | replace("__PERIOD_FILTER__", period_filter) -%}

    {% do return(filtered_sql) %}
{% endmacro %}
