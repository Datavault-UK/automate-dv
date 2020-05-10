{%- set obj = ref('raw_source') -%}
{{ log(dbtvault.check_relation(obj), true) }}