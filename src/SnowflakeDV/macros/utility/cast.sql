{%- macro cast(columns, prefix=none) -%}

{#- If a string or list -#}
{%- if columns is iterable -%}

    {#- If only single string provided -#}
    {%- if columns is string -%}

        {{columns}}

    {%- else -%}

        {%- for column in columns -%}

            {#- Output String if just a string -#}
            {%- if column is string -%}
                {%- if prefix -%}
                {{ snow_vault.prefix([column], prefix) }}
                {%- else -%}
                {{column}}
                {%- endif -%}

            {#- Recurse if a list of lists (i.e. multi-column key) -#}
            {%- elif column|first is iterable and column|first is not string -%}
                {{ log(column, true)}}
                {{ snow_vault.cast(column) }}

            {#- Otherwise it is a standard list -#}
            {%- else -%}

                {#- Make sure it is a triple -#}
                {%- if column|length == 3 %}
                    {% if prefix %}
                    CAST({{ snow_vault.prefix([column[0]], prefix) }} AS {{ column[1] }}) AS {{ column[2] }}
                    {%- else -%}
                    CAST({{ column[0] }} AS {{ column[1] }}) AS {{ column[2] }}
                    {%- endif -%}
                {%- endif -%}

            {%- endif -%}

            {#- Add trailing comma if not last -#}
            {%- if not loop.last -%} , {%- endif -%}

        {%- endfor -%}

    {%- endif -%}

{%- endif -%}

{%- endmacro -%}

