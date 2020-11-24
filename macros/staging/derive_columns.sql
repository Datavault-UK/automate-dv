
{%- macro derive_columns(source_relation=none, columns=none) -%}
    {{- adapter.dispatch('derive_columns')(source_relation=source_relation, columns=columns) -}}
{%- endmacro %}