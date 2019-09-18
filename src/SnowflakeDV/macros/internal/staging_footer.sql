{%- macro staging_footer(loaddate, source, source_table) -%}

{{ loaddate }} AS LOADDATE, '{{ source }}' AS SOURCE FROM {{ source_table }}

{%- endmacro -%}