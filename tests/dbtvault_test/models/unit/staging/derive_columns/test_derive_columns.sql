-- depends_on: {{ ref('raw_source') }}
{%- if execute -%}
{%- set table_relation = ref(var('source_table')) -%}
{% endif %}

{{ dbtvault.derive_columns(source_table=table_relation, columns=var('columns')) }}