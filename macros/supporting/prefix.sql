{%- macro prefix(columns, prefix_str, alias_target) -%}
    {{- adapter.dispatch('prefix', packages=['dbtvault'])(columns=columns, prefix_str=prefix_str, alias_target=alias_target) -}}
{%- endmacro -%}