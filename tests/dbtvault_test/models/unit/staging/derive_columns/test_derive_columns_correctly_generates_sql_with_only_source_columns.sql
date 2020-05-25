-- depends_on: {{ ref('raw_source') }}
{%- if execute -%}
{%- if var('source_model', '') != '' -%}
{%- set source_relation = ref(var('source_model')) -%}
{% endif %}
{% endif %}

{{ dbtvault.derive_columns(source_relation=source_relation) }}