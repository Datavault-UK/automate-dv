-- depends_on: {{ ref('add_columns_source') }}
{%- if execute -%}
{%- set table_relation = ref(var('source_table')) -%}
{% endif %}

{{ dbtvault.add_columns(source=table_relation,
                        pairs=[('!STG_CUSTOMER', 'SOURCE'),
                               ('LOADDATE', 'EFFECTIVE_FROM')]) }}