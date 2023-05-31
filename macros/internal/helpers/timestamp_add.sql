/*
 * Copyright (c) Business Thinking Ltd. 2019-2023
 * This software includes code developed by the AutomateDV (f.k.a dbtvault) Team at Business Thinking Ltd. Trading as Datavault
 */

{% macro timestamp_add(datepart, interval, from_date_or_timestamp) %}
    {{ return(adapter.dispatch('timestamp_add', 'automate_dv')(datepart=datepart, interval=interval,
                                                               from_date_or_timestamp=from_date_or_timestamp)) }}
{%- endmacro -%}

{%- macro default__timestamp_add(datepart, interval, from_date_or_timestamp) -%}

    {%- if datepart is in ['day', 'week', 'month', 'quarter', 'year'] -%}
        {{ automate_dv.dateadd('millisecond', 86399999, from_date_or_timestamp) }}
    {%- elif datepart == 'microsecond' -%}
        {{ automate_dv.dateadd('microsecond', 1, from_date_or_timestamp) }}
    {%- elif datepart == 'millisecond' -%}
        {{ automate_dv.dateadd('microsecond', 999, from_date_or_timestamp) }}
    {%- elif datepart == 'second' -%}
        {{ automate_dv.dateadd('millisecond', 999, from_date_or_timestamp) }}
    {%- elif datepart == 'minute' -%}
        {{ automate_dv.dateadd('millisecond', 5999, from_date_or_timestamp) }}
    {%- elif datepart == 'hour' -%}
        {{ automate_dv.dateadd('millisecond', 3599999, from_date_or_timestamp) }}
    {%- endif -%}

{%- endmacro -%}

{% macro bigquery__timestamp_add(datepart, interval, from_date_or_timestamp) %}

{%- if datepart is in ['day', 'week', 'month', 'quarter', 'year'] -%}
    {{ automate_dv.dateadd('millisecond', 86399999, from_date_or_timestamp) }}
{%- elif datepart == 'microsecond' -%}
    TIMESTAMP_ADD(CAST( {{from_date_or_timestamp}} AS TIMESTAMP), INTERVAL 1 microsecond)
{%- elif datepart == 'millisecond' -%}
    TIMESTAMP_ADD(CAST( {{from_date_or_timestamp}} AS TIMESTAMP), INTERVAL 999 microsecond)
{%- elif datepart == 'second' -%}
    TIMESTAMP_ADD(CAST( {{from_date_or_timestamp}} AS TIMESTAMP), INTERVAL 999 millisecond)
{%- elif datepart == 'minute' -%}
    TIMESTAMP_ADD(CAST( {{from_date_or_timestamp}} AS TIMESTAMP), INTERVAL 5999 millisecond)
{%- elif datepart == 'hour' -%}
    TIMESTAMP_ADD(CAST( {{from_date_or_timestamp}} AS TIMESTAMP), INTERVAL 3599999 millisecond)
{%- endif -%}

{% endmacro %}


