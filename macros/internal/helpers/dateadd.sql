/*
 * Copyright (c) Business Thinking Ltd. 2019-2023
 * This software includes code developed by the dbtvault Team at Business Thinking Ltd. Trading as Datavault
 */

{% macro dateadd(datepart, interval, from_date_or_timestamp) %}
    {{ return(adapter.dispatch('dateadd', 'dbtvault')(datepart=datepart,
                                                     interval=interval,
                                                     from_date_or_timestamp=from_date_or_timestamp)) }}
{%- endmacro -%}

{% macro default__dateadd(datepart, interval, from_date_or_timestamp) %}

    {{ dateadd(datepart, interval, from_date_or_timestamp) }}

{% endmacro %}

{% macro sqlserver__dateadd(datepart, interval, from_date_or_timestamp) %}

    dateadd(
        millisecond,
        86399999,
        CAST({{ from_date_or_timestamp }} AS DATETIME2)
    )

{% endmacro %}