{%- set obj = source('test_unit', 'source') -%}
{{ log(dbtvault.check_relation(obj), true) }}