{% macro spark__dateadd(datepart, interval, from_date_or_timestamp) %}

{{ dbt_utils.log_info("Running .....................................................spark_dateadd") }}


    {% if datepart == 'year' %}
        {%- set day_count = interval * 365 -%}
    {% elif datepart == 'quarter' %}
        {%- set day_count = interval * 120 -%}
    {% elif datepart == 'month' %}
        {%- set day_count = interval * 30 -%}
    {% elif datepart == 'day' %}
        {%- set day_count = interval -%}
    {% elif datepart == 'week' %}
        {%- set day_count = interval * 7 -%}
    {% elif datepart == 'hour' %}
        {%- set day_count = interval / 24 -%}
    {% elif datepart == 'minute' %}
        {%- set day_count = interval / (24 *60) -%}
    {% elif datepart == 'second' %}
        {%- set day_count = interval / (24 * 60 * 60) -%}
    {% elif datepart == 'millisecond' %}
        {%- set day_count = interval / (24 * 60 * 60 * 1000) -%}
    {% elif datepart == 'microsecond' %}
       {%- set day_count = interval / (24 * 60 * 60 * 1000 * 1000) -%}
    {% else %}
        {{ exceptions.raise_compiler_error("Unsupported datepart for macro datediff in spark: {!r}".format(datepart)) }}
    {% endif %}

    {{ dbt_utils.log_info("Running {} - {} .....................................................spark_dateadd".format(day_count,datepart))}}

        date_add(
            cast( {{ from_date_or_timestamp }} as timestamp),
            cast( floor( {{ day_count }} )  as INT)
        )

{% endmacro %}