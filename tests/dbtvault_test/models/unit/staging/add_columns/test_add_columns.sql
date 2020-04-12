
{%- set table_relation = ref(var('source_table')) -%}

{{ dbtvault.add_columns(source_table=table_relation, columns=var('columns')) }}