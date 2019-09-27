{%- macro staging_footer(loaddate, source, source_table) -%}
{%- if source or loaddate -%}, {%- endif -%}
{%- if loaddate -%} {{ loaddate }} AS LOADDATE, {%- endif -%} {%- if source -%} '{{ source }}' AS SOURCE {%- endif %} FROM {{ source_table }}

{%- endmacro -%}