{%- macro prefix(columns, prefix_str) -%}

{%- if columns is iterable -%}

    {#- If only single string provided -#}
    {%- if columns is string -%}

        {{prefix_str}}.{{columns.strip()}}

    {%- else -%}

        {#- For each column in the given list, prefix with given prefix_str -#}
        {%- for column in columns -%}

        {{prefix_str}}.{{column.strip()}}

        {%- if not loop.last -%} , {% endif %}

        {%- endfor -%}

    {%- endif -%}

{%- endif -%}
{%- endmacro -%}