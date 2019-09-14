{%- macro prefix(columns, prefix_str) -%}

{%- for column in columns -%}

    {% if column is iterable and column is not string %}
        {{- snow_vault.prefix(column, prefix_str) -}}
    {%- else -%}
        {{- prefix_str}}.{{column.strip() -}}
    {%- endif -%}

    {%- if not loop.last -%} , {% endif %}

{%- endfor -%}

{%- endmacro -%}