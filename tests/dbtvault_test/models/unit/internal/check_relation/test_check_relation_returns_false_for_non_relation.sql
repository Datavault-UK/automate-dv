{%- set obj = 'not_a_relation' -%}
{{ log(dbtvault.check_relation(obj), true) }}