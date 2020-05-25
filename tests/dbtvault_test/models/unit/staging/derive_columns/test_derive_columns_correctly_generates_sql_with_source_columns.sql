-- depends_on: {{ ref('raw_source') }}
{%- if execute -%}
{%- if var('source_models', '') != '' -%}
{%- set source_relation = ref(var('source_models')) -%}
{% endif %}
{% endif %}

{{ dbtvault.derive_columns(source_relation=source_relation, columns=var('columns')) }}