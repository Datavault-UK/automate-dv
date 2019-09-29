{%- macro create_col(column, alias) -%}

{{ column }} AS {{ alias }}

{%- endmacro -%}