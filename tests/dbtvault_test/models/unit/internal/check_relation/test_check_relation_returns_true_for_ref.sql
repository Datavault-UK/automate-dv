{%- set obj = ref('raw_source') -%}
{%- if execute -%}
    {{ log(dbtvault.check_relation(obj), true) }}
{%- endif -%}