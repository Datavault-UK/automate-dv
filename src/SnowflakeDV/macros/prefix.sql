{%- macro prefix(columns, prefix_str) -%}

{%- if columns.split(',')|length == 1 -%}

{{prefix_str}}.{{columns.strip()}}

{%- else -%}

{%- for column in columns.split(',') -%}

{{prefix_str}}.{{column.strip()}}
{%- if not loop.last -%} , {% endif %}

{%- endfor -%}
{%- endif -%}
{%- endmacro -%}