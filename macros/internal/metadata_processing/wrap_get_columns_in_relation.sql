{% macro wrap_get_columns_in_relation(node) -%}
    {{ return(adapter.get_columns_in_relation(node)) }}
{% endmacro %}