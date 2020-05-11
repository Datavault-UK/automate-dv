{%- set obj = 'not_a_relation' -%}
{%- if execute -%}
    {{ log(dbtvault.check_relation(obj), true) }}
{%- endif -%}