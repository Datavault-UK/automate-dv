{%- macro spark__datediff(first_date, second_date, datepart) -%}

{{ dbt_utils.log_info("Running .....................................................spark__datediff") }}


    datediff({{second_date}}, {{first_date}})

{%- endmacro -%}
