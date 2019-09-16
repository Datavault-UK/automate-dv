{%- macro staging_footer(loaddate, eff_from, source, source_table, include_wildcard=true) -%}

,*,{{ loaddate }} AS LOADDATE, {{ eff_from }} AS EFFECTIVE_FROM, '{{ source }}' AS SOURCE FROM {{ source_table }}

{%- endmacro -%}