-- depends_on: {{ ref('raw_source') }}
{%- if execute -%}
{%- if var('source_model', '') != '' -%}
{%- set table_relation = ref(var('source_model')) -%}
{% endif %}
{% endif %}

{{ dbtvault.derive_columns(source_model=table_relation) }}