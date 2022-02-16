{% macro spark__dateadd(datepart, interval, from_date_or_timestamp) %}

{{ dbt_utils.log_info("Running .....................................................spark_dateadd") }}

        date_add(
            cast( {{ from_date_or_timestamp }} as timestamp),
         cast(floor({{ interval }} / (1000 * 60 * 60 * 24)) as INT)
        )

{% endmacro %}