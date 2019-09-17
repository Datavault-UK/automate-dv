{%- macro staging_footer(loaddate, eff_from, source, source_table, include_wildcard=true) -%}

{{ loaddate }} AS LOADDATE, '{{ source }}' AS SOURCE FROM {{ source_table }}

{%- endmacro -%}