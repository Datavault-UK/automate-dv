{%- macro spark__datediff(first_date, second_date, datepart) -%}

    datediff({{second_date}}, {{first_date}})

{%- endmacro -%}
