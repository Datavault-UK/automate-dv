{%- macro prefix(columns, prefix_str) -%}

{{ log(columns) }}

{%- if columns is iterable -%}

    {#- If only single string provided -#}
    {%- if columns is string -%}

        {{prefix_str}}.{{columns.strip()}}

    {%- else -%}

        {#- For each column in the given list, prefix with given prefix_str -#}
        {%- for column in columns -%}

            {%- if column is string -%}
                {{prefix_str}}.{{column.strip()}}

            {#- Recurse if containing further nested lists -#}
            {%- elif column is iterable -%}
                {{ snow_vault.prefix(column, prefix_str)}}
            {%- endif -%}

        {%- if not loop.last -%} , {% endif %}

        {%- endfor -%}

    {%- endif -%}

{%- endif -%}
{%- endmacro -%}