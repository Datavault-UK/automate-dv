{% macro timestamp_add(datepart, interval, from_date_or_timestamp) %}
    {{ return(adapter.dispatch('timestamp_add', 'dbtvault')(datepart=datepart,
                                                     interval=interval,
                                                     from_date_or_timestamp=from_date_or_timestamp)) }}
{%- endmacro -%}

{% macro default__timestamp_add(datepart, interval, from_date_or_timestamp) %}

TIMESTAMP_ADD(CAST( {{from_date_or_timestamp}} AS TIMESTAMP), INTERVAL {{interval}} {{datepart}})

{% endmacro %}
