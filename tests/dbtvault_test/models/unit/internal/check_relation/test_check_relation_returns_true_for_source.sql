{%- set obj = source('test_unit', 'source') -%}
{%- if execute -%}
    {{ log(dbtvault.check_relation(obj), true) }}
{%- endif -%}